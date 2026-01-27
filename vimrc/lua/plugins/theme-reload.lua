return {
    {
        name = "theme-hotreload",
        dir = vim.fn.stdpath("config"),
        lazy = false,
        priority = 1000,
        config = function()
            local theme_module_name = "plugins.theme"
            local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"

            -- MUDANÇA MÍNIMA: Criamos esta função com o conteúdo que já existia
            local function reload_theme()
                package.loaded[theme_module_name] = nil
                local ok, theme_spec = pcall(require, theme_module_name)
                if not ok then return end

                local theme_plugin_name = nil
                for _, spec in ipairs(theme_spec) do
                    if spec[1] then
                        theme_plugin_name = spec.name or spec[1]:match(".*/(.*)")
                        break
                    end
                end

                -- Aplica as cores (mesma lógica original)
                for _, spec in ipairs(theme_spec) do
                    local colorscheme = spec.colorscheme or (spec.opts and spec.opts.colorscheme)
                    if colorscheme then
                        pcall(vim.cmd.colorscheme, colorscheme)
                        if vim.fn.filereadable(transparency_file) == 1 then
                            vim.cmd.source(transparency_file)
                        end
                        break
                    end
                end
            end

            -- 1. APLICAÇÃO NO STARTUP (O que você pediu)
            reload_theme()

            -- 2. APLICAÇÃO NO HOT RELOAD (Mantém o comportamento original)
            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyReload",
                callback = function()
                    vim.schedule(reload_theme)
                end,
            })
        end,
    },
}
-- return {
--     {
--         name = "theme-hotreload",
--         dir = vim.fn.stdpath("config"),
--         lazy = false,
--         priority = 1000,
--         config = function()
--             -- AJUSTE: Onde está sua lista de temas (ex: "plugins.ui" ou "plugins.theme")
--             local theme_module_name = "plugins.theme"
--             local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"
--
--             vim.api.nvim_create_autocmd("User", {
--                 pattern = "LazyReload",
--                 callback = function()
--
--                     local function reload_theme()
--                         -- 1. Limpa o cache do módulo de configuração do tema
--                         package.loaded[theme_module_name] = nil
--
--                         -- 2. Tenta carregar a especificação (o return { "tema/repo" })
--                         local ok, theme_spec = pcall(require, theme_module_name)
--                         if not ok then return end
--
--                         -- 3. Identifica o nome do plugin (idêntico ao flow original)
--                         local theme_plugin_name = nil
--                         for _, spec in ipairs(theme_spec) do
--                             -- Filtramos apenas plugins que têm o campo 'colorscheme' ou são temas
--                             -- No lazy puro, pegamos o primeiro item da lista de plugins de tema
--                             if spec[1] then
--                                 theme_plugin_name = spec.name or spec[1]:match(".*/(.*)")
--                                 break
--                             end
--                         end
--
--                         -- 4. Reset visual (Exatamente como o original)
--                         vim.cmd("highlight clear")
--                         if vim.fn.exists("syntax_on") then
--                             vim.cmd("syntax reset")
--                         end
--                         vim.o.background = "dark"
--
--                         -- 5. Força o unload dos arquivos Lua do plugin de tema (Hot Reload real)
--                         if theme_plugin_name then
--                             local plugin = require("lazy.core.config").plugins[theme_plugin_name]
--                             if plugin then
--                                 local plugin_dir = plugin.dir .. "/lua"
--                                 require("lazy.core.util").walkmods(plugin_dir, function(modname)
--                                     package.loaded[modname] = nil
--                                     package.preload[modname] = nil
--                                 end)
--                             end
--                         end
--
--                         -- 6. Aplica o novo colorscheme
--                         -- Como não temos o objeto 'LazyVim.opts', buscamos o campo 'opts.colorscheme' 
--                         -- na sua própria spec de plugins
--                         for _, spec in ipairs(theme_spec) do
--                             local colorscheme = spec.colorscheme or (spec.opts and spec.opts.colorscheme)
--
--                             if colorscheme then
--                                 -- Loader do Lazy para carregar o plugin de fato
--                                 require("lazy.core.loader").colorscheme(colorscheme)
--
--                                 vim.defer_fn(function()
--                                     pcall(vim.cmd.colorscheme, colorscheme)
--                                     vim.cmd("redraw!")
--
--                                     -- 7. Reload da transparência e Autocmds
--                                     if vim.fn.filereadable(transparency_file) == 1 then
--                                         vim.defer_fn(function()
--                                             vim.cmd.source(transparency_file)
--                                             vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
--                                             vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })
--                                             vim.cmd("redraw!")
--                                         end, 5)
--                                     end
--                                 end, 5)
--                                 break
--                             end
--                         end
--                     end
--                     vim.schedule(function()
--                         vim.schedule(reload_theme)
--                     end)
--                 end,
--             })
--         end,
--     },
-- }

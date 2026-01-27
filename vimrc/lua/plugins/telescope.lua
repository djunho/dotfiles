return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.1',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        -- Fuzzy Finder Algorithm which dependencies local dependencies to be built.
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install' },
        'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
        -- Movendo os requires para dentro da função config
        -- Isso garante que eles só rodem DEPOIS que o plugin for carregado
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')
        local lga = telescope.extensions.live_grep_args.live_grep_args

        -- Get the text if selected or the text searched. Otherwise return '' (default behavior)
        local function getText()
            local text = ''
            if (string.find("Vv", vim.fn.mode())) then
                -- visual mode
                vim.cmd('noau normal! "vy"')
                text = vim.fn.getreg('v')
                vim.fn.setreg('v', {})
                text = string.gsub(text, "\n", "")
            elseif (vim.v.hlsearch == 1) then
                -- Normal mode or any other
                text = vim.fn.getreg("/")
                text = string.gsub(text, '\\<', '\\b')
                text = string.gsub(text, '\\>', '\\b')
            end
            return text
        end

        local changeText = function(func)
            return function()
                func({ default_text = getText() })
            end
        end

        local all_git_files = function ()
            builtin.git_files({recurse_submodules = true})
        end

        -- Configuração principal
        telescope.setup({
            defaults = {
                vimgrep_arguments = {
                    "rg", "-L", "--color=never", "--no-heading",
                    "--with-filename", "--line-number", "--column", "--smart-case",
                },
                prompt_prefix = "   ",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                path_display = { "truncate" },
                mappings = {
                    n = {
                        ["q"] = require("telescope.actions").close,
                        ["-"] = require("telescope.actions").file_split,
                        ["|"] = require("telescope.actions").file_vsplit,
                        ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                    },
                    i = {
                        ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                    }
                },
            },
        })

        -- Carregar extensões
        telescope.load_extension("fzf")
        telescope.load_extension("live_grep_args")

        -- Mapeamentos de teclas (Keymaps)
        local keymap = vim.keymap.set
        keymap('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        keymap('n', '<leader>sgf', function() builtin.git_files({recurse_submodules = true}) end, { desc = '[S]earch [G]it [F]iles' })
        keymap('n', '<leader>sg', changeText(lga), { desc = '[S]earch by [G]rep' })

        -- Adicione os outros keymaps aqui usando keymap(...)
        keymap('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        keymap('n', '<leader>sgf', all_git_files, { desc = '[S]earch [G]it [F]iles' })
        keymap('n', '<C-p>',       all_git_files, { desc = '[S]earch [G]it [F]iles' })
        keymap('n', '<leader>ss',  builtin.lsp_document_symbols, { desc = '[S]earch [S]ymbosl' })
        keymap('n', '<leader>sws',  builtin.lsp_workspace_symbols, { desc = '[S]earch [W]orkspace [S]ymbols' })
        keymap('n', '<leader>sdws',  builtin.lsp_dynamic_workspace_symbols, { desc = '[S]earch [D]ynamically [W]orkspace [S]ymbols' })

        keymap('n', '<leader>of', builtin.oldfiles, { desc = 'Find recently [O]pened [F]iles' })

        keymap({'n', 'v'}, '<C-f>',     changeText(builtin.current_buffer_fuzzy_find), { desc = '[/] Fuzzily search in current buffer]' })
        keymap({'n', 'v'}, '<leader>/', changeText(builtin.current_buffer_fuzzy_find), { desc = '[/] Fuzzily search in current buffer]' })
        keymap('n', '<leader>sb', builtin.buffers, { desc = '[S]earch in all [B]uffers' })

        keymap({'n', 'v'}, '<leader>sg', changeText(lga), { desc = '[S]earch by [G]rep' })
        keymap({'n', 'v'}, '<C-g>',      changeText(lga), { desc = '[S]earch by [G]rep' })

        keymap('n', '<leader>sh',builtin.help_tags, { desc = '[S]earch [H]elp' })

        keymap('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

        keymap('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        keymap('n', '<leader>sm', builtin.man_pages, { desc = '[S]earch [M]anpages' })

        --TODO check a good description
        keymap('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = '[S]earch current [W]ord' })

    end
};


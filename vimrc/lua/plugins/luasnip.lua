return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    kets = {
        -- Rotate on choice nodes
        { "i", "s", "<C-c>", function()
            if require("luasnip").choice_active() then
                require("luasnip").change_choice(1)
            end
        end, desc = "Next choice node" },
        { "i", "s", "<C-x>", function()
            if require("luasnip").choice_active() then
                require("luasnip").change_choice(-1)
            end
        end, desc = "Previous choice node" },
        -- shortcut to reload the snippets
        { "n", "<leader><leader>s", ":source ~/.config/nvim/after/plugin/luasnip.lua<CR>", desc = "Reload Luasnip config" },
    },
    config = function()
        -- This applies the settings from the 'opts' table above
        require("luasnip").setup({
            history = true, --keep around last snippet local to jump back
            update_events = {"TextChanged", "TextChangedI"}, --update changes as you type
            delete_check_events = "TextChanged",
            enable_autosnippets = true,
            ext_opts = {
                [require("luasnip.util.types").choiceNode] = {
                    active = {
                        virt_text = { { "●  󰹳 Choice node", "GruvboxOrange" } },
                    },
                },
                [require("luasnip.util.types").insertNode] = {
                    active = {
                        virt_text = { { "󰪥 󰹳 Insert node", "GruvboxBlue" } },
                    },
                },
            },
        })

        -- This triggers your custom loader
        require("luasnip.loaders.from_lua").load({
            paths = { "~/.config/nvim/lua/snippets" }
        })
  end,
}

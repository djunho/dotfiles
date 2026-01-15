local ls = require("luasnip")

-- Virtual Text
local types = require("luasnip.util.types")
ls.config.set_config({
    history = true, --keep around last snippet local to jump back
    update_events = {"TextChanged", "TextChangedI"}, --update changes as you type
    delete_check_events = "TextChanged",
    enable_autosnippets = true,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "●  󰹳 Choice node", "GruvboxOrange" } },
            },
        },
        [types.insertNode] = {
            active = {
                virt_text = { { "󰪥 󰹳 Insert node", "GruvboxBlue" } },
            },
        },
    },
})

-- Rotate on choice nodes
vim.keymap.set({ "i", "s" }, "<C-c>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)
vim.keymap.set({ "i", "s" }, "<C-x>", function()
    if ls.choice_active() then
        ls.change_choice(-1)
    end
end)

-- shortcut to reload the snippets
vim.keymap.set('n', "<leader><leader>s", ":source ~/.config/nvim/after/plugin/luasnip.lua<CR>")

require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets"})


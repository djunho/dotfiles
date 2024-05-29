-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Change the jump up and down to Alt + left and right
vim.keymap.set("n", "<leader><Left>", "<C-O>")
vim.keymap.set("n", "<leader><Right>", "<C-i>")

-- disable highlighting of last search
-- Check :help :map-special-keys
-- To find the correct key, enter in insert mode, then  press C-V C-/
-- Ctrl - /
vim.keymap.set("n", "<C-_>", [[:noh<enter>]])
vim.keymap.set("n", "<C-O>", [[:noh<enter>]])

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- toggle spell checking
vim.keymap.set("n", "<F2>", [[:set spell!<cr>]])
vim.keymap.set("i", "<F2>", [[<C-O>:set spell!<cr>]])

vim.keymap.set("n", "<C-Right>", [[:BufferLineCycleNext<CR>]])
vim.keymap.set("n", "<C-l>",     [[:BufferLineCycleNext<CR>]])
vim.keymap.set("n", "<C-Left>", [[:BufferLineCyclePrev<CR>]])
vim.keymap.set("n", "<C-h>",    [[:BufferLineCyclePrev<CR>]])
vim.keymap.set("n", "<C-S-Right>", [[:BufferLineMoveNext<CR>]])
vim.keymap.set("n", "<C-S-Left>", [[:BufferLineMovePrev<CR>]])
vim.keymap.set("n", "L", [[:BufferLineCycleNext<CR>]])
vim.keymap.set("n", "H", [[:BufferLineCyclePrev<CR>]])
-- The next command will get the current buffer id, move to the next "tab" (buffer) and delete the previous buffer.
-- This is needed because when deleting a buffer with the neo-tree open, the newvim will redraw the windows with just the neo-tree on it. Leaving the work as a sidebar
vim.keymap.set("n", "<leader>x", [[:lua d=vim.api.nvim_get_current_buf(); require("bufferline").cycle(1); vim.cmd("bdelete! "..d)<CR>]], { silent = true })

-- (CTRL-A) open tree explorer
vim.keymap.set("n", "<C-a>", [[:Neotree toggle<CR>]])

-- Remove all trailing spaces
vim.keymap.set("n", "<F4>", [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]])

-- When selecting some lines, can move then using "J" or "K"
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- page down and up (C-d or C-u) keeps the cursor in thge middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- keeps the cursor in the middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- preserves the buffer when pasting over a highlighted selection
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- Yank to the clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

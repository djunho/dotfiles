-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.g.neo_tree_remove_legacy_commands = 1
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("config.lazy")

-- require('lazy').setup({
--     -- Git related plugins
--     'tpope/vim-fugitive',
--     'tpope/vim-rhubarb',
--
--     'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
--
--     'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
--
--     -- Fuzzy Finder (files, lsp, etc)
--     { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
--         dependencies = {
--             'nvim-lua/plenary.nvim',
--             'nvim-telescope/telescope-live-grep-args.nvim',
--         }
--     },
--
--     -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
--     { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 },
-- })

-- require("core.lsp")
require("myconf.set")
require("myconf.remap")

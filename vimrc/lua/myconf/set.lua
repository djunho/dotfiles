-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Enable break indent
vim.opt.breakindent = true

-- Set colorscheme
vim.opt.termguicolors = true
vim.cmd [[colorscheme tokyonight-storm]]

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- Configure the swap/backup
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- Save undo history
vim.opt.undofile = true

-- Decrease update time
vim.opt.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.opt.scrolloff = 8   -- enables 8 lines below and above the cursor when navigating
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = "120"

-- spell languages
vim.opt.spelllang = en
-- Show nine spell checking candidates at most
vim.opt.spellsuggest = best,9
-- Spell shortcuts
--
-- In insert mode: <C-x> followed by s.
--       A completion menu will show a list of suggestions. You can then choose the correct one.
--
-- In normal mode:
--    [s: go to previous spell error
--    ]s: go to next spell error
--    zg: to add it to your spell files
--    z=: to correct a word

vim.opt.list = true
vim.opt.listchars="tab:.>,trail:~,extends:>,precedes:<"

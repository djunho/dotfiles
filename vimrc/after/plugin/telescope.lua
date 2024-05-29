-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
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
        file_ignore_patterns = { "node_modules" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
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
}

-- Get the text if selected or the text searched. Otherwise return '' (default behavior)
local function getText()
    local text = ''
    if (string.find("Vv", vim.fn.mode())) then
        -- visual mode
        vim.cmd('noau normal! "vy"')
        text = vim.fn.getreg('v')
        vim.fn.setreg('v', {})

        text = string.gsub(text, "\n", "")
        if #text == 0 then
            text = ''
        end
    elseif (vim.v.hlsearch == 1) then
        -- Normal mode or any other
        text = vim.fn.getreg("/")
        text = string.gsub(text, '\\<', '\\b')
        text = string.gsub(text, '\\>', '\\b')
    end

    return text
end

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require("telescope").load_extension, "live_grep_args")

-- Configures some keymaps
local builtin = require('telescope.builtin')
local lga     = require('telescope').extensions.live_grep_args.live_grep_args

local changeText = function(func)
    return function()
            func({ default_text = getText() })
        end
end

vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>sgf', builtin.git_files, { desc = '[S]earch [G]it [F]iles' })
vim.keymap.set('n', '<C-p>',       builtin.git_files, { desc = '[S]earch [G]it [F]iles' })

vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })

vim.keymap.set({'n', 'v'}, '<C-f>',     changeText(builtin.current_buffer_fuzzy_find), { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set({'n', 'v'}, '<leader>/', changeText(builtin.current_buffer_fuzzy_find), { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch in all [B]uffers' })

vim.keymap.set({'n', 'v'}, '<leader>sg', changeText(lga), { desc = '[S]earch by [G]rep' })
vim.keymap.set({'n', 'v'}, '<C-g>',      changeText(lga), { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>sh',builtin.help_tags, { desc = '[S]earch [H]elp' })

vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sm', builtin.man_pages, { desc = '[S]earch [M]anpages' })

--TODO check a good description
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = '[S]earch current [W]ord' })

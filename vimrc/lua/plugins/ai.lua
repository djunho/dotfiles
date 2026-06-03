-- Copilot
return {
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for `snacks` provider.
            ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
            { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
        },
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
              -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
            }

            -- Required for `opts.events.reload`.
            vim.o.autoread = true

            -- Recommended/example keymaps.
            vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
            vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
            vim.keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

            vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
            vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

            vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
            vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

            -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
            vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
            vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
        end,
    },
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        opts = {
            -- Server Configuration
            port_range = { min = 10000, max = 65535 },
            auto_start = true,
            log_level = "info", -- "trace", "debug", "info", "warn", "error"
            terminal_cmd = nil, -- Custom terminal command (default: "claude")
                                -- For local installations: "~/.claude/local/claude"
                                -- For native binary: use output from 'which claude'

            -- Send/Focus Behavior
            -- When true, successful sends will focus the Claude terminal if already connected
            focus_after_send = false,

            -- Selection Tracking
            track_selection = true,
            visual_demotion_delay_ms = 50,

            -- Terminal Configuration
            terminal = {
                provider = "none",
                -- split_side = "right", -- "left" or "right"
                -- split_width_percentage = 0.30,
                -- provider = "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
                -- auto_close = true,
                -- snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below
                --
                -- -- Provider-specific options
                -- provider_opts = {
                --     -- Command for external terminal provider. Can be:
                --     -- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
                --     -- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
                --     -- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
                --     external_terminal_cmd = nil,
                -- },
            },

            -- Diff Integration
            diff_opts = {
                layout = "vertical", -- "vertical" or "horizontal"
                open_in_new_tab = false,
                keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
                hide_terminal_in_new_tab = false,
                -- on_new_file_reject = "keep_empty", -- "keep_empty" or "close_window"

                -- Legacy aliases (still supported):
                -- vertical_split = true,
                -- open_in_current_tab = true,
            },
        },
        keys = {
            { "<leader>a", nil, desc = "AI/Claude Code" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
        },
      },
    { 'zbirenbaum/copilot.lua',
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            panel = {
                enabled = false, -- false as used copilot-cmp
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-CR>"
                },
                layout = {
                    position = "bottom", -- | top | left | right
                    ratio = 0.4
                },
            },
            suggestion = {
                enabled = false,    -- false as used copilot-cmp
                auto_trigger = false,
                hide_during_completion = true,
                debounce = 75,
                keymap = {
                    accept = "<M-l>",
                    accept_word = false,
                    accept_line = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                yaml = false,
                help = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
            copilot_node_command = 'node', -- Node.js version must be > 18.x
            server_opts_overrides = {},
        },
    },
    { 'zbirenbaum/copilot-cmp',
        config = function ()
            require("copilot_cmp").setup()
        end
    }
}

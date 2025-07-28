-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


local actions = require "telescope.actions"
local actions_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local dropdown = require "telescope.themes".get_dropdown()

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- local colors = vim.fn.getcompletion("", "color")
local cmd = { "fd", "-uu", "--type", "f", "--color", "never", "compile_commands.json" }

local function enter(prompt_bufnr)
    local selected = actions_state.get_selected_entry()
    vim.cmd("!/bin/rm compile_commands.json")
    vim.cmd("!ln -s "..selected[1].." .")
    vim.cmd("LspRestart")
    actions.close(prompt_bufnr)
end

local function next_color(prompt_bufnr)
    actions.move_selection_next(prompt_bufnr)
end

local function prev_color(prompt_bufnr)
    actions.move_selection_previous(prompt_bufnr)
end

vim.keymap.set("n", "<leader>lc", function()
    local opts = {
        finder = finders.new_oneshot_job(cmd, {}),
        sorter = sorters.get_generic_fuzzy_sorter({}),

        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", enter)
            map("i", "<C-j>", next_color)
            map("i", "<C-k>", prev_color)
            map("n", "<CR>", enter)
            map("n", "<C-j>", next_color)
            map("n", "<C-k>", prev_color)
            return true
        end,
    }

    pickers.new(dropdown, opts):find()
end, { desc = "[L]sp [C]onfig" } )


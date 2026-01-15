-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
    current_line_blame_opts = {
        virt_text_pos = 'right_align',
    },
    current_line_blame_formatter = '<author>, <author_time:%R>, <abbrev_sha> - <summary>',
}

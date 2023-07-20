
require("bufferline").setup{
    options = {
        offsets = {
            {
                filetype = "neo-tree",
                text = "File Explorer",
                text_align = "center",
                highlight = "Directory",
                separator = true,
            },
        },
        sort_by = 'insert_after_current'
    },
}

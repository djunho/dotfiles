return {
    'akinsho/bufferline.nvim', 
    version = "*", 
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
        options = {
            close_command = "lua require(\"bufferline\").cycle(1); vim.cmd(\"bdelete! %d\")",
            right_mouse_command = "lua require(\"bufferline\").cycle(1); vim.cmd(\"bdelete! %d\")",
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
};

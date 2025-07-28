return {

    settings = {
        clangd = {
            cmd = {
                "clangd", "--background-index"
            },
            root_dir = vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]),
            filetypes = {"c", "cpp", "objc", "objcpp"},
        },
    }
}

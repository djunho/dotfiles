return {
    settings = {
        clangd = {
            cmd = {
                "clangd", "--background-index"
            },
            root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
            filetypes = {"c", "cpp", "objc", "objcpp"},
        },
    }
}

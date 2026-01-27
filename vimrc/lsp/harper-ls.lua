return {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = {
        'asciidoc',
        'c',
        'cpp',
        'cs',
        'gitcommit',
        'go',
        'html',
        'java',
        'javascript',
        'lua',
        'markdown',
        'nix',
        'python',
        'ruby',
        'rust',
        'swift',
        'toml',
        'typescript',
        'typescriptreact',
        'haskell',
        'cmake',
        'typst',
        'php',
        'dart',
        'clojure',
        'sh',
    },
    root_markers = { '.harper-dictionary.txt', '.git' },
    settings = {
        ["harper-ls"] = {
            userDictPath = "",
            workspaceDictPath = "",
            fileDictPath = "",
            linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                -- Recommended changes for programmers 
                -- https://writewithharper.com/docs/integrations/neovim#Common-Config-Changes
                SentenceCapitalization = false,
                -- 
                UnclosedQuotes = true,
                WrongQuotes = false,
                LongSentences = true,
                RepeatedWords = true,
                Spaces = true,
                Matcher = true,
                CorrectNumberSuffix = true,
                UseTitleCase = false
            },
            codeActions = {
                ForceStable = false
            },
            markdown = {
                IgnoreLinkTitle = false
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "American",
            maxFileLength = 120000,
            ignoredLintsPath = "",
            excludePatterns = {}
        }
    }
}

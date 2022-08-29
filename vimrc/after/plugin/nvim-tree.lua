-- As currently, I'm using mostly WSL, disable all the grafical features =(
local list = {
    { key = "t", action = "tabnew"},
    { key = "|", action = "vsplit"},
    { key = "-", action = "split" },
  }
require'nvim-tree'.setup {
    renderer = {
        icons = {
            webdev_colors = false,
            show = {
                file = false,
                folder = false,
                folder_arrow = true,
                git = false
            }
        }
    },
    view = {
        adaptive_size = true,
        mappings = {
            list = list
        }
    }
}

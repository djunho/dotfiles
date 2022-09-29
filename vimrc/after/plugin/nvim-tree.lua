-- As currently, I'm using mostly WSL, disable all the grafical features =(
local list = {
    { key = "t", action = "tabnew"},
    { key = "|", action = "vsplit"},
    { key = "-", action = "split" },
  }
require'nvim-tree'.setup {
    view = {
        adaptive_size = true,
        mappings = {
            list = list
        }
    }
}

return {
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = {
        enabled = true,
        bg = true,
        float = true,
      },
    },
  },
  { 
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

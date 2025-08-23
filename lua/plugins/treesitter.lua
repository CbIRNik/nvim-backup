return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "rust",
      "go",
      "javascript",
      "typescript",
      "tsx",
      "lua",
      "vue",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },
}

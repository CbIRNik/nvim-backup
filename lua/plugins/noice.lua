return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    presets = {
      command_palette = true,       -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true,           -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true,       -- add a border to hover docs and signature help
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp",
  }
}

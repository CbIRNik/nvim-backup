return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  opts = {
    options = {
      theme = "nordic",
      component_separators = "",
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard", "NvimTree" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
      lualine_b = {
        { "branch", icon = "", color = { fg = "#88C0D0" } },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          color = { fg = "#81A1C1" }
        },
        {
          "diagnostics",
          sources = { "nvim_lsp" },
          symbols = { error = " ", warn = " ", info = " " },
          color = { error = "#BF616A", warn = "#D08770", info = "#81A1C1" }
        }
      },
      lualine_c = {
        "%=",
        { "filename", path = 1, shorting_target = 40, color = { fg = "#ECEFF4" } }
      },
      lualine_x = {
        { "encoding",   color = { fg = "#81A1C1" } },
        { "fileformat", color = { fg = "#88C0D0" } }
      },
      lualine_y = {
        { "filetype", icon_only = true, separator = { right = "" }, color = { fg = "#B48EAD" } },
        { "progress", color = { fg = "#81A1C1" } }
      },
      lualine_z = {
        { "location", separator = { right = "" }, left_padding = 2, color = { fg = "#88C0D0" } }
      },
    },
    inactive_sections = {
      lualine_a = { { "filename", path = 1, color = { fg = "#4C566A" } } },
      lualine_b = {},
      lualine_c = { "%=" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { { "location", color = { fg = "#4C566A" } } },
    },
    tabline = {
      lualine_a = {
        {
          "buffers",
          show_filename_only = true,
          mode = 2,
          separator = { left = "", right = "" },
          left_padding = 1,
          right_padding = 1,
          color = { fg = "#434C5E", bg = "#434C5E" },
        }
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {
          "tabs",
          separator = { left = "", right = "" },
          left_padding = 1,
          right_padding = 1,
          color = { fg = "#ECEFF4", bg = "#434C5E" },
        },
      },
    },
    extensions = { "nvim-tree", "toggleterm", "quickfix" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

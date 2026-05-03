local function fate_palette()
  if vim.o.background == "light" then
    return {
      base = "#f3dde6",
      mantle = "#ead0dc",
      surface0 = "#f8e8ee",
      overlay1 = "#806b76",
      text = "#171316",
      red = "#9f1f42",
      pink = "#8f2447",
    }
  end

  return {
    base = "#0b0b0f",
    mantle = "#111116",
    surface0 = "#18171c",
    overlay1 = "#736b72",
    text = "#f4f0e8",
    red = "#d84d6f",
    pink = "#f2b8cc",
  }
end

local function fate_lualine_theme()
  local p = fate_palette()
  local active = { fg = p.base, bg = p.red, gui = "bold" }
  local side = { fg = p.red, bg = p.surface0 }
  local mid = { fg = p.text, bg = p.mantle }
  local inactive = { fg = p.overlay1, bg = p.mantle }
  local inactive_mid = { fg = p.overlay1, bg = p.base }

  local function mode()
    return {
      a = vim.deepcopy(active),
      b = vim.deepcopy(side),
      c = vim.deepcopy(mid),
    }
  end

  return {
    normal = mode(),
    insert = mode(),
    visual = mode(),
    replace = mode(),
    command = mode(),
    terminal = mode(),
    inactive = {
      a = inactive,
      b = inactive_mid,
      c = inactive_mid,
    },
  }
end

local function fate_tab_colors()
  local p = fate_palette()
  return {
    active = { fg = p.base, bg = p.red, gui = "bold" },
    inactive = { fg = p.overlay1, bg = p.mantle },
  }
end

local function fate_tab_active()
  return fate_tab_colors().active
end

local function fate_tab_inactive()
  return fate_tab_colors().inactive
end

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  opts = {
    options = {
      theme = fate_lualine_theme,
      component_separators = "",
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard", "NvimTree" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
      lualine_b = {
        { "branch", icon = "" },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          colored = true,
        },
        {
          "diagnostics",
          sources = { "nvim_lsp" },
          symbols = { error = " ", warn = " ", info = " " },
        }
      },
      lualine_c = {
        "%=",
        { "filename", path = 1, shorting_target = 40 }
      },
      lualine_x = {
        {
          -- Autocomplete provider with icon
          function()
            local current = vim.g.autocomplete_provider or ""
            return "⚡" .. current .. " "
          end,
          colored = true,
          padding = { left = 1, right = 1 },
        },
      },
      lualine_y = {
        { "filetype", icon_only = true, separator = { right = "" } },
        { "progress" }
      },
      lualine_z = {
        { "location", separator = { right = "" }, left_padding = 2 }
      },
    },
    inactive_sections = {
      lualine_a = { { "filename", path = 1 } },
      lualine_b = {},
      lualine_c = { "%=" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { { "location" } },
    },
    tabline = {
      lualine_a = {
        {
          "buffers",
          show_filename_only = true,
          mode = 2,
          buffers_color = {
            active = fate_tab_active,
            inactive = fate_tab_inactive,
          },
          separator = { left = "", right = "" },
          left_padding = 1,
          right_padding = 1,
        }
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {
          "tabs",
          tabs_color = {
            active = fate_tab_active,
            inactive = fate_tab_inactive,
          },
          separator = { left = "", right = "" },
          left_padding = 1,
          right_padding = 1,
        },
      },
    },
    extensions = { "toggleterm", "quickfix" },
  },
}

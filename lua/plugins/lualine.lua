return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
        options = {
            theme = "auto",
            component_separators = "",
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "alpha", "dashboard", "NvimTree" },
            globalstatus = true,
        },
        sections = {
            lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
            lualine_b = {
                { "branch", icon = "" },
                {
                    "diff",
                    symbols = { added = " ", modified = " ", removed = " " },
                },
                {
                    "diagnostics",
                    sources = { "nvim_lsp" },
                    symbols = { error = " ", warn = " ", info = " " },
                }
            },
            lualine_c = {
                "%=",
                { "filename", path = 1, shorting_target = 40 }
            },
            lualine_x = {
                { "encoding" },
                { "fileformat" }
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
                    separator = { left = "", right = "" },
                    left_padding = 1,
                    right_padding = 1,
                },
            },
        },
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
}

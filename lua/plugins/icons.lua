return {
  "echasnovski/mini.icons",
  opts = {
    color_icons = true,
    icons = {},
  },
  config = function(_, opts)
    local icons = require("mini.icons")
    icons.setup(opts)
    pcall(icons.mock_nvim_web_devicons)
  end,
}

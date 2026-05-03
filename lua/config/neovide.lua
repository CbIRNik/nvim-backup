if not vim.g.neovide then
  return
end

vim.g.have_nerd_font = true

local function number_env(name, default)
  local value = tonumber(vim.env[name] or "")
  return value or default
end

local font_size = number_env("NVIM_GUI_FONT_SIZE", 16)
local font = vim.env.NVIM_GUI_FONT or ("FiraCode Nerd Font Mono:h" .. font_size)

pcall(function()
  vim.o.guifont = font
end)

vim.opt.linespace = number_env("NVIM_GUI_LINESPACE", 4)

vim.g.neovide_opacity = 1.0
vim.g.neovide_normal_opacity = 1.0
vim.g.neovide_cursor_vfx_mode = ""
vim.g.neovide_cursor_animation_length = 0.06
vim.g.neovide_cursor_short_animation_length = 0.03
vim.g.neovide_scroll_animation_length = 0.12
vim.g.neovide_floating_shadow = false
vim.g.neovide_floating_blur_amount_x = 0.0
vim.g.neovide_floating_blur_amount_y = 0.0
vim.g.neovide_refresh_rate = 120
vim.g.neovide_refresh_rate_idle = 5

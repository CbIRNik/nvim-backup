return {
  "github/copilot.vim",
  cmd = "Copilot",
  enabled = false,
  init = function()
    vim.g.copilot_enabled = 0
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_no_maps = true
  end,
}

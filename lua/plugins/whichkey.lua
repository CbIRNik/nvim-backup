return {
  "folke/which-key.nvim",
  opts = {
    preset = "helix", -- Переносит окно в правую колонку (стиль Helix)
    win = {
      border = "rounded", -- Красивая закругленная рамка
      padding = { 1, 2 }, -- Внутренние отступы [верх/низ, лево/право]
      title = " Keymaps ", -- Текст в рамке (опционально)
      title_pos = "center",
    },
  },
}

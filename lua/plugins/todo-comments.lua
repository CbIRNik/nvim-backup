return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {}, -- ваши настройки подсветки
  config = function(_, opts)
    -- Инициализируем сам плагин todo-comments
    require("todo-comments").setup(opts)

    -- Принудительно заменяем вызов поиска на Snacks.picker
    vim.keymap.set("n", "<leader>st", function()
      Snacks.picker.todo_comments()
    end, { desc = "Поиск TODO (Snacks)" })

    vim.keymap.set("n", "<leader>sT", function()
      Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
    end, { desc = "Поиск TODO/FIX (Snacks)" })
  end,
}

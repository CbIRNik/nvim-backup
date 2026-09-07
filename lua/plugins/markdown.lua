return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.icons",
  },
  opts = {},
  keys = {
    {
      "<leader>mp",
      "<cmd>RenderMarkdown preview<cr>",
      desc = "Markdown preview",
    },
    {
      "<leader>um",
      "<cmd>RenderMarkdown buf_toggle<cr>",
      desc = "Toggle Markdown render",
    },
  },
}

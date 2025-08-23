return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
      ["*"] = { "codespell" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },
    format_after_save = {
      lsp_format = "fallback",
    },
  },
}

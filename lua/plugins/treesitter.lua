local parsers = require("config.treesitter").parsers

local parser_set = {}
for _, lang in ipairs(parsers) do
  parser_set[lang] = true
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  priority = 100,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup()

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
      callback = function(event)
        local file = vim.api.nvim_buf_get_name(event.buf)
        local stats = file ~= "" and (vim.uv or vim.loop).fs_stat(file) or nil
        if stats and stats.size > 100 * 1024 then
          return
        end

        local filetype = vim.bo[event.buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype) or filetype
        if parser_set[lang] then
          pcall(vim.treesitter.start, event.buf, lang)
        end
      end,
    })
  end,
}

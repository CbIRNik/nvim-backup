return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {}
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {
      per_filetype = {
        rust = {
          enable_close = false,
          enable_rename = false,
          enable_close_on_slash = false,
        },
      },
    },
  }
}

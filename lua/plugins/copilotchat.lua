return {
  "CopilotC-Nvim/CopilotChat.nvim",
  build = "make tiktoken",
  dependencies = {
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  opts = {
    history_path = vim.fn.stdpath("data") .. "/copilot_history",
  },
  keys = {
    { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Chat" },
    { "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "Select Model" },
    { "<leader>cr", "<cmd>CopilotChatReset<cr>",  desc = "Reset Chat" },
    {
      "<leader>cn",
      function()
        local chat = require("CopilotChat")
        chat.save("chat_" .. os.date("%Y%m%d_%H%M%S"), nil, true)
        chat.reset()
        vim.cmd("CopilotChatOpen")
      end,
      desc = "New Chat"
    },
    {
      "<leader>chl",
      function()
        local chat = require("CopilotChat")
        local history_path = vim.fn.stdpath("data") .. "/copilot_history"
        local files = vim.fn.glob(history_path .. "/*.json", false, true)
        local items = {}

        for _, file in ipairs(files) do
          table.insert(items, { text = vim.fn.fnamemodify(file, ":t:r"), file = file })
        end

        Snacks.picker.pick({
          items = items,
          title = "Load Chat History",
          confirm = function(picker)
            local item = picker:current()
            chat.load(item.text)
            vim.cmd("CopilotChatOpen")
          end,
        })
      end,
      desc = "Load History"
    },
    {
      "<leader>chd",
      function()
        local history_path = vim.fn.stdpath("data") .. "/copilot_history"

        local function get_items()
          local files = vim.fn.glob(history_path .. "/*.json", false, true)
          local items = {}
          for _, file in ipairs(files) do
            table.insert(items, {
              text = vim.fn.fnamemodify(file, ":t:r"),
              file = file
            })
          end
          return items
        end

        Snacks.picker.pick({
          items = get_items(),
          title = "Delete Chat History",
          confirm = function(picker)
            local items = picker:selected()
            if #items == 0 then
              local current = picker:current()
              if current then items = { current } end
            end

            for _, item in ipairs(items) do
              vim.fn.delete(item.file)
              vim.notify("Deleted chat: " .. item.text)
            end

            picker:close()
          end,
        })
      end,
      desc = "Delete History"
    },
    {
      "<leader>cs",
      function()
        require("CopilotChat").save("manual_" .. os.date("%Y%m%d_%H%M%S"))
      end,
      desc = "Save Chat"
    },
  },
  config = function(_, opts)
    local chat_module = require("CopilotChat")
    chat_module.setup(opts)

    local original_save = chat_module.save
    chat_module.save = function(name, history_path, silent)
      if not silent then
        original_save(name, history_path)
      else
        local log = require('plenary.log')
        local old_info = log.info
        log.info = function() end
        pcall(original_save, name, history_path)
        log.info = old_info
      end
    end

    local timer = vim.loop.new_timer()
    timer:start(0, 10000, vim.schedule_wrap(function()
      pcall(chat_module.save, "autosave", nil, true)
    end))

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        timer:stop()
        chat_module.save("autosave", nil, true)
      end,
    })
  end,
}

local M = {}

local default_provider = "none"
local state_file = vim.fn.stdpath("config") .. "/lua/config/autocomplete_state.lua"

vim.g.copilot_enabled = 0
vim.g.copilot_no_tab_map = true
vim.g.copilot_no_maps = true

local providers = {
  { id = "none", name = "Off" },
  { id = "copilot", name = "Copilot" },
}

local by_id = {}
local ids = {}

for _, provider in ipairs(providers) do
  by_id[provider.id] = provider
  table.insert(ids, provider.id)
end

local current = default_provider

local function valid_provider(id)
  return by_id[id] and id or default_provider
end

local function quote_lua_string(value)
  return string.format("%q", value)
end

local function load_saved_provider()
  local ok, provider_id = pcall(function()
    package.loaded["config.autocomplete_state"] = nil
    return require("config.autocomplete_state")
  end)

  if ok and type(provider_id) == "string" then
    return valid_provider(provider_id)
  end

  return default_provider
end

local function save_provider(provider_id)
  provider_id = valid_provider(provider_id)

  local file = io.open(state_file, "w")
  if not file then
    return
  end

  file:write("return " .. quote_lua_string(provider_id) .. "\n")
  file:close()
  package.loaded["config.autocomplete_state"] = nil
end

local function refresh_lualine()
  pcall(function()
    require("lualine").refresh()
  end)
end

local function remove_accept_map()
  pcall(vim.keymap.del, "i", "<C-g>")
  pcall(vim.api.nvim_del_keymap, "i", "<C-g>")
end

local function map_accept()
  vim.keymap.set("i", "<C-g>", function()
    local ok, accepted = pcall(vim.fn["copilot#Accept"], "")
    if ok and type(accepted) == "string" then
      return accepted
    end
    return ""
  end, {
    expr = true,
    replace_keycodes = false,
    silent = true,
    noremap = true,
    desc = "Copilot: Accept",
  })
end

local function load_copilot()
  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy then
    pcall(lazy.load, { plugins = { "copilot.vim" } })
  end

  local autoload_files = vim.fn.globpath(vim.o.runtimepath, "autoload/copilot.vim", false, true)
  return vim.fn.exists(":Copilot") == 2 and type(autoload_files) == "table" and #autoload_files > 0
end

local function copilot_ready()
  local ok, result = pcall(vim.api.nvim_exec2, "Copilot status", { output = true })
  if not ok then
    return false
  end
  return (result.output or ""):find("Copilot: Ready", 1, true) ~= nil
end

local function disable_copilot()
  vim.g.copilot_enabled = 0
  if vim.fn.exists(":Copilot") == 2 then
    pcall(vim.cmd, "silent! Copilot disable")
  end
  remove_accept_map()
end

local function enable_copilot(opts)
  if not load_copilot() then
    return false
  end

  vim.g.copilot_enabled = 1
  pcall(vim.cmd, "silent! Copilot enable")
  map_accept()

  if opts.notify and copilot_ready() then
    vim.notify("AI completion: Copilot connected", vim.log.levels.INFO)
  end

  return true
end

function M.apply(provider_id, opts)
  opts = opts or {}
  provider_id = valid_provider(provider_id)

  disable_copilot()

  if provider_id == "copilot" then
    if enable_copilot(opts) then
      current = "copilot"
    else
      current = default_provider
    end
  else
    current = default_provider
  end

  vim.g.autocomplete_provider = current
  vim.g.autocomplete_provider_list = ids

  if opts.save ~= false then
    save_provider(current)
  end

  refresh_lualine()
  return current
end

local function pick_autocomplete()
  vim.ui.select(ids, {
    prompt = "Select autocomplete: ",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice)
    if choice then
      vim.schedule(function()
        M.apply(choice, { notify = true })
      end)
    end
  end)
end

local function cycle_autocomplete()
  local next_id = current == "none" and "copilot" or "none"
  M.apply(next_id, { notify = true })
end

vim.api.nvim_create_user_command("AutocompleteProvider", function(opts)
  if opts.args == "" then
    pick_autocomplete()
    return
  end

  if not by_id[opts.args] then
    vim.notify("Unknown autocomplete provider: " .. opts.args, vim.log.levels.ERROR)
    return
  end

  M.apply(opts.args, { notify = true })
end, {
  nargs = "?",
  complete = function()
    return ids
  end,
})

vim.keymap.set("n", "<leader>pa", pick_autocomplete, {
  noremap = true,
  silent = true,
  nowait = true,
  desc = "Pick autocomplete provider",
})

vim.g.autocomplete_provider_list = ids
M.apply(load_saved_provider(), { notify = false, save = false })

_G.apply_autocomplete = function(provider_id)
  return M.apply(provider_id, { notify = true })
end
_G.pick_autocomplete = pick_autocomplete
_G.cycle_autocomplete = cycle_autocomplete
_G.AUTOCOMPLETE_PROVIDERS = providers

return M

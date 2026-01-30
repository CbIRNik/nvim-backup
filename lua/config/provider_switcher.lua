-- Provider Switcher - система выбора провайдеров как для тем
-- Просто конфигурируй провайдеры и всё работает

local config_dir = vim.fn.stdpath("config")
local autocomplete_state_file = config_dir .. "/lua/config/autocomplete_state.lua"
local chat_state_file = config_dir .. "/lua/config/chat_state.lua"

-- ============ КОНФИГУРАЦИЯ ПРОВАЙДЕРОВ ============

local AUTOCOMPLETE_PROVIDERS = {
  -- {
  --   id = "codeium",
  --   name = "Codeium",
  --   plugin = "Exafunction/codeium.vim",
  --   accept_key = function()
  --     return vim.fn["codeium#Accept"]()
  --   end,
  --   on_enable = function()
  --     vim.g.codeium_enabled = true
  --   end,
  --   on_disable = function()
  --     vim.g.codeium_enabled = false
  --   end,
  -- },
  {
    id = "copilot",
    name = "Copilot",
    plugin = "github/copilot.vim",
    accept_key = function()
      return vim.fn["copilot#Accept"]()
    end,
    on_enable = function()
      -- Copilot работает через cmp source
    end,
    on_disable = function()
    end,
  },
  {
    id = "none",
    name = "None",
    plugin = nil,
    accept_key = nil,
    on_enable = function()
    end,
    on_disable = function()
    end,
  },
}

-- ============ ЗАГРУЗКА И СОХРАНЕНИЕ СОСТОЯНИЯ ============

-- Кэш текущего состояния в памяти (для быстрого доступа)
local current_autocomplete_cached = nil

-- Кэш списков ID (инициализируются при загрузке)
local autocomplete_ids_cached = nil

local function get_cached_autocomplete_ids()
  if autocomplete_ids_cached == nil then
    autocomplete_ids_cached = {}
    for _, provider in ipairs(AUTOCOMPLETE_PROVIDERS) do
      table.insert(autocomplete_ids_cached, provider.id)
    end
  end
  return autocomplete_ids_cached
end

local function save_state(state_file, id)
  local content = string.format("return '%s'", id)
  local file = io.open(state_file, "w")
  if file then
    file:write(content)
    file:close()
  end
end

local function load_state(state_file, default)
  local file = io.open(state_file, "r")
  if not file then
    return default
  end
  local content = file:read("*a")
  file:close()

  local ok, state = pcall(function()
    return load(content)()
  end)
  return ok and state or default
end

local function get_autocomplete_cached()
  if current_autocomplete_cached == nil then
    current_autocomplete_cached = load_state(autocomplete_state_file, "codeium")
  end
  return current_autocomplete_cached
end

local function set_autocomplete_cached(id)
  current_autocomplete_cached = id
end

-- ============ AUTOCOMPLETE PROVIDERS ============

local function get_autocomplete_by_id(id)
  for _, provider in ipairs(AUTOCOMPLETE_PROVIDERS) do
    if provider.id == id then
      return provider
    end
  end
  return nil
end

local function apply_autocomplete(provider_id)
  pcall(function()
    local provider = get_autocomplete_by_id(provider_id)
    if not provider then
      vim.notify("Unknown autocomplete provider: " .. provider_id, vim.log.levels.ERROR)
      return
    end

    -- Отключить все остальные
    for _, p in ipairs(AUTOCOMPLETE_PROVIDERS) do
      if p.on_disable and p.id ~= provider_id then
        pcall(p.on_disable)
      end
    end

    -- Включить текущий
    if provider.on_enable then
      pcall(provider.on_enable)
    end

    -- Установить маппинг <C-g> только если не "none"
    if provider.id ~= "none" and provider.accept_key then
      vim.keymap.set("i", "<C-g>", function()
        return provider.accept_key()
      end, { expr = true, silent = true, noremap = true, desc = provider.name .. ": Accept" })
    else
      -- Удалить маппинг если "none"
      pcall(vim.api.nvim_del_keymap, "i", "<C-g>")
    end

    -- Обновить переменную для lualine (мгновенно)
    vim.g.autocomplete_provider = provider_id
    vim.g.autocomplete_provider_list = { "codeium", "copilot", "none" }

    -- --- Обновить настройки nvim-cmp: добавить/убрать источник `copilot`
    local ok_cmp, cmp = pcall(require, "cmp")
    if ok_cmp then
      local sources = {}
      if provider.id == "copilot" then
        table.insert(sources, { name = 'copilot' })
      end
      table.insert(sources, { name = 'nvim_lsp' })
      table.insert(sources, { name = 'vsnip' })
      -- buffer source as fallback group
      pcall(function()
        cmp.setup({
          sources = cmp.config.sources(sources, { { name = 'buffer' } })
        })
      end)
    end

    -- Попробовать включить/выключить `Copilot` если есть соответствующие команды
    if provider.id == "copilot" then
      pcall(vim.cmd, "Copilot enable")
      vim.g.copilot_enabled = true
    else
      pcall(vim.cmd, "Copilot disable")
      vim.g.copilot_enabled = false
    end

    -- Обновить кэш
    set_autocomplete_cached(provider_id)

    -- Сохранить состояние синхронно (важно для персистенции)
    save_state(autocomplete_state_file, provider_id)

    -- Уведомить асинхронно (не блокирует UI)
    vim.schedule(function()
      vim.notify("✅ Autocomplete: " .. provider.name, vim.log.levels.INFO)
    end)
  end)
end

local function pick_autocomplete()
  -- Используем кэшированный список ID
  local ids = get_cached_autocomplete_ids()

  if #ids == 0 then
    vim.notify("No autocomplete providers found", vim.log.levels.WARN)
    return
  end

  vim.ui.select(ids, {
    prompt = "Select autocomplete: ",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice)
    if choice then
      -- Применяем асинхронно чтобы меню закрылось немедленно
      vim.schedule(function()
        apply_autocomplete(choice)
      end)
    end
  end)
end

local function cycle_autocomplete()
  local current = get_autocomplete_cached()
  local current_idx = 1

  for i, provider in ipairs(AUTOCOMPLETE_PROVIDERS) do
    if provider.id == current then
      current_idx = i
      break
    end
  end

  local next_idx = (current_idx % #AUTOCOMPLETE_PROVIDERS) + 1
  apply_autocomplete(AUTOCOMPLETE_PROVIDERS[next_idx].id)
end

-- ============ КОМАНДЫ И МАППИНГИ ============

-- Команды
vim.api.nvim_create_user_command("AutocompleteProvider", function(opts)
  if opts.args == "" then
    pick_autocomplete()
  else
    apply_autocomplete(opts.args)
  end
end, {
  nargs = "?",
  complete = function()
    return get_cached_autocomplete_ids()
  end,
})

-- Маппинги (как для тем)
vim.keymap.set("n", "<leader>pa", pick_autocomplete, {
  noremap = true,
  silent = true,
  nowait = true,
  desc = "Pick autocomplete provider",
})

-- ============ ИНИЦИАЛИЗАЦИЯ ============

-- Инициализируем кэши ID списков
get_cached_autocomplete_ids()

local saved_autocomplete = load_state(autocomplete_state_file, "copilot")
set_autocomplete_cached(saved_autocomplete)
-- Отложим инициализацию применения провайдеров (не блокирует загрузку конфига)
vim.schedule(function()
  apply_autocomplete(saved_autocomplete)
end)


-- Экспортируем список провайдеров для lualine
vim.g.autocomplete_provider_list = { "codeium", "copilot", "none" }
vim.g.autocomplete_provider = saved_autocomplete

-- ============ ЭКСПОРТ ============

_G.apply_autocomplete = apply_autocomplete
_G.pick_autocomplete = pick_autocomplete
_G.cycle_autocomplete = cycle_autocomplete
_G.apply_chat = apply_chat
_G.pick_chat = pick_chat
_G.cycle_chat = cycle_chat
_G.AUTOCOMPLETE_PROVIDERS = AUTOCOMPLETE_PROVIDERS
_G.CHAT_PROVIDERS = CHAT_PROVIDERS

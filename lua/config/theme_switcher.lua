local config_dir = vim.fn.stdpath("config")
local state_file = config_dir .. "/lua/config/theme_state.lua"

-- Функция для получения всех доступных тем
local function get_available_themes()
    local themes = vim.fn.getcompletion("", "color")
    -- Фильтруем и сортируем
    table.sort(themes)
    return themes
end

-- Функция для сохранения темы в файл
local function save_theme(theme_name)
    local content = string.format("return '%s'", theme_name)
    local file = io.open(state_file, "w")
    if file then
        file:write(content)
        file:close()
    end
end

-- Функция для загрузки сохраненной темы
local function load_saved_theme()
    local ok, theme = pcall(function()
        return require("config.theme_state")
    end)
    return ok and theme or "catppuccin"
end

-- Функция для применения и сохранения темы
local function apply_theme(theme_name)
    pcall(function()
        vim.cmd("colorscheme " .. theme_name)
        save_theme(theme_name)

        -- Перезагружаем lualine для подстройки под новую тему
        pcall(function()
            require("lualine").refresh()
        end)

        vim.notify("Theme: " .. theme_name, vim.log.levels.INFO, {
            title = "Theme Switcher",
        })
    end)
end

-- Функция для открытия picker с выбором темы
local function pick_theme()
    local available_themes = get_available_themes()

    if #available_themes == 0 then
        vim.notify("No themes found", vim.log.levels.WARN, {
            title = "Theme Switcher",
        })
        return
    end

    vim.ui.select(available_themes, {
        prompt = "Select theme: ",
        format_item = function(item)
            return "  " .. item
        end,
    }, function(choice)
        if choice then
            apply_theme(choice)
        end
    end)
end

-- Загружаем сохраненную тему при старте
local saved_theme = load_saved_theme()
pcall(function()
    vim.cmd("colorscheme " .. saved_theme)
end)

-- Маппинг для открытия picker тем
vim.keymap.set("n", "<leader>uth", pick_theme, {
    noremap = true,
    silent = true,
    desc = "Choose colorscheme",
})

-- Экспортируем функции
_G.pick_theme = pick_theme
_G.apply_theme = apply_theme
_G.save_theme = save_theme
_G.get_available_themes = get_available_themes

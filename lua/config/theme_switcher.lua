local config_dir = vim.fn.stdpath("config")
local state_file = config_dir .. "/lua/config/theme_state.lua"

local themes = {
    "catppuccin",
    "nordic",
}

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

-- Функция для смены темы с сохранением
local function set_theme(theme_name)
    vim.cmd("colorscheme " .. theme_name)
    save_theme(theme_name)
    vim.notify("Theme: " .. theme_name, vim.log.levels.INFO, {
        title = "Theme Switcher",
    })
end

-- Функция для открытия picker с темами
local function theme_picker()
    local themes_list = {}
    for _, theme in ipairs(themes) do
        table.insert(themes_list, {
            text = theme,
            value = theme,
        })
    end

    vim.ui.select(themes, {
        prompt = "Select theme: ",
        format_item = function(item)
            return "  " .. item
        end,
    }, function(choice)
        if choice then
            set_theme(choice)
        end
    end)
end

-- Загружаем сохраненную тему при старте
local saved_theme = load_saved_theme()
vim.cmd("colorscheme " .. saved_theme)

-- Клавиатурные маппинги
vim.keymap.set("n", "<leader>uth", theme_picker, {
    noremap = true,
    silent = true,
    desc = "Select theme",
})

-- Экспортируем функции
_G.save_theme = save_theme
_G.load_saved_theme = load_saved_theme
_G.set_theme = set_theme
_G.theme_picker = theme_picker

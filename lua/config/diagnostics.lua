local signs = {
    Error = "󰅚 ",
    Warn = "󰀪 ",
    Hint = "󰌶 ",
    Info = "󰋽 ",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = true,
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

-- Переменная для отслеживания открытого диагностического окна
local diag_win = nil
local diag_buf = nil

local function close_diag_window()
    if diag_win and vim.api.nvim_win_is_valid(diag_win) then
        vim.api.nvim_win_close(diag_win, true)
        diag_win = nil
        diag_buf = nil
    end
end

local function open_diagnostic_float()
    -- Если окно уже открыто - закрываем его
    if diag_win and vim.api.nvim_win_is_valid(diag_win) then
        close_diag_window()
        return
    end

    -- Открываем новое окно диагностики
    local buf, win = vim.diagnostic.open_float({
        border = "rounded",
        focusable = true,
        max_width = 80,
    })

    if win then
        diag_win = win
        diag_buf = buf

        -- Добавляем маппинг Esc в буфер диагностики
        vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
            noremap = true,
            silent = true,
            callback = function()
                close_diag_window()
            end,
        })
    end
end

vim.keymap.set("n", "<space>cd", open_diagnostic_float, {
    noremap = true,
    silent = true,
    desc = "Show line diagnostics",
})

-- Автоматически подстраиваем цвета диагностики под тему
local function setup_diagnostic_highlights()
    -- Используем встроенные группы которые подстраиваются под тему
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "DiagnosticSignHint", { link = "DiagnosticHint" })
end

-- Вызываем при загрузке
setup_diagnostic_highlights()

-- Пересчитываем при смене темы
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("DiagnosticHighlights", { clear = true }),
    callback = setup_diagnostic_highlights,
})

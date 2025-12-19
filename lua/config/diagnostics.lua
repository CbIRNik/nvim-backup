vim.diagnostic.config({
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
        },
    },
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

-- Функция открытия диагностики
local function open_diagnostics()
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

    if win and buf then
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

        -- Переводим фокус на окно диагностики
        vim.api.nvim_set_current_win(win)
    end
end

-- Маппинг для открытия/закрытия диагностики
vim.keymap.set("n", "<space>cd", open_diagnostics, {
    noremap = true,
    silent = true,
    desc = "Show line diagnostics",
})

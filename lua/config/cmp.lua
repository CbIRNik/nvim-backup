local cmp = require 'cmp'

local function truncate(text, max)
    text = tostring(text or ""):gsub("%s+", " ")
    if #text <= max then
        return text
    end
    return text:sub(1, max - 3) .. "..."
end

local function cargo_tom_ranked_label(label)
    local rank, name = label:match("^(%d+)%.%s+(.+)$")
    if not rank then
        return label
    end

    return string.format("#%02d  %s", tonumber(rank) + 1, name)
end

local function lsp_client_name(entry)
    local source = entry.source and entry.source.source
    local client = source and source.client
    return client and client.name
end

cmp.setup({
    preselect = cmp.PreselectMode.None,
    completion = {
        completeopt = "menu,menuone,noinsert,noselect",
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
        completion = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None",
        },
    },
    formatting = {
        format = function(entry, item)
            if vim.fn.expand("%:t") == "Cargo.toml"
                and (entry.source.name == "cargo_tom" or lsp_client_name(entry) == "cargo_tom") then
                item.abbr = cargo_tom_ranked_label(item.abbr)
                item.kind = ""

                local detail = entry.completion_item and entry.completion_item.detail
                if type(detail) == "string" and detail ~= "" then
                    item.menu = " " .. truncate(detail, 56)
                end
            end

            return item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end, { 'i' }),
        ['<Down>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end, { 'i' }),
        ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end, { 'i' }),
        ['<Up>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end, { 'i' }),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Esc>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.abort()
            else
                fallback()
            end
        end, { 'i' }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif vim.fn["vsnip#available"](1) == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', false, true, true), '')
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', false, true, true), '')
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'buffer' },
    })
})

local function is_cargo_toml(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    return vim.fn.fnamemodify(name, ":t") == "Cargo.toml"
end

local function cargo_toml_section(row)
    for line = row, 1, -1 do
        local text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""
        local section = text:match("^%s*%[+%s*([^%]]-)%s*%]+%s*$")
        if section then
            return vim.trim(section)
        end
    end
end

local function cargo_toml_dependency_section(section)
    if not section then
        return false
    end

    return section == "dependencies"
        or section == "dev-dependencies"
        or section == "build-dependencies"
        or section == "workspace.dependencies"
        or section:match("^dependencies%.") ~= nil
        or section:match("^dev%-dependencies%.") ~= nil
        or section:match("^build%-dependencies%.") ~= nil
        or section:match("^workspace%.dependencies%.") ~= nil
        or section:match("^target%.+%.dependencies$") ~= nil
        or section:match("^target%.+%.dependencies%.") ~= nil
        or section:match("^target%.+%.dev%-dependencies$") ~= nil
        or section:match("^target%.+%.dev%-dependencies%.") ~= nil
        or section:match("^target%.+%.build%-dependencies$") ~= nil
        or section:match("^target%.+%.build%-dependencies%.") ~= nil
end

local function cargo_toml_value_completion_context()
    if not is_cargo_toml(vim.api.nvim_get_current_buf()) then
        return false
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    if not cargo_toml_dependency_section(cargo_toml_section(cursor[1])) then
        return false
    end

    local line = vim.api.nvim_get_current_line()
    local before = line:sub(1, cursor[2] + 1)

    if before:match('version%s*=%s*"[^"]*$') then
        return true
    end

    if before:match('features%s*=%s*%[[^%]]*"[^"]*$') then
        return true
    end

    if before:match('^%s*[%w_%-%.]+%s*=%s*"[^"]*$') then
        return true
    end

    return false
end

local function cargo_toml_library_completion_context()
    if not is_cargo_toml(vim.api.nvim_get_current_buf()) then
        return false
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    if not cargo_toml_dependency_section(cargo_toml_section(cursor[1])) then
        return false
    end

    if cargo_toml_value_completion_context() then
        return false
    end

    local line = vim.api.nvim_get_current_line()
    local before = line:sub(1, cursor[2] + 1)

    return before:match("^%s*[%w_%-%.]*$") ~= nil
end

local cargo_toml_field_items = {
    {
        label = "version",
        insertText = 'version = "$1"',
        insertTextFormat = 2,
        detail = "Dependency version requirement",
    },
    {
        label = "features",
        insertText = "features = [$1]",
        insertTextFormat = 2,
        detail = "Enabled crate features",
    },
    {
        label = "optional",
        insertText = "optional = $1",
        insertTextFormat = 2,
        detail = "Mark dependency as optional",
    },
    {
        label = "default-features",
        insertText = "default-features = $1",
        insertTextFormat = 2,
        detail = "Enable or disable default features",
    },
    {
        label = "package",
        insertText = 'package = "$1"',
        insertTextFormat = 2,
        detail = "Package name when dependency key is renamed",
    },
    {
        label = "registry",
        insertText = 'registry = "$1"',
        insertTextFormat = 2,
        detail = "Registry name",
    },
    {
        label = "path",
        insertText = 'path = "$1"',
        insertTextFormat = 2,
        detail = "Local dependency path",
    },
    {
        label = "git",
        insertText = 'git = "$1"',
        insertTextFormat = 2,
        detail = "Git repository URL",
    },
    {
        label = "branch",
        insertText = 'branch = "$1"',
        insertTextFormat = 2,
        detail = "Git branch",
    },
    {
        label = "tag",
        insertText = 'tag = "$1"',
        insertTextFormat = 2,
        detail = "Git tag",
    },
    {
        label = "rev",
        insertText = 'rev = "$1"',
        insertTextFormat = 2,
        detail = "Git revision",
    },
    {
        label = "workspace",
        insertText = "workspace = $1",
        insertTextFormat = 2,
        detail = "Use workspace dependency",
    },
}

local function cargo_toml_inline_field_context()
    if not is_cargo_toml(vim.api.nvim_get_current_buf()) then
        return false
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    if not cargo_toml_dependency_section(cargo_toml_section(cursor[1])) then
        return false
    end

    if cargo_toml_value_completion_context() then
        return false
    end

    local line = vim.api.nvim_get_current_line()
    local before = line:sub(1, cursor[2] + 1)
    if not before:match("=%s*{") then
        return false
    end

    local field = before:match(".*[{,]%s*([^,{}]*)$")
    return field ~= nil and field:match("^%s*[%w_%-]*%s*$") ~= nil
end

local function cargo_toml_existing_fields()
    local fields = {}
    local line = vim.api.nvim_get_current_line()
    for field in line:gmatch("([%w_%-]+)%s*=") do
        fields[field] = true
    end
    return fields
end

local cargo_tom_source_registered = false
local cargo_tom_field_source_registered = false

local function register_cargo_tom_source()
    if cargo_tom_source_registered then
        return
    end

    cmp.register_source("cargo_tom", {
        is_available = function()
            return cargo_toml_library_completion_context()
                and #vim.lsp.get_clients({ bufnr = 0, name = "cargo_tom" }) > 0
        end,

        get_debug_name = function()
            return "cargo_tom"
        end,

        get_keyword_pattern = function()
            return [[\([^"'\%^<>=~,\s]\)*]]
        end,

        complete = function(_, params, callback)
            if not cargo_toml_library_completion_context() then
                callback()
                return
            end

            local client = vim.lsp.get_clients({ bufnr = 0, name = "cargo_tom" })[1]
            if not client then
                callback()
                return
            end

            local lsp_params = vim.lsp.util.make_position_params(0, client.offset_encoding or "utf-16")
            lsp_params.context = {
                triggerKind = params.completion_context and params.completion_context.triggerKind or 1,
                triggerCharacter = params.completion_context and params.completion_context.triggerCharacter or nil,
            }

            client:request("textDocument/completion", lsp_params, function(err, result)
                if err then
                    callback()
                    return
                end

                callback(result)
            end, 0)
        end,
    })

    cargo_tom_source_registered = true
end

local function register_cargo_tom_field_source()
    if cargo_tom_field_source_registered then
        return
    end

    cmp.register_source("cargo_tom_fields", {
        is_available = cargo_toml_inline_field_context,

        get_debug_name = function()
            return "cargo_tom_fields"
        end,

        get_keyword_pattern = function()
            return [[\([[:keyword:]-]\)*]]
        end,

        get_trigger_characters = function()
            return { "{", ",", " " }
        end,

        complete = function(_, _, callback)
            if not cargo_toml_inline_field_context() then
                callback()
                return
            end

            local existing = cargo_toml_existing_fields()
            local items = {}
            for _, item in ipairs(cargo_toml_field_items) do
                if not existing[item.label] then
                    table.insert(items, item)
                end
            end

            callback({
                isIncomplete = false,
                items = items,
            })
        end,
    })

    cargo_tom_field_source_registered = true
end

local function cargo_toml_sources()
    return {
        {
            name = 'cargo_tom',
            keyword_length = 1,
            max_item_count = 25,
        },
        {
            name = 'cargo_tom_fields',
            keyword_length = 0,
            max_item_count = 12,
        },
        {
            name = 'nvim_lsp',
            keyword_length = 0,
            max_item_count = 25,
        },
    }
end

local function setup_cargo_toml_completion(bufnr)
    if not is_cargo_toml(bufnr) then
        return
    end

    register_cargo_tom_source()
    register_cargo_tom_field_source()

    cmp.setup.buffer({
        sources = cargo_toml_sources(),
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("FateCargoTomlCompletion", { clear = true }),
    pattern = "toml",
    callback = function(args)
        setup_cargo_toml_completion(args.buf)
    end,
})

setup_cargo_toml_completion(0)

-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

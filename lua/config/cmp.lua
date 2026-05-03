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

cmp.setup({
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
            if vim.fn.expand("%:t") == "Cargo.toml" and entry.source.name == "nvim_lsp" then
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
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', false, true, true), '')
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
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

local function setup_cargo_toml_completion(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if vim.fn.fnamemodify(name, ":t") ~= "Cargo.toml" then
        return
    end

    cmp.setup.buffer({
        sources = cmp.config.sources({
            { name = 'nvim_lsp', keyword_length = 1, max_item_count = 25 },
            { name = 'path' },
        }, {
            { name = 'buffer' },
        }),
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

# Neovim Keymaps

Список собран из двух источников:

- активные runtime-мэппинги после старта `nvim`
- буферные маппинги, которые появляются только при attach `LSP`, `gitsigns` или `crates.nvim`

## Основа

- `Leader`: `<Space>`
- `LocalLeader`: `\`
- Режимы: `n` = normal, `i` = insert, `v` = visual, `x` = visual, `s` = select, `o` = operator-pending, `t` = terminal

## Важное замечание

- Явные клавиатурные переходы по окнам теперь добавлены: `Ctrl+h/j/k/l`.
- Явные переходы по буферам теперь добавлены: `Shift+h` и `Shift+l`.
- Встроенные дефолты Neovim вроде `Ctrl-w h/j/k/l`, `:split`, `:vsplit`, `:bnext`, `:terminal`, `/`, `?`, `n`, `N` тоже доступны и ниже перечислены как часть keyboard-only workflow.

## Кастомные маппинги из конфига

### Окна и буферы

| Key | Mode | Action |
| --- | --- | --- |
| `<C-h>` | `n`, `t` | Focus left window |
| `<C-j>` | `n`, `t` | Focus lower window |
| `<C-k>` | `n`, `t` | Focus upper window |
| `<C-l>` | `n`, `t` | Focus right window |
| `<S-h>` | `n` | Previous buffer |
| `<S-l>` | `n` | Next buffer |

### Поиск, навигация, файлы

| Key | Mode | Action |
| --- | --- | --- |
| `<leader><space>` | `n` | Smart Find Files |
| `<leader>,` | `n` | Buffers |
| `<leader>/` | `n` | Grep |
| `<leader>:` | `n` | Command History |
| `<leader>e` | `n` | File Explorer |
| `<leader>fb` | `n` | Buffers |
| `<leader>fc` | `n` | Find Config File |
| `<leader>ff` | `n` | Find Files |
| `<leader>fg` | `n` | Find Git Files |
| `<leader>fp` | `n` | Projects |
| `<leader>fr` | `n` | Recent |
| `<leader>s"` | `n` | Registers |
| `<leader>s/` | `n` | Search History |
| `<leader>sa` | `n` | Autocmds |
| `<leader>sb` | `n` | Buffer Lines |
| `<leader>sB` | `n` | Grep Open Buffers |
| `<leader>sc` | `n` | Command History |
| `<leader>sC` | `n` | Commands |
| `<leader>sd` | `n` | Diagnostics |
| `<leader>sD` | `n` | Buffer Diagnostics |
| `<leader>sg` | `n` | Grep |
| `<leader>sh` | `n` | Help Pages |
| `<leader>sH` | `n` | Highlights |
| `<leader>si` | `n` | Icons |
| `<leader>sj` | `n` | Jumps |
| `<leader>sk` | `n` | Keymaps |
| `<leader>sl` | `n` | Location List |
| `<leader>sm` | `n` | Marks |
| `<leader>sM` | `n` | Man Pages |
| `<leader>sp` | `n` | Search for Plugin Spec |
| `<leader>sq` | `n` | Quickfix List |
| `<leader>sR` | `n` | Resume |
| `<leader>ss` | `n` | LSP Symbols |
| `<leader>sS` | `n` | LSP Workspace Symbols |
| `<leader>su` | `n` | Undo History |
| `<leader>sw` | `n`, `x`, `v` | Visual selection or word |

### Git

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>gb` | `n` | Git Branches |
| `<leader>gB` | `n`, `v`, `x`, `s` | Git Browse |
| `<leader>gd` | `n` | Git Diff (Hunks) |
| `<leader>gf` | `n` | Git Log File |
| `<leader>gg` | `n` | Lazygit |
| `<leader>gl` | `n` | Git Log |
| `<leader>gL` | `n` | Git Log Line |
| `<leader>gs` | `n` | Git Status |
| `<leader>gS` | `n` | Git Stash |

Буферные `gitsigns`-маппинги:

| Key | Mode | Action |
| --- | --- | --- |
| `]c` | `n` | Next hunk |
| `[c` | `n` | Previous hunk |
| `<leader>hs` | `n` | Stage hunk |
| `<leader>hr` | `n` | Reset hunk |
| `<leader>hs` | `v` | Stage selected hunk |
| `<leader>hr` | `v` | Reset selected hunk |
| `<leader>hS` | `n` | Stage buffer |
| `<leader>hR` | `n` | Reset buffer |
| `<leader>hp` | `n` | Preview hunk |
| `<leader>hb` | `n` | Blame line |
| `<leader>hd` | `n` | Diff this |

### Сессии, scratch, UI

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>.` | `n` | Toggle Scratch Buffer |
| `<leader>S` | `n` | Select Scratch Buffer |
| `<leader>bd` | `n` | Delete Buffer |
| `<leader>cR` | `n` | Rename File |
| `<leader>n` | `n` | Notification History |
| `<leader>N` | `n` | Neovim News |
| `<leader>un` | `n` | Dismiss All Notifications |
| `<leader>wd` | `n` | Delete session |
| `<leader>wl` | `n` | Load session |
| `<leader>wr` | `n` | Restore session |
| `<leader>ws` | `n` | Save session |
| `<leader>z` | `n` | Toggle Zen Mode |
| `<leader>Z` | `n` | Toggle Zoom |
| `<C-/>` | `n` | Toggle Terminal |
| `<C-_>` | `n` | Alias / which-key ignore |
| `[[` | `n`, `t` | Prev Reference |
| `]]` | `n`, `t` | Next Reference |

### Toggle-ы

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>uC` | `n` | Colorschemes |
| `<leader>uD` | `n` | Toggle dim mode |
| `<leader>uL` | `n` | Toggle relative number |
| `<leader>uT` | `n` | Toggle Treesitter |
| `<leader>ub` | `n` | Toggle dark background |
| `<leader>uc` | `n` | Toggle conceal level |
| `<leader>ud` | `n` | Toggle diagnostics |
| `<leader>ug` | `n` | Toggle indent guides |
| `<leader>uh` | `n` | Toggle inlay hints |
| `<leader>ul` | `n` | Toggle line numbers |
| `<leader>us` | `n` | Toggle spelling |
| `<leader>uw` | `n` | Toggle wrap |
| `<leader>uth` | `n` | Choose colorscheme |

### LSP

Глобальные:

| Key | Mode | Action |
| --- | --- | --- |
| `gd` | `n` | Goto Definition |
| `gD` | `n` | Goto Declaration |
| `gI` | `n` | Goto Implementation |
| `gr` | `n` | References |
| `gy` | `n` | Goto Type Definition |

Runtime LSP/default маппинги, которые активны в Neovim:

| Key | Mode | Action |
| --- | --- | --- |
| `gO` | `n` | `vim.lsp.buf.document_symbol()` |
| `gra` | `n`, `v`, `x` | `vim.lsp.buf.code_action()` |
| `gri` | `n` | `vim.lsp.buf.implementation()` |
| `grn` | `n` | `vim.lsp.buf.rename()` |
| `grr` | `n` | `vim.lsp.buf.references()` |
| `grt` | `n` | `vim.lsp.buf.type_definition()` |
| `<C-S>` | `i`, `v`, `s` | `vim.lsp.buf.signature_help()` |
| `<C-W>d` | `n` | Show diagnostics under cursor |
| `<C-W><C-D>` | `n` | Show diagnostics under cursor |
| `[d` | `n` | Previous diagnostic |
| `]d` | `n` | Next diagnostic |
| `[D` | `n` | First diagnostic in current buffer |
| `]D` | `n` | Last diagnostic in current buffer |

Буферные LSP-мэппинги из твоего конфига:

| Key | Mode | Action |
| --- | --- | --- |
| `K` | `n` | Hover |
| `<leader>ca` | `n` | Code Action |
| `<leader>cr` | `n` | Rename Symbol |
| `<leader>cf` | `n`, `v` | Format Buffer |

### Rust / Cargo

Буферные маппинги `crates.nvim` в `Cargo.toml`:

| Key | Mode | Action |
| --- | --- | --- |
| `K` | `n` | Show crate versions popup |
| `<leader>cr` | `n` | Reload crate metadata |
| `<leader>cv` | `n` | Show crate versions popup |
| `<leader>cf` | `n` | Show crate features popup |
| `<leader>cd` | `n` | Open crate documentation |
| `<leader>cu` | `n` | Update crate under cursor |
| `<leader>cu` | `v` | Update selected crates |
| `<leader>cU` | `n` | Upgrade crate under cursor |
| `<leader>cU` | `v` | Upgrade selected crates |
| `<leader>cx` | `n` | Expand plain crate to inline table |
| `<leader>cH` | `n` | Open crate homepage |
| `<leader>cR` | `n` | Open crate repository |
| `<leader>cC` | `n` | Open crate on crates.io |

### Copilot Chat и autocomplete

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>cc` | `n` | Toggle Chat |
| `<leader>cm` | `n` | Select Model |
| `<leader>cn` | `n` | New Chat |
| `<leader>cr` | `n` | Reset Chat |
| `<leader>cs` | `n` | Save Chat |
| `<leader>chl` | `n` | Load History |
| `<leader>chd` | `n` | Delete History |
| `<leader>pa` | `n` | Pick autocomplete provider |
| `<C-g>` | `i` | Accept current autocomplete provider suggestion |

Активные insert-mode бинды от `copilot.vim`:

| Key | Mode | Action |
| --- | --- | --- |
| `<C-]>` | `i` | Dismiss copilot suggestion |
| `<M-Bslash>` | `i` | Suggest |
| `<M-C-Right>` | `i` | Accept line |
| `<M-Right>` | `i` | Accept word |
| `<M-[>` | `i` | Previous suggestion |
| `<M-]>` | `i` | Next suggestion |
| `<Tab>` | `i` | Accept copilot suggestion or insert tab |

### Completion / snippets

| Key | Mode | Action |
| --- | --- | --- |
| `<C-b>` | `i` | Scroll docs up |
| `<C-f>` | `i` | Scroll docs down |
| `<C-Space>` | `i` | Completion |
| `<C-e>` | `i` | Abort completion |
| `<Esc>` | `i` | Close completion or fallback |
| `<CR>` | `i` | Confirm completion |
| `<Tab>` | `i`, `s` | Next item or snippet expand/jump |
| `<S-Tab>` | `i`, `v`, `s` | Previous item or snippet jump back |

Runtime snippet plug-maps:

| Key | Mode | Action |
| --- | --- | --- |
| `<Plug>(vsnip-expand)` | `i`, `v`, `s` | Expand snippet |
| `<Plug>(vsnip-expand-or-jump)` | `i`, `v`, `s` | Expand or jump |
| `<Plug>(vsnip-jump-next)` | `i`, `v`, `s` | Jump next |
| `<Plug>(vsnip-jump-prev)` | `i`, `v`, `s` | Jump prev |
| `<Plug>(vsnip-cut-text)` | `n`, `v`, `x`, `s` | Cut text into snippet placeholder |
| `<Plug>(vsnip-select-text)` | `n`, `v`, `x`, `s` | Select text for snippet placeholder |

### Treesitter

| Key | Mode | Action |
| --- | --- | --- |
| `gnn` | `n` | Init incremental selection |
| `grn` | `n` | Increment node selection |
| `grc` | `n` | Increment scope selection |
| `grm` | `n` | Decrement node selection |

## Активные built-in / plugin default маппинги, которые тоже есть в runtime

### Буферы, списки, quickfix, tabs

| Key | Mode | Action |
| --- | --- | --- |
| `[b` | `n` | `:bprevious` |
| `]b` | `n` | `:bnext` |
| `[a` | `n` | `:previous` |
| `]a` | `n` | `:next` |
| `[l` | `n` | `:lprevious` |
| `]l` | `n` | `:lnext` |
| `[L` | `n` | `:lrewind` |
| `]L` | `n` | `:llast` |
| `[q` | `n` | `:cprevious` |
| `]q` | `n` | `:cnext` |
| `[Q` | `n` | `:crewind` |
| `]Q` | `n` | `:clast` |
| `[t` | `n` | `:tprevious` |
| `]t` | `n` | `:tnext` |
| `[T` | `n` | `:trewind` |
| `]T` | `n` | `:tlast` |
| `[<C-T>` | `n` | `:ptprevious` |
| `]<C-T>` | `n` | `:ptnext` |
| `[<C-L>` | `n` | `:lpfile` |
| `]<C-L>` | `n` | `:lnfile` |
| `[<C-Q>` | `n` | `:cpfile` |
| `]<C-Q>` | `n` | `:cnfile` |
| `[A` | `n` | `:rewind` |
| `]A` | `n` | `:last` |
| `[B` | `n` | `:brewind` |
| `]B` | `n` | `:blast` |

### Комментирование и ссылки

| Key | Mode | Action |
| --- | --- | --- |
| `gc` | `n`, `v`, `x`, `o` | Toggle comment / comment textobject |
| `gcc` | `n` | Toggle comment line |
| `gx` | `n`, `v`, `x` | Open filepath or URI under cursor |

### Matchit и текстовые объекты

| Key | Mode | Action |
| --- | --- | --- |
| `%` | `n`, `v`, `x`, `o` | Matchit forward |
| `g%` | `n`, `v`, `x`, `o` | Matchit backward |
| `[%` | `n`, `v`, `x`, `o` | Matchit multi backward |
| `]%` | `n`, `v`, `x`, `o` | Matchit multi forward |
| `a%` | `v`, `x` | Matchit textobject |

### Строки и экран

| Key | Mode | Action |
| --- | --- | --- |
| `[<Space>` | `n` | Add empty line above cursor |
| `]<Space>` | `n` | Add empty line below cursor |
| `Y` | `n` | Default `Y` behavior |
| `&` | `n` | Default `&` behavior |

### Ключевые default-мэппинги Neovim для работы без мыши

Эти бинды не всегда видны через `nvim_get_keymap()`, потому что это built-in поведение редактора, а не user maps.

| Key | Mode | Action |
| --- | --- | --- |
| `<C-w>h` | `n` | Перейти в левое окно |
| `<C-w>j` | `n` | Перейти в нижнее окно |
| `<C-w>k` | `n` | Перейти в верхнее окно |
| `<C-w>l` | `n` | Перейти в правое окно |
| `<C-w>s` | `n` | Горизонтальный split |
| `<C-w>v` | `n` | Вертикальный split |
| `<C-w>c` | `n` | Закрыть текущее окно |
| `<C-w>o` | `n` | Оставить только текущее окно |
| `<C-w>=` | `n` | Выровнять размеры окон |
| `:split` | `c` | Горизонтальный split |
| `:vsplit` | `c` | Вертикальный split |
| `:close` | `c` | Закрыть окно |
| `:only` | `c` | Оставить одно окно |
| `:bnext` | `c` | Следующий буфер |
| `:bprevious` | `c` | Предыдущий буфер |
| `:buffer {n}` | `c` | Перейти к буферу по номеру |
| `:e {file}` | `c` | Открыть файл |
| `:find {file}` | `c` | Найти файл по `path` |
| `:terminal` | `c` | Открыть terminal |
| `/` | `n` | Поиск вперёд |
| `?` | `n` | Поиск назад |
| `n` | `n` | Следующее совпадение |
| `N` | `n` | Предыдущее совпадение |
| `*` | `n` | Искать слово под курсором вперёд |
| `#` | `n` | Искать слово под курсором назад |
| `gf` | `n` | Открыть файл под курсором |
| `Ctrl-^` | `n` | Переключиться на alternate buffer |
| `:ls` | `c` | Список буферов |
| `:help {topic}` | `c` | Открыть help |

## Конфликты и перекрытия

- `<leader>cr` конфликтует между `CopilotChatReset` и буферным `LSP Rename`. В LSP-буфере сработает буферный `rename`.
- `<leader>cf` конфликтует между `LSP Format` и `crates.nvim features`. В `Cargo.toml` сработает `crates`, в обычном LSP-буфере форматирование.
- `K` конфликтует между `LSP Hover` и `crates.nvim`. В `Cargo.toml` сработает popup с версиями crate.
- `<Tab>` в insert mode участвует сразу в `copilot.vim`, `nvim-cmp` и `vsnip`; фактическое поведение зависит от активного состояния completion/copilot/snippet.

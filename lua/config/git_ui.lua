local M = {}

M.icons = {
    added = "+",
    modified = "○",
    deleted = "-",
    renamed = "→",
    copied = "+",
    untracked = "+",
    ignored = "",
    unmerged = "!",
    staged = "✓",
}

-- Keep the type of change visible even when it has been staged. A file with
-- both staged and unstaged changes gets two independently coloured markers.
function M.status(xy)
    local git = require("snacks.picker.source.git")
    local status = git.git_status(xy)
    local chunks = {}
    local function add(kind, prefix)
        local hl = "SnacksPickerGitStatus" .. kind:sub(1, 1):upper() .. kind:sub(2)
        chunks[#chunks + 1] = { (prefix or "") .. (M.icons[kind] or "?"), hl }
        return hl
    end
    if status.unmerged then
        return { { "!", "SnacksPickerGitStatusUnmerged" } }, "SnacksPickerGitStatusUnmerged"
    end
    local hl = add(status.status, status.staged and "✓ " or nil)
    if status.staged and xy:sub(2, 2):match("[MADRCT]") then
        chunks[#chunks + 1] = { " ", "Normal" }
        hl = add(git.git_status(" " .. xy:sub(2, 2)).status)
    end
    return chunks, hl
end

function M.explorer_format(item, picker)
    local copy = vim.tbl_extend("force", {}, item)
    copy.filename_hl = nil
    local chunks
    if item.status then
        chunks, copy.filename_hl = M.status(item.status)
    end
    -- Delegate tree, filename, icons and diagnostics to Snacks' own formatter.
    copy.status = nil
    local ret = require("snacks.picker.format").file(copy, picker)
    if chunks then
        chunks[#chunks + 1] = { " " }
        table.insert(ret, 1, { col = 0, virt_text = chunks, virt_text_pos = "right_align", hl_mode = "combine" })
    end
    return ret
end

return M

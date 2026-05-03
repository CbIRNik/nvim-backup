local M = {}

local sep = package.config:sub(1, 1)

local function join(...)
  return table.concat({ ... }, sep)
end

local function uv()
  return vim.uv or vim.loop
end

local function executable(path)
  return path and path ~= "" and vim.fn.executable(path) == 1
end

function M.install_dir()
  return join(vim.fn.stdpath("data"), "cargotom")
end

function M.storage_dir()
  return join(M.install_dir(), "storage")
end

function M.managed_bin()
  local name = uv().os_uname().sysname == "Windows_NT" and "cargotom.exe" or "cargotom"
  return join(M.install_dir(), "bin", name)
end

function M.bin()
  local external = vim.fn.exepath("cargotom")
  if executable(external) then
    return external
  end

  local managed = M.managed_bin()
  if executable(managed) then
    return managed
  end
end

function M.is_available()
  return M.bin() ~= nil
end

local function asset_name()
  local uname = uv().os_uname()
  local machine = (uname.machine or ""):lower()
  local sysname = uname.sysname or ""

  local arch
  if machine == "arm64" or machine == "aarch64" then
    arch = "aarch64"
  elseif machine == "x86_64" or machine == "amd64" then
    arch = "x86_64"
  end

  local os
  if sysname == "Darwin" then
    os = "apple-darwin"
  elseif sysname == "Linux" then
    os = "unknown-linux-gnu"
  elseif sysname == "Windows_NT" then
    os = "pc-windows-msvc.exe"
  end

  if not arch or not os then
    return nil
  end

  return ("cargotom-%s-%s"):format(arch, os)
end

function M.server_config(capabilities, on_attach)
  local bin = M.bin()
  if not bin then
    return nil
  end

  vim.fn.mkdir(M.storage_dir(), "p")

  return {
    name = "cargo_tom",
    cmd = { bin, "--storage", M.storage_dir() },
    filetypes = { "toml" },
    root_dir = function(bufnr, on_dir)
      local filename = vim.api.nvim_buf_get_name(bufnr)
      if vim.fn.fnamemodify(filename, ":t") ~= "Cargo.toml" then
        return
      end

      local root = vim.fs.root(bufnr, { "Cargo.toml", ".git" }) or vim.fs.dirname(filename)
      if root then
        on_dir(root)
      end
    end,
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.completionProvider = nil

      if on_attach then
        on_attach(client, bufnr)
      end
    end,
    init_options = {
      per_page = 25,
      feature_display_mode = "UnusedOpt",
      hide_docs_info_message = true,
      sort_format = false,
      stable_version = true,
      offline = true,
      outdated_crate_warnings = true,
    },
  }
end

function M.configure_lsp(capabilities, on_attach)
  M._capabilities = capabilities
  M._on_attach = on_attach

  local config = M.server_config(capabilities, on_attach)
  if not config then
    return false
  end

  vim.lsp.config("cargo_tom", config)
  vim.lsp.enable("cargo_tom")
  return true
end

function M.install()
  local asset = asset_name()
  if not asset then
    vim.notify("CargoTom: unsupported platform", vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable("curl") ~= 1 then
    vim.notify("CargoTom: curl not found", vim.log.levels.ERROR)
    return
  end

  local bin = M.managed_bin()
  local tmp = bin .. ".tmp"
  local url = "https://github.com/frederik-uni/cargotom/releases/latest/download/" .. asset

  vim.fn.mkdir(vim.fn.fnamemodify(bin, ":h"), "p")
  vim.fn.mkdir(M.storage_dir(), "p")

  vim.notify("CargoTom: downloading " .. asset, vim.log.levels.INFO)

  vim.system({ "curl", "-fL", "--retry", "2", "--output", tmp, url }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        local err = obj.stderr or obj.stdout or "download failed"
        vim.notify("CargoTom: " .. vim.trim(err), vim.log.levels.ERROR)
        return
      end

      vim.fn.setfperm(tmp, "rwxr-xr-x")
      vim.fn.delete(bin)
      if vim.fn.rename(tmp, bin) ~= 0 then
        vim.notify("CargoTom: failed to install binary", vim.log.levels.ERROR)
        return
      end

      vim.notify("CargoTom: installed", vim.log.levels.INFO)

      if M._capabilities then
        M.configure_lsp(M._capabilities, M._on_attach)
      end
    end)
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("CargoTomInstall", function()
    M.install()
  end, { desc = "Install CargoTom LSP binary" })

  vim.api.nvim_create_user_command("CargoTomStatus", function()
    local bin = M.bin()
    if bin then
      vim.notify("CargoTom: " .. bin, vim.log.levels.INFO)
    else
      vim.notify("CargoTom: not installed; run :CargoTomInstall", vim.log.levels.WARN)
    end
  end, { desc = "Show CargoTom LSP status" })
end

return M

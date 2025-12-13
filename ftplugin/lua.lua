-- Lua ftplugin - configures lua_ls (Lua Language Server)

local mason_path = vim.fn.stdpath("data") .. "/mason"
-- Mason installs the wrapper script in the bin directory
local lsp_cmd = mason_path .. "/bin/lua-language-server"

-- Parse .luacheckrc to extract globals
-- Supports multiline: globals = { "foo", "bar", } and read_globals = { "baz" }
local function parse_luacheckrc(filepath)
  local globals = {}

  local file = io.open(filepath, "r")
  if not file then
    return globals
  end

  local content = file:read("*all")
  file:close()

  -- Match globals = { ... } or read_globals = { ... }
  -- %f[%w] is a frontier pattern to match word boundary
  for match in content:gmatch("%f[%w]globals%s*=%s*(%b{})") do
    for global in match:gmatch('"([^"]+)"') do
      table.insert(globals, global)
    end
  end

  for match in content:gmatch("read_globals%s*=%s*(%b{})") do
    for global in match:gmatch('"([^"]+)"') do
      table.insert(globals, global)
    end
  end

  return globals
end

-- Function to start lua_ls for the current buffer
local function start_lua_ls()
  -- Capabilities (for nvim-cmp)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
  end

  -- Find root directory
  local root_dir = vim.fs.root(0, { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" })

  -- Read globals from .luacheckrc if it exists (single source of truth)
  local globals = {}
  if root_dir then
    local luacheckrc_path = root_dir .. "/.luacheckrc"
    if vim.fn.filereadable(luacheckrc_path) == 1 then
      globals = parse_luacheckrc(luacheckrc_path)
    end
  end

  -- Start the LSP client directly (NeoVim 0.11+)
  vim.lsp.start({
    name = "lua_ls",
    cmd = { lsp_cmd },
    root_dir = root_dir,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "Lua 5.1", -- WoW uses Lua 5.1
        },
        diagnostics = {
          -- Globals parsed from .luacheckrc (single source of truth)
          globals = globals,
        },
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace",
        },
        telemetry = { enable = false },
      },
    },
  })
end

-- Check if lua-language-server is installed
if vim.fn.executable(lsp_cmd) == 1 then
  start_lua_ls()
  return
end

-- Not installed - offer to install via Mason
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if not mason_registry_ok then
  vim.notify(
    "Lua Language Server not installed.\n" .. "Install with: :MasonInstall lua-language-server",
    vim.log.levels.WARN
  )
  return
end

-- Prompt user to install
vim.ui.select({ "Yes", "No" }, {
  prompt = "Lua Language Server not installed. Install now?",
}, function(choice)
  if choice ~= "Yes" then
    return
  end

  local pkg_name = "lua-language-server"

  -- Ensure registry is up to date
  mason_registry.refresh(function()
    local ok, pkg = pcall(mason_registry.get_package, pkg_name)
    if not ok then
      vim.notify("Package '" .. pkg_name .. "' not found in Mason registry", vim.log.levels.ERROR)
      return
    end

    vim.notify("Installing " .. pkg_name .. "...", vim.log.levels.INFO)

    pkg:install():once("closed", function()
      if pkg:is_installed() then
        vim.notify(pkg_name .. " installed successfully.", vim.log.levels.INFO)
        vim.schedule(function()
          start_lua_ls()
        end)
      else
        vim.notify("Failed to install " .. pkg_name, vim.log.levels.ERROR)
      end
    end)
  end)
end)

-- Java ftplugin - configures Java LSP based on project type
-- Bazel projects: java-language-server
-- Maven/Gradle projects: nvim-jdtls

local mason_path = vim.fn.stdpath("data") .. "/mason"

-- Helper to find project root by markers
local function find_root(markers)
  return vim.fs.root(0, markers)
end

-- Helper to get capabilities
local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
  end
  return capabilities
end

-- Helper to prompt for Mason install
local function prompt_install(pkg_name, display_name, prerequisites_msg, on_installed)
  local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
  if not mason_registry_ok then
    vim.notify(
      display_name .. " not installed.\n" .. "Install with: :MasonInstall " .. pkg_name,
      vim.log.levels.WARN
    )
    return
  end

  local prompt_msg = display_name .. " not installed. Install now?"
  if prerequisites_msg then
    prompt_msg = display_name .. " not installed.\n" .. prerequisites_msg .. "\n\nInstall now?"
  end

  vim.ui.select({ "Yes", "No" }, {
    prompt = prompt_msg,
  }, function(choice)
    if choice ~= "Yes" then
      return
    end

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
            on_installed()
            vim.cmd("edit")
          end)
        else
          vim.notify("Failed to install " .. pkg_name, vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end

-- Setup java-language-server for Bazel projects
local function setup_java_language_server()
  -- Mason installs wrapper in bin directory
  local jls_cmd = mason_path .. "/bin/java-language-server"

  -- Find Bazel root
  local root_dir = vim.fs.root(0, { "BUILD.bazel", "WORKSPACE", "WORKSPACE.bazel" })

  -- Start the LSP client directly (NeoVim 0.11+)
  vim.lsp.start({
    name = "java_language_server",
    cmd = { jls_cmd },
    root_dir = root_dir,
    capabilities = get_capabilities(),
  })
end

-- Setup jdtls for Maven/Gradle projects
local function setup_jdtls()
  local jdtls = require("jdtls")
  local jdtls_setup = require("jdtls.setup")

  local jdtls_path = mason_path .. "/packages/jdtls"
  local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

  -- Find root of the Java project
  local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
  local root_dir = jdtls_setup.find_root(root_markers)
  if root_dir == "" or root_dir == nil then
    root_dir = vim.fn.getcwd()
  end

  -- Determine the OS for jdtls config
  local os_config = "config_mac"
  if vim.fn.has("linux") == 1 then
    os_config = "config_linux"
  elseif vim.fn.has("win32") == 1 then
    os_config = "config_win"
  end

  local config_path = jdtls_path .. "/" .. os_config
  local lombok_path = jdtls_path .. "/lombok.jar"

  -- Workspace directory (unique per project)
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

  -- Extended capabilities for jdtls
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  -- On attach function for jdtls-specific mappings
  local on_attach = function(_, bufnr)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    map("<leader>jo", jdtls.organize_imports, "Organize imports")
    map("<leader>jv", jdtls.extract_variable, "Extract variable")
    map("<leader>jc", jdtls.extract_constant, "Extract constant")

    vim.keymap.set("v", "<leader>jm", function()
      jdtls.extract_method(true)
    end, { buffer = bufnr, desc = "LSP: Extract method" })
  end

  -- Configuration
  local config = {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", launcher_jar,
      "-configuration", config_path,
      "-data", workspace_dir,
    },
    root_dir = root_dir,
    capabilities = get_capabilities(),
    on_attach = on_attach,
    settings = {
      java = {
        eclipse = { downloadSources = true },
        configuration = { updateBuildConfiguration = "interactive" },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        references = { includeDecompiledSources = true },
        inlayHints = { parameterNames = { enabled = "all" } },
        format = { enabled = true },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "org.assertj.core.api.Assertions.*",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
    },
    init_options = {
      extendedClientCapabilities = extendedClientCapabilities,
    },
  }

  -- Add lombok if available
  if vim.fn.filereadable(lombok_path) == 1 then
    table.insert(config.cmd, 2, "-javaagent:" .. lombok_path)
  end

  jdtls.start_or_attach(config)
end

-- Check if this is a Bazel project
local bazel_root = find_root({ "BUILD.bazel" })

if bazel_root then
  -- Bazel project: use java-language-server
  local jls_cmd = mason_path .. "/bin/java-language-server"

  -- Check if java is available first
  if vim.fn.executable("java") ~= 1 then
    vim.notify(
      "Java not found in PATH.\n" .. "Activate Java with: sdk use java <version>",
      vim.log.levels.WARN
    )
    return
  end

  -- Check if java-language-server is installed
  if vim.fn.executable(jls_cmd) == 1 then
    setup_java_language_server()
    return
  end

  -- Not installed - offer to install
  prompt_install(
    "java-language-server",
    "Java Language Server (for Bazel)",
    "Note: Requires Java 18+ active (sdk use java 25-amzn)",
    setup_java_language_server
  )
  return
end

-- Non-Bazel project: use nvim-jdtls
local jdtls_ok, _ = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify(
    "nvim-jdtls plugin not loaded.\n" .. "It should load automatically for Java files.",
    vim.log.levels.WARN
  )
  return
end

-- Check if java is available
if vim.fn.executable("java") ~= 1 then
  vim.notify(
    "Java not found in PATH.\n" .. "Activate Java with: sdk use java <version>",
    vim.log.levels.WARN
  )
  return
end

local jdtls_path = mason_path .. "/packages/jdtls"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Check if jdtls is installed
if launcher_jar ~= "" then
  setup_jdtls()
  return
end

-- Not installed - offer to install
prompt_install("jdtls", "JDTLS (Eclipse Java LSP)", nil, setup_jdtls)

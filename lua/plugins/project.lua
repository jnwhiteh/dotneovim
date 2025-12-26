return {
  "ahmedkhalf/project.nvim",
  lazy = false,
  priority = 100,
  opts = {
    detection_methods = { "lsp", "pattern" },
    patterns = { ".luacheckrc", "luarc.json", ".git", "Makefile", "package.json", "go.mod" },
    silent_chdir = true,
  },
  config = function(_, opts)
    require("project_nvim").setup(opts)
  end,
}

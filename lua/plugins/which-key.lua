return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = true, suggestions = 20 },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      show_help = true,
      show_keys = true,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Register key group labels
      wk.add({
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>e", desc = "File explorer" },
        { "<leader>E", desc = "Reveal in explorer" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Hunks" },
        { "<leader>j", group = "Java" },
        { "<leader>s", group = "Search" },
        { "<leader>x", group = "Diagnostics" },
      })
    end,
  },
}

return {
  "cappyzawa/trim.nvim",
  opts = {
    trim_current_line = false,
    highlight = true,
  },
  config = function(_, opts)
    require("trim").setup(opts)
  end,
}

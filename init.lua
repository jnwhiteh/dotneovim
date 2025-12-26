require("config.lazy")

vim.lsp.config('lua_ls', require('lsp.lua_ls'))
vim.lsp.enable('lua_ls')

vim.diagnostic.config({
  virtual_text = {
    virt_text_pos = "right_align",
    spacing = 2,
    prefix = "●", -- or "", "■", etc.
  },
})

if vim.g.neovide and vim.fn.argc() == 0 then
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      require("telescope").extensions.projects.projects()
    end,
  })
end

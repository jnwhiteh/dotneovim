return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    cmd = "Telescope",
    keys = {
		-- Quick access (VS Code style)
		{ "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },

		-- Find
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
		{ "<leader>fc", "<cmd>Telescope colorscheme<CR>", desc = "Colorschemes" },

		-- Search
		{ "<leader>s/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },
		{ "<leader>sD", "<cmd>Telescope diagnostics<CR>", desc = "Workspace diagnostics" },
		{ "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
		{ "<leader>sc", "<cmd>Telescope commands<CR>", desc = "Commands" },
    },
}

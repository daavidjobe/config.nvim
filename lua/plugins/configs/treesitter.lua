require("nvim-treesitter.install").prefer_git = true

local M = {}

M.setup = function()
	---@diagnostic disable-next-line: missing-fields
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "lua", "c", "vim", "vimdoc", "query", "rust", "ruby", "typescript" },
		auto_install = true,

		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	})
end

return M

local M = {}

M.close_floating = function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			vim.api.nvim_win_close(win, false)
		end
	end
end

M.toggle_background = function()
	local current = vim.o.bg .. ""
	print(current)
	if current == "light" then
		vim.cmd("set background=dark")
	else
		vim.cmd("set background=light")
	end
end

return M

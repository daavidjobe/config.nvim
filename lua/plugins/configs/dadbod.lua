local M = {}

local save_sql_query = function(query_name)
	local file_path = vim.fn.expand("~/.config/nvim/db_queries/") .. query_name .. ".sql"
	vim.cmd("w " .. file_path)
	print("Saved query to " .. file_path)
end

M.setup = function()
	vim.g.db_ui_use_nerd_fonts = 1
	vim.g.db_ui_save_location = "~/.config/nvim/db_queries"

	vim.api.nvim_create_user_command("DBUISave", function(opts)
		save_sql_query(opts.args)
	end, { nargs = 1, complete = "file" })
end

return M

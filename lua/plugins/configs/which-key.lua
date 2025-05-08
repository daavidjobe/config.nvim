local wk = require("which-key")
wk.setup()

local M = {}

wk.add({
	{ "<leader>c", desc = "[C]ode" },
	{ "<leader>d", desc = "[D]ocument" },
	{ "<leader>r", desc = "[R]ename" },
	{ "<leader>s", desc = "[S]earch" },
	{ "<leader>w", desc = "[W]orkspace" },
	{ "<leader>t", desc = "[T]oggle" },
	{ "<leader>h", desc = "Git [H]unk" },
}, {
	mode = { "n", "v" }, -- NORMAL and VISUAL mode
	{ "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
	{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
})

wk.add({ "<leader>h", desc = "Git [H]unk" }, { mode = "v" })

return M

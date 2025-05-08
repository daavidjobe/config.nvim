local M = {}

function M.setup() end

-- Global rustaceanvim configuration
vim.g.rustaceanvim = {
	tools = {
		code_actions = {
			ui_select_fallback = true,
		},
		test_executor = "background", -- Run tests in background and show diagnostics for failed tests
		hover_actions = {
			auto_focus = true,
		},
		executor = {
			reload_workspace_from_cargo_toml = false,
		},
	},
	-- LSP configuration for rust-analyzer
	server = {
		on_attach = function(_, bufnr)
			-- Define buffer-local keymaps and settings when LSP attaches
			local opts = { buffer = bufnr, noremap = true, silent = true }
			-- LSP keybindings
			vim.keymap.set("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>a", function()
				vim.cmd.RustLsp("codeAction")
			end, opts)
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			-- Set up document formatting with rustfmt
			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)
			-- Special rust-analyzer commands
			vim.keymap.set("n", "<leader>rr", function()
				vim.cmd.RustLsp("runnables")
			end, opts)
			vim.keymap.set("n", "<leader>rt", function()
				vim.cmd.RustLsp("testables")
			end, opts)
			vim.keymap.set("n", "<leader>rd", function()
				vim.cmd.RustLsp("debuggables")
			end, opts)
			vim.keymap.set("n", "<leader>re", function()
				vim.cmd.RustLsp("explainError")
			end, opts)
			vim.keymap.set("n", "<leader>rp", function()
				vim.cmd.RustLsp("parentModule")
			end, opts)
			vim.keymap.set("n", "<leader>rc", function()
				vim.cmd.RustLsp("openCargo")
			end, opts)
			vim.keymap.set("n", "<leader>rm", function()
				vim.cmd.RustLsp("expandMacro")
			end, opts)
			vim.keymap.set("n", "<leader>rg", function()
				vim.cmd.RustLsp("crateGraph")
			end, opts)
			vim.keymap.set("n", "<leader>rw", function()
				vim.cmd.RustLsp("workspaceSymbol")
			end, opts)
			vim.keymap.set("n", "<leader>fl", function()
				vim.cmd.RustLsp("flyCheck", "run")
			end, opts)
			-- Set up inlay hints (Neovim >= 0.10)
			if vim.fn.has("nvim-0.10") == 1 then
				-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
			-- Format on save (optional)
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("RustFormat", {}),
				pattern = "*.rs",
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
		-- Configure rust-analyzer settings
		default_settings = {
			["rust-analyzer"] = {
				-- Performance optimizations for large workspaces
				cargo = {
					-- If building on save is slow, consider changing to false
					-- and instead using the flyCheck command when needed
					buildScripts = {
						enable = true,
						useRustcWrapper = true, -- Uses RUSTC_WRAPPER to avoid unnecessary checks in large projects
					},
					-- Use a separate target directory to avoid locking Cargo.lock
					-- Useful if you have multiple editors or tools using cargo at once
					targetDir = ".rust-analyzer", -- Separate directory for rust-analyzer
					-- Only load the specific package you're working on, not all workspace members
					-- Useful for large monorepos with many packages
					-- loadOutDirsFromCheck = true,
					-- Target specific targets to speed up analysis
					-- target = "wasm32-unknown-unknown", -- Uncomment if you have a specific target
					allTargets = false, -- Reduces build times by only building the current target(s)
				},
				-- Configure Clippy integration
				check = {
					command = "clippy", -- Use clippy instead of check for better lints
					extraArgs = {
						"--no-deps", -- Don't check dependencies
						"--all-targets", -- Check all targets (bin, lib, tests, etc)
					},
					-- Customize if you want check on save or on-demand via flyCheck command
					-- If you have large workspaces, you might want to set this to false
					-- and use flyCheck on demand with <leader>fl
					checkOnSave = true,
				},
				-- Improve cache behavior
				cachePriming = {
					enable = true,
					numThreads = 4, -- Adjust based on your CPU cores
				},
				-- Proc macro settings
				procMacro = {
					enable = true,
					attributes = {
						enable = true,
					},
				},
				-- Completion settings
				completion = {
					limit = 100,
					callable = {
						snippets = "none",
					},
					postfix = {
						enable = false,
					},
					hover = {
						 memoryLayout = {
              enable = false,
            },
					},
					autoimport = {
						enable = true,
					},
					fullFunctionSignatures = {
						enable = true,
					},
				},
				-- Diagnostics settings
				diagnostics = {
					enable = true,
					experimental = {
						enable = false,
					},
					-- Configure which diagnostics are shown as hints instead of warnings
					warningsAsHint = {
						"unused_variables",
						"unused_imports",
					},
				},
				-- Inlay hints configuration
				inlayHints = {
					typeHints = {
						enable = true,
						hideClosureInitialization = false,
						hideNamedConstructor = false,
					},
					parameterHints = {
						enable = true,
					},
					chainingHints = {
						enable = true,
					},
					closingBraceHints = {
						enable = true,
						minLines = 25,
					},
				},
				-- Lens configuration
				lens = {
					enable = false,
					references = {
              adt = { enable = false },
              enumVariant = { enable = false },
              method = { enable = false },
            },
				},
				hover = {
					memoryLayout = {
						enable = false,
					},
				},
				-- Workspace configuration
				workspace = {
					symbol = {
						search = {
							kind = "all_symbols", -- Search for all symbols, not just types
							limit = 256,   -- Increase symbol search limit for large codebases
						},
					},
				},
			},
		},
	},
	dap = {
		autodetect = true,
	},
}

-- Additional Neovim configuration for working with Rust

-- Enable filetype detection, plugin, and indent
vim.cmd([[
    filetype plugin indent on
    syntax enable
  ]])

-- Setup diagnostics display
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		header = "",
		prefix = "",
	},
})

-- Add diagnostic symbols to the sign column
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Add custom commands for Rust projects
vim.api.nvim_create_user_command("CargoUpdate", function()
	vim.cmd("!cargo update")
end, {})

vim.api.nvim_create_user_command("CargoFmt", function()
	vim.cmd("!cargo fmt")
end, {})

vim.api.nvim_create_user_command("CargoClippy", function()
	vim.cmd("!cargo clippy --all-targets --all-features")
end, {})

return M

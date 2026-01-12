vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "gofmt", stop_after_first = true },
		python = { "ruff_format", "isort", "black", stop_after_first = true },
		json = { "prettierd", "prettier", "biome", stop_after_first = true },
		jsonc = { "prettierd", "prettier", "biome", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		["markdown.mdx"] = { "prettierd", "prettier", stop_after_first = true },
		javascript = { "biome", "prettierd", "prettier", "deno_fmt", stop_after_first = true },
		typescript = { "biome", "prettierd", "prettier", "deno_fmt", stop_after_first = true },
		javascriptreact = { "biome", "prettierd", "prettier", "deno_fmt", "dprint", stop_after_first = true },
		typescriptreact = { "biome", "prettierd", "prettier", "deno_fmt", "dprint", stop_after_first = true },
		svelte = { "biome", "prettierd", "prettier", "deno_fmt", "dprint", stop_after_first = true },
		css = { "biome", "prettierd", "prettier", stop_after_first = true },
		scss = { "biome", "prettierd", "prettier", stop_after_first = true },
		html = { "biome", "prettierd", "prettier", stop_after_first = true },
		vue = { "biome", "prettierd", "prettier", stop_after_first = true },
		astro = { "biome", "prettierd", "prettier", stop_after_first = true },
		xml = { "prettierd", "prettier", stop_after_first = true },
		toml = { "taplo" },
		nix = { "nixfmt" },
	},
	formatters = {
		biome = { require_cwd = true },
		deno_fmt = { require_cwd = true },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = function(bufnr)
		local ignore_filetypes = { "sql", "yaml", "yml" }
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(opts)
	if opts.bang then
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
	vim.notify("Autoformat disabled" .. (opts.bang and " (buffer)" or " (global)"), vim.log.levels.WARN)
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
	vim.notify("Autoformat enabled", vim.log.levels.INFO)
end, { desc = "Re-enable autoformat-on-save" })

local auto_format = true

vim.keymap.set("n", "<leader>uf", function()
	auto_format = not auto_format
	if auto_format then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable")
	end
end, { desc = "Toggle Autoformat" })

vim.keymap.set({ "n", "v" }, "<leader>cn", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true }, function(err, did_edit)
		if not err and did_edit then
			vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
		end
	end)
end, { desc = "Format buffer" })

vim.keymap.set({ "n", "v" }, "<leader>cF", function()
	require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Langs" })

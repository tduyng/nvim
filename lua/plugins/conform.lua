vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "gofmt", stop_after_first = true },
		python = { "ruff_format", "isort", "black", stop_after_first = true },
		json = { "prettier", "biome", stop_after_first = true },
		jsonc = { "prettier", "biome", stop_after_first = true },
		markdown = { "injected", "prettier", stop_after_first = false },
		["markdown.mdx"] = { "injected", "prettier", stop_after_first = false },
		javascript = { "biome", "prettier", "deno_fmt", stop_after_first = true },
		typescript = { "biome", "prettier", "deno_fmt", stop_after_first = true },
		javascriptreact = { "biome", "prettier", "deno_fmt", "dprint", stop_after_first = true },
		typescriptreact = { "biome", "prettier", "deno_fmt", "dprint", stop_after_first = true },
		svelte = { "biome", "prettier", "deno_fmt", "dprint", stop_after_first = true },
		css = { "biome", "prettier", stop_after_first = true },
		scss = { "biome", "prettier", stop_after_first = true },
		html = { "biome", "prettier", stop_after_first = true },
		vue = { "biome", "prettier", stop_after_first = true },
		astro = { "biome", "prettier", stop_after_first = true },
		xml = { "prettier", stop_after_first = true },
		toml = { "taplo" },
		nix = { "nixfmt" },
	},
	formatters = {
		prettier = {
			args = function(_self, ctx)
				local search_dir = ctx.dirname or vim.fn.getcwd()

				-- find project-level prettier config
				local config_files = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yaml",
					".prettierrc.yml",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
					"prettier.config.ts",
				}
				local project_config = nil
				for _, name in ipairs(config_files) do
					local found = vim.fn.findfile(name, search_dir .. ";")
					if found and found ~= "" then
						project_config = found
						break
					end
				end

				-- personal overrides per filetype (CLI flags override config file)
				-- these apply regardless of project or global config
				local personal_overrides = {
					graphql = { "--tab-width", "2", "--print-width", "120" },
					markdown = { "--tab-width", "2", "--prose-wrap", "preserve", "--print-width", "120" },
					mdx = { "--tab-width", "2", "--prose-wrap", "preserve" },
					html = { "--tab-width", "2", "--print-width", "120" },
					css = { "--tab-width", "2" },
					scss = { "--tab-width", "2" },
					less = { "--tab-width", "2" },
					yaml = { "--tab-width", "2", "--no-bracket-spacing" },
					json = { "--tab-width", "4" },
					jsonc = { "--tab-width", "4" },
					javascript = {}, -- fully trust project/global config
					typescript = {},
					svelte = { "--tab-width", "2" },
					vue = { "--tab-width", "2" },
					astro = { "--tab-width", "2" },
					xml = { "--tab-width", "2", "--print-width", "120" },
				}

				local ft = vim.bo[ctx.buf].filetype
				local overrides = personal_overrides[ft] or {}

				local args = { "--stdin-filepath", ctx.filename }

				-- use project config if found, else fall back to ~/.prettierrc
				local config = project_config or vim.fn.expand("~/.prettierrc")
				vim.list_extend(args, { "--config", config })

				-- personal overrides always win (CLI flags beat config file)
				vim.list_extend(args, overrides)

				return args
			end,
		},
		biome = { require_cwd = true },
		deno_fmt = { require_cwd = true },
		injected = {
			options = {
				ignore_errors = true,
				lang_to_formatters = {
					graphql = { "prettier" }, -- use prettier for graphql blocks
				},
			},
		},
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

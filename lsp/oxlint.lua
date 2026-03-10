-- https://github.com/oxc-project/oxc
-- https://oxc.rs/docs/guide/usage/linter.html
-- Install with: pnpm add -g oxlint

local function oxlint_conf_mentions_typescript(root_dir)
	local files = { ".oxlintrc.json", ".oxlintrc.jsonc" }
	for _, file in ipairs(files) do
		local fn = vim.fs.joinpath(root_dir, file)
		if vim.fn.filereadable(fn) == 1 then
			for line in io.lines(fn) do
				if line:find("typescript") then
					return true
				end
			end
		end
	end
	return false
end

return {
	cmd = function(dispatchers, config)
		local cmd = "oxlint"
		local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/oxlint"
		if local_cmd and vim.fn.executable(local_cmd) == 1 then
			cmd = local_cmd
		end
		if vim.fn.executable(cmd) == 0 then
			cmd = "oxc_language_server"
		end
		return vim.lsp.rpc.start({ cmd, "--lsp", "--import-plugin" }, dispatchers)
	end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
		"svelte",
		"astro",
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		-- Stop at $HOME to prevent detecting oxlint configs outside the project
		local stop = vim.fs.dirname(vim.fn.expand("$HOME"))
		local marker = vim.fs.find({
			".oxlintrc.json",
			".oxlintrc.jsonc",
			"oxlint.config.ts",
			"oxlint.config.js",
			"oxlint.config.mjs",
			"oxlint.config.cjs",
		}, { path = fname, upward = true, stop = stop })[1]
		on_dir(marker and vim.fs.dirname(marker) or nil)
	end,
	workspace_required = true,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
			client:exec_cmd({
				title = "Apply Oxlint automatic fixes",
				command = "oxc.fixAll",
				arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
			})
		end, {
			desc = "Apply Oxlint automatic fixes",
		})
	end,
	settings = {
		-- run = 'onType',
		-- configPath = nil,
		-- tsConfigPath = nil,
		-- unusedDisableDirectives = 'allow',
		-- typeAware = false,
		-- disableNestedConfig = false,
		fixKind = "safe_fix",
	},
	before_init = function(init_params, config)
		local settings = config.settings or {}
		if settings.typeAware == nil then
			local ok, res = pcall(oxlint_conf_mentions_typescript, config.root_dir or "")
			if ok and res then
				settings = vim.tbl_extend("force", settings, { typeAware = true })
			end
		end
		local init_options = config.init_options or {}
		init_options.settings = vim.tbl_extend("force", init_options.settings or {}, settings)
		init_params.initializationOptions = init_options
	end,
}

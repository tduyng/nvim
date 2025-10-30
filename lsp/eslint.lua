local util = require("utils.lsp")
local lsp = vim.lsp

return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
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
		"htmlangular",
	},
	workspace_required = true,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(0, "LspEslintFixAll", function()
			client:request_sync("workspace/executeCommand", {
				command = "eslint.applyAllFixes",
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = lsp.util.buf_versions[bufnr],
					},
				},
			}, nil, bufnr)
		end, {})
	end,
	-- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)

		-- First, find the actual workspace root (for monorepo support)
		local workspace_root_patterns = {
			".git",
			"pnpm-workspace.yaml",
			"rush.json",
			"lerna.json",
			"nx.json",
			"package.json", -- fallback for single repos
		}

		local workspace_root = vim.fs.dirname(vim.fs.find(workspace_root_patterns, { path = fname, upward = true })[1])

		-- If no workspace root found, use current directory
		if not workspace_root then
			workspace_root = vim.fn.getcwd()
		end

		on_dir(workspace_root)
	end,
	-- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
	settings = {
		validate = "on",
		packageManager = nil,
		useESLintClass = false,
		experimental = {
			useFlatConfig = false,
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = true,
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onType",
		problems = {
			shortenToSingleLine = false,
		},
		-- nodePath configures the directory in which the eslint server should start its node_modules resolution.
		-- This path is relative to the workspace folder (root dir) of the server instance.
		nodePath = "",
		-- working directory is now set dynamically in before_init based on config location
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
	},
	before_init = function(_, config)
		-- The "workspaceFolder" is a VSCode concept. It limits how far the
		-- server will traverse the file system when locating the ESLint config
		-- file (e.g., .eslintrc).
		local root_dir = config.root_dir

		if root_dir then
			config.settings = config.settings or {}
			config.settings.workspaceFolder = {
				uri = root_dir,
				name = vim.fn.fnamemodify(root_dir, ":t"),
			}

			-- Find the nearest ESLint config from the current file
			local fname = vim.api.nvim_buf_get_name(0)
			local eslint_config_patterns = {
				".eslintrc",
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.yaml",
				".eslintrc.yml",
				".eslintrc.json",
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				"eslint.config.mts",
				"eslint.config.cts",
			}

			-- Add package.json with eslintConfig to patterns
			eslint_config_patterns = util.insert_package_json(eslint_config_patterns, "eslintConfig", fname)

			local nearest_config = vim.fs.find(eslint_config_patterns, { path = fname, upward = true })[1]
			local config_dir = nearest_config and vim.fs.dirname(nearest_config) or root_dir

			-- Set working directory to where the ESLint config is found
			-- This is crucial for monorepos where config might be in a subdirectory
			config.settings.workingDirectory = {
				mode = "location",
				location = config_dir,
			}

			-- Support flat config
			local flat_config_files = {
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				"eslint.config.mts",
				"eslint.config.cts",
			}

			for _, file in ipairs(flat_config_files) do
				if vim.fn.filereadable(config_dir .. "/" .. file) == 1 then
					config.settings.experimental = config.settings.experimental or {}
					config.settings.experimental.useFlatConfig = true
					break
				end
			end

			-- Support Yarn2 (PnP) projects - check both root and config directory
			local pnp_cjs = root_dir .. "/.pnp.cjs"
			local pnp_js = root_dir .. "/.pnp.js"
			local config_pnp_cjs = config_dir .. "/.pnp.cjs"
			local config_pnp_js = config_dir .. "/.pnp.js"

			if
				vim.uv.fs_stat(pnp_cjs)
				or vim.uv.fs_stat(pnp_js)
				or vim.uv.fs_stat(config_pnp_cjs)
				or vim.uv.fs_stat(config_pnp_js)
			then
				local cmd = config.cmd
				config.cmd = vim.list_extend({ "yarn", "exec" }, cmd)
			end
		end
	end,
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4 -- approved
		end,
		["eslint/probeFailed"] = function()
			vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
	},
}

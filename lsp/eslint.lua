local lsp = vim.lsp

-- ESLint flat config patterns (ESLint 9+)
local ESLINT_FLAT_CONFIG = {
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
}

local OXLINT_CONFIG = {
	".oxlintrc.json",
	".oxlintrc.jsonc",
	"oxlint.config.ts",
	"oxlint.config.js",
	"oxlint.config.mjs",
	"oxlint.config.cjs",
}

local WORKSPACE_ROOT_PATTERNS = {
	".git",
	".moon/workspace.yml", -- moon monorepo tool
	"pnpm-workspace.yaml",
	"turbo.json",
	"rush.json",
	"lerna.json",
	"nx.json",
	"package.json",
}

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
		vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
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
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local home_stop = vim.fs.dirname(vim.fn.expand("$HOME"))

		-- Priority: If Oxlint is found (same stop boundary as oxlint.lua), disable ESLint
		local oxlint_config = vim.fs.find(OXLINT_CONFIG, { path = fname, upward = true, stop = home_stop })[1]
		if oxlint_config then
			on_dir(nil)
			return
		end

		-- Find workspace root to limit ESLint config search
		local workspace_root = vim.fs.root(bufnr, WORKSPACE_ROOT_PATTERNS) or vim.fn.getcwd()
		local stop_dir = vim.fs.dirname(workspace_root)

		-- Only activate if flat config exists (ESLint 9+)
		local eslint_config = vim.fs.find(ESLINT_FLAT_CONFIG, { path = fname, upward = true, stop = stop_dir })[1]
		if not eslint_config then
			on_dir(nil)
			return
		end

		on_dir(workspace_root)
	end,
	settings = {
		validate = "on",
		packageManager = nil,
		useESLintClass = false,
		experimental = {
			useFlatConfig = true, -- ESLint 9+ flat config only
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
		nodePath = "",
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
		local root_dir = config.root_dir
		if not root_dir then
			return
		end

		config.settings = config.settings or {}
		config.settings.workspaceFolder = {
			uri = root_dir,
			name = vim.fn.fnamemodify(root_dir, ":t"),
		}

		-- Find the nearest ESLint flat config from the current file
		local fname = vim.api.nvim_buf_get_name(0)
		local stop_dir = vim.fs.dirname(root_dir)
		local nearest_config = vim.fs.find(ESLINT_FLAT_CONFIG, { path = fname, upward = true, stop = stop_dir })[1]
		local config_dir = nearest_config and vim.fs.dirname(nearest_config) or root_dir

		-- Set working directory to where the ESLint config is found
		-- This is crucial for monorepos where config might be in a subdirectory
		config.settings.workingDirectory = {
			mode = "location",
			location = config_dir,
		}
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

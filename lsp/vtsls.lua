local ROOT_MARKERS = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }

local _vtsls_cmd = nil
local function get_vtsls_cmd()
	if _vtsls_cmd then
		return _vtsls_cmd
	end
	local handle = io.popen("node --version 2>/dev/null")
	if handle then
		local version = handle:read("*l")
		handle:close()
		if version then
			local major = tonumber(version:match("^v?(%d+)"))
			if major and major >= 20 then
				_vtsls_cmd = { "vtsls", "--stdio" }
				return _vtsls_cmd
			end
		end
	end
	-- Node < 20 or not found, use fnm with Node 24
	_vtsls_cmd = { "fnm", "exec", "--using=24", "vtsls", "--stdio" }
	return _vtsls_cmd
end

return {
	cmd = get_vtsls_cmd(),
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local filetype = vim.bo[bufnr].filetype

		local valid_filetypes = {
			javascript = true,
			javascriptreact = true,
			["javascript.jsx"] = true,
			typescript = true,
			typescriptreact = true,
			["typescript.tsx"] = true,
		}

		if not valid_filetypes[filetype] then
			on_dir(nil)
			return
		end

		-- Find workspace root
		local workspace_root = vim.fs.dirname(vim.fs.find(ROOT_MARKERS, { path = fname, upward = true })[1])
		on_dir(workspace_root or vim.fn.getcwd())
	end,
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = false },
				propertyDeclarationTypes = { enabled = false },
				variableTypes = { enabled = false },
			},
		},
	},
}

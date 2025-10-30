local util = require("utils.lsp")
-- pnpm add -g oxlint

return {
	cmd = { "oxc_language_server" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root_markers = util.insert_package_json({ ".oxlintrc.json" }, "oxlint", fname)
		on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
	end,
}

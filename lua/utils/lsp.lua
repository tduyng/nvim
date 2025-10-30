local lsp = vim.lsp
local M = { path = {} }

M.default_config = {
	log_level = lsp.protocol.MessageType.Warning,
	message_level = lsp.protocol.MessageType.Warning,
	settings = vim.empty_dict(),
	init_options = vim.empty_dict(),
	handlers = {},
	autostart = true,
	capabilities = lsp.protocol.make_client_capabilities(),
}

function M.root_markers_with_field(root_files, new_names, field, fname)
	local path = vim.fn.fnamemodify(fname, ":h")
	local found = vim.fs.find(new_names, { path = path, upward = true })

	for _, f in ipairs(found or {}) do
		for line in io.lines(f) do
			if line:find(field) then
				root_files[#root_files + 1] = vim.fs.basename(f)
				break
			end
		end
	end

	return root_files
end

function M.insert_package_json(root_files, field, fname)
	return M.root_markers_with_field(root_files, { "package.json", "package.json5" }, field, fname)
end

return M

local M = {}

local SEP = "" -- separator glyph at buffer boundary
local CLOSE = "" -- close icon shown on active buffer
local NO_NAME = "[NO NAME]"

local _tab_cache = nil -- cached rendered string
local _tab_cache_buf = nil -- bufnr when cache was built

local _tab_invalidate_events = {
	"BufAdd",
	"BufDelete",
	"BufWipeout",
	"BufFilePost", -- buffer renamed
	"BufModifiedSet", -- modified flag changed (shows/hides the indicator)
}

vim.api.nvim_create_autocmd(_tab_invalidate_events, {
	group = vim.api.nvim_create_augroup("MyTablineCache", { clear = true }),
	callback = function()
		_tab_cache = nil
	end,
})

function M.set_highlights()
	vim.api.nvim_set_hl(0, "MyBufInactive", { fg = "#ABB2BF", bg = "#282C34" })
	vim.api.nvim_set_hl(0, "MyBufActive", { fg = "#ECEFF4", bg = "#3E4451", bold = true })
	vim.api.nvim_set_hl(0, "MyBufSeparator", { fg = "#21252B", bg = "#282C34" })
	vim.api.nvim_set_hl(0, "MyBufClose", { fg = "#BF616A", bg = "#3E4451" })
end

-- Safe devicons resolve (cached per render)
local function get_icon(filename, name)
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok or not name or name == "" then
		return ""
	end
	local ext = vim.fn.fnamemodify(name, ":e")
	local icon = devicons.get_icon(filename, ext, { default = true })
	return icon and (icon .. " ") or ""
end

-- Extract parent folders + filename (e.g., "parent/config/tabline.lua")
local function get_display_name(path)
	if path == "" then
		return NO_NAME
	end
	local parts = vim.split(path, "/", { plain = true })
	if #parts == 1 then
		return parts[1] -- Just filename if no parent
	elseif #parts == 2 then
		return parts[#parts - 1] .. "/" .. parts[#parts] -- parent/filename
	else
		-- Return "grandparent/parent/filename" (last 3 parts)
		return parts[#parts - 2] .. "/" .. parts[#parts - 1] .. "/" .. parts[#parts]
	end
end

-- Render a single buffer chunk
local function render_buf(bufnr, current)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return ""
	end
	if not vim.bo[bufnr].buflisted then
		return ""
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	local display_name = get_display_name(name)
	local filename = (name ~= "" and vim.fn.fnamemodify(name, ":t")) or NO_NAME
	local icon = get_icon(filename, name)
	local content = icon .. display_name

	if bufnr == current then
		return table.concat({
			"%#MyBufActive# ",
			content,
			" %#MyBufClose#",
			CLOSE,
			" %#MyBufSeparator#",
			SEP,
		})
	else
		return table.concat({
			"%#MyBufInactive# ",
			content,
			"  %#MyBufSeparator#",
			SEP,
		})
	end
end

function _G.tabline()
	local current = vim.api.nvim_get_current_buf()

	-- Return cached string if the buffer list and active buffer haven't changed
	if _tab_cache and _tab_cache_buf == current then
		return _tab_cache
	end

	local parts = {}
	-- Iterate listed buffers in ascending handle order for stability
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local chunk = render_buf(bufnr, current)
		if chunk ~= "" then
			table.insert(parts, chunk)
		end
	end

	if #parts == 0 then
		_tab_cache = ""
		_tab_cache_buf = current
		return ""
	end

	local line = table.concat(parts)
	-- Trim trailing separator if present
	local result = line:gsub(vim.pesc(SEP) .. "$", "")
	_tab_cache = result
	_tab_cache_buf = current
	return result
end

function M.setup()
	M.set_highlights()

	vim.api.nvim_create_augroup("MyTabline", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = "MyTabline",
		callback = M.set_highlights,
	})

	vim.opt.showtabline = 2
	vim.opt.tabline = "%!v:lua.tabline()"
end

-- Close all buffers to the left/right of the current one
vim.keymap.set("n", "<leader>bl", function()
	local cur = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf < cur then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end, { desc = "Close all left buffers" })

vim.keymap.set("n", "<leader>br", function()
	local cur = vim.api.nvim_get_current_buf()
	local bufs = vim.api.nvim_list_bufs()
	for i = #bufs, 1, -1 do
		local buf = bufs[i]
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf > cur then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end, { desc = "Close all right buffers" })

M.setup()

return M

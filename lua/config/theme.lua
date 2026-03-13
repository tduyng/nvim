-- Native Catppuccin Configuration (Neovim 0.12+)
vim.g.catppuccin_flavour = "macchiato"

-- 1. Custom Palette Definition (Gruvbox-like feel)
local palettes = {
	macchiato = {
		rosewater = "#ea6962",
		flamingo = "#ea6962",
		red = "#ea6962",
		maroon = "#ea6962",
		pink = "#d3869b",
		mauve = "#d3869b",
		peach = "#e78a4e",
		yellow = "#d8a657",
		green = "#a9b665",
		teal = "#89b482",
		sky = "#89b482",
		sapphire = "#89b482",
		blue = "#7daea3",
		lavender = "#7daea3",
		text = "#ebdbb2",
		subtext2 = "#d5c4a1",
		subtext1 = "#d5c4a1",
		subtext0 = "#bdae93",
		overlay2 = "#a89984",
		overlay1 = "#928374",
		overlay0 = "#595959",
		surface2 = "#4d4d4d",
		surface1 = "#404040",
		surface0 = "#292929",
		base = "#1d2021",
		mantle = "#191b1c",
		crust = "#141617",
		none = "NONE",
	},
}

local function apply_custom_highlights()
	local flavor = vim.g.catppuccin_flavour or "macchiato"
	local colors = palettes[flavor] or palettes.macchiato

	-- [1] Core UI & Transparency
	local transparent_groups = {
		"Normal",
		"NormalNC",
		"LineNr",
		"Folded",
		"SignColumn",
		"EndOfBuffer",
		"VertSplit",
		"WinSeparator",
		"StatusLine",
		"StatusLineNC",
	}
	for _, group in ipairs(transparent_groups) do
		vim.api.nvim_set_hl(0, group, { fg = colors.text, bg = colors.none, ctermbg = colors.none })
	end

	local highlights = {
		-- UI Elements
		CmpItemMenu = { fg = colors.surface2 },
		CursorLineNr = { fg = colors.text, bold = true },
		FloatBorder = { bg = colors.base, fg = colors.surface0 },
		NormalFloat = { fg = colors.text, bg = colors.base },
		LineNr = { fg = colors.overlay0 },
		LspInfoBorder = { link = "FloatBorder" },
		Pmenu = { bg = colors.mantle, fg = colors.text },
		PmenuSel = { bg = colors.surface0, fg = colors.text },
		Question = { fg = colors.blue },
		WarningMsg = { fg = colors.yellow },
		ErrorMsg = { fg = colors.red },
		YankHighlight = { bg = colors.surface2 },
		VertSplit = { bg = colors.none, fg = colors.surface0 },
		Visual = { bg = colors.surface1 },
		Search = { bg = colors.surface1, fg = colors.text },
		CurSearch = { bg = colors.yellow, fg = colors.base },
		Directory = { fg = colors.blue, bold = true },
		NonText = { fg = colors.surface2 },
		SpecialKey = { fg = colors.surface2 },

		-- [2] Plugin: Snacks (Pickers, Notifier, etc.)
		SnacksBackdrop = { bg = "#000000" },
		SnacksNormal = { link = "NormalFloat" },
		SnacksPicker = { link = "NormalFloat" },
		SnacksPickerBorder = { link = "FloatBorder" },
		SnacksPickerList = { bg = colors.mantle, fg = colors.text },
		SnacksPickerPreview = { bg = colors.crust, fg = colors.text },
		SnacksPickerPreviewBorder = { bg = colors.crust, fg = colors.crust },
		SnacksPickerInput = { bg = colors.surface0, fg = colors.text },
		SnacksPickerInputBorder = { bg = colors.surface0, fg = colors.surface0 },
		SnacksPickerTitle = { fg = colors.mauve, bold = true },
		SnacksPickerMatch = { fg = colors.blue, bold = true },
		SnacksPickerLabel = { fg = colors.overlay1 },
		SnacksPickerDirectory = { fg = colors.subtext1 },
		SnacksPickerSelection = { bg = colors.surface0, bold = true },
		SnacksPickerRow = { bg = colors.mantle },

		-- [3] Plugin: WhichKey
		WhichKey = { fg = colors.pink },
		WhichKeyGroup = { fg = colors.blue },
		WhichKeySeparator = { fg = colors.overlay1 },
		WhichKeyDesc = { fg = colors.teal },
		WhichKeyFloat = { bg = colors.mantle },
		WhichKeyValue = { fg = colors.overlay1 },

		-- [4] Plugin: Telescope
		TelescopeNormal = { link = "NormalFloat" },
		TelescopeBorder = { link = "FloatBorder" },
		TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
		TelescopePreviewNormal = { bg = colors.crust },
		TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
		TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
		TelescopePromptCounter = { fg = colors.mauve, bold = true },
		TelescopePromptNormal = { bg = colors.surface0 },
		TelescopePromptPrefix = { bg = colors.surface0 },
		TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
		TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
		TelescopeResultsNormal = { bg = colors.mantle },
		TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
		TelescopeSelection = { bg = colors.surface0 },

		-- [5] Plugin: NeoTree
		NeoTreeDirectoryIcon = { fg = colors.subtext1 },
		NeoTreeDirectoryName = { fg = colors.subtext1 },
		NeoTreeFloatBorder = { link = "TelescopeResultsBorder" },
		NeoTreeGitConflict = { fg = colors.red },
		NeoTreeGitDeleted = { fg = colors.red },
		NeoTreeGitIgnored = { fg = colors.overlay0 },
		NeoTreeGitModified = { fg = colors.peach },
		NeoTreeGitStaged = { fg = colors.green },
		NeoTreeGitUnstaged = { fg = colors.red },
		NeoTreeGitUntracked = { fg = colors.green },
		NeoTreeIndent = { fg = colors.surface1 },
		NeoTreeNormal = { bg = colors.mantle, fg = colors.text },
		NeoTreeNormalNC = { bg = colors.mantle, fg = colors.text },
		NeoTreeRootName = { fg = colors.subtext1, bold = true },
		NeoTreeTabActive = { fg = colors.text, bg = colors.mantle },
		NeoTreeTabInactive = { fg = colors.surface2, bg = colors.crust },
		NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
		NeoTreeTabSeparatorInactive = { fg = colors.crust, bg = colors.crust },
		NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },

		-- [6] Plugin: Other Integrations
		FidgetTask = { fg = colors.subtext2 },
		FidgetTitle = { fg = colors.peach, bold = true },
		IblIndent = { fg = colors.surface0 },
		IblScope = { fg = colors.overlay0 },
		GitSignsChange = { fg = colors.peach },
		GitSignsAdd = { fg = colors.green },
		GitSignsDelete = { fg = colors.red },
		BlinkCmpLabelMatch = { fg = colors.blue, bold = true },
		FlashMatch = { bg = colors.mauve, fg = colors.base },
		FlashLabel = { bg = colors.peach, fg = colors.base, bold = true },
		NoiceLspProgressTitle = { fg = colors.peach, bold = true },
		YankyYanked = { bg = colors.surface2 },

		-- [7] Debugger (DAP)
		DapBreakpoint = { fg = colors.red },
		DapStopped = { fg = colors.green },
		DapLogPoint = { fg = colors.yellow },

		-- [8] Diagnostics
		DiagnosticError = { fg = colors.red },
		DiagnosticWarn = { fg = colors.yellow },
		DiagnosticInfo = { fg = colors.sky },
		DiagnosticHint = { fg = colors.teal },
		DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
		DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },
		DiagnosticUnderlineInfo = { sp = colors.sky, undercurl = true },
		DiagnosticUnderlineHint = { sp = colors.teal, undercurl = true },
		DiagnosticUnnecessary = { fg = colors.overlay0, undercurl = true },

		-- [9] Syntax Overrides (General)
		Identifier = { fg = colors.text },
		Boolean = { fg = colors.mauve },
		Number = { fg = colors.mauve },
		Float = { fg = colors.mauve },
		PreProc = { fg = colors.mauve },
		PreCondit = { fg = colors.mauve },
		Include = { fg = colors.mauve },
		Define = { fg = colors.mauve },
		Conditional = { fg = colors.red },
		Repeat = { fg = colors.red },
		Keyword = { fg = colors.red },
		Typedef = { fg = colors.red },
		Exception = { fg = colors.red },
		Statement = { fg = colors.red },
		Error = { fg = colors.red },
		StorageClass = { fg = colors.peach },
		Tag = { fg = colors.peach },
		Label = { fg = colors.peach },
		Structure = { fg = colors.peach },
		Operator = { fg = colors.peach },
		Title = { fg = colors.peach, bold = true },
		Special = { fg = colors.yellow },
		SpecialChar = { fg = colors.yellow },
		Type = { fg = colors.yellow, bold = true },
		Function = { fg = colors.green, bold = true },
		Delimiter = { fg = colors.subtext2 },
		Ignore = { fg = colors.subtext2 },
		Macro = { fg = colors.teal },
		String = { fg = colors.teal },
		Comment = { fg = colors.overlay1, italic = true },

		-- [10] Treesitter & LSP Highlighting (Comprehensive)
		["@variable"] = { fg = colors.text },
		["@variable.builtin"] = { fg = colors.red },
		["@variable.parameter"] = { fg = colors.text },
		["@variable.member"] = { fg = colors.blue },
		["@property"] = { fg = colors.blue },
		["@field"] = { fg = colors.blue },
		["@parameter"] = { fg = colors.text },
		["@constant"] = { fg = colors.text },
		["@constant.builtin"] = { fg = colors.mauve },
		["@constructor"] = { fg = colors.green, bold = true },
		["@module"] = { fg = colors.yellow },
		["@namespace"] = { fg = colors.yellow },
		["@label"] = { fg = colors.peach },
		["@attribute"] = { fg = colors.mauve },
		["@none"] = { fg = colors.text },

		-- Language specific
		["@tag"] = { fg = colors.peach },
		["@tag.attribute"] = { fg = colors.green },
		["@tag.delimiter"] = { fg = colors.green },

		-- Feature Files (Cucumber/Gherkin)
		["@gherkin.feature"] = { fg = colors.peach, bold = true },
		["@gherkin.scenario"] = { fg = colors.peach, bold = true },
		["@gherkin.step"] = { fg = colors.text },
		["@gherkin.keyword"] = { fg = colors.peach, bold = true },
		["@gherkin.text"] = { fg = colors.text },
		["@gherkin.parameter"] = { fg = colors.sky },
		["@gherkin.tag"] = { fg = colors.mauve },
		["@keyword.gherkin"] = { fg = colors.peach, bold = true },
		["@string.gherkin"] = { fg = colors.teal },
		["@cucumber.step"] = { fg = colors.text },
		["@cucumber.keyword"] = { fg = colors.peach, bold = true },
		gherkinFeature = { fg = colors.peach, bold = true },
		gherkinScenario = { fg = colors.peach, bold = true },
		gherkinKeyword = { fg = colors.peach, bold = true },
		gherkinStep = { fg = colors.text },
		gherkinText = { fg = colors.text },
		gherkinParameter = { fg = colors.sky },
		gherkinTags = { fg = colors.mauve },

		-- Git Commit
		gitcommitSummary = { fg = colors.red, bold = true },
		gitcommitHeader = { fg = colors.peach },
		gitcommitOverflow = { fg = colors.red },
		gitcommitSelectedFile = { fg = colors.green },
		gitcommitDiscardedFile = { fg = colors.red },

		-- Markdown
		["@markup.heading"] = { fg = colors.peach, bold = true },
		["@markup.list"] = { fg = colors.red },
		["@markup.link"] = { fg = colors.blue },
		["@markup.link.label"] = { fg = colors.blue },
		["@markup.raw"] = { fg = colors.teal },
		["@markup.italic"] = { italic = true },
		["@markup.strong"] = { bold = true },

		-- LSP Semantic Tokens
		["@lsp.type.variable"] = { link = "@variable" },
		["@lsp.type.property"] = { link = "@property" },
		["@lsp.type.function"] = { link = "@function" },
		["@lsp.type.parameter"] = { fg = colors.text },
		["@lsp.type.member"] = { link = "@variable.member" },
		["@lsp.type.type"] = { link = "@type" },
		["@lsp.type.class"] = { link = "@type" },
		["@lsp.type.enum"] = { link = "@type" },
		["@lsp.type.enumMember"] = { link = "@variable.member" },
		["@lsp.type.namespace"] = { link = "@namespace" },
		["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },

		-- [11] Diff & Git (Fixes vdiff issues)
		DiffAdd = { bg = "#2d3326", fg = colors.none },
		DiffChange = { bg = "#2d2a2e", fg = colors.none },
		DiffDelete = { bg = "#332626", fg = colors.none },
		DiffText = { bg = "#263033", fg = colors.none },
		diffAdded = { fg = colors.green },
		diffRemoved = { fg = colors.red },
		diffChanged = { fg = colors.blue },
		VDiffActiveFile = { link = "Search" },
	}

	for group, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

-- Create autocommand to apply overrides whenever catppuccin is loaded
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("NativeCatppuccinOverrides", { clear = true }),
	pattern = "catppuccin*",
	callback = apply_custom_highlights,
})

-- Load the colorscheme
vim.cmd("colorscheme catppuccin")

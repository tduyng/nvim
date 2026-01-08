vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap", version = "7bb46cc612bb127d7b0e3e9ed695267d830824ec" },
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
})

local _dap_initialized = false

local function init_dap()
	if _dap_initialized then
		return
	end

	_dap_initialized = true

	local dap = require("dap")
	local dapui = require("dapui")

	local js_debug_path = vim.fn.expand("$HOME/vscode-js-debug/out/src/dapDebugServer.js")
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = { js_debug_path, "${port}" },
		},
	}
	dap.adapters["node"] = function(cb, config)
		if config.type == "node" then
			config.type = "pwa-node"
		end
		local a = dap.adapters["pwa-node"]
		if type(a) == "function" then
			a(cb, config)
		else
			cb(a)
		end
	end

	-- JS/TS configurations
	local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
	for _, ft in ipairs(js_filetypes) do
		dap.configurations[ft] = {
			{
				type = "pwa-node",
				request = "attach",
				name = "Neovim node.js",
				port = 9229,
				address = "localhost",
				localRoot = vim.fn.getcwd(),
				remoteRoot = "/usr/src/app",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Neovim mocha",
				program = "${workspaceFolder}/node_modules/mocha/bin/_mocha",
				args = {
					"--require",
					"ts-node/register/transpile-only",
					"--require",
					"source-map-support/register",
					"--reporter",
					"spec",
					"--colors",
					"${workspaceFolder}/tests/unit/**/*.[tj]s",
				},
				cwd = vim.fn.getcwd(),
				runtimeExecutable = "node",
				internalConsoleOptions = "openOnSessionStart",
				skipFiles = { "<node_internals>/**" },
				sourceMaps = true,
				protocol = "inspector",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Neovim Jest",
				program = "${workspaceFolder}/node_modules/jest/bin/jest.js",
				args = { "--runInBand", "--no-cache", "${relativeFile}" },
				cwd = "${workspaceFolder}",
				runtimeExecutable = "node",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
				sourceMaps = true,
				skipFiles = { "<node_internals>/**" },
			},
		}
	end

	-- DAP UI setup
	dapui.setup({
		icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
		controls = {
			icons = {
				pause = "⏸",
				play = "▶",
				step_into = "⏎",
				step_over = "⏭",
				step_out = "⏮",
				step_back = "b",
				run_last = "▶▶",
				terminate = "⏹",
				disconnect = "⏏",
			},
		},
	})

	-- Auto-open/close UI
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.disconnect["dapui_config"] = function()
		dapui.close({})
	end

	-- Virtual text
	require("nvim-dap-virtual-text").setup()
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>db", function() init_dap(); require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function() init_dap(); require("dap").list_breakpoints(); vim.cmd("copen") end, { desc = "List Breakpoints" })
vim.keymap.set("n", "<leader>dc", function() init_dap(); require("dap").continue() end, { desc = "Run/Continue" })
vim.keymap.set("n", "<leader>dC", function() init_dap(); require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dg", function() init_dap(); require("dap").goto_() end, { desc = "Go to Line (No Execute)" })
vim.keymap.set("n", "<leader>di", function() init_dap(); require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dj", function() init_dap(); require("dap").down() end, { desc = "Down" })
vim.keymap.set("n", "<leader>dk", function() init_dap(); require("dap").up() end, { desc = "Up" })
vim.keymap.set("n", "<leader>dl", function() init_dap(); require("dap").run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>do", function() init_dap(); require("dap").step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dO", function() init_dap(); require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dP", function() init_dap(); require("dap").pause() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", function() init_dap(); require("dap").repl.toggle() end, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>ds", function() init_dap(); require("dap").session() end, { desc = "Session" })
vim.keymap.set("n", "<leader>dt", function() 
	init_dap();
	require("dap").terminate()
	vim.defer_fn(function()
		require("dapui").close({})
	end, 100)
end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dw", function() init_dap(); require("dap.ui.widgets").hover() end, { desc = "DAP Widgets" })
vim.keymap.set("n","<leader>du", function() init_dap(); require("dapui").toggle({}) end, {desc = "Dap UI"})

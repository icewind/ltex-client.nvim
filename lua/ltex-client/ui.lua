local M = {}

local close_keys = { "<ESC>", "<CR>", "<leader>", "q" }

function M.showModalWindow(content)
	local vim_ui = vim.api.nvim_list_uis()[1]
	local buf = vim.api.nvim_create_buf(false, true)

	for _, key in pairs(close_keys) do
		vim.api.nvim_buf_set_keymap(buf, "n", key, ":close<CR>", { silent = true, noremap = true, nowait = true })
	end

	local width = 50
	local height = 20

	local lines = {}
	for line in string.gmatch(content, "([^\n]*)\n?") do
		lines[#lines + 1] = line
	end

	vim.api.nvim_buf_set_lines(buf, 0, 0, true, lines)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = (vim_ui.width / 2) - (width / 2),
		row = (vim_ui.height / 2) - (height / 2),
		anchor = "NW",
		style = "minimal",
	})
end

return M

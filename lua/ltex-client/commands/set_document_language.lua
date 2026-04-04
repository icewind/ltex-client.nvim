-- Command to override a document language
local server = require("ltex-client.server")
local constants = require("ltex-client.constants")

return {
	name = "LTeXSetLanguage",
	description = "Set the document language",
	handler = function()
		vim.ui.input({
			prompt = "Set document language to: ",
		}, function(value)
			local code = vim.fn.trim(value)
			if not vim.tbl_contains(constants.SUPPORTED_LANGUAGES, code) then
				vim.notify(string.format(constants.UNSUPPORTED_LANG_MESSAGE, code), vim.log.levels.ERROR)
				return
			end
			server.update_configuration({ language = code })
		end)
	end,
}

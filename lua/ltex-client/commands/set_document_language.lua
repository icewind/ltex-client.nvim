local server = require("ltex-client.server")

-- The list taken from https://valentjn.github.io/ltex/settings.html#ltexlanguage
local SUPPORTED_LANGUAGES = {
	"auto",
	"ar",
	"ast-ES",
	"be-BY",
	"br-FR",
	"ca-ES",
	"ca-ES-valencia",
	"da-DK",
	"de",
	"de-AT",
	"de-CH",
	"de-DE",
	"de-DE-x-simple-language",
	"el-GR",
	"en",
	"en-AU",
	"en-CA",
	"en-GB",
	"en-NZ",
	"en-US",
	"en-ZA",
	"eo",
	"es",
	"es-AR",
	"fa",
	"fr",
	"ga-IE",
	"gl-ES",
	"it",
	"ja-JP",
	"km-KH",
	"nl",
	"nl-BE",
	"pl-PL",
	"pt",
	"pt-AO",
	"pt-BR",
	"pt-MZ",
	"pt-PT",
	"ro-RO",
	"ru-RU",
	"sk-SK",
	"sl-SI",
	"sv",
	"ta-IN",
	"tl-PH",
	"uk-UA",
	"zh-CN",
}

local UNSUPPORTED_LANG_MESSAGE = "LTeXClient: Unsupported language: %s\n"
	.. "Please refer to https://valentjn.github.io/ltex/settings.html#ltexlanguage for the list of supported languages"

return {
	name = "LTeXSetLanguage",
	description = "Set the document language",
	handler = function()
		vim.ui.input({
			prompt = "Set document language to: ",
		}, function(value)
			local code = vim.fn.trim(value)
			if not vim.tbl_contains(SUPPORTED_LANGUAGES, code) then
				vim.notify(string.format(UNSUPPORTED_LANG_MESSAGE, code), vim.log.levels.ERROR)
				return
			end
			server.update_configuration({ language = code })
		end)
	end,
}

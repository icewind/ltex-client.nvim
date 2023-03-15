local M = {}

local utils = require("ltex-client.utils")
local server = require("ltex-client.server")
local Dictionary = require("ltex-client.dictionary")

local commands = require("ltex-client.commands.all")

-- `user_dictionaries_path` determines a path where dictionaries, excludes and ignores will be saved
-- Later, I'd like to add `workspace_dictionaries_path` which will be dynamically determined
-- or accept a callback function.
local default_options = {
	user_dictionaries_path = utils.path({ vim.env.HOME, ".ltex", "dictionaries" }),
}

local function make_handler(dictionary, section)
	return function(command)
		for language, values in pairs(command.arguments[1][section]) do
			dictionary:add(language, values)
		end
		server.update_configuration({ [dictionary.name] = dictionary.content })
	end
end

function M.setup(options)
	options = vim.tbl_extend("keep", options or {}, default_options)
	utils.ensure_folder(options.user_dictionaries_path)

	local dictionary = Dictionary:new(utils.path({ options.user_dictionaries_path, "dictionary.json" }), "dictionary")
	local disabled_rules =
		Dictionary:new(utils.path({ options.user_dictionaries_path, "disabled_rules.json" }), "disabledRules")
	local false_positives =
		Dictionary:new(utils.path({ options.user_dictionaries_path, "false_positives.json" }), "hiddenFalsePositives")

	-- Set initial/saved values
	server.set_startup_configuration({
		dictionary,
		disabled_rules,
		false_positives,
	})

	-- Action handlers
	server.set_handler("addToDictionary", make_handler(dictionary, "words"))
	server.set_handler("disableRules", make_handler(disabled_rules, "ruleIds"))
	server.set_handler("hideFalsePositives", make_handler(false_positives, "falsePositives"))

	-- Setting commands
	vim.api.nvim_create_autocmd({ "FileType" }, {
		-- These are default values taken from https://valentjn.github.io/ltex/settings.html#ltexenabled
		-- TODO: Check if I can dynamically load these from ltex-ls settings
		pattern = {
			"bibtex",
			"context",
			"context.tex",
			"html",
			"latex",
			"markdown",
			"org",
			"restructuredtext",
			"rsweave",
		},
		callback = function()
			for _, command in ipairs(commands) do
				vim.api.nvim_create_user_command(command.name, command.handler, {})
			end
		end,
	})
end

return M

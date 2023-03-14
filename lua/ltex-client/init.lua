local M = {}

local utils = require("ltex-client.utils")
local server = require("ltex-client.server")
local Dictionary = require("ltex-client.dictionary")

-- `user_dictionaries_path` determines a path where dictionaries, excludes and ignores will be saved
-- Later, I'd like to add `workspace_dictionaries_path` which will be dynamically determined
-- or accept a callback function.
local default_options = {
	user_dictionaries_path = utils.path({ vim.env.HOME, ".ltex", "dictionaries" }),
}

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

	server.set_handler("addToDictionary", function(command)
		for language, words in pairs(command.arguments[1].words) do
			dictionary:add(language, words)
		end
		server.update_dictionary(dictionary)
	end)

	server.set_handler("disableRules", function(command)
		for language, rules in pairs(command.arguments[1].ruleIds) do
			disabled_rules:add(language, rules)
		end
		server.update_dictionary(disabled_rules)
	end)

	server.set_handler("hideFalsePositives", function(command)
		for language, falsy in pairs(command.arguments[1].falsePositives) do
			false_positives:add(language, falsy)
		end
		server.update_dictionary(false_positives)
	end)
end

return M

local server = require("ltex-client.server")

describe("ltex-client setup", function()
	local tmpdir

	before_each(function()
		tmpdir = vim.fn.tempname()
		os.execute("mkdir -p " .. tmpdir)
	end)

	after_each(function()
		os.execute("rm -rf " .. tmpdir)
		rawset(vim.lsp.commands, "_ltex.addToDictionary", nil)
		rawset(vim.lsp.commands, "_ltex.disableRules", nil)
		rawset(vim.lsp.commands, "_ltex.hideFalsePositives", nil)
	end)

	it("addToDictionary handler persists words and pushes config to server", function()
		require("ltex-client").setup({ user_dictionaries_path = tmpdir })

		local config_received = nil
		local orig_update = server.update_configuration
		server.update_configuration = function(values)
			config_received = values
		end

		vim.lsp.commands["_ltex.addToDictionary"]({
			arguments = { { words = { ["en-US"] = { "neovim", "lua" } } } },
		})

		server.update_configuration = orig_update

		local file = io.open(tmpdir .. "/dictionary.json", "r")
		local content = vim.json.decode(file:read("*a"))
		file:close()

		assert.are.same({ "neovim", "lua" }, content["en-US"])
		assert.are.same({ "neovim", "lua" }, config_received.dictionary["en-US"])
	end)

	it("disableRules handler persists rule IDs and pushes config to server", function()
		require("ltex-client").setup({ user_dictionaries_path = tmpdir })

		local config_received = nil
		local orig_update = server.update_configuration
		server.update_configuration = function(values)
			config_received = values
		end

		vim.lsp.commands["_ltex.disableRules"]({
			arguments = { { ruleIds = { ["en-US"] = { "MORFOLOGIK_RULE_EN_US" } } } },
		})

		server.update_configuration = orig_update

		local file = io.open(tmpdir .. "/disabled_rules.json", "r")
		local content = vim.json.decode(file:read("*a"))
		file:close()

		assert.are.same({ "MORFOLOGIK_RULE_EN_US" }, content["en-US"])
		assert.are.same({ "MORFOLOGIK_RULE_EN_US" }, config_received.disabledRules["en-US"])
	end)

	it("hideFalsePositives handler persists false positives and pushes config to server", function()
		require("ltex-client").setup({ user_dictionaries_path = tmpdir })

		local config_received = nil
		local orig_update = server.update_configuration
		server.update_configuration = function(values)
			config_received = values
		end

		vim.lsp.commands["_ltex.hideFalsePositives"]({
			arguments = { { falsePositives = { ["en-US"] = { "some sentence" } } } },
		})

		server.update_configuration = orig_update

		local file = io.open(tmpdir .. "/false_positives.json", "r")
		local content = vim.json.decode(file:read("*a"))
		file:close()

		assert.are.same({ "some sentence" }, content["en-US"])
		assert.are.same({ "some sentence" }, config_received.hiddenFalsePositives["en-US"])
	end)
end)

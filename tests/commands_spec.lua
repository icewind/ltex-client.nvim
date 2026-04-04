describe("set_document_language", function()
	local server = require("ltex-client.server")
	local cmd = require("ltex-client.commands.set_document_language")

	it("updates server configuration with a valid language", function()
		local called_with = nil

		local orig_input = vim.ui.input
		vim.ui.input = function(_, callback)
			callback("en-US")
		end

		local orig_update = server.update_configuration
		server.update_configuration = function(values)
			called_with = values
		end

		cmd.handler()

		vim.ui.input = orig_input
		server.update_configuration = orig_update

		assert.are.same({ language = "en-US" }, called_with)
	end)

	it("rejects an unsupported language and does not update configuration", function()
		local notified_level = nil
		local update_called = false

		local orig_input = vim.ui.input
		vim.ui.input = function(_, callback)
			callback("xx-INVALID")
		end

		local orig_notify = vim.notify
		vim.notify = function(_, level)
			notified_level = level
		end

		local orig_update = server.update_configuration
		server.update_configuration = function(_)
			update_called = true
		end

		cmd.handler()

		vim.ui.input = orig_input
		vim.notify = orig_notify
		server.update_configuration = orig_update

		assert.is_false(update_called)
		assert.are.equal(vim.log.levels.ERROR, notified_level)
	end)

	it("trims whitespace from user input before validating", function()
		local called_with = nil

		local orig_input = vim.ui.input
		vim.ui.input = function(_, callback)
			callback("  en-US  ")
		end

		local orig_update = server.update_configuration
		server.update_configuration = function(values)
			called_with = values
		end

		cmd.handler()

		vim.ui.input = orig_input
		server.update_configuration = orig_update

		assert.are.same({ language = "en-US" }, called_with)
	end)
end)

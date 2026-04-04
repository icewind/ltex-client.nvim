local server = require("ltex-client.server")

describe("server", function()
	describe("set_startup_configuration", function()
		local original_handler

		before_each(function()
			original_handler = vim.lsp.handlers["workspace/configuration"]
		end)

		after_each(function()
			vim.lsp.handlers["workspace/configuration"] = original_handler
		end)

		it("injects dictionary content when the ltex client requests configuration", function()
			local dictionaries = {
				{ name = "dictionary", content = { ["en-US"] = { "hello" } } },
				{ name = "disabledRules", content = { ["en-US"] = { "RULE1" } } },
			}
			server.set_startup_configuration(dictionaries)

			local orig_get_client = vim.lsp.get_client_by_id
			vim.lsp.get_client_by_id = function(_)
				return { name = "ltex" }
			end

			local result = vim.lsp.handlers["workspace/configuration"](nil, {}, { client_id = 1 }, nil)

			vim.lsp.get_client_by_id = orig_get_client

			assert.are.same({ "hello" }, result.dictionary["en-US"])
			assert.are.same({ "RULE1" }, result.disabledRules["en-US"])
		end)

		it("delegates to the original handler for non-ltex clients", function()
			local delegate_called = false
			local delegate_result = { some = "config" }
			vim.lsp.handlers["workspace/configuration"] = function(_, _, _, _)
				delegate_called = true
				return delegate_result
			end

			server.set_startup_configuration({})

			local orig_get_client = vim.lsp.get_client_by_id
			vim.lsp.get_client_by_id = function(_)
				return { name = "pyright" }
			end

			local result = vim.lsp.handlers["workspace/configuration"](nil, {}, { client_id = 1 }, nil)

			vim.lsp.get_client_by_id = orig_get_client

			assert.is_true(delegate_called)
			assert.are.same(delegate_result, result)
		end)
	end)

	describe("update_configuration", function()
		it("gracefully returns when no LSP client is attached", function()
			assert.has_no.errors(function()
				server.update_configuration({ language = "en-US" })
			end)
		end)
	end)
end)

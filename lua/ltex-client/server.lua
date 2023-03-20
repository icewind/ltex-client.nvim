local Server = {}

local current_configuration = {}

local function update_config(new_values)
	current_configuration = vim.tbl_deep_extend("force", current_configuration, new_values)
	return current_configuration
end

-- Get ltex language server
local function get_client()
	local _, client = next(vim.lsp.get_active_clients({ name = "ltex" }))
	return client
end

function Server.is_loaded()
	return get_client() ~= nil
end

function Server.update_configuration(values)
	local client = get_client()
	if client == nil then
		vim.notify("Ltex-ls is not loaded for the current buffer", vim.log.levels.WARN)
		return
	end
	if client.config.settings.ltex == nil then
		client.config.settings.ltex = {}
	end
	client.config.settings.ltex = vim.tbl_deep_extend("force", client.config.settings.ltex, update_config(values))
	client.notify("workspace/didChangeConfiguration", client.config.settings)
end

function Server.set_startup_configuration(dictionaries)
	local name = "workspace/configuration"
	local existing_handler = vim.lsp.handlers[name]
	vim.lsp.handlers[name] = function(err, msg, info)
		local client = vim.lsp.get_client_by_id(info.client_id)
		if client == nil or client.name ~= "ltex" then
			return existing_handler(err, msg, info)
		end
		local config = {}
		for _, value in ipairs(dictionaries) do
			config[value.name] = value.content
		end

		-- Get initial configuration from the client(possibly defined in lspconfig)
		update_config(existing_handler(err, msg, info)[1])
		return update_config(config)
	end
end

-- Set the handler for ltex-specific command
function Server.set_handler(action, handler)
	vim.lsp.commands[string.format("_ltex.%s", action)] = handler
end

return Server

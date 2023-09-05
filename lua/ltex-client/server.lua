local Server = {}

local current_configuration = {}

local function update_local_config(new_values)
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
	client.config.settings.ltex = vim.tbl_deep_extend("force", client.config.settings.ltex, update_local_config(values))
	client.notify("workspace/didChangeConfiguration", client.config.settings)
end

function Server.set_startup_configuration(dictionaries)
	local name = "workspace/configuration"
	local existing_handler = vim.lsp.handlers[name]
	vim.lsp.handlers[name] = function(err, result, ctx, config)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if client == nil or client.name ~= "ltex" then
			return existing_handler(err, result, ctx, config)
		end
		local options = {}
		for _, value in ipairs(dictionaries) do
			options[value.name] = value.content
		end
		if config ~= nil then
			-- Reading configuration values from nvim lsp config
			update_local_config(config)
		end
		return update_local_config(options)
	end
end

-- Set the handler for ltex-specific command
function Server.set_handler(action, handler)
	vim.lsp.commands[string.format("_ltex.%s", action)] = handler
end

return Server

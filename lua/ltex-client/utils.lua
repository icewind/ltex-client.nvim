local Utils = {}
local path_separator = package.config:sub(1, 1)

function Utils.path(parts)
	if type(parts) ~= "table" then
		parts = { parts }
	end
	return table.concat(parts, path_separator)
end

-- Check if a folder exists and creates if it is not
function Utils.ensure_folder(path)
	if vim.fn.isdirectory(path) == 0 then
		os.execute("mkdir -p " .. path)
	end
end

return Utils

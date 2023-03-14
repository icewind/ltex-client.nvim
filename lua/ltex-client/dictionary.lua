local Dictionary = {}

function Dictionary:new(path, name)
	local instance = {
		path = path,
		name = name,
		content = {},
	}
	self.__index = self

	-- In case there is no file with words, we will create it only if needed(Something added).
	if vim.fn.filereadable(vim.fn.expand(path)) ~= 0 then
		local file = io.open(path, "r")
		if file ~= nil then
			instance.content = vim.json.decode(file:read("*a"))
			file:close()
		end
	end

	return setmetatable(instance, self)
end

-- Add new line to current dictionary
function Dictionary:add(language, values)
	if self.content[language] == nil then
		self.content[language] = {}
	end

	if type(values) ~= "table" then
		values = { values }
	end

	vim.list_extend(self.content[language], values)

	local file = io.open(self.path, "w+")
	if file then
		file:write(vim.json.encode(self.content))
		file:close()
	else
		vim.notify("Error saving the dictionary file", vim.log.levels.ERROR)
	end
end

return Dictionary

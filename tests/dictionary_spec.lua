local Dictionary = require("ltex-client.dictionary")

describe("Dictionary", function()
	local tmpdir
	local dict_path

	before_each(function()
		tmpdir = vim.fn.tempname()
		os.execute("mkdir -p " .. tmpdir)
		dict_path = tmpdir .. "/test_dict.json"
	end)

	after_each(function()
		os.execute("rm -rf " .. tmpdir)
	end)

	it("loads existing content from a JSON file", function()
		local file = io.open(dict_path, "w")
		file:write(vim.json.encode({ ["en-US"] = { "hello", "world" } }))
		file:close()

		local dict = Dictionary:new(dict_path, "dictionary")
		assert.are.same({ ["en-US"] = { "hello", "world" } }, dict.content)
	end)

	it("wraps a single string value into a table on add", function()
		local dict = Dictionary:new(dict_path, "dictionary")
		dict:add("en-US", "hello")
		assert.are.same({ "hello" }, dict.content["en-US"])
	end)

	it("appends to an existing language key", function()
		local dict = Dictionary:new(dict_path, "dictionary")
		dict:add("en-US", { "hello" })
		dict:add("en-US", { "world" })
		assert.are.same({ "hello", "world" }, dict.content["en-US"])
	end)

	it("persists content to disk on add", function()
		local dict = Dictionary:new(dict_path, "dictionary")
		dict:add("en-US", { "hello", "world" })

		local file = io.open(dict_path, "r")
		local saved = vim.json.decode(file:read("*a"))
		file:close()
		assert.are.same({ ["en-US"] = { "hello", "world" } }, saved)
	end)

	it("survives a round-trip: add, destroy, reload from same file", function()
		local dict1 = Dictionary:new(dict_path, "dictionary")
		dict1:add("en-US", { "alpha", "beta" })
		dict1:add("fr", { "bonjour" })

		local dict2 = Dictionary:new(dict_path, "dictionary")
		assert.are.same({ "alpha", "beta" }, dict2.content["en-US"])
		assert.are.same({ "bonjour" }, dict2.content["fr"])
	end)
end)

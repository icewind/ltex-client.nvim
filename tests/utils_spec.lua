local utils = require("ltex-client.utils")

describe("utils", function()
	describe("ensure_folder", function()
		local tmpdir

		before_each(function()
			tmpdir = vim.fn.tempname()
		end)

		after_each(function()
			os.execute("rm -rf " .. tmpdir)
		end)

		it("creates a directory that does not exist", function()
			assert.are.equal(0, vim.fn.isdirectory(tmpdir))
			utils.ensure_folder(tmpdir)
			assert.are.equal(1, vim.fn.isdirectory(tmpdir))
		end)

		it("is idempotent on an existing directory", function()
			os.execute("mkdir -p " .. tmpdir)
			utils.ensure_folder(tmpdir)
			assert.are.equal(1, vim.fn.isdirectory(tmpdir))
		end)
	end)
end)

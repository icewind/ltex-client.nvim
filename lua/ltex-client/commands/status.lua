-- A command that shows a popup window with a status message from ltex-ls server
local server = require("ltex-client.server")
local ui = require("ltex-client.ui")

local template = [[CPU Duration: %s
CPU Usage:    %d
IS Checking:  %s
Process ID:   %d
Success:      %s
Total Memory: %s
Used Memory:  %s

Wall Clock Duration: %s

Document Uri Being Checked: %s
]]

local function formatMemory(size)
	return string.format("%.2f MB", size / 1000000)
end

local function formatDuration(duration)
	local milliseconds = math.floor(1000 * (duration % 1))
	local seconds = math.floor(duration % 60)
	local minutes = math.floor(duration / 60) % 60
	local hours = math.floor(duration / 3600)
	return string.format("%02d:%02d:%02d.%04d", hours, minutes, seconds, milliseconds)
end

return {
	name = "LTeXStatus",
	description = "Show ltex-ls status",
	handler = function()
		server.status(function(status)
			local message = string.format(
				template,
				formatDuration(status.cpuDuration),
				status.cpuUsage,
				status.isChecking,
				status.processId,
				status.success,
				formatMemory(status.totalMemory),
				formatMemory(status.usedMemory),
				formatDuration(status.wallClockDuration),
				status.documentUriBeingChecked
			)
			ui.showModalWindow(message)
		end)
	end,
}

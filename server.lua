------------------------------------
--- Discord Chat Roles by Badger ---
------------------------------------

--[[
	List in order of least priority to highest with 
	highest priority overtaking role before it if 
	they have that discord role.
]]--
roleList = {
{0, "^4Civilian | "},
{1, "^3Trusted Civ | "},
{1, "^2Donator | "},
{1, "^1T-Mod | "},
{1, "^1Mod | "},
{1, "^1Admin | "},
{1, "^6Management | "},
{1, "^6Owner | "},
}


--- Code ---

function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
AddEventHandler('chatMessage', function(source, name, msg)
	CancelEvent()
	local args = stringsplit(msg)
	if not string.find(args[1], "/") then
		local src = source
		for k, v in ipairs(GetPlayerIdentifiers(src)) do
			if string.sub(v, 1, string.len("discord:")) == "discord:" then
				identifierDiscord = v
			end
		end
		local roleStr = roleList[1][2]
		if identifierDiscord then
			local roleIDs = exports.discord_perms:GetRoles(src)
			-- Loop through roleList and set their role up:
			for i = 1, #roleList do
				for j = 1, #roleIDs do
					local roleID = roleIDs[j]
					if (tostring(roleList[i][1]) == tostring(roleID)) then
						roleStr = roleList[i][2]
					end
				end
			end
		end
		TriggerClientEvent('chatMessage', -1, roleStr .. name .. "^7: " .. msg)
	end
end)
			

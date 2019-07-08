------------------------------------
--- Discord Chat Roles by Badger ---
------------------------------------

--[[
	List in order of least priority to highest with 
	highest priority overtaking role before it if 
	they have that discord role.
]]--
roleList = {
{0, "^4Civilian | "}, -- 1
{1, "^3Trusted Civ | "}, -- 2
{1, "^2Donator | "}, -- 3
{1, "^1T-Mod | "}, -- 4
{1, "^1Mod | "}, -- 5
{1, "^1Admin | "}, -- 6
{1, "^6Management | "}, -- 7
{1, "^6Owner | "}, -- 8
}

-- For allowing colored chat
allowedColors = {3, 4, 5, 6, 7, 8}
allowedRed = {4, 5, 6, 7, 8}


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

roleTracker = {}

function setContains(set, key)
    return set[key] ~= nil
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
		local roleNum = 0
		if identifierDiscord then
			local roleIDs = exports.discord_perms:GetRoles(src)
			-- Loop through roleList and set their role up:
			if not (roleIDs == false) then
				for i = 1, #roleList do
					for j = 1, #roleIDs do
						local roleID = roleIDs[j]
						if (tostring(roleList[i][1]) == tostring(roleID)) then
							roleStr = roleList[i][2]
							roleNum = i
						end
					end
				end
			else
				print(GetPlayerName(src) .. " has not gotten their permissions cause roleIDs == false")
			end
		end
		roleTracker[GetPlayerName(src)] = roleStr
		local colors = {'^0', '^2', '^3', '^4', '^5', '^6', '^7', '^8', '^9'}
		local staffColors = {'^1', '^8'}
		local hasColors = false
		local hasRed = false
		for i = 1, #colors do
			local checkFor = "%" .. tostring(colors[i])
			if string.match(msg, checkFor) ~= nil then
				hasColors = true
			end
		end
		for i = 1, #staffColors do
			if string.find(msg, "%" .. staffColors[i]) ~= nil then
				hasRed = true
			end
		end
		local dontSend = false
		if hasColors then
			-- Check if they have required role
			if not has_value(allowedColors, tonumber(roleNum)) then
				dontSend = true
				TriggerClientEvent('chatMessage', source, "^7[^1DiscordChatRoles^7] ^1You cannot use colored chat since you are not a donator...")
			end
		end
		if hasRed then
			-- Check if they have required role
			if not has_value(allowedRed, tonumber(roleNum)) then
				dontSend = true
				TriggerClientEvent('chatMessage', source, "^7[^1DiscordChatRoles^7] ^1You cannot use the color RED in chat since you are not staff...")
			end
		end
		if not dontSend then
			TriggerClientEvent('chatMessage', -1, roleStr .. name .. "^7: " .. msg)
		end
	end
end)
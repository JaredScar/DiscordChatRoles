------------------------------------
--- Discord Chat Roles by Badger ---
------------------------------------

roleList = Config.roleList;
allowedColors = Config.allowedColors;
allowedRed = Config.allowedRed;
allowedEmoji = Config.allowedEmoji;
sendBlockMessages = Config.sendBlockMessages;
emojis = Config.emojis;


-- CODE --
function sendMsg(firstline, msg, to) 
	TriggerClientEvent('chat:addMessage', to, {
		template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(93, 93, 93, 0.25); border-radius: 3px;">{0} <br> {1}</div>',
        args = { firstline, msg }
	});
end 


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
function get_index (tab, val)
	local counter = 1
    for index, value in ipairs(tab) do
        if value == val then
            return counter
        end
		counter = counter + 1
    end

    return nil
end

roleTracker = {}
roleAccess = {}
chatcolorTracker = {}
availColors = Config.ColorPatterns
RegisterCommand('chatcolor', function(source, args, rawCommand)
	local theirList = {}
	local colorList = {}
	for k, v in pairs(availColors) do 
		-- k = Permission 
		-- v = Array of color-selections
		if IsPlayerAceAllowed(source, k) then 
			-- They have permission to use these colors:
			for colorName, colorArr in pairs(availColors[k]) do 
				table.insert(theirList, colorName);
				table.insert(colorList, colorArr);
			end
		end
	end
	if #args == 0 then 
		-- List out which ones they have access to 
		if #theirList > 0 then 
			TriggerClientEvent('chatMessage', source, prefix .. 'You have access to the following Chat-Colors:');
			for i = 1, #theirList do 
				local arr = colorList[i];
				local example = 'Example'
				local ex = '';
				local indCount = 1
				for j = 1, #example do 
					if indCount > #arr then 
						indCount = 1;
					end
					local char = example:sub(j, j);
					ex = ex .. arr[indCount] .. char;
					indCount = indCount + 1;
				end
				TriggerClientEvent('chatMessage', source, '^9[^4' .. i .. '^9] ^0' .. theirList[i] .. " ---> " .. ex);
			end
		else
			TriggerClientEvent('chatMessage', source, prefix .. '^1ERROR: You have no Chat-Colors :( - Consider donating for some :)');
		end 
	else
		local selection = args[1]
		if tonumber(selection) ~= nil then 
			local sel = tonumber(selection);
			if sel <= #theirList then 
				chatcolorTracker[source] = colorList[sel];
				TriggerClientEvent('chatMessage', source, prefix .. 'You have set your Chat-Color to ^4' .. theirList[sel]);
			else 
				-- Invalid selection 
				TriggerClientEvent('chatMessage', source, '^1ERROR: That is not a valid selection...')
			end
		else 
			-- Print it's not a number
			TriggerClientEvent('chatMessage', source, '^1ERROR: You did not put in a number...') 
		end
	end
end)
RegisterCommand('cc', function(source, args, rawCommand)
	local theirList = {}
	local colorList = {}
	for k, v in pairs(availColors) do 
		-- k = Permission 
		-- v = Array of color-selections
		if IsPlayerAceAllowed(source, k) then 
			-- They have permission to use these colors:
			for colorName, colorArr in pairs(availColors[k]) do 
				table.insert(theirList, colorName);
				table.insert(colorList, colorArr);
			end
		end
	end
	if #args == 0 then 
		-- List out which ones they have access to 
		if #theirList > 0 then 
			TriggerClientEvent('chatMessage', source, prefix .. 'You have access to the following Chat-Colors:');
			for i = 1, #theirList do 
				local arr = colorList[i];
				local example = 'Example'
				local ex = '';
				local indCount = 1
				for j = 1, #example do 
					if indCount > #arr then 
						indCount = 1;
					end
					local char = example:sub(j, j);
					ex = ex .. arr[indCount] .. char;
					indCount = indCount + 1;
				end
				TriggerClientEvent('chatMessage', source, '^9[^4' .. i .. '^9] ^0' .. theirList[i] .. " ---> " .. ex);
			end
		else
			TriggerClientEvent('chatMessage', source, prefix .. '^1ERROR: You have no Chat-Colors :( - Consider donating for some :)');
		end 
	else
		local selection = args[1]
		if tonumber(selection) ~= nil then 
			local sel = tonumber(selection);
			if sel <= #theirList then 
				chatcolorTracker[source] = colorList[sel];
				TriggerClientEvent('chatMessage', source, prefix .. 'You have set your Chat-Color to ^4' .. theirList[sel]);
			else 
				-- Invalid selection 
				TriggerClientEvent('chatMessage', source, '^1ERROR: That is not a valid selection...')
			end
		else 
			-- Print it's not a number
			TriggerClientEvent('chatMessage', source, '^1ERROR: You did not put in a number...') 
		end
	end
end)
function setContains(set, key)
    return set[key] ~= nil
end
function msg(src, mesg) 
	TriggerClientEvent('chatMessage', src, prefix .. mesg)
end
function msgRaw(src, mesg)
	TriggerClientEvent('chatMessage', src, mesg)
end
prefix = '^9[^5DiscordChatRoles^9] ^3'
RegisterCommand('chattag', function(source, args, rawCommand)
	local steamID = GetPlayerIdentifiers(source)[1];
	local accessChat = roleAccess[steamID] 
	if accessChat == nil then 
		-- Need them to say something in chat first 1 time 
		msg(source, 'Your Discord was not detected or you have not typed in chat yet...')
		return;
	end
	if #args == 0 then 
		-- Just list their chat tags
		msg(source, "You have access to the following Chat-Tags:")
		for i = 1, #accessChat do 
			msgRaw(source, '^9[^4' .. i .. '^9] ^r' .. roleList[accessChat[i]][2])
		end
		msg(source, "Use /chattag <id> to change your Chat-Tag")
	elseif #args == 1 then 
		-- Change their chat tag 
		if tonumber(args[1]) ~= nil then 
			if accessChat[tonumber(args[1])] ~= nil then
				-- Set their chatTag 
				roleTracker[steamID] = accessChat[tonumber(args[1])]
				msg(source, 'Your Chat-Tag has now been set to:^r ' .. roleList[accessChat[tonumber(args[1])]][2])
			else 
				-- Not a valid chat tag ID 
				msg(source, '^1ERROR: This is not a valid Chat-Tag id')
			end
		else 
			-- It's not a valid number 
			msg(source, '^1ERROR: This is not a number...')
		end
	else 
		-- Not correct syntax 
		msg(source, '^1ERROR: Not proper usage. /chattag <id>')
	end
end)
chatNotEnabled = {}
RegisterNetEvent('DiscordChatRoles:DisableChat')
AddEventHandler('DiscordChatRoles:DisableChat', function(src)
	chatNotEnabled[src] = true;
end)
RegisterNetEvent('DiscordChatRoles:EnableChat')
AddEventHandler('DiscordChatRoles:EnableChat', function(src)
	chatNotEnabled[src] = nil;
end)

AddEventHandler('chatMessage', function(source, name, msg)
	local args = stringsplit(msg)
	CancelEvent()
	local src = source 
	if not string.find(args[1], "/") and setContains(roleTracker, GetPlayerIdentifiers(source)[1]) and 
		not has_value(inStaffChat, GetPlayerIdentifiers(source)[1]) and not (chatNotEnabled[src] ~= nil) then 
		local roleStr = roleList[roleTracker[GetPlayerIdentifiers(source)[1]]][2]
		local colors = {'^0', '^2', '^3', '^4', '^5', '^6', '^7', '^8', '^9'}
		local staffColors = {'^1', '^8'}
		local hasColors = false
		local hasRed = false
		local roleNum = roleTracker[GetPlayerIdentifiers(source)[1]]
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
		local hasEmoji = false;
		for label, val in pairs(emojis) do 
			if string.find(msg, label) ~= nil then 
				hasEmoji = true;
				msg = msg:gsub(label, val);
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
		if hasEmoji then 
			if not has_value(allowedEmoji, tonumber(roleNum)) then 
				dontSend = true;
				TriggerClientEvent('chatMessage', source, "^7[^1DiscordChatRoles^7] ^1You cannot use emojis :(")
			end
		end
		local theirColor = chatcolorTracker[source];
		local finalMessage = msg;
		if theirColor ~= nil then 
			finalMessage = ''
			local indCount = 1;
			for j = 1, #msg do 
				if indCount > #theirColor then 
					indCount = 1;
				end
				local char = msg:sub(j, j);
				finalMessage = finalMessage .. theirColor[indCount] .. char;
				indCount = indCount + 1;
			end
		end
		if not dontSend then
			--TriggerClientEvent('chatMessage', -1, roleStr .. name .. "^7: " .. finalMessage)
			if sendBlockMessages then 
				sendMsg(roleStr .. name .. "^7: ", finalMessage, -1); 
			else 
				TriggerClientEvent('chatMessage', -1, roleStr .. name .. "^7: " .. finalMessage);
			end 
		end
	end
	if not string.find(args[1], "/") and not has_value(inStaffChat, GetPlayerIdentifiers(source)[1]) and 
		not setContains(roleTracker, GetPlayerIdentifiers(source)[1]) and not (chatNotEnabled[src] ~= nil) then
		CancelEvent()
		roleTracker[GetPlayerIdentifiers(source)[1]] = 1
		for k, v in ipairs(GetPlayerIdentifiers(src)) do
			if string.sub(v, 1, string.len("discord:")) == "discord:" then
				identifierDiscord = v
			end
		end
		local roleStr = roleList[1][2]
		local roleNum = 1
		local hasAccess = {}
		table.insert(hasAccess, roleNum)
		if identifierDiscord then
			local roleIDs = exports.Badger_Discord_API:GetDiscordRoles(src)
			-- Loop through roleList and set their role up:
			if not (roleIDs == false) then
				for i = 1, #roleList do
					for j = 1, #roleIDs do
						local roleID = roleIDs[j]
						if exports.Badger_Discord_API:CheckEqual(roleList[i][1], roleID) and i ~= 1 then
							roleStr = roleList[i][2]
							table.insert(hasAccess, i)
							roleNum = i
						end
					end
				end
				roleAccess[GetPlayerIdentifiers(source)[1]] = hasAccess;
			else
				print(GetPlayerName(src) .. " has not gotten their permissions cause roleIDs == false")
			end
		end
		roleTracker[GetPlayerIdentifiers(source)[1]] = roleNum
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
		local hasEmoji = false;
		for label, val in pairs(emojis) do 
			if string.find(msg, label) ~= nil then 
				hasEmoji = true;
				msg = msg:gsub(label, val);
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
		if hasEmoji then 
			if not has_value(allowedEmoji, tonumber(roleNum)) then 
				dontSend = true;
				TriggerClientEvent('chatMessage', source, "^7[^1DiscordChatRoles^7] ^1You cannot use emojis :(")
			end
		end
		local theirColor = chatcolorTracker[source];
		local finalMessage = msg;
		if theirColor ~= nil then 
			finalMessage = ''
			local indCount = 1;
			for j = 1, #msg do 
				if indCount > #theirColor then 
					indCount = 1;
				end
				local char = msg:sub(j, j);
				finalMessage = finalMessage .. theirColor[indCount] .. char;
				indCount = indCount + 1;
			end
		end
		if not dontSend then
			--TriggerClientEvent('chatMessage', -1, roleStr .. name .. "^7: " .. finalMessage)
			if (sendBlockMessages) then 
				sendMsg(roleStr .. name .. "^7: ", finalMessage, -1); 
			else
				TriggerClientEvent('chatMessage', -1, roleStr .. name .. "^7: " .. finalMessage);
			end 
		end
	elseif has_value(inStaffChat, GetPlayerIdentifiers(source)[1]) and not string.find(args[1], "/") and not (chatNotEnabled[src] ~= nil) then
		-- Run client event for all and check perms
		CancelEvent()
		msg = "^7[^1StaffChat^7] ^5(^1" .. name .. "^5) ^9" .. msg
		TriggerClientEvent('Permissions:CheckPermsClient', -1, msg)
		--print("It gets here 1")
	end
end)
RegisterNetEvent('Print:PrintDebug')
AddEventHandler('Print:PrintDebug', function(msg)
	print(msg)
	TriggerClientEvent('chatMessage', source, "^7[^1Badger's Scripts^7] ^1DEBUG ^7" .. msg)
end)
inStaffChat = {}
RegisterNetEvent("DiscordChatRoles:CheckPerms")
AddEventHandler("DiscordChatRoles:CheckPerms", function(msg)
	-- Check if they have permissions
	--print("It gets to start")
	local src = source
	if IsPlayerAceAllowed(src, "StaffChat.Toggle") then
		TriggerClientEvent('chatMessage', src, msg)
		--print("It gets to end")
	else
		-- Doesn't have perms
	end
end)
RegisterCommand("staffchat", function(source, args, rawCommand)
	-- Check if they can run the command
	if IsPlayerAceAllowed(source, "StaffChat.Toggle") then
		if #args == 1 then
			if args[1] == "toggle" then
				-- Turn off their staffchat and return
				TriggerClientEvent('DiscordChatRoles:StaffChat:Toggle', source)
				return
			end
		end
		if not has_value(inStaffChat, GetPlayerIdentifiers(source)[1]) then
			table.insert(inStaffChat, GetPlayerIdentifiers(source)[1])
			TriggerClientEvent('chatMessage', source, "^7[^1StaffChat^7] ^5StaffChat has been toggled ^2ON")
		else
			table.remove(inStaffChat, get_index(inStaffChat, GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('chatMessage', source, "^7[^1StaffChat^7] ^5StaffChat has been toggled ^1OFF")
		end
	end
end)

RegisterCommand("sc", function(source, args, rawCommand)
	-- Check if they can run the command
	if IsPlayerAceAllowed(source, "StaffChat.Toggle") then
		if #args == 1 then
			if args[1] == "toggle" then
				-- Turn off their staffchat and return
				TriggerClientEvent('DiscordChatRoles:StaffChat:Toggle', source)
				return
			end
		end
		if not has_value(inStaffChat, GetPlayerIdentifiers(source)[1]) then
			table.insert(inStaffChat, GetPlayerIdentifiers(source)[1])
			TriggerClientEvent('chatMessage', source, "^7[^1StaffChat^7] ^5StaffChat has been toggled ^2ON")
		else
			table.remove(inStaffChat, get_index(inStaffChat, GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('chatMessage', source, "^7[^1StaffChat^7] ^5StaffChat has been toggled ^1OFF")
		end
	end
end)

AddEventHandler("playerDropped", function()
	if has_value(inStaffChat, GetPlayerIdentifiers(source)[1]) then
		table.remove(inStaffChat, get_index(inStaffChat, GetPlayerIdentifiers(source)[1]))
	end
end)
------------------------------------
--- Discord Chat Roles by Badger ---
------------------------------------

RegisterNetEvent('Permissions:CheckPermsClient')
AddEventHandler('Permissions:CheckPermsClient', function(msg)
	if staffchatActive then
		TriggerServerEvent('DiscordChatRoles:CheckPerms', msg)
	end
end)
staffchatActive = true
RegisterNetEvent('DiscordChatRoles:StaffChat:Toggle')
AddEventHandler('DiscordChatRoles:StaffChat:Toggle', function()
	if staffchatActive then
		staffchatActive = false
		TriggerEvent('chatMessage', '', {255, 255, 255}, '^7[^1StaffChat^7] ^5StaffChat messages are now ^1DISABLED')
	else
		staffchatActive = true
		TriggerEvent('chatMessage', '', {255, 255, 255}, '^7[^1StaffChat^7] ^5StaffChat messages are now ^2ENABLED')
	end
end)
------------------------------------
--- Discord Chat Roles by Badger ---
------------------------------------

RegisterNetEvent('Permissions:CheckPermsClient')
AddEventHandler('Permissions:CheckPermsClient', function(msg)
	TriggerServerEvent('DiscordChatRoles:CheckPerms', msg)
end)
# DiscordChatRoles

## Continued Documentation
https://docs.badger.store/fivem-discord-scripts/discordchatroles

## Jared's Developer Community [Discord]
[![Developer Discord](https://discordapp.com/api/guilds/597445834153525298/widget.png?style=banner4)](https://discord.com/invite/WjB5VFz)

## Discontinued Documentation

### Version 1.0

#### Installation Information:
https://forum.fivem.net/t/discordchatroles-release/566338

This is a very simple script that uses IllusiveTea’s discord_perms for chat roles :)

Picture example taken from my RP server:

![Example](https://i.gyazo.com/c845547a9cbcd99e7716726d53abb216.png)

You must set up IllusiveTea’s discord_perms script for this to work properly:

https://forum.fivem.net/t/discord-roles-for-permissions-im-creative-i-know/233805

Example of how the chat roles are set up and what you should change:

```lua
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
{1, "^5Owner | "},
}
```

The 1s should be replaced with IDs of the respective roles in your discord server. (0 should stay for Civilian as it is the default role for all users)

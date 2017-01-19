if SERVER then
	AddCSLuaFile("actors2/convars.lua")
	AddCSLuaFile("actors2/language.lua")
	AddCSLuaFile("actors2/properties.lua")
	AddCSLuaFile("actors2/panels/welcome.lua")
	AddCSLuaFile("actors2/panels/actor_settings.lua")
end

include("actors2/convars.lua")
include("actors2/language.lua")
include("actors2/properties.lua")
include("actors2/panels/welcome.lua")
include("actors2/panels/actor_settings.lua")

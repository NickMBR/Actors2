if CLIENT then
-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Variables
-- ## ------------------------------------------------------------------------------ ## --
--local NavMesh = false

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Main HTML Panel
-- ## ------------------------------------------------------------------------------ ## --
local CheckAddonTable = {}
local WelcomeState = 0

local function OpenWelcomePanel()
	-- To avoid a bug where the base panel becomes invalid
	-- the HTML panel needs to be parented with a DFrame
	-- in case of the bug, you can still close it.
	Wlc_Base = vgui.Create( "DFrame" )
	Wlc_Base:SetSize( ScrW()/1.5, ScrH()/1.5 )
	Wlc_Base:Center()
	Wlc_Base:SetDraggable( false )
	Wlc_Base:SetSizable( false )
	Wlc_Base:SetTitle( "" )
	Wlc_Base:InvalidateLayout()

	-- Creates the HTML Panel parented to the Base DPanel
	Wlc = vgui.Create( "DHTML", Wlc_Base )
	Wlc:Dock( FILL )
	Wlc:SetAllowLua( true )
	Wlc:OpenURL( "asset://garrysmod/html/welcome.html" )

	--[[Wlc:AddFunction( "console", "luaprint", function( str )
		print( str )
	end )]]--

	if Wlc_Base:IsValid() then
		Wlc:QueueJavascript( "receiveLang( '" .. A2LANG .. "' )" )
		Wlc:QueueJavascript( "getWelcomeState( " .. WelcomeState .. " )" )
	end

	Wlc_Base:MakePopup()
end

function SendAddonCheckings()
	if next( CheckAddonTable ) == nil then
		Wlc:QueueJavascript( "checkAddon( 'true' )" )
	elseif CheckAddonTable.AC2Nav then
		Wlc:QueueJavascript( "checkAddon( 'false' )" )
		Wlc:QueueJavascript( "getCheckAddonReason( '" .. CheckAddonTable.AC2Nav .. "' )" )
	elseif CheckAddonTable.AC2Version then
		Wlc:QueueJavascript( "checkAddon( 'false' )" )
		Wlc:QueueJavascript( "getCheckAddonReason( '" .. CheckAddonTable.AC2Version .. "' )" )
	end
	Wlc:QueueJavascript( "showCheckResults()" )
end

net.Receive( "Ac2_FetchVersion", function()
	CheckAddonTable = net.ReadTable()
	SendAddonCheckings()
end )

net.Receive( "Ac2_OpenWelcomePanel", function()
	WelcomeState = net.ReadDouble()
	OpenWelcomePanel()
end )


-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Functions called from the JS environment
-- ## ------------------------------------------------------------------------------ ## --
function CloseWelcomePanel()
	if Wlc_Base:IsValid() then
		Wlc_Base:Remove()
	end
end

function CloseandDontShowAgain()
	RunConsoleCommand( "actors2_pathmaker_ac2_welcome", 0 )
end

end -- Client
if CLIENT then
-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Variables
-- ## ------------------------------------------------------------------------------ ## --
--local NavMesh = false

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Main HTML Panel
-- ## ------------------------------------------------------------------------------ ## --
local CheckAddonTable = {}
local NavString = ""

function OpenWelcomePanel()
	-- To avoid a bug where the base panel becomes invalid
	-- the HTML panel needs to be parented with a DFrame
	-- in case of the bug, you can still close it.
	Base = vgui.Create( "DFrame" )
	Base:SetSize( ScrW()/1.5, ScrH()/1.5 )
	Base:Center()
	Base:SetDraggable( false )
	Base:SetSizable( false )
	Base:SetTitle( "" )
	--Base:InvalidateLayout()

	-- Creates the HTML Panel parented to the Base DPanel
	if Base:IsValid() then
		Wlc = vgui.Create( "DHTML", Base )
		Wlc:Dock( FILL )
		Wlc:SetAllowLua( true )
		Wlc:OpenURL( "asset://garrysmod/html/welcome.html" )

		--[[Wlc:AddFunction( "console", "luaprint", function( str )
			print( str )
		end )]]--

		Wlc:QueueJavascript( "receiveLang( '" .. A2LANG .. "' )" )

		if next( CheckAddonTable ) == nil then
			Wlc:QueueJavascript( "checkAddon( 'true' )" )
		elseif CheckAddonTable.AC2Nav then
			Wlc:QueueJavascript( "checkAddon( 'false' )" )
			Wlc:QueueJavascript( "getCheckAddonReason( '" .. CheckAddonTable.AC2Nav .. "' )" )
		elseif CheckAddonTable.AC2Version then
			Wlc:QueueJavascript( "checkAddon( 'false' )" )
			Wlc:QueueJavascript( "getCheckAddonReason( '" .. CheckAddonTable.AC2Version .. "' )" )
		end
	end

	Base:MakePopup()
end

net.Receive( "Ac2_OpenWelcomePanel", function()
	CheckAddonTable = net.ReadTable()
	OpenWelcomePanel()
end )


-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Functions called from the JS environment
-- ## ------------------------------------------------------------------------------ ## --
function CloseWelcomePanel()
	if Base:IsValid() then
		Base:Remove()
	elseif Wlc:IsValid() then
		Wlc:Remove()
	end
end

end -- Client
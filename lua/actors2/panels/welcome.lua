if CLIENT then
-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Variables
-- ## ------------------------------------------------------------------------------ ## --
--local NavMesh = false

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Main HTML Panel
-- ## ------------------------------------------------------------------------------ ## --
local NavMesh = false

function OpenWelcomePanel()
	--[[Base = vgui.Create( "DFrame" )
	Base:SetSize( ScrW()/1.5, ScrH()/1.5 )
	Base:Center()
	Base:SetTitle( AC2_LANG[A2LANG]["ac2_tool_category"] )
	Base:SetVisible( true )
	Base:SetDraggable( false )
	Base:SetSizable( false )
	Base:ShowCloseButton( false )]]--

	Wlc = vgui.Create( "DHTML" )
	Wlc:SetSize( ScrW()/1.5, ScrH()/1.5 )
	Wlc:Center()
	Wlc:SetAllowLua( true )
	Wlc:OpenURL( "asset://garrysmod/html/welcome.html" )
	Wlc:MakePopup()

	--[[Wlc:AddFunction( "console", "luaprint", function( str )
		Msg( str )
	end )]]--

	-- Sends the Language to translate the HTML page
	if IsValid( Wlc ) then
		Wlc:QueueJavascript( "receiveLang( '" .. A2LANG .. "' )" )
		Wlc:QueueJavascript( "checkNavMesh( '" .. tostring(NavMesh) .. "' )" )
	end
end

net.Receive( "Ac2_OpenWelcomePanel", function()
	NavMesh = net.ReadBool()
	OpenWelcomePanel()
end )


-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Functions called from the JS environment
-- ## ------------------------------------------------------------------------------ ## --
function CloseWelcomePanel()
	if IsValid( Wlc ) then
		Wlc:Remove()
	end
end

end -- Client
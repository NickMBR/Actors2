if CLIENT then
-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Main HTML Panel
-- ## ------------------------------------------------------------------------------ ## --
local Wlc = vgui.Create( "DHTML" )
Wlc:SetSize( ScrW()/1.5, ScrH()/1.5 )
Wlc:Center()
Wlc:SetKeyboardInputEnabled( true )
Wlc:SetMouseInputEnabled( true )
Wlc:SetAllowLua( true )
Wlc:OpenURL( "asset://garrysmod/html/welcome.html" )
Wlc:MakePopup()

-- Sends the Language to translate the HTML page
if IsValid( Wlc ) then
	Wlc:QueueJavascript( "receiveLang( '" .. A2LANG .. "' )" )
	-- This is serverside, network, workaround?
	--Wlc:QueueJavascript( "checkNavMesh( " .. navmesh.IsLoaded() .. " )" )

	timer.Simple(3, function() 
		Wlc:Remove() 
	end)
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Functions called from the JS environment
-- ## ------------------------------------------------------------------------------ ## --
function CloseWelcomePanel()
	if IsValid( Wlc ) then
		Wlc:Remove() 
	end
end

end -- Client
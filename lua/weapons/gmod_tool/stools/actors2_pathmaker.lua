/*

Actors2
Author: NickMBR

Connect:
Website: nickmbr.github.io -tbd
GitHub: https://github.com/NickMBR
Facebook: http://fb.com/NickMBR1
Youtube: http://youtube.com/NickMBR

Coffee Cups: 1
GM Crashes: 0

*/

// -- Tool Language and Translation -------------------------------------------------- //
if ( CLIENT ) then
	TOOL.Category	= AC2_LANG[A2LANG]["ac2_tool_category"]
	TOOL.Name		= AC2_LANG[A2LANG]["ac2_tool_pathmaker"]
	TOOL.Command	= nil
	TOOL.ConfigName	= ""
	
	TOOL.Information = {
		{ name = "info" },
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}
	
	-- Tool Keys
	language.Add("tool.actors2_pathmaker.left", AC2_LANG[A2LANG]["ac2_tool_pm_leftclick"])
	language.Add("tool.actors2_pathmaker.right", AC2_LANG[A2LANG]["ac2_tool_pm_rightclick"])
	language.Add("tool.actors2_pathmaker.reload", AC2_LANG[A2LANG]["ac2_tool_pm_reload"])
	
	-- Tool Descriptions
	language.Add("tool.actors2_pathmaker.name", AC2_LANG[A2LANG]["ac2_tool_category"])
	language.Add("tool.actors2_pathmaker.desc", AC2_LANG[A2LANG]["ac2_tool_pm_desc"])
	language.Add("tool.actors2_pathmaker.0", AC2_LANG[A2LANG]["ac2_tool_pm_info"])
end

// -- Functions ---------------------------------------------------------------------- //
if SERVER then
	function CreatePathPoint( ply, pos )
		pathptn = ents.Create( "ac2_pathpoint" )
		if ( !IsValid( pathptn ) ) then return false end

		pathptn:SetPlayer( ply )
		pathptn:SetPos( pos )
		pathptn:Spawn()
	end
end

function TOOL:LeftClick( trace )
	if ( !trace.HitPos ) 			then return false end
	if ( trace.Entity:IsPlayer() ) 	then return false end
	if ( CLIENT ) 					then return true end
	
	local ply = self:GetOwner()
	local PathPoint = CreatePathPoint( ply, trace.HitPos )
	
	-- Creates the Undo Entry for the SP
	undo.Create("RMVPathPoint")
		undo.AddEntity(pathptn)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText(AC2_LANG[A2LANG]["ac2_tool_pm_remove_pathptn"])
	undo.Finish("RMVPathPoint")

	return true
end

function TOOL:RightClick( trace )

end

function TOOL:Reload( trace )

end
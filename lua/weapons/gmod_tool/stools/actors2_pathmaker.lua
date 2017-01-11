-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Author: NickMBR

	-- Connect:
		--	Website: nickmbr.github.io -tbd
		--	GitHub: https://github.com/NickMBR
		--	Facebook: http://fb.com/NickMBR1
		--	Youtube: http://youtube.com/NickMBR

	--	Coffee Cups: 1
	--	GM Crashes: 0
-- ## ------------------------------------------------------------------------------ ## --

local Actors2TBL = {}
local PathPointsTBL = {}

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Tool Keys, Language, Translation
-- ## ------------------------------------------------------------------------------ ## --
if ( CLIENT ) then
	TOOL.Category	= AC2_LANG[A2LANG]["ac2_tool_category"]
	TOOL.Name		= AC2_LANG[A2LANG]["ac2_tool_pathmaker"]
	TOOL.Command	= nil
	TOOL.ConfigName	= ""
	
	TOOL.Information = {
		"info",
		"left",
		"right",
		{ 
		name  = "shift_reload",
		icon2  = "gui/e.png",
		icon = "gui/r.png",
		},
		"reload",
	}
	
	-- Tool Keys
	language.Add("tool.actors2_pathmaker.left", AC2_LANG[A2LANG]["ac2_tool_pm_leftclick"])
	language.Add("tool.actors2_pathmaker.right", AC2_LANG[A2LANG]["ac2_tool_pm_rightclick"])
	language.Add("tool.actors2_pathmaker.shift_reload", AC2_LANG[A2LANG]["ac2_tool_pm_shiftreload"])
	language.Add("tool.actors2_pathmaker.reload", AC2_LANG[A2LANG]["ac2_tool_pm_reload"])
	
	-- Tool Descriptions
	language.Add("tool.actors2_pathmaker.name", AC2_LANG[A2LANG]["ac2_tool_category"])
	language.Add("tool.actors2_pathmaker.desc", AC2_LANG[A2LANG]["ac2_tool_pm_desc"])
	language.Add("tool.actors2_pathmaker.0", AC2_LANG[A2LANG]["ac2_tool_pm_info"])
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Path Point Creator
	-- 1. Sets PathPointTBL with unique entity index
	-- 2. Networks the table to be used by clientside functions
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:LeftClick( trace )
	if not trace.HitPos then return false end
	if trace.Entity:IsPlayer() then return false end
	if CLIENT then return true end
	
	local ply = self:GetOwner()
	local PathPoint = CreatePathPoint( ply, trace.HitPos )

	BuildActorTable(ply, pathpnt)
	
	-- Creates the Undo Entry for the Path Point
	undo.Create("RMVPathPoint")
		undo.AddEntity(pathpnt)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText(AC2_LANG[A2LANG]["ac2_tool_pm_remove_pathpnt"])
		undo.AddFunction( function()
			RemoveFromPathPointsTable( ply )
		end)
	undo.Finish("RMVPathPoint")

	return true
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Path Point Remover
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:RightClick( trace )

end

function TOOL:Reload( trace )

end

function TOOL:Think()

end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Functions
-- ## ------------------------------------------------------------------------------ ## --
local function CheckForPlayer( ply )
	local rtn = {}
	if next(Actors2TBL) then
		for k,v in pairs ( Actors2TBL ) do
			for ke,va in SortedPairs ( v ) do
				if ke == ply:SteamID() then
					rtn = {k, ke, v, va}
					return rtn
				end
			end
		end
	end
	return nil
end

local function PopulateActorTable( ply )
	local TempTable = 
	{
		[ply:SteamID()] =
		{
			PathPoints = {}
		}
	}
	table.insert(Actors2TBL, TempTable)
end

local function PopulatePathPointsTable( ply, ent )
	local TempTBL = CheckForPlayer( ply )
	local TempPathTBL = Actors2TBL[TempTBL[1]][TempTBL[2]].PathPoints
	if TempTBL then
		table.insert(TempPathTBL, ent:EntIndex())
		net.Start( "DrawPathPointLine" )
			net.WriteTable( TempPathTBL )
		net.Send( ply )
	end
end

function BuildActorTable( ply, ent )
	if next(Actors2TBL) == nil then
		PopulateActorTable( ply )
		PopulatePathPointsTable( ply, ent )
	else
		PopulatePathPointsTable( ply, ent )
	end
end

function RemoveFromPathPointsTable( ply )
	local TempTBL = CheckForPlayer( ply )
	local TBLKeyToRemove = Actors2TBL[TempTBL[1]][TempTBL[2]].PathPoints
	TBLKeyToRemove[#TBLKeyToRemove] = nil
	
	net.Start( "DrawPathPointLine" )
		net.WriteTable( TBLKeyToRemove )
	net.Send( ply )
end

if CLIENT then

end

if SERVER then
	util.AddNetworkString( "DrawPathPointLine" )

	function CreatePathPoint( ply, pos )
		pathpnt = ents.Create( "ac2_pathpoint" )
		if not IsValid( pathpnt ) then return false end

		pathpnt:SetPlayer( ply )
		pathpnt:SetPos( pos )
		pathpnt:Spawn()
	end
end
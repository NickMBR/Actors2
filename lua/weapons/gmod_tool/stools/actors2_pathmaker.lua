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
	-- Resources
-- ## ------------------------------------------------------------------------------ ## --
resource.AddFile( "buttons/button15.wav" )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Hooks
-- ## ------------------------------------------------------------------------------ ## --
if SERVER then
	local function ClearTablesWhenSVCleanUP()
		Actors2TBL = {}
		PathPointsTBL = {}
	end
	hook.Add( "PostCleanupMap", "AC2PostCleanupMap", ClearTablesWhenSVCleanUP )
end

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

	-- Custom Lang Strings
	language.Add("ac2_notify_removed_pathptn", "["..AC2_LANG[A2LANG]["ac2_tool_category"].."] "..AC2_LANG[A2LANG]["ac2_tool_pm_remove_pathpnt"])

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

	return true
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Path Point Remover
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:RightClick( trace )
	if not trace.HitPos then return false end
	if trace.Entity:IsPlayer() then return false end
	if CLIENT then return true end

	PrintTable(Actors2TBL)
	local ply = self:GetOwner()
	RemovePathPoint( ply )
	return false
end

function TOOL:Reload( trace )

end

function TOOL:Think()

end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Table Management Functions
-- ## ------------------------------------------------------------------------------ ## --
local function IsEmptyTable( t )
	return next( t ) == nil
end

local function CheckForPlayer( ply )
	local rtn = {}
	if not IsEmptyTable(Actors2TBL) then
		for k,v in pairs ( Actors2TBL ) do
			for ke,va in SortedPairs ( v ) do
				if ke == ply:SteamID() then
					rtn = {k, ke, v, va}
					return rtn
				end
			end
		end
	end
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

local function GetPathPointsTBL( ply )
	local TempTBL = CheckForPlayer( ply )
	if TempTBL then
		local TempPathTBL = Actors2TBL[TempTBL[1]][TempTBL[2]].PathPoints
		return TempPathTBL
	end
end

local function PopulatePathPointsTable( ply, ent )
	local TempPTBL = GetPathPointsTBL( ply )
	if TempPTBL then
		table.insert(TempPTBL, ent:EntIndex())
		net.Start( "DrawPathPointLine" )
			net.WriteTable( TempPTBL )
		net.Send( ply )
	end
end

local function RemoveFromPathPointsTable( ply )
	local TBLKeyToRemove = GetPathPointsTBL( ply )
	if TBLKeyToRemove then 
		TBLKeyToRemove[#TBLKeyToRemove] = nil
		net.Start( "DrawPathPointLine" )
			net.WriteTable( TBLKeyToRemove )
		net.Send( ply )
	end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- TOOL Click Functions
	-- 1. Order Matters!
-- ## ------------------------------------------------------------------------------ ## --
function BuildActorTable( ply, ent )
	if IsEmptyTable(Actors2TBL) then
		PopulateActorTable( ply )
		PopulatePathPointsTable( ply, ent )
	else
		PopulatePathPointsTable( ply, ent )
	end
end

function RemovePathPoint( ply )
	local PathTBL = GetPathPointsTBL( ply )
	if PathTBL and PathTBL[#PathTBL] != nil then
		local LastEnt = ents.GetByIndex( PathTBL[#PathTBL] )
		LastEnt:Remove()
		RemoveFromPathPointsTable( ply )
		ply:ChatPrint( "#ac2_notify_removed_pathptn" )
		if CLIENT then ply:EmitSound( "buttons/button15.wav" ) end
	end
end

if CLIENT then

end

if SERVER then
	util.AddNetworkString( "DrawPathPointLine" )

	function CreatePathPoint( ply, pos )
		pathpnt = ents.Create( "ac2_pathpoint" )
		if not IsValid( pathpnt ) then return end
		
		pathpnt:SetPlayer( ply )
		pathpnt:SetPos( pos )
		pathpnt:Spawn()
	end
end

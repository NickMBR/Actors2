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

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Persisting Client Variables
-- ## ------------------------------------------------------------------------------ ## --
TOOL.ClientConVar =
{
	-- Selection
	[ "ac2_pathselector" ] = 1,
}

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Variables
-- ## ------------------------------------------------------------------------------ ## --
local Actors2TBL = {}
local PathPointsTBL = {}
local PathSelector = GetConVar("actors2_pathmaker_ac2_pathselector"):GetInt()

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
		RunConsoleCommand( "actors2_pathmaker_ac2_pathselector", 1)
		PathSelector = 1
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
	language.Add("tool.actors2_pathmaker.reload", AC2_LANG[A2LANG]["ac2_tool_pm_reload"])
	language.Add("tool.actors2_pathmaker.shift_reload", AC2_LANG[A2LANG]["ac2_tool_pm_shiftreload"])
	
	-- Tool Descriptions
	language.Add("tool.actors2_pathmaker.name", AC2_LANG[A2LANG]["ac2_tool_category"])
	language.Add("tool.actors2_pathmaker.desc", AC2_LANG[A2LANG]["ac2_tool_pm_desc"])
	language.Add("tool.actors2_pathmaker.0", AC2_LANG[A2LANG]["ac2_tool_pm_info"])

	-- Custom Lang Strings
	language.Add("ac2_notify_removed_pathptn", AC2_LANG[A2LANG]["ac2_tool_pm_remove_pathpnt"])
	language.Add("ac2_notify_sel_nopath", AC2_LANG[A2LANG]["ac2_tool_pm_sel_nopatht"])

end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Deploy
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:Deploy()
	
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Path Point Creator
	-- 1. Sets PathPointTBL with unique entity index
	-- 2. Networks the table to be used by clientside functions
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:LeftClick( trace )
	if not trace.HitPos then return false end
	if trace.Entity:IsPlayer() then return false end
	if trace.Entity:GetClass() == "ac2_pathpoint" then return false end
	if CLIENT then return true end
	
	local ply = self:GetOwner()
	local PathPoint = CreatePathPoint( ply, trace.HitPos )

	BuildActorTable(ply, pathpnt)
	PrintTable(Actors2TBL)

	return true
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Path Point Remover
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:RightClick( trace )
	--if not trace.HitPos then return false end
	--if trace.Entity:IsPlayer() then return false end
	if CLIENT then return true end

	local ply = self:GetOwner()

	if trace.Entity:GetClass() == "ac2_pathpoint" then
		RemoveAimedPathPoint( ply, trace.Entity)
	else
		RemovePathPoint( ply )
	end
	
	return false
end

function TOOL:Reload( trace )
	if CLIENT then return true end
	local ply = self:GetOwner()

	-- Path Selector
	if ( ply:KeyDown( IN_USE ) or ply:KeyDown( IN_SPEED ) ) then
		if next(Actors2TBL) != nil then
			local AC2 = CheckForPlayer( ply )
			if #Actors2TBL[AC2[1]][AC2[2]].PathPoints <= 1 then
				SendNotifyClient( ply, "#ac2_notify_sel_nopath", 1, "buttons/button16.wav" )
			else
				-- Select new path
			end
		end
	else
		-- Add new Path
		if next(Actors2TBL) != nil then
			local AC2T = CheckForPlayer( ply )
			if Actors2TBL[AC2T[1]][AC2T[2]].PathPoints[PathSelector+1] == nil then
				PathSelector = PathSelector + 1
				Actors2TBL[AC2T[1]][AC2T[2]].PathPoints[PathSelector] = {}
				RunConsoleCommand( "actors2_pathmaker_ac2_pathselector", PathSelector)
				SendNotifyClient( ply, "Added New Path", 3, "buttons/button17.wav" )
			end
		end
	end

	return false
end

function TOOL:Think()
	PathSelector = GetConVar("actors2_pathmaker_ac2_pathselector"):GetInt()
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Table Management Functions
-- ## ------------------------------------------------------------------------------ ## --
local function IsEmptyTable( t )
	return next( t ) == nil
end

function CheckForPlayer( ply )
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
			PathPoints = 
			{
				[PathSelector] = {}
			}
		}
	}
	table.insert(Actors2TBL, TempTable)
end

local function GetPathPointsTBL( ply )
	local TempTBL = CheckForPlayer( ply )
	if TempTBL then
		local TempPathTBL = Actors2TBL[TempTBL[1]][TempTBL[2]].PathPoints[PathSelector]
		return TempPathTBL
	end
end

local function SendNewPathPointTable( ply, t )
	net.Start( "DrawPathPointLine" )
		net.WriteTable( t )
		net.WriteDouble( PathSelector)
	net.Send( ply )
end

local function PopulatePathPointsTable( ply, ent )
	local TempPTBL = GetPathPointsTBL( ply )
	if TempPTBL then
		table.insert(TempPTBL, ent:EntIndex())
		SendNewPathPointTable( ply, TempPTBL )
	end
end

local function RemoveFromPathPointsTable( ply )
	local TBLKeyToRemove = GetPathPointsTBL( ply )
	if TBLKeyToRemove then 
		TBLKeyToRemove[#TBLKeyToRemove] = nil
		SendNewPathPointTable( ply, TBLKeyToRemove )
	end
end

function SendNotifyClient( ply, msg, type, snd )
	net.Start( "NotifyPathPointRMV" )
		net.WriteString( msg )
		net.WriteDouble( type)
		net.WriteString( snd )
	net.Send( ply )
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
		SendNotifyClient( ply, "#ac2_notify_removed_pathptn", 2, "buttons/button15.wav" )
	end
end

function RemoveAimedPathPoint( ply, ent )
	local PathTBL = GetPathPointsTBL( ply )
	if PathTBL and PathTBL[#PathTBL] != nil then
		for k,v in pairs ( PathTBL ) do
			if v == ent:EntIndex() then
				table.remove(PathTBL, k)
				ent:Remove()
				SendNewPathPointTable( ply, PathTBL )
				SendNotifyClient( ply, "#ac2_notify_removed_pathptn", 2, "buttons/button15.wav" )
			end
		end
	end
end

if CLIENT then
	local function NotifyHint( msg, type, snd )
		notification.AddLegacy( msg, type, 2 )
		surface.PlaySound( snd )
	end
	net.Receive( "NotifyPathPointRMV", function()
		local msg = net.ReadString()
		local type = net.ReadDouble()
		local snd = net.ReadString()
		NotifyHint( msg, type, snd )
	end )
end

if SERVER then
	util.AddNetworkString( "DrawPathPointLine" )
	util.AddNetworkString( "NotifyPathPointRMV" )

	function CreatePathPoint( ply, pos )
		pathpnt = ents.Create( "ac2_pathpoint" )
		if not IsValid( pathpnt ) then return end
		
		pathpnt:SetPlayer( ply )
		pathpnt:SetPos( pos )
		pathpnt:Spawn()
	end
end

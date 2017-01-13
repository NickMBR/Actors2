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
local PathSelector = 1
local PathCount = 1
local degrees = 0

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Resources
-- ## ------------------------------------------------------------------------------ ## --

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Hooks
-- ## ------------------------------------------------------------------------------ ## --
if SERVER then
	local function ClearTablesWhenSVCleanUP()
		Actors2TBL = {}
		PathPointsTBL = {}
		RunConsoleCommand( "actors2_pathmaker_ac2_pathselector", 1)
		PathSelector = 1
		PathCount = 1
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
		{ name = "left", stage = 0 },
		{ name = "left_1", stage = 1 },
		{ name = "right", stage = 0 },
		{ name = "reload", stage = 0 },
		{ name  = "shift_left", icon2  = "gui/e.png", icon = "gui/lmb.png", stage = 0 },
		{ name  = "shift_left_1", icon2  = "gui/e.png", icon = "gui/lmb.png", stage = 1 },
		{ name  = "shift_reload", stage = 0, icon2  = "gui/e.png", icon = "gui/r.png" },
		{ name = "info", stage = 0 },
		{ name = "info_1", stage = 1 }
	}
	
	-- Tool Keys
	language.Add("tool.actors2_pathmaker.left", AC2_LANG[A2LANG]["ac2_tool_pm_leftclick"])
	language.Add("tool.actors2_pathmaker.right", AC2_LANG[A2LANG]["ac2_tool_pm_rightclick"])
	language.Add("tool.actors2_pathmaker.reload", AC2_LANG[A2LANG]["ac2_tool_pm_reload"])
	language.Add("tool.actors2_pathmaker.shift_left", AC2_LANG[A2LANG]["ac2_tool_pm_shiftleft"])
	language.Add("tool.actors2_pathmaker.shift_reload", AC2_LANG[A2LANG]["ac2_tool_pm_shiftreload"])
	
	-- Tool Descriptions
	language.Add("tool.actors2_pathmaker.name", AC2_LANG[A2LANG]["ac2_tool_category"])
	language.Add("tool.actors2_pathmaker.desc", AC2_LANG[A2LANG]["ac2_tool_pm_desc"])
	language.Add("tool.actors2_pathmaker.0", AC2_LANG[A2LANG]["ac2_tool_pm_info"])

	-- Stage 1 of the tool, used when rotating
	language.Add("tool.actors2_pathmaker.left_1", AC2_LANG[A2LANG]["ac2_tool_pm_leftclick1"])
	language.Add("tool.actors2_pathmaker.shift_left_1", AC2_LANG[A2LANG]["ac2_tool_pm_shiftleft1"])
	language.Add("tool.actors2_pathmaker.1", AC2_LANG[A2LANG]["ac2_tool_pm_rotation"])

	-- Cache strings for serverside usage
	language.Add("ac2_notify_removed_pathptn", AC2_LANG[A2LANG]["ac2_tool_pm_remove_pathpnt"])
	language.Add("ac2_notify_sel_nopath", AC2_LANG[A2LANG]["ac2_tool_pm_sel_nopatht"])
	language.Add("ac2_notify_sel_newpath", AC2_LANG[A2LANG]["ac2_tool_pm_sel_newpath"])
	language.Add("ac2_notify_no_navmesh", AC2_LANG[A2LANG]["ac2_tool_pm_no_navmesh"])
	language.Add("ac2_notify_sel_nonewpath", AC2_LANG[A2LANG]["ac2_tool_pm_sel_newnopath"])

end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Deploy
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:Deploy()
	local ply = self:GetOwner()

	-- If there's no nav mesh, notify the client
	if not navmesh.IsLoaded() then
		SendNotifyClient( ply, "#ac2_notify_no_navmesh", 1, "buttons/button10.wav", 7 )
	end
end

function TOOL:Holster()
	self:ClearObjects()
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
	local numobj = self:NumObjects()
	degrees = 0

	if ply:KeyDown( IN_USE ) or ply:KeyDown( IN_SPEED ) then
		if trace.HitWorld then return false end
		if trace.Entity:GetClass() == "ac2_pathpoint" then
			if SERVER and not util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) then return false end

			if numobj == 0 then
				if CLIENT then return true end
				SendNotifyClient( ply, "#tool.actors2_pathmaker.1", 0, "buttons/button17.wav", 4 )
				local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
				if IsValid( Phys ) then
					Phys:EnableMotion( false )
				end
				self:SetObject( 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
				self:SetStage( 1 )
			else
				self:ClearObjects()
			end

		end
	elseif self:NumObjects() > 0 and IsValid( self:GetEnt(1) ) then
		self:ClearObjects()
	else
		if trace.Entity:GetClass() == "ac2_pathpoint" then return false end
		local PathPoint = CreatePathPoint( ply, trace.HitPos )
		BuildActorTable( ply, pathpnt )
		PathSelector = GetConVar( "actors2_pathmaker_ac2_pathselector" ):GetInt()
	end

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

	-- Automatic selector when a path is completely removed
	local AC2TP = CheckForPlayer( ply )
	if PathSelector > 1 and next(Actors2TBL[AC2TP[1]][AC2TP[2]].PathPoints[PathCount]) == nil then
		table.remove( Actors2TBL[AC2TP[1]][AC2TP[2]].PathPoints, PathCount )
		PathSelector = PathSelector - 1
		RunConsoleCommand( "actors2_pathmaker_ac2_pathselector", PathSelector)
		PathCount = PathSelector
		SendNewPathPointTable( ply )
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
				SendNotifyClient( ply, "#ac2_notify_sel_nopath", 1, "buttons/button16.wav", 2 )
			else
				if PathCount > 1 then PathCount = PathCount - 1 else PathCount = PathSelector end
				SendNewPathPointTable( ply )
			end
		end
	else
		-- Add new Path
		if next(Actors2TBL) != nil then
			local AC2T = CheckForPlayer( ply )
			if next(Actors2TBL[AC2T[1]][AC2T[2]].PathPoints[PathSelector]) and Actors2TBL[AC2T[1]][AC2T[2]].PathPoints[PathSelector+1] == nil then
				PathSelector = PathSelector + 1
				Actors2TBL[AC2T[1]][AC2T[2]].PathPoints[PathSelector] = {}
				RunConsoleCommand( "actors2_pathmaker_ac2_pathselector", PathSelector)
				SendNotifyClient( ply, "#ac2_notify_sel_newpath", 0, "buttons/button17.wav", 2 )
				PathCount = PathSelector
				SendNewPathPointTable( ply )
			else
				SendNotifyClient( ply, "#ac2_notify_sel_nonewpath", 1, "buttons/button16.wav", 4 )
			end
		end
	end

	return false
end

function TOOL:Think()
	-- Rotate the Selected Path Point
	if self:NumObjects() > 0 then
		if SERVER then
			local Phys2 = self:GetPhys(1)
			local Norm2 = Vector( 0, 0, 1 ) -- Forces Z axis
			local cmd = self:GetOwner():GetCurrentCommand()
			degrees = degrees + cmd:GetMouseX() * 0.05
			local ra = degrees
			if self:GetOwner():KeyDown(IN_SPEED) then ra = math.Round(ra/45)*45 end
			local Ang = Norm2:Angle()
			Ang.pitch = Ang.pitch + 90
			Ang:RotateAroundAxis(Norm2, ra)
			Phys2:SetAngles( Ang )
			Phys2:Wake()
		end
	end

	if SERVER then
		if self:GetOwner():IsInWorld() and next(Actors2TBL) then
			SendNewPathPointTable( self:GetOwner() )
		end
	end
end

-- Custom Tool Screen Interface
function TOOL:DrawToolScreen( width, height )
	surface.SetDrawColor( Color( 30, 30, 30 ) )
	surface.DrawRect( 0, 0, width, height )
	draw.SimpleText( "Actors2", "DermaLarge", width / 2, (height / 2)-30, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
				[PathCount] = {}
			}
		}
	}
	table.insert(Actors2TBL, TempTable)
end

local function GetPathPointsTBL( ply )
	local TempTBL = CheckForPlayer( ply )
	if TempTBL then
		local TempPathTBL = Actors2TBL[TempTBL[1]][TempTBL[2]].PathPoints[PathCount]
		return TempPathTBL
	end
end

function SendNewPathPointTable( ply )
	local TempTBL = CheckForPlayer( ply )

	net.Start( "DrawPathPointLine" )
		net.WriteTable( Actors2TBL[TempTBL[1]][TempTBL[2]].PathPoints )
		net.WriteDouble( PathCount )
	net.Send( ply )
end

local function PopulatePathPointsTable( ply, ent )
	local TempPTBL = GetPathPointsTBL( ply )
	if TempPTBL then
		table.insert(TempPTBL, ent:EntIndex())
		SendNewPathPointTable( ply )
	end
end

local function RemoveFromPathPointsTable( ply )
	local TBLKeyToRemove = GetPathPointsTBL( ply )
	if TBLKeyToRemove then 
		TBLKeyToRemove[#TBLKeyToRemove] = nil
		SendNewPathPointTable( ply )
	end
end

function SendNotifyClient( ply, msg, type, snd, dur )
	net.Start( "NotifyPathPointRMV" )
		net.WriteString( msg )
		net.WriteDouble( type)
		net.WriteString( snd )
		net.WriteDouble( dur )
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
		SendNotifyClient( ply, "#ac2_notify_removed_pathptn", 2, "buttons/button15.wav", 2 )
	end
end

function RemoveAimedPathPoint( ply, ent )
	local PathTBL = GetPathPointsTBL( ply )
	if PathTBL and PathTBL[#PathTBL] != nil then
		for k,v in pairs ( PathTBL ) do
			if v == ent:EntIndex() then
				table.remove(PathTBL, k )
				ent:Remove()
				SendNewPathPointTable( ply )
				SendNotifyClient( ply, "#ac2_notify_removed_pathptn", 2, "buttons/button15.wav", 2 )
			end
		end
	end
end

if CLIENT then
	local function NotifyHint( msg, type, snd, dur )
		notification.AddLegacy( msg, type, dur )
		surface.PlaySound( snd )
	end
	net.Receive( "NotifyPathPointRMV", function()
		local msg = net.ReadString()
		local type = net.ReadDouble()
		local snd = net.ReadString()
		local dur = net.ReadDouble()
		NotifyHint( msg, type, snd, dur )
	end )

	function TOOL:FreezeMovement()
		return self:GetStage() == 1
	end
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

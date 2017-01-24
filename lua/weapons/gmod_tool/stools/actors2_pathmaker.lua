-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Author: NickMBR

	-- Connect:
		--	Website: nickmbr.github.io -tbd
		--	GitHub: https://github.com/NickMBR
		--	Facebook: http://fb.com/NickMBR1
		--	Youtube: http://youtube.com/NickMBR
-- ## ------------------------------------------------------------------------------ ## --

TOOL.Category	= AC2_LANG[A2LANG]["ac2_tool_category"]
TOOL.Name		= AC2_LANG[A2LANG]["ac2_tool_pathmaker"]
TOOL.Command	= nil
TOOL.ConfigName	= ""

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Persisting Client Variables
-- ## ------------------------------------------------------------------------------ ## --
TOOL.ClientConVar =
{
	-- Actors2
	[ "ac2_welcome" ] = 1,
	[ "ac2_lang" ] = A2LANG,

	-- Selection
	[ "ac2_pathselector" ] = 1,

	-- Spawn/Remove Keys
	[ "ac2_spawn" ]	= "52",
	[ "ac2_despawn" ]	= "51",
}

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Variables
-- ## ------------------------------------------------------------------------------ ## --
local Actors2TBL = {}
local PathPointsTBL = {}
local PathSelector = 1
local PathCount = 1
local degrees = 0
local AC2_Version = "104"
local CheckActors2Addon = {}
local WlcState = 0

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Resources
-- ## ------------------------------------------------------------------------------ ## --
if CLIENT then
	surface.CreateFont("Actors2F_50", {
		font = "Trebuchet24",
		size = 50,
	})
end

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
	language.Add("tool.actors2_pathmaker.name", AC2_LANG[A2LANG]["ac2_tool_category"].." - "..AC2_LANG[A2LANG]["ac2_tool_pathmaker"])
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

function TOOL:CheckAddonTest()
	local ply = self:GetOwner()

	local function AC2GitCheck( contents, size )
		if not navmesh.IsLoaded() then
			CheckActors2Addon.AC2Nav = AC2_LANG[GetConVar("actors2_pathmaker_ac2_lang"):GetString()]["ac2_welc_check_nav"]
		end

		local vrs = tonumber( contents, 10 )
		if vrs then
			if tonumber(AC2_Version, 10) < vrs then
				CheckActors2Addon.AC2Version = AC2_LANG[GetConVar("actors2_pathmaker_ac2_lang"):GetString()]["ac2_welc_check_version"]
			end
		elseif vrs == nil then
			CheckActors2Addon.AC2Version = AC2_LANG[GetConVar("actors2_pathmaker_ac2_lang"):GetString()]["ac2_welc_check_vers404"]
		end

		net.Start( "Ac2_FetchVersion" )
			net.WriteTable( CheckActors2Addon )
		net.Send( ply )

		RunConsoleCommand( "actors2_pathmaker_ac2_welcome", 2 )
	end
	http.Fetch("https://raw.githubusercontent.com/NickMBR/Actors2/master/version.txt", AC2GitCheck, function() end)

	if WlcState < 2 then WlcState = WlcState + 1 else WlcState = 2 end

	-- Open the Welcome Panel if it's the first time
	net.Start( "Ac2_OpenWelcomePanel" )
		net.WriteDouble( WlcState )
	net.Send( ply )

	-- If there's no nav mesh, notify the client
	if not navmesh.IsLoaded() then
		SendNotifyClient( ply, "#ac2_notify_no_navmesh", 1, "buttons/button10.wav", 7 )
	end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Deploy
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:Deploy()
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Holster
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:Holster()
	-- Cancels rotation
	self:ClearObjects()

	if self:GetClientNumber( "ac2_welcome" ) != 0 then
		RunConsoleCommand( "actors2_pathmaker_ac2_welcome", 1 )
	end
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

	-- Opens the Welcome Panel if it's the first time
	if self:GetClientNumber( "ac2_welcome" ) == 1 then
		self:CheckAddonTest()
		return false
	else
		local ply = self:GetOwner()
		local numobj = self:NumObjects()
		degrees = 0

		-- Receive Vars to insert on the actor Point
		local SpawnKey = self:GetClientNumber( "ac2_spawn" )
		local DeSpawnKey = self:GetClientNumber( "ac2_despawn" )

		-- Builds a table to add in the Path
		local ActorSettings =
		{
			SKey = SpawnKey,
			DSKey = DeSpawnKey,
		}

		-- Rotate if 'E' or 'SHIFT' is pressed
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
		-- If Pressed shift to snap angles, still finishes the rotation
		elseif self:NumObjects() > 0 and IsValid( self:GetEnt(1) ) then
			self:ClearObjects()

		-- Creates the Path Points and Tables Here
		else
			if trace.Entity:GetClass() == "ac2_pathpoint" then return false end

			local PathPoint = CreatePathPoint( ply, trace.HitPos )
			BuildActorTable( ply, pathpnt )
			PathSelector = GetConVar( "actors2_pathmaker_ac2_pathselector" ):GetInt()

			-- Adds the Table to all Path Points (in case the actor point is removed)
			pathpnt.ActorSettings = ActorSettings
			CheckActorSpawn( ply )
		end
		return true
	end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Path Point Remover
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:RightClick( trace )
	if CLIENT then return true end
	local ply = self:GetOwner()

	if trace.Entity:GetClass() == "ac2_pathpoint" then
		RemoveAimedPathPoint( ply, trace.Entity)
		CheckActorSpawn( ply )
	else
		RemovePathPoint( ply )
		CheckActorSpawn( ply )
	end

	-- Automatic selector when a path is completely removed
	local AC2TP = CheckForPlayer( ply )
	if PathSelector > 1 and next(Actors2TBL[AC2TP[1]][AC2TP[2]].PathPoints[PathCount]) == nil then
		-- Theres no more entities in the table, remove it
		table.remove( Actors2TBL[AC2TP[1]][AC2TP[2]].PathPoints, PathCount )

		-- Updates the Count
		PathSelector = PathSelector - 1
		RunConsoleCommand( "actors2_pathmaker_ac2_pathselector", PathSelector)
		PathCount = PathSelector

		-- Send the changes
		SendNewPathPointTable( ply )
	end
	
	return false
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Creates a new Path or Select one if avaliable
-- ## ------------------------------------------------------------------------------ ## --
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
				--CheckActorSpawn( ply )
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

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Think
	-- 1. Runs every tick
-- ## ------------------------------------------------------------------------------ ## --
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

	-- Solves a bug when the players get out of the map
	-- and the path points loses their color but this
	-- is called every tick, needs optimization ASAP!!
	if SERVER then
		if self:GetOwner():IsInWorld() and next(Actors2TBL) then
			SendNewPathPointTable( self:GetOwner() )
		end
	end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Custom Tool Interface (Screen)
-- ## ------------------------------------------------------------------------------ ## --
function TOOL:DrawToolScreen( width, height )
	surface.SetDrawColor( Color( 30, 30, 30 ) )
	surface.DrawRect( 0, 0, width, height )

	surface.SetDrawColor( Color( 200, 200, 200 ) )
	surface.DrawRect( 0, 0, width, height/2-50 )
	draw.SimpleText( "Actors2", "Actors2F_50", width / 2, height/2-90, Color( 30, 30, 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

function GetActorPointsTBL( ply )
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

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Network Functions
-- ## ------------------------------------------------------------------------------ ## --
function SendNewPathPointTable( ply )
	local TempTBL = CheckForPlayer( ply )
	net.Start( "DrawPathPointLine" )
		net.WriteTable( Actors2TBL[TempTBL[1]][TempTBL[2]].PathPoints )
		net.WriteDouble( PathCount )
	net.Send( ply )
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
	-- Actor Removal
-- ## ------------------------------------------------------------------------------ ## --
function RemoveActorFromPath( ent )
	if IsValid( ent:GetTable().ActorSettings.ActorEnt ) then
		ent:GetTable().ActorSettings.ActorEnt:Remove()
	end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- TOOL Click Functions
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

		-- if An Actor Exists in the point, remove it
		RemoveActorFromPath( LastEnt )

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

				RemoveActorFromPath( ent )

				ent:Remove()
				SendNewPathPointTable( ply )
				SendNotifyClient( ply, "#ac2_notify_removed_pathptn", 2, "buttons/button15.wav", 2 )
			end
		end
	end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Client Functions
-- ## ------------------------------------------------------------------------------ ## --
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

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Server Functions
-- ## ------------------------------------------------------------------------------ ## --
if SERVER then
	util.AddNetworkString( "Ac2_OpenWelcomePanel" )
	util.AddNetworkString( "Ac2_FetchVersion" )
	util.AddNetworkString( "Ac2_OpenActorPanel" )
	util.AddNetworkString( "SendActorPoints" )
	util.AddNetworkString( "DrawPathPointLine" )
	util.AddNetworkString( "NotifyPathPointRMV" )
	util.AddNetworkString( "CheckNavMesh" )

	function CreatePathPoint( ply, pos )
		pathpnt = ents.Create( "ac2_pathpoint" )
		if not IsValid( pathpnt ) then return end
		
		pathpnt:SetOwner( ply )
		pathpnt:SetPos( pos )
		pathpnt:Spawn()
	end

	-- Makes the actor face the next path point
	-- Updates the angle when path is updated
	function FaceLastPathPoint( t )
		if t[2] then
			local ENT1 = ents.GetByIndex( t[1] )
			local ENT2 = ents.GetByIndex( t[2] )

			if IsValid( ENT1 ) and IsValid( ENT2 ) then
				ENT1:PointAtEntity( ENT2 )
			end
		end
	end

	-- Check The Path Points
	-- Spawns an Actor always on the first point of the Path
	-- If it exists, remove it and create again (despawn)
	-- Somewhat unoptimized, needs to be called when the path Updates
	-- LeftClick, RightClick, E+Reload
	function CheckActorSpawn( ply )
		local PathPTBL = GetActorPointsTBL( ply )

		if PathPTBL and #PathPTBL[PathCount] > 0 then
			local PathP = PathPTBL[PathCount]
			local ACEnt = ents.GetByIndex(PathP[1])
			local ACName = string.format("%s%s", "ac2_", tostring(PathP[1]))

			if IsValid( ACEnt:GetTable().ActorSettings.ActorEnt ) and ACEnt:GetTable().ActorSettings.ActorEnt:GetName() == ACName then
				ACEnt:GetTable().ActorSettings.ActorEnt:Remove()
				numpad.Remove( ACEnt:GetTable().ActorSettings.npzAcSpawn )
				numpad.Remove( ACEnt:GetTable().ActorSettings.npzAcDeSpawn )

				FaceLastPathPoint( PathP )
				CreateActorSpawn( ply, ACEnt:GetPos(), ACEnt:GetAngles(), ACEnt:GetTable().ActorSettings, PathP[1] )
				
			else
				FaceLastPathPoint( PathP )
				CreateActorSpawn( ply, ACEnt:GetPos(), ACEnt:GetAngles(), ACEnt:GetTable().ActorSettings, PathP[1] )
			end
		end
	end

	function CreateActorSpawn( ply, pos, angs, t, id )
		npz = ents.Create( "ac2_actor_generic" )
		if not IsValid( npz ) then return end

		npz:SetName( "ac2_"..id )
		npz:SetPos( pos )
		npz:SetAngles( angs )
		npz:SetOwner( ply )

		t.ActorEnt = npz
		t.npzAcSpawn = numpad.OnDown(ply, t.SKey, "ActorSpawn", npz, pos, 0)
		t.npzAcDeSpawn = numpad.OnDown(ply, t.DSKey, "ActorDeSpawn", npz)
	end

	local function SpawnActor(ply, ent, pos, delay, t)
		if not IsValid( ent ) then return false end

		local posz = string.Explode(" ", tostring(pos))
		delay = delay or 0
		timer.Simple( delay, function()
			ent:SetPos(Vector( posz[1], posz[2], posz[3] ) )
			ent:Spawn()
			ent:Activate()
		end)
	end

	local PTwice = 1
	local function DeSpawnActor(ply, ent)
		if not IsValid( ent ) then return false end

		if PTwice == 1 then
			CheckActorSpawn( ply )
			PTwice = 0
		end
		timer.Simple(1, function() PTwice = 1 end)
	end

	numpad.Register("ActorSpawn", function( pl, ent )
		if not IsValid(ent) then return false end
		SpawnActor()
	end)
	numpad.Register("ActorDeSpawn", DeSpawnActor )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- TOOL CPanel
-- ## ------------------------------------------------------------------------------ ## --
function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Text = "#tool.actors2_pathmaker.name", Description = "#tool.actors2_pathmaker.desc" } )
	CPanel:AddControl( "Numpad", { Label = "Spawn Actor", Command = "actors2_pathmaker_ac2_spawn" } )
	CPanel:AddControl( "Numpad", { Label = "Remove Actor", Command = "actors2_pathmaker_ac2_despawn" } )
end

AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable = false
local LaserMat = Material("trails/laser")
local PathPointLinesTBL = {}
local PathPointsSelector = 0
local PathPointLineOffset = Vector(0,0,2)

function ENT:Initialize()
	if ( SERVER ) then
		self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		self:SetPersistent( true )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		
		self:SetMaterial("models/debug/debugwhite")
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		--self:SetColor( Color( 30, 60, 210, 255 ) )
		self:DrawShadow( false )
	end
end

-- Allows only the Actors2 properties to be shown
function ENT:CanProperty( ply, property )
	if property == "ac2_p_editactor" and self:GetColor().r == 225 and self:GetColor().g == 150 then return true
	elseif property == "ac2_p_editpathpoint" and self:GetColor().r == 30 and self:GetColor().g == 30 then return true
	else return false end
	return false
end

-- Prevents the use of any Gmod tools on this entity
function ENT:CanTool( ply, tr, tool )
	if IsValid( tr.Entity ) and tr.Entity:GetClass() == "ac2_pathpoint" then
		if tool == "actors2_pathmaker" then return true else return false end
	end
end

function ChangePathColors()
	for k, v in pairs (PathPointLinesTBL) do
		if k != PathPointsSelector then
			for ke, va in pairs (v) do
				if IsValid( ents.GetByIndex(va) ) then
					ents.GetByIndex(va):SetColor( Color( 210, 210, 210, 255 ) )
				end
			end
		else
			for ke, va in pairs (v) do
				if IsValid( ents.GetByIndex(va) ) then
					if ke == 1 then 
						ents.GetByIndex(va):SetColor( Color( 225, 150, 55, 255 ) )
					else
						ents.GetByIndex(va):SetColor( Color( 30, 30, 30, 255 ) )
					end
				end
			end
		end
	end
end

if CLIENT then
	net.Receive( "DrawPathPointLine", function()
		PathPointLinesTBL = net.ReadTable()
		PathPointsSelector = net.ReadDouble()
		ChangePathColors()
	end )
end

function ENT:FaceLastPathPoint()
	-- Needs to Network!
	if SERVER then
		if #PathPointLinesTBL[PathPointsSelector] >= 2 then
			for i = 2, #PathPointLinesTBL[PathPointsSelector] do
				local ENT1 = ents.GetByIndex( PathPointLinesTBL[PathPointsSelector][i] )
				local ENT2 = ents.GetByIndex( PathPointLinesTBL[PathPointsSelector][i+1] )

				if IsValid( ENT1 ) and IsValid( ENT2 ) then
					ENT1:PointAtEntity( ENT2 )
				end
			end
		end
	end
end

function ENT:Draw()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	-- Makes the Path Point Invisible when the using the Gmod Camera
	if ( wep:IsValid() ) then 
		local weapon_name = wep:GetClass()
		if ( weapon_name == "gmod_camera" ) then return end
	end

	self:DrawModel()

	-- Draws a line between the Path Points
	if #PathPointLinesTBL[PathPointsSelector] >= 2 then
		render.SetMaterial( LaserMat )
		for i = 2, #PathPointLinesTBL[PathPointsSelector] do
			local PathP1 = ents.GetByIndex( PathPointLinesTBL[PathPointsSelector][i] )
			local PathP2 = ents.GetByIndex( PathPointLinesTBL[PathPointsSelector][i-1] )
			render.DrawLine( PathP1:GetPos()+PathPointLineOffset, PathP2:GetPos()+PathPointLineOffset, Color(255, 255, 255, 255), true)
		end
	end
end

function ENT:Think()
	--self:FaceLastPathPoint()
end

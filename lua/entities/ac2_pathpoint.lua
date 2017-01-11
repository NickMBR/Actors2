AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable = false
local LaserMat = Material("trails/laser")
local PathPointLinesTBL = {}
local PathPointLineOffset = Vector(0,0,2)

function ENT:Initialize()
	if ( SERVER ) then
		self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		
		self:SetPersistent( true )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		
		self:SetMaterial("models/debug/debugwhite")
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:SetColor( Color( 30, 60, 210, 150 ) )
		self:DrawShadow( false )
	end
	
	-- Removes the drive, persist and collision properties of the entity
	hook.Add( "CanProperty", "prevent_path_property", function( ply, property, ent )
		if ( ent:GetClass() == "ac2_pathpoint" ) then
			if ( property == "drive" or property == "persist" or property == "collision" or property == "remover") then 
				return false 
			end
		else
			return true
		end
	end )
end

-- Prevents the use of any Gmod tools on this entity
function ENT:CanTool( ply, tr, tool )
	if IsValid( tr.Entity ) and tr.Entity:GetClass() == "ac2_pathpoint" then
		return false
	end
end

if CLIENT then
	net.Receive( "DrawPathPointLine", function()
		PathPointLinesTBL = net.ReadTable()
	end )
end

function ENT:Draw()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	-- Makes the Path Point Invisible when the using the Gmod Camera
	if ( wep:IsValid() ) then 
		local weapon_name = wep:GetClass()
		if ( weapon_name == "gmod_camera" ) then return end
	end
	BaseClass.Draw( self )

	-- Draws a line between the Path Points
	if ( #PathPointLinesTBL >= 2 ) then
		render.SetMaterial( LaserMat )
		for i = 2, #PathPointLinesTBL do
			local PathP1 = ents.GetByIndex( PathPointLinesTBL[i] )
			local PathP2 = ents.GetByIndex( PathPointLinesTBL[i-1] )
			render.DrawBeam( PathP1:GetPos()+PathPointLineOffset, PathP2:GetPos()+PathPointLineOffset, 3, 1, 1, Color(255, 255, 255, 255) )
		end
	end
end
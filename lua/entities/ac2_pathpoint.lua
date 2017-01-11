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
		--self:SetColor( Color( 30, 60, 210, 255 ) )
		self:DrawShadow( false )
	end

	if ( #PathPointLinesTBL == 1 ) then self:SetColor( Color( 225, 150, 55, 255 ) ) else self:SetColor( Color( 30, 60, 210, 255 ) ) end

	-- Allows only the Actors2 properties to be shown
	--[[hook.Add( "CanProperty", "prevent_path_property", function( ply, property, ent )
		if ( ent:GetClass() == "ac2_pathpoint" ) then
			if property == "ac2_p_editactor" or property == "ac2_p_actionpoint" then return true else return false end
		else
			return true
		end
	end )]]--
end

function ENT:CanProperty( ply, property )
	if property == "ac2_p_editactor" and self:GetColor().r == 225 and self:GetColor().g == 150 then return true
	elseif property == "ac2_p_actionpoint" and self:GetColor().r == 30 and self:GetColor().g == 60 then return true
	elseif property == "ac2_p_editactionpoint" and self:GetColor().r == 225 and self:GetColor().g == 54 then return true
	else return false end
	return false
end

-- Prevents the use of any Gmod tools on this entity
function ENT:CanTool( ply, tr, tool )
	if IsValid( tr.Entity ) and tr.Entity:GetClass() == "ac2_basepoint" then
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

	self:DrawModel()

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

function ENT:Think()
	
end
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable = false

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
	
	// -- Removes the drive, persist and collision properties of the entity
	hook.Add( "CanProperty", "prevent_path_property", function( ply, property, ent )
		if ( property == "drive" or property == "persist" or property == "collision") then return false end
	end )
end

// -- Prevents the use of any Gmod tools on this entity ------------------------------ //
function ENT:CanTool( ply, tr, tool )
	if IsValid( tr.Entity ) and tr.Entity:GetClass() == "ac2_pathpoint" then
		return false
	end
end

// -- Makes the Path Point Invisible when the using the Gmod Camera ------------------ //
function ENT:Draw()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	if ( wep:IsValid() ) then 
		local weapon_name = wep:GetClass()
		if ( weapon_name == "gmod_camera" ) then return end
	end
	BaseClass.Draw( self )
end
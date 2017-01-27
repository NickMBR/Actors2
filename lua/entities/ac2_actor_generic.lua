AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false

function ENT:Initialize()
	if SERVER then
		self:SetCustomCollisionCheck( true ) 
		self:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) )
	end
end

function ENT:RunBehaviour()
	while ( true ) do
		self:StartActivity( ACT_WALK )
		self.loco:SetDesiredSpeed( 90 )
		coroutine.yield()
	end
end
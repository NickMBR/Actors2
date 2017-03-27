AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false

function ENT:Initialize()
	if SERVER then
		self:SetCustomCollisionCheck( true ) 
		self:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) )
	end
end

local options = {
	lookahead = 300,
	tolerance = 10,
	draw = true,
	maxage = 1,
	repath = 0.1,
}

function ENT:MoveToPos( pos, options )
	local options = options or {}
	local path = Path( "Chase" )
	path:SetMinLookAheadDistance( options.lookahead or 300000000 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )
	while ( path:IsValid() ) do
		path:Update( self )
		--
		-- If they set maxage on options then make sure the path is younger than it
		--
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end
		--
		-- If they set repath then rebuild the path every x seconds
		--
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		coroutine.yield()
	end
	return "ok"
end

--[[function ENT:RunBehaviour()
	while ( true ) do
		self:StartActivity( ACT_WALK )
		self.loco:SetDesiredSpeed( 90 )
		coroutine.yield()
	end
end]]--
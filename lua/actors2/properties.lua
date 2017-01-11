-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Edit Actor Property
	-- 1. Only Appears on the Actor Path Point (Orange)
	-- 2. Opens the Actor Settings Panel, allowing model changes, attachments and custom templates.
-- ## ------------------------------------------------------------------------------ ## --
properties.Add( "ac2_p_editactor", {
	MenuLabel = AC2_LANG[A2LANG]["ac2_properties_ac2_editactor"],
	Order = 1,
	MenuIcon = "icon16/user_orange.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if ent:IsPlayer() then return false end
		if not gamemode.Call( "CanProperty", ply, "ac2_p_editactor", ent ) then return false end
		if ent:GetClass() == "ac2_pathpoint" then return true end

		return false
	end,
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end
	end
} )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Action Point Property
	-- 1. Only Appears on the Blue Path Points
	-- 2. Transforms the Path Point into a Action Point
	-- 3. Action Points make actors run custom functions such as shoot to a target.
-- ## ------------------------------------------------------------------------------ ## --
properties.Add( "ac2_p_actionpoint", {
	MenuLabel = AC2_LANG[A2LANG]["ac2_properties_ac2_actionpoint"],
	Order = 2,
	MenuIcon = "icon16/flag_red.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if ent:IsPlayer() then return false end
		if not gamemode.Call( "CanProperty", ply, "ac2_p_actionpoint", ent ) then return false end
		if ent:GetClass() == "ac2_pathpoint" then return true end

		return false
	end,
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end
		ent:SetColor( Color( 225, 54, 54, 255 ) )
	end
} )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Edit Action Point Property
	-- 1. Only Appears on Action Points (Red)
	-- 2. Opens the Action Point Settings Panel, settings are based on the actor selected.
-- ## ------------------------------------------------------------------------------ ## --
properties.Add( "ac2_p_editactionpoint", {
	MenuLabel = AC2_LANG[A2LANG]["ac2_properties_ac2_editaction"],
	Order = 2,
	MenuIcon = "icon16/wrench.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if ent:IsPlayer() then return false end
		if not gamemode.Call( "CanProperty", ply, "ac2_p_editactionpoint", ent ) then return false end
		if ent:GetClass() == "ac2_pathpoint" then return true end

		return false
	end,
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end
	end
} )

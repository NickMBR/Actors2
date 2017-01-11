properties.Add( "ac2_p_editactor", {
	MenuLabel = AC2_LANG[A2LANG]["ac2_properties_ac2_editactor"],
	Order = 1,
	MenuIcon = "icon16/user_orange.png",

	Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
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

properties.Add( "ac2_p_actionpoint", {
	MenuLabel = AC2_LANG[A2LANG]["ac2_properties_ac2_actionpoint"],
	Order = 2,
	MenuIcon = "icon16/flag_red.png",

	Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
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

properties.Add( "ac2_p_editactionpoint", {
	MenuLabel = AC2_LANG[A2LANG]["ac2_properties_ac2_editaction"],
	Order = 2,
	MenuIcon = "icon16/wrench.png",

	Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
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

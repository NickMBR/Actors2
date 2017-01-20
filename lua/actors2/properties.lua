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
		print("opened actor settings on Action")
		OpenActorSettingsPanel()

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end
	end
} )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Action Point Property
	-- 1. Only Appears on the Black Path Points
	-- 2. Opens the panel to edit the point settings.
	-- 3. Path Points make actors run custom functions such as shoot to a target.
-- ## ------------------------------------------------------------------------------ ## --
properties.Add( "ac2_p_editpathpoint", {
	MenuLabel = AC2_LANG[A2LANG]["ac2_properties_ac2_editaction"],
	Order = 2,
	MenuIcon = "icon16/wrench.png",

	Filter = function( self, ent, ply )
		if not IsValid( ent ) then return false end
		if ent:IsPlayer() then return false end
		if not gamemode.Call( "CanProperty", ply, "ac2_p_editpathpoint", ent ) then return false end
		if ent:GetClass() == "ac2_pathpoint" then return true end

		return false
	end,
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
		print("opened path settings on Action")

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end
	end
} )

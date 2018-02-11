if CLIENT then

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Resources
-- ## ------------------------------------------------------------------------------ ## --
surface.CreateFont( "AC2_F10", {
	font = "DermaLarge",
	size = 12,
	weight = 400,
	antialias = true,
})

surface.CreateFont( "AC2_F15", {
	font = "DermaLarge",
	size = 15,
	weight = 600,
	antialias = true,
})

surface.CreateFont( "AC2_F20", {
	font = "DermaLarge",
	size = 20,
	weight = 600,
	antialias = true,
})

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Variables
-- ## ------------------------------------------------------------------------------ ## --
local RedBtnHover, RedBtnTextHover, WhiteBtnHover, WhiteBtnTextHover, BlueBtnHover, BlueBtnTextHover, GreenBtnHover, GreenBtnTextHover = Color( 35, 35, 35, 255 )
local ActorSettings = {}
local ActorAnimations = {}

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Receive the path settings
-- ## ------------------------------------------------------------------------------ ## --
net.Receive( "PathSettings", function()
	ActorSettings = net.ReadTable()
	PrintTable(ActorSettings)
end )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Open the Panel
-- ## ------------------------------------------------------------------------------ ## --
function OpenActorAnimationsPanel( pathp )

end

end
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
local SelectedAnimation = nil

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Receive the Actor Settings
-- ## ------------------------------------------------------------------------------ ## --
net.Receive( "PathSettings", function()
	ActorSettings = net.ReadTable()

	ActorSettings.Model = ActorSettings.Model or "models/alyx.mdl"
	ActorSettings.Skin = ActorSettings.Skin or 0
	ActorSettings.Bodygroup = ActorSettings.Bodygroup or "0"
end )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Open the Panel
-- ## ------------------------------------------------------------------------------ ## --
function OpenActorAnimationsPanel( pathp )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Hover Functions
-- ## ------------------------------------------------------------------------------ ## --
function ButtonHover( btn, class ) 
	if btn:IsHovered() then
	   if class == "red" then
		   RedBtnHover = Color( 180, 70, 55, 255 )
		   RedBtnTextHover = Color( 210, 210, 210, 255 )
	   elseif class == "white" then
		   WhiteBtnHover = Color( 180, 180, 180, 255 )
		   WhiteBtnTextHover = Color( 35, 35, 35, 255 )
	   elseif class == "blue" then
		   BlueBtnHover = Color( 55, 100, 180, 255 )
		   BlueBtnTextHover = Color( 210, 210, 210, 255 )
	   elseif class == "green" then
		   GreenBtnHover = Color( 55, 180, 70, 255 )
		   GreenBtnTextHover = Color( 210, 210, 210, 255 )
	   end
   else
	   if class == "red" then
		   RedBtnHover = Color( 200, 90, 75, 255 )
		   RedBtnTextHover = Color( 210, 210, 210, 255 )
	   elseif class == "white" then
		   WhiteBtnHover = Color( 210, 210, 210, 255 )
		   WhiteBtnTextHover = Color( 35, 35, 35, 255 )
	   elseif class == "blue" then
		   BlueBtnHover = Color( 75, 120, 200, 255 )
		   BlueBtnTextHover = Color( 210, 210, 210, 255 )
	   elseif class == "green" then
		   GreenBtnHover = Color( 75, 200, 90, 255 )
		   GreenBtnTextHover = Color( 210, 210, 210, 255 )
	   end
   end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Updates the Entity Settings
-- ## ------------------------------------------------------------------------------ ## --
function UpdateFromConvars()

    -- Sets the entity to Draw
    if IsValid( mdl ) then
        mdl:SetModel( ActorSettings.Model )
        mdl.Entity:SetPos( Vector( -120, 0, -55 ) )
		mdl.Entity:SetSkin( ActorSettings.Skin )

        local ac_bgroups = string.Replace(ActorSettings.Bodygroup, " ", "")
        mdl.Entity:SetBodyGroups(ac_bgroups)

        if mdl.Entity:GetModelRadius() > 80 or mdl.Entity:GetModelRadius() < 72 then
            mdl:SetLookAt( Vector( -200, 0, -22 ) )
            mdl:SetCamPos( Vector( 100, 0, 0 ) )
        else
            mdl:SetLookAt( Vector( -120, 0, -22 ) )
            mdl:SetCamPos( Vector( 0, 0, 0 ) )
        end
    end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Base Panel
-- ## ------------------------------------------------------------------------------ ## --
Base = vgui.Create( "DFrame" )
Base:SetSize( ScrW()/1.1, ScrH()/1.5 )
Base:SetTitle("")
Base:SetDraggable( false )
Base:SetSizable( false )
Base:ShowCloseButton( false )
Base:Center()
Base.Paint = function()
    surface.SetDrawColor( 35, 35, 35, 253 )
    surface.DrawRect( 0, 0, Base:GetWide(), Base:GetTall() )

    surface.SetDrawColor( 25, 25, 25, 255 )
    surface.DrawRect( 0, 0, Base:GetWide(), 30 )

    surface.SetTextColor( 210, 210, 210, 255 )
    surface.SetFont( "AC2_F20" )
    surface.SetTextPos( 10, 5 )
	surface.DrawText( AC2_LANG[A2LANG]["ac2_panelset_title"] )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Close Button
-- ## ------------------------------------------------------------------------------ ## --
local BaseCloseBtn = vgui.Create( "DButton", Base )
BaseCloseBtn:SetPos( Base:GetWide()-80, 0 )
BaseCloseBtn:SetText( "" )
BaseCloseBtn:SetSize( 80, 30 )
BaseCloseBtn.DoClick = function()

	if IsValid(Base) then
        Base:Remove()
    end
end
BaseCloseBtn.Paint = function()
    ButtonHover( BaseCloseBtn, "white" )
    surface.SetDrawColor( WhiteBtnHover )
    surface.DrawRect( 0, 0, BaseCloseBtn:GetWide(), BaseCloseBtn:GetTall() )

    draw.SimpleText( AC2_LANG[A2LANG]["ac2_panelset_btnclose"], "AC2_F15", 40, 15, WhiteBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Help Button
-- ## ------------------------------------------------------------------------------ ## --
local BaseHelpBtn = vgui.Create( "DButton", Base )
BaseHelpBtn:SetPos( Base:GetWide()-165, 0 )
BaseHelpBtn:SetText( "" )
BaseHelpBtn:SetSize( 80, 30 )
BaseHelpBtn.DoClick = function()
	print("Open Help Menu or Tutorial?")
end
BaseHelpBtn.Paint = function()
    ButtonHover( BaseHelpBtn, "red" )
    surface.SetDrawColor( RedBtnHover )
    surface.DrawRect( 0, 0, BaseHelpBtn:GetWide(), BaseHelpBtn:GetTall() )

    draw.SimpleText( AC2_LANG[A2LANG]["ac2_panelset_btnhelp"], "AC2_F15", 40, 15, RedBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Actor Model Panel Container
-- ## ------------------------------------------------------------------------------ ## --
local ModelBase = vgui.Create( "DPanel", Base )
ModelBase:SetPos( 10, 40 )
ModelBase:SetSize( Base:GetWide()/2-100, Base:GetTall()-50 )
ModelBase:SetPaintBackground( false )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Draw Model Panel and Functions
-- ## ------------------------------------------------------------------------------ ## --
mdl = vgui.Create( "DModelPanel", ModelBase)
mdl:Dock( FILL )
mdl:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 80, 255 ) )
mdl:SetDirectionalLight( BOX_LEFT, Color( 80, 160, 255, 255 ) )
mdl:SetAmbientLight( Vector( -64, -64, -64 ) )
mdl:SetAnimated( true )
mdl.Angles = Angle( 0, 0, 0 )
mdl:SetFOV( 50 )

-- Rotates the entity with the mouse
function mdl:DragMousePress()
    self.PressX, self.PressY = gui.MousePos()
    self.Pressed = true
end

function mdl:DragMouseRelease() self.Pressed = false end

function mdl:LayoutEntity( Entity )
    if ( self.bAnimated ) then self:RunAnimation() end

    if ( self.Pressed ) then
        local mx, my = gui.MousePos()
        self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
            
        self.PressX, self.PressY = gui.MousePos()
    end

    Entity:SetAngles( self.Angles )
end

-- Makes Page 2 container
Container = vgui.Create( "DPanel", Base )
Container:SetPos( ( Base:GetWide()-Base:GetWide()/2 )-100, 30 )
Container:SetSize( Base:GetWide()/2+90, Base:GetTall()-40 )
Container:SetPaintBackground( false )

-- Back Button
local ListBtnBack = vgui.Create( "DButton", Container )
ListBtnBack:SetPos( 0, 10 )
ListBtnBack:SetText( "" )
ListBtnBack:SetSize( 80, 30 )
ListBtnBack.DoClick = function()
	surface.PlaySound( "ui/csgo_ui_contract_type4.wav" )
	
end
ListBtnBack.Paint = function()
	ButtonHover( ListBtnBack, "red" )
	surface.SetDrawColor( RedBtnHover )
	surface.DrawRect( 0, 0, ListBtnBack:GetWide(), ListBtnBack:GetTall() )

	draw.SimpleText( AC2_LANG[A2LANG]["ac2_panelset_btnback"], "AC2_F15", 40, 15, RedBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- Common Base Panel
AnimationsContainer = vgui.Create( "DPanel", Container )
AnimationsContainer:SetPos( 0, 60 )
AnimationsContainer:SetSize( 300, Container:GetTall()-70 )
AnimationsContainer:SetPaintBackground( false )
AnimationsContainer:SetBackgroundColor( Color( 100, 100, 100, 255 ) )

local animcontrolpanel = vgui.Create( "DListView", AnimationsContainer)
animcontrolpanel:SetMultiSelect( false )
animcontrolpanel:AddColumn( "Animation" )
animcontrolpanel:Dock( FILL )

local function PlayPreviewAnimation( panel, playermodel )

	if ( !panel or !IsValid( panel.Entity ) ) then return end
		
	timer.Create( "lol", 0, 1, function()
		local animz = SelectedAnimation	
		local iSeq = panel.Entity:LookupSequence( animz )
		local iSeqDur = panel.Entity:SequenceDuration( iSeq )
		panel.Entity:SetPoseParameter("move_x", 1)
		panel.Entity:ResetSequence( iSeq ) 
		panel.Entity:ResetSequenceInfo()
		panel.Entity:SetCycle( 0 )
			
		timer.Adjust( "lol", iSeqDur, 0, function()
			if (!panel or !IsValid( panel.Entity ) ) then timer.Destroy( "lol" ) return end
			panel.Entity:SetPoseParameter("move_x",1)
			panel.Entity:ResetSequence( iSeq ) 
			panel.Entity:ResetSequenceInfo()
			panel.Entity:SetCycle( 0 )
		end)
	end)			
end

local function FilterAnimations()
	--"g_", "p_", "e_", "b_", "bg_", "hg_", "tc_", "aim_", "turn", "gest_", "pose_", "pose_", "auto_", "layer_", "posture", "bodyaccent", "a_"
	--local badBegginings = {"g_", "p_", "e_", "b_", "bg_", "hg_", "tc_", "aim_", "turn", "gest_", "auto_", "layer_", "posture", "bodyaccent", "a_", "aimlayer_", "flinch_", "accentdown_", "accentup_", "bodystretch"}
	
	local badAnimations = { "accent", "apex", "loop", "delta", "layer", "default", "in", "out", "exit", "arms", "spine" }
	for k, v in SortedPairsByValue( mdl.Entity:GetSequenceList() ) do
		local isbad = false
		for i, s in pairs( badAnimations ) do
			if ( string.match( v:lower(), s:lower() ) != nil ) then
				isbad = true
				break
			end
		end
		if ( isbad == true) then continue end

		animcontrolpanel:AddLine(v)
	end
			
	animcontrolpanel.OnRowSelected = function(panel, line)
		timer.Simple( 0.1, function() 
			SelectedAnimation = panel:GetLine(line):GetValue(1)
			PlayPreviewAnimation(mdl, model)	
		end )
				
	end
end

Base:MakePopup()
UpdateFromConvars()
FilterAnimations()

end -- end open panel

end
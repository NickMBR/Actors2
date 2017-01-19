if CLIENT then

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Resources
-- ## ------------------------------------------------------------------------------ ## --
surface.CreateFont( "AC2_F15", {
	font = "DermaLarge",
	size = 15,
	weight = 600,
	antialias = true,
} )

surface.CreateFont( "AC2_F20", {
	font = "DermaLarge",
	size = 20,
	weight = 600,
	antialias = true,
} )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Variables
-- ## ------------------------------------------------------------------------------ ## --
local RedBtnHover = Color( 200, 90, 75, 255 )
local RedBtnTextHover = Color( 210, 210, 210, 255 )

local WhiteBtnHover = Color( 210, 210, 210, 255 )
local WhiteBtnTextHover = Color( 35, 35, 35, 255 )

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
        end
    else
        if class == "red" then
            RedBtnHover = Color( 200, 90, 75, 255 )
            RedBtnTextHover = Color( 210, 210, 210, 255 )
        elseif class == "white" then
            WhiteBtnHover = Color( 210, 210, 210, 255 )
            WhiteBtnTextHover = Color( 35, 35, 35, 255 )
        end
    end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Base Panel
-- ## ------------------------------------------------------------------------------ ## --
local Base = vgui.Create( "DPanel" )
Base:SetSize( ScrW()/1.5, ScrH()/1.5 )
Base:SetContentAlignment( 5 )
Base:Center()
Base.Paint = function()
    surface.SetDrawColor( 35, 35, 35, 253 )
    surface.DrawRect( 0, 0, Base:GetWide(), Base:GetTall() )

    surface.SetDrawColor( 25, 25, 25, 255 )
    surface.DrawRect( 0, 0, Base:GetWide(), 30 )

    surface.SetTextColor( 210, 210, 210, 255 )
    surface.SetFont( "AC2_F20" )
    surface.SetTextPos( 10, 5 )
	surface.DrawText( "Actor Settings" )
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

    draw.SimpleText( "Close", "AC2_F15", 40, 15, WhiteBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

    draw.SimpleText( "Help", "AC2_F15", 40, 15, RedBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Actor Model Settings
-- ## ------------------------------------------------------------------------------ ## --
local ModelSettingsBase = vgui.Create( "DPanel", Base )
ModelSettingsBase:SetPos( 10, 40 )
ModelSettingsBase:SetSize( Base:GetWide()/2-100, Base:GetTall()-50 )
ModelSettingsBase:SetPaintBackground( false )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Draw Model Panel and Functions
-- ## ------------------------------------------------------------------------------ ## --
local mdl = vgui.Create( "DModelPanel", ModelSettingsBase)
mdl:Dock( FILL )
mdl:SetFOV( 40 )
mdl:SetCamPos( Vector( 0, 0, 0 ) )
mdl:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 80, 255 ) )
mdl:SetDirectionalLight( BOX_LEFT, Color( 80, 160, 255, 255 ) )
mdl:SetAmbientLight( Vector( -64, -64, -64 ) )
mdl:SetAnimated( true )
mdl.Angles = Angle( 0, 0, 0 )
mdl:SetLookAt( Vector( -120, 0, -22 ) )

-- Sets the entity to Draw
mdl:SetModel( "models/alyx.mdl" )
mdl.Entity:SetPos( Vector( -120, 0, -55 ) )

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

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Debug
-- ## ------------------------------------------------------------------------------ ## --
Base:MakePopup()

if IsValid(Base) then
    timer.Simple(5, function()
        Base:Remove()
    end)
end

end
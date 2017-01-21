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
local RedBtnHover, RedBtnTextHover, WhiteBtnHover, WhiteBtnTextHover, BlueBtnHover, BlueBtnTextHover = Color( 35, 35, 35, 255 )

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
        end
    end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Fade Functions
-- ## ------------------------------------------------------------------------------ ## --
function fadePanelAlpha( str )
    if IsValid( MdlSelect ) then MdlSelect:Remove() end
    if IsValid( ModelListBase ) then
        ModelListBase:AlphaTo( 0, 0, 0 )
        ModelListBase:AlphaTo( 255, 1, 0 )

        if str == "human" then
            local hmn_list = list.Get( "NPCModelList_Human" )
            CreateModelList( hmn_list )
        elseif str == "alien" then
            local aln_list = list.Get( "NPCModelList_Alien" )
            CreateModelList( aln_list )
        elseif str == "custom" then
            local custom_list = player_manager.AllValidModels()
            CreateModelList( custom_list )
        end
    end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Base Panel
-- ## ------------------------------------------------------------------------------ ## --
function OpenActorSettingsPanel()
Base = vgui.Create( "DPanel" )
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
local mdl = vgui.Create( "DModelPanel", ModelBase)
mdl:Dock( FILL )
mdl:SetFOV( 40 )
mdl:SetCamPos( Vector( 0, 0, 0 ) )
mdl:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 80, 255 ) )
mdl:SetDirectionalLight( BOX_LEFT, Color( 80, 160, 255, 255 ) )
mdl:SetAmbientLight( Vector( -64, -64, -64 ) )
mdl:SetAnimated( true )
mdl.Angles = Angle( 0, 0, 0 )
mdl:SetLookAt( Vector( -120, 0, -22 ) )

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
-- Actor List - Buttons Container
-- ## ------------------------------------------------------------------------------ ## --
local ButtonListBase = vgui.Create( "DPanel", Base )
ButtonListBase:SetPos( ( Base:GetWide()-Base:GetWide()/2 )-100, 40 )
ButtonListBase:SetSize( Base:GetWide()/2+90, 80 )
ButtonListBase:SetPaintBackground( false )

ButtonListBase.Paint = function()
    surface.SetTextColor( 210, 210, 210, 255 )
    surface.SetFont( "AC2_F20" )
    surface.SetTextPos( 0, 5 )
	surface.DrawText( "Choose a Model:" )
end

-- Human Models Button
local ListBtnMain = vgui.Create( "DButton", ButtonListBase )
ListBtnMain:SetPos( 0, 30 )
ListBtnMain:SetText( "" )
ListBtnMain:SetSize( 100, 30 )
ListBtnMain.DoClick = function()
	fadePanelAlpha( "human" )
end
ListBtnMain.Paint = function()
    ButtonHover( ListBtnMain, "blue" )
    surface.SetDrawColor( BlueBtnHover )
    surface.DrawRect( 0, 0, ListBtnMain:GetWide(), ListBtnMain:GetTall() )

    draw.SimpleText( "Human", "AC2_F15", 50, 15, BlueBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- Alien Models Button
local ListBtnCitizen = vgui.Create( "DButton", ButtonListBase )
ListBtnCitizen:SetPos( 105, 30 )
ListBtnCitizen:SetText( "" )
ListBtnCitizen:SetSize( 100, 30 )
ListBtnCitizen.DoClick = function()
	fadePanelAlpha( "alien" )
end
ListBtnCitizen.Paint = function()
    ButtonHover( ListBtnCitizen, "blue" )
    surface.SetDrawColor( BlueBtnHover )
    surface.DrawRect( 0, 0, ListBtnCitizen:GetWide(), ListBtnCitizen:GetTall() )

    draw.SimpleText( "Alien", "AC2_F15", 50, 15, BlueBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- Custom Models Button
-- Attempt to search for custom ones ?
local ListBtnCustom = vgui.Create( "DButton", ButtonListBase )
ListBtnCustom:SetPos( 210, 30 )
ListBtnCustom:SetText( "" )
ListBtnCustom:SetSize( 100, 30 )
ListBtnCustom.DoClick = function()
	fadePanelAlpha( "custom" )
end
ListBtnCustom.Paint = function()
    ButtonHover( ListBtnCustom, "blue" )
    surface.SetDrawColor( BlueBtnHover )
    surface.DrawRect( 0, 0, ListBtnCustom:GetWide(), ListBtnCustom:GetTall() )

    draw.SimpleText( "Custom", "AC2_F15", 50, 15, BlueBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Makes the model list container
-- ## ------------------------------------------------------------------------------ ## --
ModelListBase = vgui.Create( "DPanel", Base )
ModelListBase:SetPos( ( Base:GetWide()-Base:GetWide()/2 )-100, 110 )
ModelListBase:SetSize( Base:GetWide()/2+90, Base:GetTall()-120 )
ModelListBase:SetPaintBackground( false )

if IsValid(ModelListBase) then 
    fadePanelAlpha( "human" )
end

local function UpdateFromConvars()
    -- Sets the entity to Draw
    local modelz = GetConVar( "actors2_pathmaker_ac2_model" )
    mdl:SetModel( modelz:GetString() )
    mdl.Entity:SetPos( Vector( -120, 0, -55 ) )
end

function MdlSelect:OnActivePanelChanged( old, new )
    --[[if ( old != new ) then
        RunConsoleCommand( "nmactors_ac_bodygroup", "0" )
        RunConsoleCommand( "nmactors_ac_skin", "0" )
    end	]]--
    timer.Simple( 0.1, function() UpdateFromConvars() end )

end

-- Opens It!
Base:MakePopup()
UpdateFromConvars()

end -- End OpenPanel function

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Makes the List of default models
-- ## ------------------------------------------------------------------------------ ## --
function CreateModelList( mdl_list )
    MdlSelect = vgui.Create( "DPanelSelect", ModelListBase )
    MdlSelect:Dock( FILL )

    for name, model in SortedPairs( mdl_list ) do
        local icon = vgui.Create( "SpawnIcon", painel )
        icon:SetModel( model )
        icon:SetSize( 64, 64 )
        icon:SetTooltip( name )

        MdlSelect:AddPanel( icon, { actors2_pathmaker_ac2_model = model } )
            
    end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Debug
-- ## ------------------------------------------------------------------------------ ## --

--[[if IsValid(Base) then
    timer.Simple(5, function()
        Base:Remove()
    end)
end]]--

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Default model list
-- ## ------------------------------------------------------------------------------ ## --
list.Set ( "NPCModelList_Human", "Mossman", "models/mossman.mdl" )
list.Set ( "NPCModelList_Human", "Alyx", "models/alyx.mdl" )
list.Set ( "NPCModelList_Human", "Barney", "models/Barney.mdl" )
list.Set ( "NPCModelList_Human", "Breen", "models/breen.mdl" )
list.Set ( "NPCModelList_Human", "Eli", "models/Eli.mdl" )
list.Set ( "NPCModelList_Human", "Gman", "models/gman_high.mdl" )
list.Set ( "NPCModelList_Human", "Kleiner", "models/Kleiner.mdl" )
list.Set ( "NPCModelList_Human", "Monk", "models/monk.mdl" )
list.Set ( "NPCModelList_Human", "Odessa", "models/odessa.mdl" )
list.Set ( "NPCModelList_Human", "Vortigaunt", "models/vortigaunt.mdl" )
list.Set ( "NPCModelList_Human", "Dog", "models/dog.mdl" )

list.Set ( "NPCModelList_Human", "Female1", "models/Humans/Group01/Female_01.mdl" )
list.Set ( "NPCModelList_Human", "Female2", "models/Humans/Group01/Female_02.mdl" )
list.Set ( "NPCModelList_Human", "Female3", "models/Humans/Group01/Female_03.mdl" )
list.Set ( "NPCModelList_Human", "Female4", "models/Humans/Group01/Female_04.mdl" )
list.Set ( "NPCModelList_Human", "Female5", "models/Humans/Group01/Female_06.mdl" )
list.Set ( "NPCModelList_Human", "Female6", "models/Humans/Group01/Female_07.mdl" )

list.Set ( "NPCModelList_Human", "Female7", "models/Humans/Group02/Female_01.mdl" )
list.Set ( "NPCModelList_Human", "Female8", "models/Humans/Group02/Female_02.mdl" )
list.Set ( "NPCModelList_Human", "Female9", "models/Humans/Group02/Female_03.mdl" )
list.Set ( "NPCModelList_Human", "Female10", "models/Humans/Group02/Female_04.mdl" )
list.Set ( "NPCModelList_Human", "Female11", "models/Humans/Group02/Female_06.mdl" )
list.Set ( "NPCModelList_Human", "Female12", "models/Humans/Group02/Female_07.mdl" )

list.Set ( "NPCModelList_Human", "Female13", "models/Humans/Group03/Female_01.mdl" )
list.Set ( "NPCModelList_Human", "Female14", "models/Humans/Group03/Female_02.mdl" )
list.Set ( "NPCModelList_Human", "Female15", "models/Humans/Group03/Female_03.mdl" )
list.Set ( "NPCModelList_Human", "Female16", "models/Humans/Group03/Female_04.mdl" )
list.Set ( "NPCModelList_Human", "Female17", "models/Humans/Group03/Female_06.mdl" )
list.Set ( "NPCModelList_Human", "Female18", "models/Humans/Group03/Female_07.mdl" )

list.Set ( "NPCModelList_Human", "CFemale1", "models/Humans/Group03m/Female_01.mdl" )
list.Set ( "NPCModelList_Human", "CFemale2", "models/Humans/Group03m/Female_02.mdl" )
list.Set ( "NPCModelList_Human", "CFemale3", "models/Humans/Group03m/Female_03.mdl" )
list.Set ( "NPCModelList_Human", "CFemale4", "models/Humans/Group03m/Female_04.mdl" )
list.Set ( "NPCModelList_Human", "CFemale5", "models/Humans/Group03m/Female_06.mdl" )
list.Set ( "NPCModelList_Human", "CFemale6", "models/Humans/Group03m/Female_07.mdl" )

list.Set ( "NPCModelList_Human", "Male1", "models/Humans/Group01/Male_01.mdl" )
list.Set ( "NPCModelList_Human", "Male2", "models/Humans/Group01/Male_02.mdl" )
list.Set ( "NPCModelList_Human", "Male3", "models/Humans/Group01/Male_03.mdl" )
list.Set ( "NPCModelList_Human", "Male4", "models/Humans/Group01/Male_04.mdl" )
list.Set ( "NPCModelList_Human", "Male5", "models/Humans/Group01/Male_05.mdl" )
list.Set ( "NPCModelList_Human", "Male6", "models/Humans/Group01/Male_06.mdl" )
list.Set ( "NPCModelList_Human", "Male7", "models/Humans/Group01/Male_07.mdl" )
list.Set ( "NPCModelList_Human", "Male8", "models/Humans/Group01/Male_08.mdl" )
list.Set ( "NPCModelList_Human", "Male9", "models/Humans/Group01/Male_09.mdl" )
list.Set ( "NPCModelList_Human", "Male10", "models/Humans/Group01/Male_Cheaple.mdl" )

list.Set ( "NPCModelList_Human", "Male11", "models/Humans/Group02/Male_01.mdl" )
list.Set ( "NPCModelList_Human", "Male12", "models/Humans/Group02/Male_02.mdl" )
list.Set ( "NPCModelList_Human", "Male13", "models/Humans/Group02/Male_03.mdl" )
list.Set ( "NPCModelList_Human", "Male14", "models/Humans/Group02/Male_04.mdl" )
list.Set ( "NPCModelList_Human", "Male15", "models/Humans/Group02/Male_05.mdl" )
list.Set ( "NPCModelList_Human", "Male16", "models/Humans/Group02/Male_06.mdl" )
list.Set ( "NPCModelList_Human", "Male17", "models/Humans/Group02/Male_07.mdl" )
list.Set ( "NPCModelList_Human", "Male18", "models/Humans/Group02/Male_08.mdl" )
list.Set ( "NPCModelList_Human", "Male19", "models/Humans/Group02/Male_09.mdl" )

list.Set ( "NPCModelList_Human", "Male20", "models/Humans/Group03/Male_01.mdl" )
list.Set ( "NPCModelList_Human", "Male21", "models/Humans/Group03/Male_02.mdl" )
list.Set ( "NPCModelList_Human", "Male22", "models/Humans/Group03/Male_03.mdl" )
list.Set ( "NPCModelList_Human", "Male23", "models/Humans/Group03/Male_04.mdl" )
list.Set ( "NPCModelList_Human", "Male24", "models/Humans/Group03/Male_05.mdl" )
list.Set ( "NPCModelList_Human", "Male25", "models/Humans/Group03/Male_06.mdl" )
list.Set ( "NPCModelList_Human", "Male26", "models/Humans/Group03/Male_07.mdl" )
list.Set ( "NPCModelList_Human", "Male27", "models/Humans/Group03/Male_08.mdl" )
list.Set ( "NPCModelList_Human", "Male28", "models/Humans/Group03/Male_09.mdl" )

list.Set ( "NPCModelList_Human", "CMale1", "models/Humans/Group03m/Male_01.mdl" )
list.Set ( "NPCModelList_Human", "CMale2", "models/Humans/Group03m/Male_02.mdl" )
list.Set ( "NPCModelList_Human", "CMale3", "models/Humans/Group03m/Male_03.mdl" )
list.Set ( "NPCModelList_Human", "CMale4", "models/Humans/Group03m/Male_04.mdl" )
list.Set ( "NPCModelList_Human", "CMale5", "models/Humans/Group03m/Male_05.mdl" )
list.Set ( "NPCModelList_Human", "CMale6", "models/Humans/Group03m/Male_06.mdl" )
list.Set ( "NPCModelList_Human", "CMale7", "models/Humans/Group03m/Male_07.mdl" )
list.Set ( "NPCModelList_Human", "CMale8", "models/Humans/Group03m/Male_08.mdl" )
list.Set ( "NPCModelList_Human", "CMale9", "models/Humans/Group03m/Male_09.mdl" )

list.Set ( "NPCModelList_Human", "Police", "models/Police.mdl" )
list.Set ( "NPCModelList_Human", "Combine Super Soldier", "models/Combine_Super_Soldier.mdl" )
list.Set ( "NPCModelList_Human", "Combine PrisonGuard", "models/Combine_Soldier_PrisonGuard.mdl" )
list.Set ( "NPCModelList_Human", "Combine Soldier", "models/Combine_Soldier.mdl" )

list.Set ( "NPCModelList_Alien", "Headcrab", "models/headcrab.mdl" )
list.Set ( "NPCModelList_Alien", "Headcrab Black", "models/headcrabblack.mdl" )
list.Set ( "NPCModelList_Alien", "Lamarr", "models/Lamarr.mdl" )
list.Set ( "NPCModelList_Alien", "Zombie", "models/Zombie/Classic.mdl" )
list.Set ( "NPCModelList_Alien", "Zombie Torso", "models/Zombie/Classic_torso.mdl" )
list.Set ( "NPCModelList_Alien", "Fast Zombie", "models/Zombie/Fast.mdl" )
list.Set ( "NPCModelList_Alien", "Zombie Poison", "models/Zombie/Poison.mdl" )

list.Set ( "NPCModelList_Alien", "Antlion", "models/AntLion.mdl" )
list.Set ( "NPCModelList_Alien", "Antlion Guard", "models/antlion_guard.mdl" )

// Lista de Animacoes

list.Set( "PlayerOptionsAnimations", "gman", { "menu_gman" } )

list.Set( "PlayerOptionsAnimations", "hostage01", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage02", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage03", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage04", { "idle_all_scared" } )

list.Set( "PlayerOptionsAnimations", "zombine", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "corpse", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "zombiefast", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "zombie", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "skeleton", { "menu_zombie_01" } )

list.Set( "PlayerOptionsAnimations", "combine", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "combineprison", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "combineelite", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "police", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "policefem", { "menu_combine" } )

list.Set( "PlayerOptionsAnimations", "css_arctic", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_gasmask", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_guerilla", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_leet", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_phoenix", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_riot", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_swat", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_urban", { "pose_standing_02", "idle_fist" } )

end
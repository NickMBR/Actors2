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
local RedBtnHover, RedBtnTextHover, WhiteBtnHover, WhiteBtnTextHover, BlueBtnHover, BlueBtnTextHover, GreenBtnHover, GreenBtnTextHover = Color( 35, 35, 35, 255 )
local ActorSettings = {}

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Open the Panel
-- ## ------------------------------------------------------------------------------ ## --
function OpenActorSettingsPanel( pathp )

ActorSettings.Model = ActorSettings.Model or "models/alyx.mdl"

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
        ListCustom:SetText( ActorSettings.Model )
        mdl:SetModel( ActorSettings.Model )
        mdl.Entity:SetPos( Vector( -120, 0, -55 ) )

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

        MdlSelect:AddPanel( icon )

        -- When clicked, update the model
        icon.DoClick = function()
            ActorSettings.Model = model
            UpdateFromConvars()
        end
    end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Fade Functions with Search
-- ## ------------------------------------------------------------------------------ ## --
function fadePanelAlpha( str, search_str )
    if IsValid( MdlSelect ) then MdlSelect:Remove() end
    if IsValid( ModelListBase ) then
        ModelListBase:AlphaTo( 0, 0, 0 )
        ModelListBase:AlphaTo( 255, 1, 0 )

        local HC_ModelList = list.Get( "NPCModelList_Default" )
        local NPC_NiceList = list.Get( "FormatedNPCList" )
        local PlyModelsList = player_manager.AllValidModels()

        local npc_list = table.Merge( HC_ModelList, NPC_NiceList )
        local SearchTable = table.Merge( npc_list, PlyModelsList )

        local ResultList = {}

        if str == "npcs" then
            CreateModelList( npc_list )
        elseif str == "plymodels" then
            CreateModelList( PlyModelsList )
        elseif str == "search" then
            for k, v in SortedPairs( SearchTable ) do
                if string.find( v, search_str, 0, true ) or string.find( k, search_str, 0, true ) then
                     table.insert(ResultList, v)
                end
            end
            CreateModelList( ResultList )
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

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Actor List - Buttons Container
-- ## ------------------------------------------------------------------------------ ## --
local ButtonListBase = vgui.Create( "DPanel", Base )
ButtonListBase:SetPos( ( Base:GetWide()-Base:GetWide()/2 )-100, 35 )
ButtonListBase:SetSize( Base:GetWide()/2+90, 80 )
ButtonListBase:SetPaintBackground( false )

ButtonListBase.Paint = function()
    surface.SetTextColor( 210, 210, 210, 255 )
    surface.SetFont( "AC2_F20" )
    surface.SetTextPos( 0, 5 )
	surface.DrawText( AC2_LANG[A2LANG]["ac2_panelset_filterby"] )

    surface.SetTextPos( 375, 5 )
	surface.DrawText( AC2_LANG[A2LANG]["ac2_panelset_inputcustom"] )
end

-- Npcs Models Button
local ListBtnMain = vgui.Create( "DButton", ButtonListBase )
ListBtnMain:SetPos( 0, 30 )
ListBtnMain:SetText( "" )
ListBtnMain:SetSize( 60, 30 )
ListBtnMain.DoClick = function()
	fadePanelAlpha( "npcs", "" )
end
ListBtnMain.Paint = function()
    ButtonHover( ListBtnMain, "blue" )
    surface.SetDrawColor( BlueBtnHover )
    surface.DrawRect( 0, 0, ListBtnMain:GetWide(), ListBtnMain:GetTall() )

    draw.SimpleText( "NPCs", "AC2_F15", 30, 15, BlueBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- Player Models Button
local ListBtnPlyModls = vgui.Create( "DButton", ButtonListBase )
ListBtnPlyModls:SetPos( 65, 30 )
ListBtnPlyModls:SetText( "" )
ListBtnPlyModls:SetSize( 100, 30 )
ListBtnPlyModls.DoClick = function()
	fadePanelAlpha( "plymodels", "" )
end
ListBtnPlyModls.Paint = function()
    ButtonHover( ListBtnPlyModls, "blue" )
    surface.SetDrawColor( BlueBtnHover )
    surface.DrawRect( 0, 0, ListBtnPlyModls:GetWide(), ListBtnPlyModls:GetTall() )

    draw.SimpleText( "PlayerModels", "AC2_F15", 50, 15, BlueBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- Search Models TextBox
local ListSearch = vgui.Create( "DTextEntry", ButtonListBase ) -- create the form as a child of frame
ListSearch:SetPos( 170, 30 )
ListSearch:SetSize( 200, 30 )
ListSearch:SetText( AC2_LANG[A2LANG]["ac2_panelset_search"] )
ListSearch:SetFont( "AC2_F15" )
ListSearch:SetUpdateOnType( true )
ListSearch.OnEnter = function( self )
    if self:GetValue() != "" then
	    fadePanelAlpha( "search", self:GetValue() )
    end
end

ListSearch.OnValueChange = function ( self )
	fadePanelAlpha( "search", self:GetValue() )
end

ListSearch.OnGetFocus = function( self )
	if self:GetValue() == AC2_LANG[A2LANG]["ac2_panelset_search"] then
        self:SetText( "" )
    end
end

ListSearch.Paint = function( self )
    ButtonHover( ListSearch, "blue" )
	surface.SetDrawColor( BlueBtnHover )
    surface.DrawRect( 0, 0, ListSearch:GetWide(), ListSearch:GetTall() )

    self:DrawTextEntryText( Color(210,210,210), Color(35,35,35), Color(210,210,210) )
end

-- Custom Model TextBox
ListCustom = vgui.Create( "DTextEntry", ButtonListBase ) -- create the form as a child of frame
ListCustom:SetPos( 375, 30 )
ListCustom:SetSize( 370, 30 )
ListCustom:SetText( ActorSettings.Model )
ListCustom:SetFont( "AC2_F15" )
ListCustom.OnEnter = function( self )
    if self:GetValue() != "" then
	    ActorSettings.Model = self:GetValue()
        UpdateFromConvars()
    end
end

ListCustom.Paint = function( self )
    ButtonHover( ListCustom, "blue" )
	surface.SetDrawColor( BlueBtnHover )
    surface.DrawRect( 0, 0, ListCustom:GetWide(), ListCustom:GetTall() )

    self:DrawTextEntryText( Color(210,210,210), Color(35,35,35), Color(210,210,210) )
end

-- Next Button
-- Npcs Models Button
local ListBtnNext = vgui.Create( "DButton", ButtonListBase )
ListBtnNext:SetPos( 750, 30 )
ListBtnNext:SetText( "" )
ListBtnNext:SetSize( 150, 30 )
ListBtnNext.DoClick = function()
	chat.AddText("next")
end
ListBtnNext.Paint = function()
    ButtonHover( ListBtnNext, "green" )
    surface.SetDrawColor( GreenBtnHover )
    surface.DrawRect( 0, 0, ListBtnNext:GetWide(), ListBtnNext:GetTall() )

    draw.SimpleText( "Next", "AC2_F15", 72.5, 15, GreenBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Makes the model list container
-- ## ------------------------------------------------------------------------------ ## --
ModelListBase = vgui.Create( "DPanel", Base )
ModelListBase:SetPos( ( Base:GetWide()-Base:GetWide()/2 )-100, 105 )
ModelListBase:SetSize( Base:GetWide()/2+90, Base:GetTall()-120 )
ModelListBase:SetPaintBackground( false )

if IsValid(ModelListBase) then 
    fadePanelAlpha( "npcs", "" )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- The bodygroup base container
-- ## ------------------------------------------------------------------------------ ## --
BodygroupBase = vgui.Create( "DPanel", Base )
BodygroupBase:SetPos( 10, 40 )
BodygroupBase:SetSize( Base:GetWide()/8, Base:GetTall()-50 )
BodygroupBase:SetPaintBackground( true )


-- Opens It!
Base:MakePopup()
UpdateFromConvars()

end -- End OpenPanel function

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Debug
-- ## ------------------------------------------------------------------------------ ## --

--[[if IsValid(Base) then
    timer.Simple(5, function()
        Base:Remove()
    end)
end]]--

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Default Hardcoded and NPC lists 
-- ## ------------------------------------------------------------------------------ ## --
for k, v in SortedPairs( list.Get( "NPC" ) ) do
    list.Set( "FormatedNPCList", k, v.Model)
end

list.Set ( "NPCModelList_Default", "Mossman", "models/mossman.mdl" )
list.Set ( "NPCModelList_Default", "Alyx", "models/alyx.mdl" )
list.Set ( "NPCModelList_Default", "Barney", "models/Barney.mdl" )
list.Set ( "NPCModelList_Default", "Breen", "models/breen.mdl" )
list.Set ( "NPCModelList_Default", "Eli", "models/Eli.mdl" )
list.Set ( "NPCModelList_Default", "Gman", "models/gman_high.mdl" )
list.Set ( "NPCModelList_Default", "Kleiner", "models/Kleiner.mdl" )
list.Set ( "NPCModelList_Default", "Monk", "models/monk.mdl" )
list.Set ( "NPCModelList_Default", "Odessa", "models/odessa.mdl" )
list.Set ( "NPCModelList_Default", "Vortigaunt", "models/vortigaunt.mdl" )
list.Set ( "NPCModelList_Default", "Dog", "models/dog.mdl" )

list.Set ( "NPCModelList_Default", "Female1", "models/Humans/Group01/Female_01.mdl" )
list.Set ( "NPCModelList_Default", "Female2", "models/Humans/Group01/Female_02.mdl" )
list.Set ( "NPCModelList_Default", "Female3", "models/Humans/Group01/Female_03.mdl" )
list.Set ( "NPCModelList_Default", "Female4", "models/Humans/Group01/Female_04.mdl" )
list.Set ( "NPCModelList_Default", "Female5", "models/Humans/Group01/Female_06.mdl" )
list.Set ( "NPCModelList_Default", "Female6", "models/Humans/Group01/Female_07.mdl" )

list.Set ( "NPCModelList_Default", "Female7", "models/Humans/Group02/Female_01.mdl" )
list.Set ( "NPCModelList_Default", "Female8", "models/Humans/Group02/Female_02.mdl" )
list.Set ( "NPCModelList_Default", "Female9", "models/Humans/Group02/Female_03.mdl" )
list.Set ( "NPCModelList_Default", "Female10", "models/Humans/Group02/Female_04.mdl" )
list.Set ( "NPCModelList_Default", "Female11", "models/Humans/Group02/Female_06.mdl" )
list.Set ( "NPCModelList_Default", "Female12", "models/Humans/Group02/Female_07.mdl" )

list.Set ( "NPCModelList_Default", "Female13", "models/Humans/Group03/Female_01.mdl" )
list.Set ( "NPCModelList_Default", "Female14", "models/Humans/Group03/Female_02.mdl" )
list.Set ( "NPCModelList_Default", "Female15", "models/Humans/Group03/Female_03.mdl" )
list.Set ( "NPCModelList_Default", "Female16", "models/Humans/Group03/Female_04.mdl" )
list.Set ( "NPCModelList_Default", "Female17", "models/Humans/Group03/Female_06.mdl" )
list.Set ( "NPCModelList_Default", "Female18", "models/Humans/Group03/Female_07.mdl" )

list.Set ( "NPCModelList_Default", "CFemale1", "models/Humans/Group03m/Female_01.mdl" )
list.Set ( "NPCModelList_Default", "CFemale2", "models/Humans/Group03m/Female_02.mdl" )
list.Set ( "NPCModelList_Default", "CFemale3", "models/Humans/Group03m/Female_03.mdl" )
list.Set ( "NPCModelList_Default", "CFemale4", "models/Humans/Group03m/Female_04.mdl" )
list.Set ( "NPCModelList_Default", "CFemale5", "models/Humans/Group03m/Female_06.mdl" )
list.Set ( "NPCModelList_Default", "CFemale6", "models/Humans/Group03m/Female_07.mdl" )

list.Set ( "NPCModelList_Default", "Male1", "models/Humans/Group01/Male_01.mdl" )
list.Set ( "NPCModelList_Default", "Male2", "models/Humans/Group01/Male_02.mdl" )
list.Set ( "NPCModelList_Default", "Male3", "models/Humans/Group01/Male_03.mdl" )
list.Set ( "NPCModelList_Default", "Male4", "models/Humans/Group01/Male_04.mdl" )
list.Set ( "NPCModelList_Default", "Male5", "models/Humans/Group01/Male_05.mdl" )
list.Set ( "NPCModelList_Default", "Male6", "models/Humans/Group01/Male_06.mdl" )
list.Set ( "NPCModelList_Default", "Male7", "models/Humans/Group01/Male_07.mdl" )
list.Set ( "NPCModelList_Default", "Male8", "models/Humans/Group01/Male_08.mdl" )
list.Set ( "NPCModelList_Default", "Male9", "models/Humans/Group01/Male_09.mdl" )
list.Set ( "NPCModelList_Default", "Male10", "models/Humans/Group01/Male_Cheaple.mdl" )

list.Set ( "NPCModelList_Default", "Male11", "models/Humans/Group02/Male_01.mdl" )
list.Set ( "NPCModelList_Default", "Male12", "models/Humans/Group02/Male_02.mdl" )
list.Set ( "NPCModelList_Default", "Male13", "models/Humans/Group02/Male_03.mdl" )
list.Set ( "NPCModelList_Default", "Male14", "models/Humans/Group02/Male_04.mdl" )
list.Set ( "NPCModelList_Default", "Male15", "models/Humans/Group02/Male_05.mdl" )
list.Set ( "NPCModelList_Default", "Male16", "models/Humans/Group02/Male_06.mdl" )
list.Set ( "NPCModelList_Default", "Male17", "models/Humans/Group02/Male_07.mdl" )
list.Set ( "NPCModelList_Default", "Male18", "models/Humans/Group02/Male_08.mdl" )
list.Set ( "NPCModelList_Default", "Male19", "models/Humans/Group02/Male_09.mdl" )

list.Set ( "NPCModelList_Default", "Male20", "models/Humans/Group03/Male_01.mdl" )
list.Set ( "NPCModelList_Default", "Male21", "models/Humans/Group03/Male_02.mdl" )
list.Set ( "NPCModelList_Default", "Male22", "models/Humans/Group03/Male_03.mdl" )
list.Set ( "NPCModelList_Default", "Male23", "models/Humans/Group03/Male_04.mdl" )
list.Set ( "NPCModelList_Default", "Male24", "models/Humans/Group03/Male_05.mdl" )
list.Set ( "NPCModelList_Default", "Male25", "models/Humans/Group03/Male_06.mdl" )
list.Set ( "NPCModelList_Default", "Male26", "models/Humans/Group03/Male_07.mdl" )
list.Set ( "NPCModelList_Default", "Male27", "models/Humans/Group03/Male_08.mdl" )
list.Set ( "NPCModelList_Default", "Male28", "models/Humans/Group03/Male_09.mdl" )

list.Set ( "NPCModelList_Default", "CMale1", "models/Humans/Group03m/Male_01.mdl" )
list.Set ( "NPCModelList_Default", "CMale2", "models/Humans/Group03m/Male_02.mdl" )
list.Set ( "NPCModelList_Default", "CMale3", "models/Humans/Group03m/Male_03.mdl" )
list.Set ( "NPCModelList_Default", "CMale4", "models/Humans/Group03m/Male_04.mdl" )
list.Set ( "NPCModelList_Default", "CMale5", "models/Humans/Group03m/Male_05.mdl" )
list.Set ( "NPCModelList_Default", "CMale6", "models/Humans/Group03m/Male_06.mdl" )
list.Set ( "NPCModelList_Default", "CMale7", "models/Humans/Group03m/Male_07.mdl" )
list.Set ( "NPCModelList_Default", "CMale8", "models/Humans/Group03m/Male_08.mdl" )
list.Set ( "NPCModelList_Default", "CMale9", "models/Humans/Group03m/Male_09.mdl" )

list.Set ( "NPCModelList_Default", "Police", "models/Police.mdl" )
list.Set ( "NPCModelList_Default", "Combine Super Soldier", "models/Combine_Super_Soldier.mdl" )
list.Set ( "NPCModelList_Default", "Combine PrisonGuard", "models/Combine_Soldier_PrisonGuard.mdl" )
list.Set ( "NPCModelList_Default", "Combine Soldier", "models/Combine_Soldier.mdl" )

list.Set ( "NPCModelList_Default", "Headcrab", "models/headcrab.mdl" )
list.Set ( "NPCModelList_Default", "Headcrab Black", "models/headcrabblack.mdl" )
list.Set ( "NPCModelList_Default", "Lamarr", "models/Lamarr.mdl" )
list.Set ( "NPCModelList_Default", "Zombie", "models/Zombie/Classic.mdl" )
list.Set ( "NPCModelList_Default", "Zombie Torso", "models/Zombie/Classic_torso.mdl" )
list.Set ( "NPCModelList_Default", "Fast Zombie", "models/Zombie/Fast.mdl" )
list.Set ( "NPCModelList_Default", "Zombie Poison", "models/Zombie/Poison.mdl" )

list.Set ( "NPCModelList_Default", "Antlion", "models/AntLion.mdl" )
list.Set ( "NPCModelList_Default", "Antlion Guard", "models/antlion_guard.mdl" )

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
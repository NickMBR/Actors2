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

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Variables
-- ## ------------------------------------------------------------------------------ ## --
ActorSettings.Model = ActorSettings.Model or "models/alyx.mdl"
ActorSettings.Skin = ActorSettings.Skin or 0
ActorSettings.Bodygroup = ActorSettings.Bodygroup or "0"

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
    
    BuildPageTwo()
    Page2Container:AlphaTo( 0, 0, 0 )
    Page2Container:SetMouseInputEnabled( false )
    -- Sets the entity to Draw
    if IsValid( mdl ) then
        ListCustom:SetText( ActorSettings.Model )
        mdl:SetModel( ActorSettings.Model )
        mdl.Entity:SetPos( Vector( -120, 0, -55 ) )
        mdl.Entity:SetSkin( ActorSettings.Skin )

        RebuildBodygroupTab()

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
            ActorSettings.Skin = 0
            ActorSettings.Bodygroup = "0"

            UpdateFromConvars()
            RebuildBodygroupTab()
        end
    end
end


-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Fade Functions with Search
-- ## ------------------------------------------------------------------------------ ## --
local HC_ModelList = list.Get( "Def_NPCList" )
local NPC_NiceList = list.Get( "FormatedNPCList" )
local PlyModelsList = player_manager.AllValidModels()

function fadePanelAlpha( str, search_str )
    if IsValid( MdlSelect ) then MdlSelect:Remove() end
    if IsValid( ModelListBase ) then
        ModelListBase:AlphaTo( 0, 0, 0 )
        ModelListBase:AlphaTo( 255, 1, 0 )

        if str == "npcs" then
            local npc_list = table.Merge( NPC_NiceList, HC_ModelList )
            CreateModelList( npc_list )
        end
        if str == "plymodels" then
            CreateModelList( PlyModelsList )
        end
        if str == "search" then
            local all_npc_list = table.Merge( NPC_NiceList, HC_ModelList )
            local SearchTable = table.Merge( all_npc_list, PlyModelsList )
            local ResultList = {}

            local lower_searchstr = string.lower( search_str )

            for k, v in SortedPairs( SearchTable ) do
                if string.find( string.lower( v ), lower_searchstr, 0, true ) or string.find( string.lower( k ), lower_searchstr, 0, true ) then
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
ButtonListBase:SetPos( ( Base:GetWide()-Base:GetWide()/2 )-100, 40 )
ButtonListBase:SetSize( Base:GetWide()/2+90, 50 )
ButtonListBase:SetPaintBackground( false )

--[[ButtonListBase.Paint = function()
    surface.SetDrawColor( 60, 60, 60, 255 )
    surface.DrawRect( 0, 0, Base:GetWide(), Base:GetTall() )

    surface.SetTextColor( 210, 210, 210, 255 )
    surface.SetFont( "AC2_F20" )
    surface.SetTextPos( 0, 5 )
	surface.DrawText( AC2_LANG[A2LANG]["ac2_panelset_filterby"] )

    surface.SetTextPos( 375, 5 )
	surface.DrawText( AC2_LANG[A2LANG]["ac2_panelset_inputcustom"] )
end]]--

-- Npcs Models Button
local ListBtnMain = vgui.Create( "DButton", ButtonListBase )
ListBtnMain:SetPos( 0, 0 )
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
ListBtnPlyModls:SetPos( 65, 0 )
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
local ListSearch = vgui.Create( "DTextEntry", ButtonListBase )
ListSearch:SetPos( 170, 0 )
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
ListCustom = vgui.Create( "DTextEntry", ButtonListBase )
ListCustom:SetPos( 375, 0 )
ListCustom:SetSize( 370, 30 )
ListCustom:SetText( ActorSettings.Model )
ListCustom:SetFont( "AC2_F15" )
ListCustom.OnEnter = function( self )
    if self:GetValue() != "" then
	    ActorSettings.Model = self:GetValue()
        UpdateFromConvars()
        RebuildBodygroupTab()
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
ListBtnNext:SetPos( 750, 0 )
ListBtnNext:SetText( "" )
ListBtnNext:SetSize( 150, 30 )
ListBtnNext.DoClick = function()
    surface.PlaySound( "ui/csgo_ui_contract_type4.wav" )
    timer.Simple(0.1, function() 
        ButtonListBase:SetMouseInputEnabled( false )
        ModelListBase:SetMouseInputEnabled( false )

        ButtonListBase:AlphaTo( 0, 0.5, 0 )
        ModelListBase:AlphaTo( 0, 0.5, 0 )
    end)

    timer.Simple(0.5, function()
        Page2Container:AlphaTo( 255, 0.5, 0 )
        Page2Container:SetMouseInputEnabled( true )
    end)
end
ListBtnNext.Paint = function()
    ButtonHover( ListBtnNext, "green" )
    surface.SetDrawColor( GreenBtnHover )
    surface.DrawRect( 0, 0, ListBtnNext:GetWide(), ListBtnNext:GetTall() )

    draw.SimpleText( AC2_LANG[A2LANG]["ac2_panelset_btnnext"], "AC2_F15", 72.5, 15, GreenBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Makes the model list container
-- ## ------------------------------------------------------------------------------ ## --
ModelListBase = vgui.Create( "DPanel", Base )
ModelListBase:SetPos( ( Base:GetWide()-Base:GetWide()/2 )-100, 80 )
ModelListBase:SetSize( Base:GetWide()/2+90, Base:GetTall()-90 )
ModelListBase:SetPaintBackground( false )

if IsValid(ModelListBase) then 
    fadePanelAlpha( "npcs", "" )
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- The bodygroup base container
-- ## ------------------------------------------------------------------------------ ## --
local BodygroupBase = vgui.Create( "DScrollPanel", ModelBase )
BodygroupBase:SetSize( ModelBase:GetWide()/4, ModelBase:GetTall())
BodygroupBase:SetPos( 0, 0 )
BodygroupBase:SetPaintBackground( false )

BodygroupBase.Paint = function()
    surface.SetDrawColor( Color( 60, 60, 60, 255) )
    surface.DrawRect( 0, 0, BodygroupBase:GetWide()-50, BodygroupBase:GetTall() )
end

BodygroupBase:SetVisible( false )

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Page 2
-- ## ------------------------------------------------------------------------------ ## --
function BuildPageTwo()

    -- Makes Page 2 container
    Page2Container = vgui.Create( "DPanel", Base )
    Page2Container:SetPos( ( Base:GetWide()-Base:GetWide()/2 )-100, 30 )
    Page2Container:SetSize( Base:GetWide()/2+90, Base:GetTall()-40 )
    Page2Container:SetPaintBackground( false )

    -- Back Button
    local ListBtnBack = vgui.Create( "DButton", Page2Container )
    ListBtnBack:SetPos( 0, 10 )
    ListBtnBack:SetText( "" )
    ListBtnBack:SetSize( 80, 30 )
    ListBtnBack.DoClick = function()
        surface.PlaySound( "ui/csgo_ui_contract_type4.wav" )
        timer.Simple(0.1, function() 
            Page2Container:AlphaTo( 0, 0.5, 0 )
            Page2Container:SetMouseInputEnabled( false )
        end)

        timer.Simple(0.5, function()
            ButtonListBase:SetMouseInputEnabled( true )
            ModelListBase:SetMouseInputEnabled( true )

            ButtonListBase:AlphaTo( 255, 0.5, 0 )
            ModelListBase:AlphaTo( 255, 0.5, 0 )
            
        end)
    end
    ListBtnBack.Paint = function()
        ButtonHover( ListBtnBack, "red" )
        surface.SetDrawColor( RedBtnHover )
        surface.DrawRect( 0, 0, ListBtnBack:GetWide(), ListBtnBack:GetTall() )

        draw.SimpleText( AC2_LANG[A2LANG]["ac2_panelset_btnback"], "AC2_F15", 40, 15, RedBtnTextHover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    -- Common Base Panel
    BtnSettingsContainer = vgui.Create( "DPanel", Page2Container )
    BtnSettingsContainer:SetPos( 0, 60 )
    BtnSettingsContainer:SetSize( 300, Page2Container:GetTall()-70 )
    BtnSettingsContainer:SetPaintBackground( false )
    BtnSettingsContainer:SetBackgroundColor( Color( 100, 100, 100, 255 ) )

    FancyLabel( 0, 0, "Common Settings:", "AC2_F20", Color( 210, 210, 210, 255 ), BtnSettingsContainer, 1, 0, 0, 0, 0)

    -- Toggleable Buttons (Works like checkboxes)
    -- Actor Collision
    local Tog = 0
    local TogBtn = FancyToggleButton( 0, 0, 50, 20, BtnSettingsContainer, Tog, "Collisions", 1, 0, 10, 0, 0 )
    TogBtn.DoClick = function( self )
        if Tog != 1 then Tog = 1 else Tog = 0 end
        FancyToggleButton_Update( TogBtn, Tog, 50, 20, "Collisions" )
    end

    local Tog = 0
    local TogBtn = FancyToggleButton( 0, 0, 50, 20, BtnSettingsContainer, Tog, "Damage", 1, 0, 2, 0, 0 )
    TogBtn.DoClick = function( self )
        if Tog != 1 then Tog = 1 else Tog = 0 end
        FancyToggleButton_Update( TogBtn, Tog, 50, 20, "Damage" )
    end

    local Tog = 0
    local TogBtn = FancyToggleButton( 0, 0, 50, 20, BtnSettingsContainer, Tog, "Repeat", 1, 0, 2, 0, 0 )
    TogBtn.DoClick = function( self )
        if Tog != 1 then Tog = 1 else Tog = 0 end
        FancyToggleButton_Update( TogBtn, Tog, 50, 20, "Repeat" )
    end

    FancyLabel( 0, 0, "Optional Settings:", "AC2_F20", Color( 210, 210, 210, 255 ), BtnSettingsContainer, 1, 0, 10, 0, 0)

    local Tog = 0
    local TogBtn = FancyToggleButton( 0, 0, 50, 20, BtnSettingsContainer, Tog, "Free Walk", 1, 0, 10, 0, 0 )
    TogBtn.DoClick = function( self )
        if Tog != 1 then Tog = 1 else Tog = 0 end
        FancyToggleButton_Update( TogBtn, Tog, 50, 20, "Free Walk" )
    end

    local Tog = 0
    local TogBtn = FancyToggleButton( 0, 0, 50, 20, BtnSettingsContainer, Tog, "Interactive", 1, 0, 2, 0, 0 )
    TogBtn.DoClick = function( self )
        if Tog != 1 then Tog = 1 else Tog = 0 end
        FancyToggleButton_Update( TogBtn, Tog, 50, 20, "Interactive" )
    end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Skins and Bodygroups sliders
-- ## ------------------------------------------------------------------------------ ## --
local function MakeNiceName( str )
    local newname = {}
    for _, s in pairs( string.Explode( "_", str ) ) do
        if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
        table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
    end

    return string.Implode( " ", newname )
end

local function UpdateBodyGroups( pnl, val )
    mdl.Entity:SetBodygroup( pnl.typenum, math.Round( val ) )

    local str = string.Explode( " ", ActorSettings.Bodygroup )
    if ( #str < pnl.typenum + 1 ) then for i = 1, pnl.typenum + 1 do str[ i ] = str[ i ] or 0 end end
    str[ pnl.typenum + 1 ] = math.Round( val )
    ActorSettings.Bodygroup = table.concat( str, " " )
end

function RebuildBodygroupTab()
    BodygroupBase:Clear()
    BodygroupBase:SetVisible( false )

    local nskin = mdl.Entity:SkinCount() - 1
    if ( nskin > 0 ) then

        FancyLabel( 10, 5, "Skin:", "AC2_F15", Color( 210, 210, 210, 255 ), BodygroupBase, 1, 5, 5, 5, 0)
        local skins = FancySlider( 10, 30, BodygroupBase:GetWide()+25, 10, BodygroupBase, 0, nskin, ActorSettings.Skin, "", 0)

        skins.OnValueChanged = function( self )
            ActorSettings.Skin = math.Round( self:GetValue() )
            mdl.Entity:SetSkin( ActorSettings.Skin )
        end

        BodygroupBase:SetVisible( true )
    end

    local groups = string.Explode( " ", ActorSettings.Bodygroup )
    for k = 0, mdl.Entity:GetNumBodyGroups() - 1 do
        if ( mdl.Entity:GetBodygroupCount( k ) <= 1 ) then continue end

        FancyLabel( 10, 25*(k+1), MakeNiceName( mdl.Entity:GetBodygroupName( k ) )..":", "AC2_F15", Color( 210, 210, 210, 255 ), BodygroupBase, 1, 5, 5, 5, 0)
        local bgroup = FancySlider( 10, 38*(k+1), BodygroupBase:GetWide()+25, 10, BodygroupBase, 0, mdl.Entity:GetBodygroupCount( k ) - 1, groups[ k + 1 ] or 0, "bgroup", k)
        bgroup.OnValueChanged = UpdateBodyGroups

        BodygroupBase:SetVisible( true )
    end
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Fancy Label
-- ## ------------------------------------------------------------------------------ ## --
function FancyLabel( x, y, text, font, col, parent, should_dock, m_l, m_t, m_r, m_b)
    local fancy_label = vgui.Create( "DLabel", parent )
    fancy_label:SetPos( x, y )
    if should_dock == 1 then fancy_label:Dock( TOP ) else fancy_label:Dock( NODOCK ) end
    fancy_label:DockMargin( m_l, m_t, m_r, m_b )
    fancy_label:SetText( text )
    fancy_label:SetFont( font )
    fancy_label:SetTextColor( col )
    fancy_label:SizeToContents()
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Fancy Toggleable Button
-- ## ------------------------------------------------------------------------------ ## --
function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

function FancyToggleButton_Update( btn, togvar, wi, he, str )
    if IsValid( btn ) then
        btn.Paint = function( self, w, h )
            if togvar == 0 then
                surface.SetDrawColor( 200, 90, 75, 255 )
                surface.DrawRect( 0, 0, wi/2, he )
            else
                surface.SetDrawColor( 75, 200, 90, 255 )
                surface.DrawRect( wi/2, 0, wi/2, he )
            end

            surface.SetTextColor( 210, 210, 210, 255 )
            surface.SetFont( "AC2_F15" )
            surface.SetTextPos( 60, 2 )
            surface.DrawText( str )

            draw.OutlinedBox( 0, 0, wi, he, 2, Color(80, 80, 80, 255))
        end
    end
end

function FancyToggleButton( x, y, wi, he, parent, togvar, str, should_dock, m_l, m_t, m_r, m_b)
    local toggle_button = vgui.Create( "DButton", parent )
    toggle_button:SetPos( x, y )
    toggle_button:SetText( "" )
    toggle_button:SetSize( wi, he )
    if should_dock == 1 then toggle_button:Dock( TOP ) else toggle_button:Dock( NODOCK ) end
    toggle_button:DockMargin( m_l, m_t, m_r, m_b )

    FancyToggleButton_Update( toggle_button, togvar, wi, he, str )

    --[[toggle_button.Paint = function()
        if togvar == 0 then
            surface.SetDrawColor( 200, 90, 75, 255 )
            surface.DrawRect( 0, 0, wi/2, he )
        else
            surface.SetDrawColor( 75, 200, 90, 255 )
            surface.DrawRect( wi/2, 0, wi/2, he )
        end
        draw.OutlinedBox( 0, 0, wi, he, 2, Color(80, 80, 80, 255))
    end]]--

    return toggle_button
end

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Fancy Slider
-- ## ------------------------------------------------------------------------------ ## --
function FancySlider( x, y, w, h, parent, min, max, val, typ, typnum)
    local fancy_slider = vgui.Create( "DNumSlider", parent )
    fancy_slider:SetSize( w, h )
    fancy_slider:Dock( TOP )
    fancy_slider:DockMargin( 5, 5, 5, 5 )
    fancy_slider:SetPos( x, y )
    fancy_slider:SetText( "" )
    fancy_slider:SetMinMax( min, max )
    fancy_slider:SetDecimals( 0 )
    fancy_slider:SetDark( false )
    fancy_slider:SetValue( val )

    fancy_slider.type = typ
	fancy_slider.typenum = typnum

    fancy_slider.TextArea:SetFont( 'AC2_F15' )
    fancy_slider.TextArea:SetTextColor( 210, 210, 210, 255 )

    fancy_slider.Label:Dock( NODOCK )
    fancy_slider.Label:SetSize( 0, 0 )

    fancy_slider.Scratch:SetParent( fancy_slider.TextArea )
    fancy_slider.Scratch:Dock( RIGHT )

    fancy_slider.Slider.Paint = function( self, w, h )
        surface.SetDrawColor( 210, 210, 210, 255 )
        surface.DrawRect( 3, 3, w-10, h-8 )
    end

    fancy_slider.Slider.Knob.Paint = function( self, w, h )
        surface.SetDrawColor( 75, 120, 200, 255 )
        surface.DrawRect( 0, -2, w-7, h )
    end

    return fancy_slider
end


-- ## ----------------------------------- Actors2 ---------------------------------- ## --
-- Opens and updates it!
-- ## ------------------------------------------------------------------------------ ## --
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
list.Set ( "Def_NPCList", "Mossman", "models/mossman.mdl" )
list.Set ( "Def_NPCList", "Alyx", "models/alyx.mdl" )
list.Set ( "Def_NPCList", "Barney", "models/Barney.mdl" )
list.Set ( "Def_NPCList", "Breen", "models/breen.mdl" )
list.Set ( "Def_NPCList", "Eli", "models/Eli.mdl" )
list.Set ( "Def_NPCList", "Gman", "models/gman_high.mdl" )
list.Set ( "Def_NPCList", "Kleiner", "models/Kleiner.mdl" )
list.Set ( "Def_NPCList", "Monk", "models/monk.mdl" )
list.Set ( "Def_NPCList", "Odessa", "models/odessa.mdl" )
list.Set ( "Def_NPCList", "Vortigaunt", "models/vortigaunt.mdl" )
list.Set ( "Def_NPCList", "Dog", "models/dog.mdl" )

list.Set ( "Def_NPCList", "Female1", "models/Humans/Group01/Female_01.mdl" )
list.Set ( "Def_NPCList", "Female2", "models/Humans/Group01/Female_02.mdl" )
list.Set ( "Def_NPCList", "Female3", "models/Humans/Group01/Female_03.mdl" )
list.Set ( "Def_NPCList", "Female4", "models/Humans/Group01/Female_04.mdl" )
list.Set ( "Def_NPCList", "Female5", "models/Humans/Group01/Female_06.mdl" )
list.Set ( "Def_NPCList", "Female6", "models/Humans/Group01/Female_07.mdl" )

list.Set ( "Def_NPCList", "Female7", "models/Humans/Group02/Female_01.mdl" )
list.Set ( "Def_NPCList", "Female8", "models/Humans/Group02/Female_02.mdl" )
list.Set ( "Def_NPCList", "Female9", "models/Humans/Group02/Female_03.mdl" )
list.Set ( "Def_NPCList", "Female10", "models/Humans/Group02/Female_04.mdl" )
list.Set ( "Def_NPCList", "Female11", "models/Humans/Group02/Female_06.mdl" )
list.Set ( "Def_NPCList", "Female12", "models/Humans/Group02/Female_07.mdl" )

list.Set ( "Def_NPCList", "Female13", "models/Humans/Group03/Female_01.mdl" )
list.Set ( "Def_NPCList", "Female14", "models/Humans/Group03/Female_02.mdl" )
list.Set ( "Def_NPCList", "Female15", "models/Humans/Group03/Female_03.mdl" )
list.Set ( "Def_NPCList", "Female16", "models/Humans/Group03/Female_04.mdl" )
list.Set ( "Def_NPCList", "Female17", "models/Humans/Group03/Female_06.mdl" )
list.Set ( "Def_NPCList", "Female18", "models/Humans/Group03/Female_07.mdl" )

list.Set ( "Def_NPCList", "CFemale1", "models/Humans/Group03m/Female_01.mdl" )
list.Set ( "Def_NPCList", "CFemale2", "models/Humans/Group03m/Female_02.mdl" )
list.Set ( "Def_NPCList", "CFemale3", "models/Humans/Group03m/Female_03.mdl" )
list.Set ( "Def_NPCList", "CFemale4", "models/Humans/Group03m/Female_04.mdl" )
list.Set ( "Def_NPCList", "CFemale5", "models/Humans/Group03m/Female_06.mdl" )
list.Set ( "Def_NPCList", "CFemale6", "models/Humans/Group03m/Female_07.mdl" )

list.Set ( "Def_NPCList", "Male1", "models/Humans/Group01/Male_01.mdl" )
list.Set ( "Def_NPCList", "Male2", "models/Humans/Group01/Male_02.mdl" )
list.Set ( "Def_NPCList", "Male3", "models/Humans/Group01/Male_03.mdl" )
list.Set ( "Def_NPCList", "Male4", "models/Humans/Group01/Male_04.mdl" )
list.Set ( "Def_NPCList", "Male5", "models/Humans/Group01/Male_05.mdl" )
list.Set ( "Def_NPCList", "Male6", "models/Humans/Group01/Male_06.mdl" )
list.Set ( "Def_NPCList", "Male7", "models/Humans/Group01/Male_07.mdl" )
list.Set ( "Def_NPCList", "Male8", "models/Humans/Group01/Male_08.mdl" )
list.Set ( "Def_NPCList", "Male9", "models/Humans/Group01/Male_09.mdl" )
list.Set ( "Def_NPCList", "Male10", "models/Humans/Group01/Male_Cheaple.mdl" )

list.Set ( "Def_NPCList", "Male11", "models/Humans/Group02/Male_01.mdl" )
list.Set ( "Def_NPCList", "Male12", "models/Humans/Group02/Male_02.mdl" )
list.Set ( "Def_NPCList", "Male13", "models/Humans/Group02/Male_03.mdl" )
list.Set ( "Def_NPCList", "Male14", "models/Humans/Group02/Male_04.mdl" )
list.Set ( "Def_NPCList", "Male15", "models/Humans/Group02/Male_05.mdl" )
list.Set ( "Def_NPCList", "Male16", "models/Humans/Group02/Male_06.mdl" )
list.Set ( "Def_NPCList", "Male17", "models/Humans/Group02/Male_07.mdl" )
list.Set ( "Def_NPCList", "Male18", "models/Humans/Group02/Male_08.mdl" )
list.Set ( "Def_NPCList", "Male19", "models/Humans/Group02/Male_09.mdl" )

list.Set ( "Def_NPCList", "Male20", "models/Humans/Group03/Male_01.mdl" )
list.Set ( "Def_NPCList", "Male21", "models/Humans/Group03/Male_02.mdl" )
list.Set ( "Def_NPCList", "Male22", "models/Humans/Group03/Male_03.mdl" )
list.Set ( "Def_NPCList", "Male23", "models/Humans/Group03/Male_04.mdl" )
list.Set ( "Def_NPCList", "Male24", "models/Humans/Group03/Male_05.mdl" )
list.Set ( "Def_NPCList", "Male25", "models/Humans/Group03/Male_06.mdl" )
list.Set ( "Def_NPCList", "Male26", "models/Humans/Group03/Male_07.mdl" )
list.Set ( "Def_NPCList", "Male27", "models/Humans/Group03/Male_08.mdl" )
list.Set ( "Def_NPCList", "Male28", "models/Humans/Group03/Male_09.mdl" )

list.Set ( "Def_NPCList", "CMale1", "models/Humans/Group03m/Male_01.mdl" )
list.Set ( "Def_NPCList", "CMale2", "models/Humans/Group03m/Male_02.mdl" )
list.Set ( "Def_NPCList", "CMale3", "models/Humans/Group03m/Male_03.mdl" )
list.Set ( "Def_NPCList", "CMale4", "models/Humans/Group03m/Male_04.mdl" )
list.Set ( "Def_NPCList", "CMale5", "models/Humans/Group03m/Male_05.mdl" )
list.Set ( "Def_NPCList", "CMale6", "models/Humans/Group03m/Male_06.mdl" )
list.Set ( "Def_NPCList", "CMale7", "models/Humans/Group03m/Male_07.mdl" )
list.Set ( "Def_NPCList", "CMale8", "models/Humans/Group03m/Male_08.mdl" )
list.Set ( "Def_NPCList", "CMale9", "models/Humans/Group03m/Male_09.mdl" )

list.Set ( "Def_NPCList", "Police", "models/Police.mdl" )
list.Set ( "Def_NPCList", "Combine Super Soldier", "models/Combine_Super_Soldier.mdl" )
list.Set ( "Def_NPCList", "Combine PrisonGuard", "models/Combine_Soldier_PrisonGuard.mdl" )
list.Set ( "Def_NPCList", "Combine Soldier", "models/Combine_Soldier.mdl" )

list.Set ( "Def_NPCList", "Headcrab", "models/headcrab.mdl" )
list.Set ( "Def_NPCList", "Headcrab Black", "models/headcrabblack.mdl" )
list.Set ( "Def_NPCList", "Lamarr", "models/Lamarr.mdl" )
list.Set ( "Def_NPCList", "Zombie", "models/Zombie/Classic.mdl" )
list.Set ( "Def_NPCList", "Zombie Torso", "models/Zombie/Classic_torso.mdl" )
list.Set ( "Def_NPCList", "Fast Zombie", "models/Zombie/Fast.mdl" )
list.Set ( "Def_NPCList", "Zombie Poison", "models/Zombie/Poison.mdl" )

list.Set ( "Def_NPCList", "Antlion", "models/AntLion.mdl" )
list.Set ( "Def_NPCList", "Antlion Guard", "models/antlion_guard.mdl" )

for k, v in SortedPairs( list.Get( "NPC" ) ) do
    list.Set( "FormatedNPCList", k, v.Model)
end

end -- End Client
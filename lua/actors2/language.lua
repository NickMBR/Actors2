-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Translations
-- ## ------------------------------------------------------------------------------ ## --
A2LANG = ""
AC2_LANG = {
	["en"] = {
		-- Path Maker Tool
		["ac2_tool_category"]				= "Actors2",
		["ac2_tool_pathmaker"]				= "Path Maker",
		["ac2_tool_pm_leftclick"]			= "Spawn Path Point",
		["ac2_tool_pm_leftclick1"]			= "Apply Rotation",
		["ac2_tool_pm_rightclick"]			= "Remove Path Point",
		["ac2_tool_pm_shiftreload"]			= "Toggle Selection Between Paths",
		["ac2_tool_pm_shiftleft"]			= "Change Path Facing Angle",
		["ac2_tool_pm_shiftleft1"]			= "Apply Locked Rotation",
		["ac2_tool_pm_reload"]				= "Add New Path",
		["ac2_tool_pm_info"]				= "Use the Context Menu for more options",
		["ac2_tool_pm_rotation"]			= "Press Shift to lock the rotation in 45 degrees",
		["ac2_tool_pm_desc"]				= "Creates the path of the Actors.",
		["ac2_tool_pm_remove_pathpnt"]		= "Removed Path Point",

		-- Properties
		["ac2_properties_ac2_editactor"]	= "Edit Actor",
		["ac2_properties_ac2_actionpoint"]	= "Transform to Action Point",
		["ac2_properties_ac2_editaction"]	= "Edit Action Point",

		-- Notifications
		["ac2_tool_pm_sel_nopatht"]			= "There's no Paths to Select",
		["ac2_tool_pm_sel_newpath"]			= "New Path was Added",
		["ac2_tool_pm_sel_newnopath"]		= "Active Path has no points, can't create new Path",
		["ac2_tool_pm_no_navmesh"]			= "This map doesn't have a Nav Mesh, Actors2 will not work correctly",

		-- Welcome Panel
		["ac2_welc_check_nav"]				= "No Navigation Mesh found",
		["ac2_welc_check_version"]			= "Addon is Out-of-Date",
		["ac2_welc_check_vers404"]			= "Addon version could not be found",

		-- Actor Settings Panel
		["ac2_panelset_title"]				= "Actor Settings",
		["ac2_panelset_btnclose"]			= "Close",
		["ac2_panelset_btnhelp"]			= "Help",
		["ac2_panelset_filterby"]			= "Filter By:",
		["ac2_panelset_search"]				= "Search...",
		["ac2_panelset_inputcustom"]		= "Model Path:",
		["ac2_panelset_btnnext"]			= "Next",
		["ac2_panelset_btnback"]			= "Go Back",

		-- Actor Path Settings Panel
		["ac2_panelpath_title"]				= "Path Settings",
		["ac2_panelpath_animations"]		= "Animations",
		["ac2_panelpath_animsettings"]		= "Animation Settings",
		["ac2_panelpath_sounds"]			= "Sounds",
	},
	["pt-BR"] = {
		-- Ferramenta de Trajeto
		["ac2_tool_category"]				= "Atores2",
		["ac2_tool_pathmaker"]				= "Trajeto",
		["ac2_tool_pm_leftclick"]			= "Adicionar Ponto de Trajeto",
		["ac2_tool_pm_leftclick1"]			= "Aplicar Rotação",
		["ac2_tool_pm_rightclick"]			= "Remover Ponto de Trajeto",
		["ac2_tool_pm_shiftreload"]			= "Alternar Seleção Entre Trajetos",
		["ac2_tool_pm_shiftleft"]			= "Trocar Ângulo de Visão do Trajeto",
		["ac2_tool_pm_shiftleft1"]			= "Aplicar Rotação Travada",
		["ac2_tool_pm_reload"]				= "Adicionar Novo Trajeto",
		["ac2_tool_pm_info"]				= "Use o Menu de Contexto para mais opções",
		["ac2_tool_pm_rotation"]			= "Pressione Shift para travar a rotação em 45 graus",
		["ac2_tool_pm_desc"]				= "Cria o trajeto para os Atores.",
		["ac2_tool_pm_remove_pathpnt"]		= "Ponto de Trajeto Removido",

		-- Propriedades
		["ac2_properties_ac2_editactor"]	= "Editar Ator",
		["ac2_properties_ac2_actionpoint"]	= "Transformar em Ponto de Ação",
		["ac2_properties_ac2_editaction"]	= "Editar Ponto de Ação",

		-- Notificações
		["ac2_tool_pm_sel_nopatht"]			= "Não há Trajetos para Selecionar",
		["ac2_tool_pm_sel_newpath"]			= "Novo Trajeto foi Adicionado",
		["ac2_tool_pm_sel_newnopath"]		= "O Trajeto atual não tem pontos, impossível criar novo Trajeto",
		["ac2_tool_pm_no_navmesh"]			= "Esse mapa não possui um Nav Mesh, Atores2 não funcionará corretamente",

		-- Painel de Boas Vindas
		["ac2_welc_check_nav"]				= "Navigation Mesh não encontrado",
		["ac2_welc_check_version"]			= "Addon está Desatualizado",
		["ac2_welc_check_vers404"]			= "Versão do addon não pode ser encontrada",

		-- Painel Configurações do Ator
		["ac2_panelset_title"]				= "Configurações do Ator",
		["ac2_panelset_btnclose"]			= "Fechar",
		["ac2_panelset_btnhelp"]			= "Ajuda",
		["ac2_panelset_filterby"]			= "Filtrar por:",
		["ac2_panelset_search"]				= "Pesquisar...",
		["ac2_panelset_inputcustom"]		= "Caminho do Modelo:",
		["ac2_panelset_btnnext"]			= "Próximo",
		["ac2_panelset_btnback"]			= "Voltar",

		-- Painel de Configurações do Ponto de Trajeto
		["ac2_panelpath_title"]				= "Configurações do Ponto de Trajeto",
		["ac2_panelpath_animations"]		= "Animações",
		["ac2_panelpath_animsettings"]		= "Configurações da Animação",
		["ac2_panelpath_sounds"]			= "Sons",
	}
}

-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Automatic Language Selection
	-- 1. If it is not supported by the array above the language is set to English.
-- ## ------------------------------------------------------------------------------ ## --
function checkLanguage( language )
	for k,v in SortedPairs( AC2_LANG ) do
		if k == language then
			return true
		end
	end
	return false
end

function loadDefaultLanguage()
	if ConVarExists( "ac2_language" ) then 
		if not checkLanguage( GetConVar( "gmod_language" ):GetString() ) then
			if CLIENT then GetConVar( "ac2_language" ):SetString( "en" ) end
			A2LANG = "en"
		else
			if CLIENT then GetConVar( "ac2_language" ):SetString( GetConVar( "gmod_language" ):GetString() ) end
			A2LANG = GetConVar( "ac2_language" ):GetString()
		end
	else
		A2LANG = "en"
	end
end

loadDefaultLanguage()

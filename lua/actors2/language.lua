-- ## ----------------------------------- Actors2 ---------------------------------- ## --
	-- Translations
-- ## ------------------------------------------------------------------------------ ## --
A2LANG = ""
AC2_LANG = {
	["en"] = {
		["ac2_tool_category"]				= "Actors2",
		["ac2_tool_pathmaker"]				= "Path Maker",
		["ac2_tool_pm_leftclick"]			= "Spawn Path Point",
		["ac2_tool_pm_rightclick"]			= "Remove Path Point",
		["ac2_tool_pm_shiftreload"]			= "Toggle Selection Between Paths",
		["ac2_tool_pm_reload"]				= "Add New Path",
		["ac2_tool_pm_info"]				= "Use the Context Menu for more options",
		["ac2_tool_pm_desc"]				= "Creates the path of the Actors.",
		["ac2_tool_pm_remove_pathpnt"]		= "Removed Path Point",
		["ac2_properties_ac2_editactor"]	= "Edit Actor",
		["ac2_properties_ac2_actionpoint"]	= "Transform to Action Point",
		["ac2_properties_ac2_editaction"]	= "Edit Action Point",
		["ac2_tool_pm_sel_nopatht"]			= "There's no Paths to Select",
	},
	["pt-BR"] = {
		["ac2_tool_category"]				= "Atores2",
		["ac2_tool_pathmaker"]				= "Trajeto",
		["ac2_tool_pm_leftclick"]			= "Adicionar Ponto de Trajeto",
		["ac2_tool_pm_rightclick"]			= "Remover Ponto de Trajeto",
		["ac2_tool_pm_shiftreload"]			= "Alternar Seleção Entre Trajetos",
		["ac2_tool_pm_reload"]				= "Adicionar Novo Trajeto",
		["ac2_tool_pm_info"]				= "Use o Menu de Contexto para mais opções",
		["ac2_tool_pm_desc"]				= "Cria o trajeto para os Atores.",
		["ac2_tool_pm_remove_pathpnt"]		= "Ponto de Trajeto Removido",
		["ac2_properties_ac2_editactor"]	= "Editar Ator",
		["ac2_properties_ac2_actionpoint"]	= "Transformar em Ponto de Ação",
		["ac2_properties_ac2_editaction"]	= "Editar Ponto de Ação",
		["ac2_tool_pm_sel_nopatht"]			= "Não há Trajetos para Selecionar",
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

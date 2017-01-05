A2LANGCL = ""
A2LANGSV = ""

AC2_LANG = {
	["en"] = {
		["ac2_tool_category"] 			= "Actors2",
		["ac2_tool_pathmaker"] 			= "Path Maker",
		["ac2_tool_pm_leftclick"] 		= "Spawn Path Point",
		["ac2_tool_pm_rightclick"] 		= "Remove Path Point",
		["ac2_tool_pm_reload"]			= "Transform aimed point into an Action Point",
		["ac2_tool_pm_info"]			= "Use the Context Menu for more options",
		["ac2_tool_pm_desc"]			= "Creates the path of the Actors.",
	},
	["pt-BR"] = {
		["ac2_tool_category"] 			= "Atores2",
		["ac2_tool_pathmaker"] 			= "Trajeto",
		["ac2_tool_pm_leftclick"] 		= "Adicionar Ponto de Trajeto",
		["ac2_tool_pm_rightclick"] 		= "Remover Ponto de Trajeto",
		["ac2_tool_pm_reload"] 			= "Transformar ponto mirado em um Ponto de Ação",
		["ac2_tool_pm_info"]			= "Use o Menu de Contexto para mais opções",
		["ac2_tool_pm_desc"]			= "Cria o trajeto para os Atores.",
	}
}

if CLIENT then
	local function checkLanguage( language )
		for k,v in SortedPairs( AC2_LANG ) do
			if k == language then
				return true
			end
		end
		return false
	end

	local function loadDefaultLanguage()
		if ConVarExists( "ac2_language" ) then
			A2LANG_TEMP = GetConVar( "gmod_language" ):GetString()
			if not checkLanguage( A2LANG_TEMP ) then
				GetConVar( "ac2_language" ):SetString( "en" )
				A2LANGCL = "en"
			else
				GetConVar( "ac2_language" ):SetString( A2LANG_TEMP )
				A2LANGCL = GetConVar( "ac2_language" ):GetString()
			end
		else
			A2LANGCL = "en"
		end
	end

	loadDefaultLanguage()
	hook.Add( "Initialize", "ac2_set_default_language", loadDefaultLanguage )

    net.Start( "AC2_LangServer" )
    net.WriteString( A2LANGCL )
    net.SendToServer()
end

if SERVER then
	util.AddNetworkString("AC2_LangServer")
	net.Receive( "AC2_LangServer",function()
		A2LANGSV = net.ReadString()
	end )
end

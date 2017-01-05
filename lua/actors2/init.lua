/*include("actors2/language.lua" )

local A2LANG_TEMP = ""
local A2LANG = ""

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
			A2LANG = "en"
		else
			GetConVar( "ac2_language" ):SetString( A2LANG_TEMP )
			A2LANG = GetConVar( "ac2_language" ):GetString()
        end
    end
end

hook.Add( "Initialize", "ac2_set_default_language", loadDefaultLanguage )*/
/* ==================================================
  Check Language
================================================== */
function translateItem( ActorsLang ) {
    var Translate_ENItem = $('[do-translate="en"]');
	var Translate_PTBRItem = $('[do-translate="ptbr"]');
    if (ActorsLang == "pt-BR" || ActorsLang == "pt-br" || ActorsLang == "pt") {Translate_ENItem.remove();}
    else if (ActorsLang == "en") {Translate_PTBRItem.remove();}
    else {Translate_PTBRItem.remove();}
}

function receiveLang( str ) {
    translateItem( str )
}

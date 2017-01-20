var Page = 0;
var CheckAddon = "";
var CheckAddonReason = "";

function closePanel() {
    setTimeout(function() { 
        lua.Run( "CloseWelcomePanel()" );
    }, 100);
}

function hideAllPages() {
    $('[change-pg="1"]').hide();
    $('[change-pg="2"]').hide();
    $('[prop="check"]').hide();
    $('[prop="nocheck"]').hide();
    Page = 0;
    nextPage();
}

function checkAddon( str ) {
    this.CheckAddon = str;
}

function getCheckAddonReason( reason ) {
    this.CheckAddonReason = reason;
}

function nextPage() {
    if (Page == 0) 
    { 
        Page = 1;
        $('[change-pg="1"]').show(500);

        $("a").on( "mouseenter", function () { lua.PlaySound( "ui/csgo_ui_contract_type3.wav" ); } );
        $("a").on( "click", function () { lua.PlaySound( "ui/csgo_ui_contract_type1.wav" ); } );

        setTimeout(function() { 
            if (this.CheckAddon == "true") { $('[prop="check"]').fadeIn(500); }
            else { 
                $('[prop="nocheck"]').fadeIn(500);
                document.getElementById("checkreason").innerHTML = this.CheckAddonReason; 
            }
            lua.PlaySound( "ui/hint.wav" );
        }, 800);
    }

    else if (Page == 1) { 
        Page = 2;
        $('[change-pg="1"]').hide(500);
        $('[change-pg="2"]').show(500);
    }
}
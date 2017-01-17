var Page = 0;
var Zuzu = "";

function closePanel() {
    lua.Run( "CloseWelcomePanel()" );
}

function hideAllPages() {
    $('[change-pg="1"]').hide();
    $('[change-pg="2"]').hide();
    $('[prop="nav"]').hide();
    $('[prop="nonav"]').hide();
    Page = 0;
    nextPage();
}

function checkNavMesh( str ) {
    this.Zuzu = str;
}

function nextPage() {
    if (Page == 0) 
    { 
        Page = 1;
        $('[change-pg="1"]').show(500);

        $("a").on( "mouseenter", function () { lua.PlaySound( "ambient/water/rain_drip1.wav" ); } );
        $("a").on( "click", function () { lua.PlaySound( "buttons/lightswitch2.wav" ); } );

        setTimeout(function() { 
           if (this.Zuzu == "true") { $('[prop="nav"]').fadeIn(500); }
            else { $('[prop="nonav"]').fadeIn(500); }
        }, 500);
    }

    else if (Page == 1) { 
        Page = 2;
        $('[change-pg="1"]').hide(500);
        $('[change-pg="2"]').show(500);
    }
}
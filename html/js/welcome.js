var Page = 0;
var NavMesh = false;

function closePanel() 
{
    lua.Run( "CloseWelcomePanel()" );
}

function hideAllPages()
{
    $('[change-pg="1"]').hide();
    $('[change-pg="2"]').hide();
    $('[prop="nav"]').hide();
    Page = 0;
    nextPage();
}

function checkNavMesh( bool )
{
    NavMesh = bool
}

function nextPage()
{
    if (Page == 0) 
    { 
        Page = 1;
        $('[change-pg="1"]').show(500);
        if (NavMesh == true)
        {
            $('[prop="nav"]').show(200);
        }
    }


    else if (Page == 1) { Page = 2; $('[change-pg="1"]').hide(500); $('[change-pg="2"]').show(500);}
}
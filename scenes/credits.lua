local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local text, backcground, character, showText;
local h, w;
local tm;

local function gotoMenu(event)
    timer.cancel(tm);
    transition.cancel("txt");
    composer.gotoScene("scenes.menu", {effect="crossFade", time=500});
end 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    w, h = display.contentWidth, display.contentHeight;

    background = display.newImage("assets/beach.png");
    background.y = display.contentHeight + 100;
    background.anchorY = 1;
    background:scale(.9,.9);
    sceneGroup:insert(background);


    local cucumberOptions =
    {
        width = 64,
        height = 68,
        numFrames = 48,
     
        sheetContentWidth = 3072, 
        sheetContentHeight = 68  
    };
 
    local cucumberImageSheet = graphics.newImageSheet( "assets/cucumber.png", cucumberOptions );

    local cucumberSequenceData =
    {
        { name="iddle", start=1, count=36, time=4000 }
    }
 
    cucumber = display.newSprite(cucumberImageSheet, cucumberSequenceData );
    cucumber:play();
    cucumber.xScale = -1;

    cucumber.x = display.contentWidth/4;
    cucumber.y = display.contentHeight * .9;

    cucumber:scale(2,2);
    sceneGroup:insert(cucumber);

    text = {
        "PROGRAMMED BY\nTiago Alcantara\nWanessa Ribeiro",
        "SPRITES\nPirate Bomb by Orlando Herrera\nAnimated Water Tiles available on OpenGameArt.org",
        "Fantasy Icons Pack by Shikashi\n2D Mobile UI for Casual Game by CGA Creative",
        "Shield Effect by Bonsaiheldin\bBeach Background by Burgerpantz",
        "SOUNDS\nChippy's Chiptune Music Pack by chiptunistchippy",
        "Sound Effect Mini Pack by Swiss Arcade Game Entertainment",
        "OTHERS\nFont Fipps by Stefanie Koerner",
        "THANKS FOR PLAYING :)";
    };

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        Runtime:addEventListener("tap", gotoMenu);
 
    elseif ( phase == "did" ) then
        tm = timer.performWithDelay(20000, gotoMenu);

        local options = 
        {
            text = "",     
            x = display.contentWidth * .5,
            y = h * 1.3,
            width = w - 50,
            font = "assets/Fipps-Regular.otf",   
            fontSize = 14,
            align = "center"  -- Alignment parameter
        }

        local offSet = 200;

        for i=1, #text, 1 do 
            local myText = display.newText(options);
            myText.text = text[i];
            myText.y = myText.y + offSet * i;
            myText:setFillColor(.4 , .4, .4);

            sceneGroup:insert(myText);

            local dest = -500;
            local time = 10*myText.y;

            if(i==#text) then dest = h * .5; time = time * .8; end


            transition.to(myText, {time=time, x=myText.x, y=dest, onComplete=function () timer.performWithDelay(5000, function() myText:removeSelf(); end) end, onCancel=function() myText:removeSelf() end, tag="txt"});
        end
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener("tap", gotoMenu);
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
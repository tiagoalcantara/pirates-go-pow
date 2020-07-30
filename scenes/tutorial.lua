local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 local widget = require("widget");

 local player, map, text;
 local w, h;

 local function gotoMenu(event)
    if event.phase == "ended" then composer.gotoScene("scenes.menu"); end
 end 

  local function changeToIddle()
     player:setSequence("iddle");
     player:play();
     player.isMoving = false;
 end
 
 local function checkSwipe(event)

    local swipeY = math.abs(event.y - event.yStart);
    local swipeX = math.abs(event.x - event.xStart);

    if(event.phase == "began") then

    elseif(event.phase == "ended") then
        if not player.isMoving then
            if(event.xStart > event.x and swipeX > 30) then
            -- Left
            player.column = player.column - (1 * player.panic);
            player.xScale = 1 * player.panic;
        elseif(event.xStart < event.x and swipeX > 30) then
            -- Right
            player.column = player.column + (1 * player.panic);
            player.xScale = -1 * player.panic;

        elseif(event.y < event.yStart and swipeY > 30) then
            -- Up
            player.line = player.line - (1 * player.panic);
        elseif(event.y > event.yStart and swipeY > 30) then
            -- Down
            player.line = player.line + (1 * player.panic);
        end

        if player.line < 1 then player.line = 1;
        elseif player.line > 3 then player.line = 3; 
        elseif player.column > 3 then player.column = 3;
        elseif player.column < 1 then player.column = 1;
        end

        player.isMoving = true;
        player:setSequence("run");
        player:play();
        transition.to(player, {time=player.velocity,x=map[player.line][player.column].column, y=map[player.line][player.column].line, onComplete=changeToIddle});
        end
    end
 end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    w, h = display.contentWidth, display.contentHeight;

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local backgroundOptions =
    {
        width = 1024,
        height = 768,
        numFrames = 3,
     
        sheetContentWidth = 3072, 
        sheetContentHeight = 768  
    };
 
    local backgroundImageSheet = graphics.newImageSheet( "assets/waterBackground.png", backgroundOptions );

    local backgroundSequenceData =
    {
        { name="move", start=1, count=3, time=3000 }
    }
 
    background = display.newSprite(backgroundImageSheet, backgroundSequenceData );
    background.x = w * .5;
    background.y = h * .5;
    background.rotation = 45;
    background:scale(3,3)
    background:play();
    sceneGroup:insert(background);

-- Map config
    map = {};
    local initX, initY, size = w * .20, h * .35, 75;
    for i=1, 3 do
        map[i] = {};
        for j=1, 3 do
            map[i][j] = display.newImage("assets/woodenPlank2.png");
            map[i][j].x = initX;
            map[i][j].y = initY;
            map[i][j].line = initY;
            map[i][j].column = initX;

            initX = initX + size + 21;

            sceneGroup:insert(map[i][j]);
        end
        initX = w * .20;
        initY = initY + size + 21;
    end
    -- Player config

    local playerOptions =
    {
        width = 64,
        height = 68,
        numFrames = 48,
     
        sheetContentWidth = 3072, 
        sheetContentHeight = 68  
    };
 
    local playerImageSheet = graphics.newImageSheet( "assets/cucumber.png", playerOptions );

    local playerSequenceData =
    {
        { name="iddle", start=1, count=36, time=2000 },
        { name="run", start=37, count=12, time=1000 },
    }
 
    player = display.newSprite(playerImageSheet, playerSequenceData )
    player.myName = "player";
    player.anchorY = 1;
    player.x = map[2][2].column;
    player.y = map[2][2].line;

    player.line = 2;
    player.column = 2;

    player.velocity = 500;
    player.isMoving = false;
    player.panic = 1;
    player:play();

    Runtime:addEventListener("touch", checkSwipe);

    backButton = widget.newButton(
    {
        width = 150,
        height = 75,
        defaultFile = "assets/button.png",
        label = "BACK TO MENU",
        font = "assets/Fipps-Regular.otf",
        fontSize = 10,
        labelYOffset = -5,
        labelColor = { default={ 1, 1, 1 }, over={ 0/255, 105/255, 148/255, 1 } },
        onEvent=gotoMenu
    }
    )
    backButton.x = display.contentWidth * .5;
    backButton.y = display.contentHeight * .95;

    sceneGroup:insert(player);
    sceneGroup:insert(backButton);

    local options = 
    {
        text = "1. Move with swipes\n2. Don't get hit\n3. Collect stuff\n4. Gain points",     
        x = 0,
        y = -30,
        width = w,
        font = "assets/Fipps-Regular.otf",   
        fontSize = 12,
        align = "center"  -- Alignment parameter
    }
     
    local myText = display.newText( options )
    myText.anchorX = -1;
    myText.anchorY = -1;
    sceneGroup:insert(myText);
    
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
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
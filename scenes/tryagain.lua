local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local widget = require("widget");

 local ui;
 local frame, replayButton, backButton, score;
 local music;

 local function gotoGame(event)
    if event.phase == "ended" then composer.gotoScene("scenes.game"); end
 end

  local function gotoMenu(event)
    if event.phase == "ended" then composer.gotoScene("scenes.menu"); end
 end 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    
    ui = display.newGroup();

    background = display.newImage(ui, "assets/beach.png");
    background.y = display.contentHeight + 100;
    background.anchorY = 1;
    background:scale(.9,.9);

    local cucumberOptions =
    {
        width = 64,
        height = 68,
        numFrames = 4,
     
        sheetContentWidth = 256, 
        sheetContentHeight = 68  
    };
 
    local cucumberImageSheet = graphics.newImageSheet( "assets/fallenCucumber.png", cucumberOptions );

    local cucumberSequenceData =
    {
        { name="iddle", start=1, count=4, time=3000 }
    }
 
    cucumber = display.newSprite(ui, cucumberImageSheet, cucumberSequenceData );
    cucumber:play();

    cucumber.x = display.contentWidth/4;
    cucumber.y = display.contentHeight * .8;

    cucumber:scale(3,3);

    frame = widget.newButton(
    {
        width = display.contentWidth - 20,
        height = display.contentHeight/2,
        defaultFile = "assets/frame.png",
    }
    )
    frame.x = display.contentCenterX
    frame.y = display.contentHeight * .3;
    ui:insert(frame);

    replayButton = widget.newButton(
    {
        width = 150,
        height = 75,
        defaultFile = "assets/button.png",
        label = "PLAY AGAIN",
        font = "assets/Fipps-Regular.otf",
        fontSize = 10,
        labelYOffset = -5,
        labelColor = { default={ 1, 1, 1 }, over={ 0/255, 105/255, 148/255, 1 } },
        onEvent=gotoGame
    }
    )
    replayButton.x = display.contentWidth * .25;
    replayButton.y = display.contentHeight * .65;
    ui:insert(replayButton);

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
    backButton.x = display.contentWidth * .75;
    backButton.y = display.contentHeight * .65;
    ui:insert(backButton);

    local options = 
    {
        text = "Score: ",
        width = 256,
        font = "assets/Fipps-Regular.otf",  
        fontSize = 24,
        align = "center"
    }

    score = display.newText(options);
    score.x = display.contentCenterX;
    score.y = display.contentHeight * .2;
    score:setFillColor(.6,.6,.6);

    ui:insert(score);

    music = audio.loadSound("assets/menuLoop.wav");

    sceneGroup:insert(ui);

    
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        if(composer.getVariable("currentScore") ~= nil) then score.text = "Score: " .. composer.getVariable("currentScore"); end
        audio.setVolume(.4, {channel=5});
        audio.play(music, {loops=-1, fadeIn=5000, channel=5});
    elseif ( phase == "did" ) then
        
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

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
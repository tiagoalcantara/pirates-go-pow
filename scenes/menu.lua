local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local widget = require("widget");

 local ui;
 local gameButton, creditsButton, tutorialButton;
 local cucumber, captain, background;
 local menuMusic;

 local function gotoGame(event)
    audio.fadeOut({channel=5, time=500});
    if event.phase == "ended" then composer.gotoScene("scenes.game"); end
 end

  local function gotoTutorial(event)
    if event.phase == "ended" then composer.gotoScene("scenes.tutorial"); end
 end

  local function gotoCredits(event)
    if event.phase == "ended" then composer.gotoScene("scenes.credits"); end
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
        numFrames = 48,
     
        sheetContentWidth = 3072, 
        sheetContentHeight = 68  
    };
 
    local cucumberImageSheet = graphics.newImageSheet( "assets/cucumber.png", cucumberOptions );

    local cucumberSequenceData =
    {
        { name="iddle", start=1, count=36, time=4000 }
    }
 
    cucumber = display.newSprite(ui, cucumberImageSheet, cucumberSequenceData );
    cucumber:play();
    cucumber.xScale = -1;

    cucumber.x = display.contentWidth/4;
    cucumber.y = display.contentHeight;

    cucumber:scale(3,3);

    local captainOptions =
    {
        width = 80,
        height = 72,
        numFrames = 46,
     
        sheetContentWidth = 3680, 
        sheetContentHeight = 72  
    };
 
    local captainImageSheet = graphics.newImageSheet( "assets/captain.png", captainOptions );

    local captainSequenceData =
    {
        { name="iddle", start=1, count=32, time=4000 }
    }
 
    captain = display.newSprite(ui, captainImageSheet, captainSequenceData);
    captain:play();
    captain.xScale = -1;

    captain.x = display.contentWidth/1.5;
    captain.y = display.contentHeight;

    captain:scale(3,3);

    gameButton = widget.newButton(
    {
        width = 180,
        height = 90,
        defaultFile = "assets/button.png",
        label = "PLAY",
        font = "assets/Fipps-Regular.otf",
        fontSize = 20,
        labelYOffset = -10,
        labelColor = { default={ 1, 1, 1 }, over={ 0/255, 105/255, 148/255, 1 } },
        onEvent = gotoGame
    }
    )
    gameButton.x = display.contentCenterX
    gameButton.y = display.contentHeight * .2;
    ui:insert(gameButton);

    tutorialButton = widget.newButton(
    {
        width = 200,
        height = 90,
        defaultFile = "assets/button.png",
        label = "TUTORIAL",
        font = "assets/Fipps-Regular.otf",
        fontSize = 20,
        labelYOffset = -10,
        labelColor = { default={ 1, 1, 1 }, over={ 0/255, 105/255, 148/255, 1 } },
        onEvent = gotoTutorial
    }
    )
    tutorialButton.x = display.contentCenterX
    tutorialButton.y = display.contentHeight * .4;
    ui:insert(tutorialButton);

    creditsButton = widget.newButton(
    {
        width = 200,
        height = 90,
        defaultFile = "assets/button.png",
        label = "CREDITS",
        font = "assets/Fipps-Regular.otf",
        fontSize = 20,
        labelYOffset = -10,
        labelColor = { default={ 1, 1, 1 }, over={ 0/255, 105/255, 148/255, 1 } },
        onEvent = gotoCredits
    }
    )
    creditsButton.x = display.contentCenterX
    creditsButton.y = display.contentHeight * .6;
    ui:insert(creditsButton);

    menuMusic = audio.loadSound("assets/menuLoop.wav");

    sceneGroup:insert(ui);
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        audio.setVolume(1, {channel=5});
        audio.play(menuMusic, {loops=-1, fadeIn=1000, channel=5});
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
local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local physics = require("physics");

 local w, h;

 local bg, fg, ui, pj, pu;

 local score, time, difficulty, whenToIncrease;
 local showScore, showTime, showDifficulty;
 
 local timerPickUp, timerCannonBall;

 local background;

 local player;
 local map;

 local cannonBalls;
 local cannonBallImageSheet, cannonBallSequenceData;

 local pickup;
 local activePickup;

 local loopMusic, powerupSound, loseSound, explosionSound;


-- Player Functions

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

-- Cannon Ball Functions

 local function deleteCannonBall(thisCannonBall)
     display.remove(thisCannonBall);
     thisCannonBall = nil;
     score = score + math.floor(difficulty * cannonBalls.quantity);
 end
 
 local function generateCannonBalls()
     if(not cannonBalls.spawn) then return nil; end

     local direction = math.random(1,3); -- 1 for horizontal, 2 for vertical, 3 for diagonal
     local orientation = math.random(1,2) -- 1 for left or up, 2 for right or down
     local cannonBallWarning = display.newImage(pj, "assets/warning.png");
     local projectile = display.newSprite(pj, cannonBallImageSheet, cannonBallSequenceData);
 
     projectile.myName = "projectile";
     projectile:scale(1.2,1.2);
     projectile.anchorY = 1;
     physics.addBody( projectile, "dynamic", {isSensor=true, radius=projectile.contentWidth/2 - 5});
 
     projectile:play();
     if(direction == 1) then
         local line = math.random(1,3);
         local mod;
         if orientation == 1 then mod = 1 else mod = -1 end;
 
         projectile.x = map[line][2].column - (w * .7 * mod);
         projectile.y = map[line][2].line;
 
         cannonBallWarning.x = map[line][2].column - (w * .45 * mod);
         cannonBallWarning.y = map[line][2].line;
 
         transition.to(projectile, {time=cannonBalls.speed, x=projectile.x + (w*mod+(200*mod)), y=projectile.y, onComplete=deleteCannonBall, tag="cannonBall"});
         transition.pause(projectile);
 
     elseif(direction == 2) then
         local column = math.random(1,3);
         local mod;
         if orientation == 1 then mod = 1 else mod = -1 end;
 
 
         projectile.x = map[2][column].column;
         projectile.y = map[2][column].line + (h * .7 * mod);
 
         cannonBallWarning.x = map[2][column].column;
         cannonBallWarning.y = map[2][column].line + (h * .35 * mod);
 
         transition.to(projectile, {time=cannonBalls.speed, x=projectile.x, y=projectile.y - (h*mod+(200*mod)), onComplete=deleteCannonBall, tag="cannonBall"});
         transition.pause(projectile);
 
     elseif(direction == 3) then
         local diagonal = math.random(1,4);
         local xOrigin, xDestiny, yOrigin, yDestiny;
         local xOffSet, yOffSet = w*.4, h*.4;
         local xWarning, yWarning, warningXOffSet, warningYOffSet = 0, 0, w*.15, h*.10;
 
         if(diagonal == 1) then 
             xWarning = map[1][1].column - warningXOffSet;
             yWarning = map[1][1].line - warningYOffSet;
 
             xOrigin = map[1][1].column - xOffSet;
             yOrigin = map[1][1].line - yOffSet;
 
             xDestiny = map[3][3].column + xOffSet;
             yDestiny = map[3][3].line + yOffSet;
         elseif(diagonal == 2) then
             xWarning = map[1][3].column + warningXOffSet;
             yWarning = map[1][3].line - warningYOffSet;
 
             xOrigin = map[1][3].column + xOffSet;
             yOrigin = map[1][3].line - yOffSet;
 
             xDestiny = map[3][1].column - xOffSet;
             yDestiny = map[3][1].line + yOffSet;
         elseif(diagonal == 3) then
             xWarning = map[3][3].column + warningXOffSet;
             yWarning = map[3][3].line + warningYOffSet;
 
             xOrigin = map[3][3].column + xOffSet;
             yOrigin = map[3][3].line + yOffSet;
 
             xDestiny = map[1][1].column - xOffSet;
             yDestiny = map[1][1].line - yOffSet;
         else
             xWarning = map[3][1].column - warningXOffSet;
             yWarning = map[3][1].line + warningYOffSet;
 
             xOrigin = map[3][1].column - xOffSet;
             yOrigin = map[3][1].line + yOffSet;
 
             xDestiny = map[1][3].column + xOffSet;
             yDestiny = map[1][3].line - yOffSet;
         end
 
         projectile.x = xOrigin;
         projectile.y = yOrigin;
 
         cannonBallWarning.x = xWarning;
         cannonBallWarning.y = yWarning;
 
 
         transition.moveTo(projectile, {time=cannonBalls.speed, x=xDestiny, y=yDestiny, onComplete=deleteCannonBall, tag="cannonBall"});
         transition.pause(projectile);
     end
 
    local function removeWarning()
        if cannonBalls.spawn then 
            transition.resume(projectile); 
            display.remove(cannonBallWarning);
            cannonBallWarning = nil;
            audio.play(explosionSound, {channel=2, loops=0});

            
        else
             timer.performWithDelay(1000, removeWarning, 1);
        end
    end

     timer.performWithDelay(1000, removeWarning, 1);
 end

    local function controllCannonBallGeneration()
        if(cannonBalls.spawn) then timer.performWithDelay(math.random(500,1000), generateCannonBalls, cannonBalls.quantity); end
    end

-- PickUps 
    local function spawnText(message)
        local textOptions = {
            text = "",
            y = 0;
            width = 150,
            font = "assets/Fipps-Regular.otf",
            fontSize = 13,
            align = "center"
        }

        local text = display.newText(textOptions);
        text.text = message;
        text.x = player.x;
        text.y = player.y - 20;

        transition.to(text, {time=800, x=text.x, y=text.y-100, onComplete=function() display.remove(text); text = nil; end});

    end

    local function pickUpsGenerator()
        if(activePickup) then return nil end;

        local l, c;
        local images = {
            "assets/boots.png",
            "assets/coins.png",
            "assets/timePotion.png",
            "assets/panic.png",
            "assets/shield.png",
        };

        l = math.random(1,3);
        c = math.random(1,3);

        while(l == player.line and c == player.column) do
            l = math.random(1,3);
            c = math.random(1,3);
        end

        local randomizer = math.random(1,100);
        local whichOne;

        if randomizer >= 1 and randomizer < 21 then
            whichOne = 1;
        elseif randomizer >= 21 and randomizer < 61 then
            whichOne = 2;
        elseif randomizer >= 61 and randomizer < 71 then
            whichOne = 3;
        elseif randomizer >= 95 and randomizer < 101 then
            whichOne = 4;
        elseif randomizer >= 71 and randomizer < 95 then
            whichOne = 5;
        end

        pickup = display.newImage(pu, images[whichOne]);
        pu:insert(pickup);
        pickup.y = map[l][c].line;
        pickup.x = map[l][c].column;
        pickup.anchorY = 1;
        pickup:scale(1.5,1.5);
        pickup.myName = "pickup";
        pickup.message = "";
        physics.addBody(pickup, "dynamic" ,{radius=15, isSensor=true});

        activePickup = true;

        if(whichOne == 1) then -- Boots
            
            pickup.effect = function()
                if player.velocity > 200 then player.velocity = player.velocity - 50; pickup.message = "SPEED UP"; 
                else  score = score + 50; showScore.text = "Score: " .. score; pickup.message = "+50";
                end 
            end

            pickup.revertEffect = function()
                -- nothing happens
            end

        elseif(whichOne == 2) then -- Coins
            pickup.message = "+100";
            pickup.effect = function()
                score = score + 100;
                showScore.text = "Score: " .. score;
            end

            pickup.revertEffect = function()
                -- nothing happens
            end

        elseif(whichOne == 3) then -- Slow Potion
            if(player.hasEffect) then
                display.remove(pickup);
                pickup = nil;
                activePickup = false;

                return nil;
            end

            pickup.message = "TIME POTION";
            
            pickup.effect = function()
                player.hasEffect = true;
                cannonBalls.spawn = false;
                transition.pause("cannonBall");
            end

            pickup.revertEffect = function()
                cannonBalls.spawn = true;
                transition.resume("cannonBall");
                player.hasEffect = false;
            end

        elseif(whichOne == 4) then
            
            if(player.hasEffect) then
                display.remove(pickup);
                pickup = nil;
                activePickup = false;

                return nil;
            end


            pickup.message = "PANIC";

            pickup.effect = function()
                player.panic = -1;
                player.hasEffect = true;
                transition.blink(player, {time=500, tag="panic"});
            end

            pickup.revertEffect = function()
                player.panic = 1;
                player.hasEffect = false;
                transition.cancel("panic");
                player.alpha = 1;
            end

        elseif(whichOne == 5) then
            if(player.barrier ~= nil) then
                display.remove(pickup);
                pickup = nil;
                activePickup = false;

                return nil;
            end

            pickup.message = "SHIELD UP";

            pickup.effect = function()
                player.barrier = display.newImage("assets/barrier.png");
                player.barrier:scale(.1,.1);
                player.barrier.x = player.x;
                player.barrier.y = player.y - player.contentHeight/2;

                player.barrier.timer = timer.performWithDelay(10, function() player.barrier.x = player.x; player.barrier.y = player.y - player.contentHeight/2; end, 0);
            end

            pickup.revertEffect = function()
                -- nothing
            end
        end

        timer.performWithDelay(2500, function() display.remove(pickup); pickup = nil; activePickup = false; end, 1);
    end

-- Difficulty and score

    local function increaseDifficulty()
        if difficulty <= 10 then
            difficulty = difficulty + 1;

            cannonBalls.speed = cannonBalls.speed - 300;
            cannonBalls.frequency = cannonBalls.frequency - 200;

            if difficulty == 3 then cannonBalls.quantity = 2 end;
            if difficulty == 8 then cannonBalls.quantity = 3 end;
        end
    end

    local function keepScore()
        time = time + 1;

        if(score > whenToIncrease) then increaseDifficulty(); whenToIncrease = whenToIncrease + 200; end 
        showScore.text = "Score: " .. score;
        showTime.text = string.format("%02d:%02d", time/60, time%60);
        showDifficulty.text = "Level: " .. difficulty;
    end

    local function initGame()
        difficulty = 1;
        score = 0;
        time = 0;
        whenToIncrease = 200;
        showScore.text = "Score: " .. score;
        showTime.text = string.format("%02d:%02d", time/60, time%60);
        showDifficulty.text = "Level: " .. difficulty;
        
        display.remove(pu);
        pu = display.newGroup();

        cannonBalls.speed = 4000;
        cannonBalls.frequency = 2000;
        cannonBalls.quantity = 1;

        display.remove(pj);
        pj = display.newGroup();
        fg:insert(pj);

        transition.cancel(player);
        player.x = map[2][2].column;
        player.y = map[2][2].line;
        player.line = 2;
        player.column = 2;
        player.velocity = 500;
        player.panic = 1;
        player.barrier = nil;
        player.hasEffect = false;
        changeToIddle();

        timerCannonBall = timer.performWithDelay(cannonBalls.frequency, controllCannonBallGeneration, 0);
        timerPickUp =  timer.performWithDelay(3000, pickUpsGenerator, 0);
    end

-- Collision

    local function onGlobalCollision( event )
        if event.object1.myName == "player" and event.object2.myName == "projectile" then
            if player.barrier == nil then 
                composer.setVariable("currentScore", score);
                composer.gotoScene("scenes.tryagain");
            else 
                display.remove(event.object2);
                event.object2 = nil;

                timer.cancel(player.barrier.timer);

                display.remove(player.barrier);
                player.barrier = nil;
            end

        elseif event.object1.myName == "player" and event.object2.myName == "pickup" then
            audio.play(powerupSound, {loops=0, channel=3});
            event.object2:effect();
            spawnText(pickup.message);
            timer.performWithDelay(5000, event.object2.revertEffect, 1);

            display.remove(event.object2);
            event.object2 = nil;
        end
    end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
        
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.start();
    --physics.setDrawMode("hybrid");
    physics.setGravity(0,0);
    

--General config
    w = display.contentWidth;
    h = display.contentHeight;

    bg = display.newGroup();
    fg = display.newGroup();
    ui = display.newGroup();
    pj = display.newGroup();

-- Background config
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
 
    background = display.newSprite( bg, backgroundImageSheet, backgroundSequenceData );
    background.x = w * .5;
    background.y = h * .5;
    background.rotation = 45;
    background:scale(3,3)
    background:play();

-- Map config
    map = {};
    local initX, initY, size = w * .20, h * .35, 75;
    for i=1, 3 do
        map[i] = {};
        for j=1, 3 do
            map[i][j] = display.newImage(fg, "assets/woodenPlank2.png");
            map[i][j].x = initX;
            map[i][j].y = initY;
            map[i][j].line = initY;
            map[i][j].column = initX;

            initX = initX + size + 21;
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
 
    player = display.newSprite( fg, playerImageSheet, playerSequenceData )
    player.myName = "player";
    player.anchorY = 1;
    player.x = map[2][2].column;
    player.y = map[2][2].line;

    player.line = 2;
    player.column = 2;

    player.velocity = 500;
    player.isMoving = false;
    player.hasEffect = false;
    player.panic = 1;
    player.barrier = nil;

    player:play();

    physics.addBody( player, "dynamic", {box={halfWidth=9, halfHeight=21, x=-1, y=-32}});

    Runtime:addEventListener("touch", checkSwipe);

-- Cannon Ball config
    cannonBalls = {};
    cannonBalls.speed = 4000;
    cannonBalls.frequency = 2000;
    cannonBalls.quantity = 1;
    cannonBalls.spawn = true;

    cannonBallImageSheet = graphics.newImageSheet( "assets/cannonBall.png", {
        width = 32,
        height = 30,
        numFrames = 10,
     
        sheetContentWidth = 320, 
        sheetContentHeight = 30  
    }
    );

    cannonBallSequenceData =
    {
        { name="iddle", start=1, count=10, time=1000 },
    }


-- Score and UI
    score = 0;
    difficulty = 1;
    time = 0;
    whenToIncrease = 200;

    local textOptions = 
    {
        text = "",
        y = 0;
        width = 150,
        font = "assets/Fipps-Regular.otf",
        fontSize = 13,
        align = "center"
    }

    showScore = display.newText(textOptions);
    showScore.text = "Score: " .. score;
    showScore.x = w * .5; 
    ui:insert(showScore);

    showTime = display.newText(textOptions);
    showTime.text = string.format("%02d:%02d", time/60, time%60);
    showTime.x = w * .85;
    ui:insert(showTime);

    showDifficulty = display.newText(textOptions);
    showDifficulty.text = "Level: " .. difficulty;
    showDifficulty.x = w * .15;
    ui:insert(showDifficulty);
    
    timer.performWithDelay(1000, keepScore, 0);

-- PickUps config
     activePickup = false;
     pu = display.newGroup();

-- Collision
    Runtime:addEventListener("collision", onGlobalCollision);

    fg:insert(pj);
    fg:insert(pu);
    sceneGroup:insert(bg);
    sceneGroup:insert(fg);
    sceneGroup:insert(ui);

 -- Music
     loopMusic = audio.loadSound( "assets/gameLoop.wav" );
     loseSound = audio.loadSound("assets/lose.wav");
     powerupSound = audio.loadSound("assets/powerup.wav");
     explosionSound = audio.loadSound("assets/explosion.wav");

     audio.setVolume(.5, {channel=1});
     audio.setVolume(1, {channel=2});
     audio.setVolume(.7, {channel=3});
     audio.setVolume(1, {channel=4});
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        initGame();
        audio.stop(5);
        audio.setVolume(.5, {channel=1});
        audio.play(loopMusic, {loops=-1, channel=1, fadein=500});
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        display.remove(pu);

        timer.cancel(timerCannonBall);
        timer.cancel(timerPickUp);
 
    elseif ( phase == "did" ) then
        audio.fadeOut({channel=1, time=500});
        audio.play(loseSound, {channel=4, loops=0});
 
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
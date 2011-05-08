--frontend.lua

--main state, will mainly display the interface and switch to the appropriate state when action is taken.

Gamestate.frontend = Gamestate.new()
local st = Gamestate.frontend

require "nextGame"
require "previousGame"
require "nextLetter"
require "previousLetter"
require "imagesMenu"
require "menu"
require "search"
require "xml"

local nextGame
local previousGame
local nextLetter
local previousLetter
local treatInput
local menu
local emptyGameImages

function st:draw()
	local game = gameList[currentGame]

	drawBackground()
	
	-- Prints useful messages for debugging
	--love.graphics.print(xml.find(game, "description")[1], 0, 0)
	love.graphics.print("currentGame = " ..currentGame, 0, 15)
	love.graphics.print("currentImage = " ..currentImage, 0, 30)
	love.graphics.print(images[currentImage], 0, 45) 
    love.graphics.print("groupSelection = " ..groupSelection, 0, 60) --]]
	
	love.graphics.printf(infoMessage, LW + 0.1*LW, 2*LH + H/5 + 20, (250/1600)*W)

	--Print game names on the right
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame-2), (1300/1600)*W, (550/1200)*H, -0.05)
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame-1), (1280/1600)*W, (690/1200)*H, 0.05)
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame), (1300/1600)*W, (835/1200)*H, -0.05)
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame+1), (1280/1600)*W, (950/1200)*H, 0.05)
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame+2), (1280/1600)*W, (1140/1200)*H)
	
	love.graphics.draw(tonneaux[1], (1300/1600)*W - tonneaux[1]:getWidth(), (835/1200)*H)
    
    if isGroup(game) then
        local selectedGame = getGameOfGroup(game)
        local i = selectedGame["Logo"]
        if i == nil then
            i = selectedGame["Marquee"]
        end
        if i ~= nil then
            local X = i:getWidth()
            local Y = i:getHeight()
            local scale = (W/5)/X
            if Y*scale > H/5 then
                scale = (H/5)/Y
            end
            love.graphics.draw(i, W/2 - (X/2)*scale, H - Y*scale, 0, scale)
        end
        
        selectedGame = getGameOfGroup(game, groupSelection - 1)
        i = selectedGame["Logo"]
        if i == nil then
            i = selectedGame["Marquee"]
        end
        if i ~= nil then
            local X = i:getWidth()
            local Y = i:getHeight()
            local scale = (W/7)/X
            if Y*scale > H/7 then
                scale = (H/7)/Y
            end
            love.graphics.draw(i, W/4 - (X/2)*scale, H - Y*scale, 0, scale)
        end
        
        selectedGame = getGameOfGroup(game, groupSelection + 1)
        i = selectedGame["Logo"]
        if i == nil then
            i = selectedGame["Marquee"]
        end
        if i ~= nil then
            local X = i:getWidth()
            local Y = i:getHeight()
            local scale = (W/7)/X
            if Y*scale > H/7 then
                scale = (H/7)/Y
            end
            love.graphics.draw(i, W*3/4 - (X/2)*scale, H - Y*scale, 0, scale)
        end
    end
end

function st:keypressed(key, unicode)
	local input = controools["keyboard"][key]
	if  input ~= nil then
		treatInput(input)
	elseif key == "escape" then
		os.exit()
	end
end

function st:update(dt)
	for i=0,(nbJoy-1) do
		for j=0,joys[i]["nbHats"]-1 do
			if love.joystick.getHat(i,j) ~= "c" then
				local input = controools[i][love.joystick.getHat(i,j)]
				if input ~= nil then
					treatInput(input)
				end
			end
		end
	end
	if currentGame > #gameList then 
		currentGame = currentGame %#gameList 
		if currentGame == 0 then
			currentGame = #currentGame
		end
	end
	love.graphics.setColor(255,255,255,255)
end

function st:joystickpressed(joystick, button)
	local input = controools[joystick][button]
	if input ~= nil then
		treatInput(input)
	end
end

function loadGameImages(game, ...)
    if isGroup(game) then
        for _, g in pairs(game[1]) do
            local name = getName(g)
            for _, folder in ipairs{...} do
                if g[folder] == nil then
                    local path = pathToMame.."/"..folder.."/"..name
                    if love.filesystem.exists(path .. ".png") then
                        g[folder] = love.graphics.newImage(path..".png")
                    elseif love.filesystem.exists(path .. ".bmp") then
                        g[folder] = love.graphics.newImage(path..".bmp")
                    else
                        print("Image not found : "..path)
                    end
                end
            end
        end
    else
        local name = getName(game)
        for _, folder in ipairs{...} do
            if game[folder] == nil then
                local path = pathToMame.."/"..folder.."/"..name
                if love.filesystem.exists(path .. ".png") then
                    game[folder] = love.graphics.newImage(path..".png")
                elseif love.filesystem.exists(path .. ".bmp") then
                    game[folder] = love.graphics.newImage(path..".bmp")
                else
                    print("Image not found : "..path)
                end
            end
        end
    end
end

function launch(romName)
    if romName == nil then
        local g = getGameByNumber(gameList, currentGame)
        if isGroup(g) then
            romName = getName(getGameOfGroup(g))
        else
            romName = getName(g)
        end
    end
	cmd = ("cd " .. pathToMame .. " & mame.exe " .. romName)
	print(cmd)
	os.execute(cmd)
end

nextGame = function()
    groupSelection = 1
	if love.timer.getTime() - timer > timeLimit then
		currentGame = currentGame + 1
		if currentGame-5 ~= 0 then
			emptyGameImages(gameList[currentGame-5]) 
		else
			emptyGameImages(gameList[currentGame-6])
		end
		loadGameImages(gameList[currentGame], "Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title")
		timer = love.timer.getTime()
	end
	infoMessage = getInfo()
	Gamestate.switch(Gamestate.nextGame)
	love.draw()
end

previousGame = function()
    groupSelection = 1
	if love.timer.getTime() - timer > timeLimit then
		currentGame = currentGame - 1
		if currentGame < 1 then currentGame = #gameList end
		emptyGameImages(gameList[currentGame+5]) 
		loadGameImages(gameList[currentGame], "Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title")
		timer = love.timer.getTime()
	end
	infoMessage = getInfo()
	Gamestate.switch(Gamestate.previousGame)
	love.draw()
end

previousLetter = function()
    if love.timer.getTime() - timer > timeLimit then
        if isGroup(getGameByNumber(gameList, currentGame)) then
            groupSelection = groupSelection - 1
        else
            groupSelection = 1
            oldGame = currentGame
            local gameName = getDescriptionOfNumber(gameList, currentGame)
            local firstLetter = string.sub(gameName, 1, 1)
            --Going to last game of previous letter
            while string.sub(getDescriptionOfNumber(gameList, currentGame), 1, 1) == firstLetter do
                currentGame = currentGame - 1
            end
            gameName = getDescriptionOfNumber(gameList, currentGame)
            firstLetter = string.sub(gameName, 1, 1)
            --Going to last game of previous letter (just before the first game of this letter)
            while string.sub(getDescriptionOfNumber(gameList, currentGame), 1, 1) == firstLetter do
                currentGame = currentGame - 1
            end
            --Going to aimed game
            currentGame = currentGame + 1
            loadGameImages(gameList[currentGame], "Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title")
            infoMessage = getInfo()
            Gamestate.switch(Gamestate.previousLetter, oldGame, currentGame)
        end
        timer = love.timer.getTime()
    end
	love.draw()
end

nextLetter = function()
    if love.timer.getTime() - timer > timeLimit then
        if isGroup(getGameByNumber(gameList, currentGame)) then
            groupSelection = groupSelection + 1
        else
            groupSelection = 1
            oldGame = currentGame
            local gameName = getDescriptionOfNumber(gameList, currentGame)
            local firstLetter = string.sub(gameName, 1, 1)
            while string.sub(getDescriptionOfNumber(gameList, currentGame), 1, 1) == firstLetter do
                currentGame = currentGame + 1
            end
            loadGameImages(gameList[currentGame], "Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title")
            infoMessage = getInfo()
            Gamestate.switch(Gamestate.nextLetter, oldGame, currentGame)
        end
        timer = love.timer.getTime()
    end
	love.draw()
end

menu = function()
	Gamestate.switch(Gamestate.menu)
end

treatInput = function(input)
	if     input == "next game"       then nextGame()
	elseif input == "previous game"   then previousGame()
	elseif input == "next letter"     then nextLetter()
	elseif input == "previous letter" then previousLetter()
	elseif input == "action"          then launch()
	elseif input == "menu/cancel"     then menu()
	elseif input == "exit"            then os.exit()
	end
end

emptyGameImages =  function(game) --remove some images from memory
	print("emptying " .. getName(game))
	for _, image in ipairs(images) do
		game[image]=nil
	end
	collectgarbage()
end

function getInfo()
	local game = getGameByNumber(gameList, currentGame)
	info = "Year : "
	info = info .. getTagValue(game, "year") .. "\n"
	info = info .. "Developper : " .. getTagValue(game, "manufacturer") .. "\n"
	if getAttributeOfTag(game, "display", "width") ~= nil and getAttributeOfTag(game, "display", "height") ~= nil then
		info = info .. "Resolution : " .. getAttributeOfTag(game, "display", "width").."*"..getAttributeOfTag(game, "display", "height") .. "\n"
	end
	if getAttributeOfTag(game, "input", "players") ~= nil then
		info = info .. "Number of Players : " .. getAttributeOfTag(game, "input", "players") .. "\n"
	end
	if getAttributeOfTag(game, "input", "buttons") ~= nil then
		info = info .. "Number of buttons : " .. getAttributeOfTag(game, "input", "buttons") .. "\n"
	else
		info = info .. "Number of buttons : 0\n"
	end
	info = info .. "Emulation quality : " .. getAttributeOfTag(game, "driver", "status")
	return info
end

function drawBackground() --separated from st:draw because reused several times in other states
	local game = gameList[currentGame]
    if isGroup(game) then
        game = getGameOfGroup(game)
    end
	
	if game[images[currentImage]] ~= nil then
		local toDisplay = game[images[currentImage]]
		local X = toDisplay:getWidth()
		local Y = toDisplay:getHeight()
		local scale = (W*3/5)/X
		if Y*scale > H*3/5 then
			scale = (H*3/5)/Y
		end
		love.graphics.draw(toDisplay, W/2 - X*scale/2, 2*LH + H/5 + (H*3/5)/2 - Y*scale/2, 0, scale)	
	end
	
	love.graphics.draw(borne, 0, 0, 0, W/borne:getWidth(), H/borne:getHeight())
	
	if game["Panels"] ~= nil then
		local X = game["Panels"]:getWidth()
		local Y = game["Panels"]:getHeight()
		local scale = (W/4)/X
		if Y*scale > H/6 then
			scale = (H/6)/Y
		end
		love.graphics.draw(game["Panels"], W/60, H - Y*scale, 0, scale)
	end
	
	if game["Marquee"] ~= nil and game["Marquee"]:getWidth() > game["Marquee"]:getHeight() then
		local X = game["Marquee"]:getWidth()
		local Y = game["Marquee"]:getHeight()
		local scale = (W*3/5)/X
		if Y*scale > H/5 then
			scale = (H/5)/Y
		end
		love.graphics.draw(game["Marquee"], (W/2) - X*scale/2, (H/5)/2 - Y*scale/2 + LW, 0, scale)
	elseif game["Logo"] ~= nil then
		local X = game["Logo"]:getWidth()
		local Y = game["Logo"]:getHeight()
		local scale = (W*3/5)/X
		if Y*scale > H/5 then
			scale = (H/5)/Y
		end
		love.graphics.draw(game["Logo"], (W/2) - X*scale/2, (H/5)/2 - Y*scale/2 + LW, 0, scale)
	end
	
	love.graphics.draw(dkface, (1343/1600)*W, (180/1200)*H, 0, W/1600)
end

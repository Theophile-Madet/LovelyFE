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

local joystickScaleX, joystickScaleY, joystickWidth, joystickHeight
local tdArrowScaleX, tdArrowScaleY, tdArrowWidth, tdArrowHeight
local lrArrowScaleX, lrArrowScaleY, lrArrowWidth, lrArrowHeight
local pointingArrowScaleX, pointingArrowScaleY, pointingArrowWidth, pointingArrowHeight
local groupArrowScaleX, groupArrowScaleY, groupArrowWidth, groupArrowHeight

function st:enter()
    if joystickScaleX == nil then
        joystickScaleX = ((W/5)/3)/im.joystick:getWidth()
        joystickScaleY = ((H/5)*(2/3))/im.joystick:getHeight()
        joystickWidth = im.joystick:getWidth()*joystickScaleX
        joystickHeight = im.joystick:getHeight()*joystickScaleY
        
        tdArrowScaleX = ((W/5)/4)/im.tdArrow:getWidth()
        tdArrowScaleY = ((H/5)*(2/3))/im.tdArrow:getHeight()
        tdArrowWidth = im.tdArrow:getWidth()*tdArrowScaleX
        tdArrowHeight = im.tdArrow:getHeight()*tdArrowScaleY
        
        lrArrowScaleX = ((W/5)/4)/im.lrArrow:getWidth()
        lrArrowScaleY = ((H/5)/3)/im.lrArrow:getHeight()
        lrArrowWidth = im.lrArrow:getWidth()*lrArrowScaleX
        lrArrowHeight = im.lrArrow:getHeight()*lrArrowScaleY
        
        pointingArrowScaleX = ((W/25)*3/2)/im.arrow:getWidth()
        pointingArrowScaleY = (H/10)/im.arrow:getHeight()
        pointingArrowWidth = im.arrow:getWidth()*pointingArrowScaleX
        pointingArrowHeight = im.arrow:getHeight()*pointingArrowScaleY
        
        groupArrowScaleX = ((W/25)*2)/im.arrow:getWidth()
        groupArrowScaleY = (H/6)/im.arrow:getHeight()
        groupArrowWidth = im.arrow:getWidth()*groupArrowScaleX
        groupArrowHeight = im.arrow:getHeight()*groupArrowScaleY
    end
end

function st:draw()
	local game = gameList[currentGame]

    drawBackground()
    
	-- Prints useful messages for debugging
	--[[love.graphics.print(xml.find(game, "description")[1], 0, 0)
	love.graphics.print("currentGame = " ..currentGame, 0, 15)
	love.graphics.print("currentImage = " ..currentImage, 0, 30)
	love.graphics.print(images[currentImage], 0, 45) 
    love.graphics.print("groupSelection = " ..groupSelection, 0, 60) --]]
    
    if isGroup(game) then
        drawGame(getGameOfGroup(game, groupSelection-1), 0, (H/5)/2, true)
        drawGame(getGameOfGroup(game, groupSelection+1), W*4/5, (H/5)/2, true)
    end--]]
    
    --drawing the wheel
    drawGame(getGameByNumber(gameList, currentGame+3), W*4/5 + 2*(W/5)/4, H/2 + 3*H/10)
    drawGame(getGameByNumber(gameList, currentGame+2), W*4/5 + (W/5)/4, H/2 + 2*H/10)
    drawGame(getGameByNumber(gameList, currentGame+1), W*4/5, H/2 + H/10)
    drawGame(getGameByNumber(gameList, currentGame-3), W*4/5 + 2*(W/5)/4, H/2 - 3*H/10)
    drawGame(getGameByNumber(gameList, currentGame-2), W*4/5 + (W/5)/4, H/2 - 2*H/10)
    drawGame(getGameByNumber(gameList, currentGame-1), W*4/5, H/2 - H/10)
    if isGroup(game) then
        drawGame(getGameOfGroup(game, groupSelection), W*4/5 - (W/5)/4, H/2, true)
    else
        drawGame(getGameByNumber(gameList, currentGame), W*4/5 - (W/5)/4, H/2, true)
    end
    
    drawGroupArrows()
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
    
    --can this be removed?
	if currentGame > #gameList then 
		currentGame = currentGame %#gameList 
		if currentGame == 0 then
			currentGame = #currentGame
		end
	end
    
    --can this be removed?
	love.graphics.setColor(255,255,255,255)
end

function st:joystickpressed(joystick, button)
	local input = controools[joystick][button]
	if input ~= nil then
		treatInput(input)
	end
end

function loadGameImages(game, ...)
    local function f(g, ...)
        local name = getName(g)
        for _, folder in ipairs{...} do
            if g[folder] == nil then
                local path = pathToMame.."/"..folder.."/"..name
                if love.filesystem.exists(path .. ".png") then
                    g[folder] = love.graphics.newImage(path..".png")
                elseif love.filesystem.exists(path .. ".bmp") then
                    g[folder] = love.graphics.newImage(path..".bmp")
                end
            end
        end
    end
    
    if isGroup(game) then
        for _, g in pairs(game[1]) do
            f(g, ...)
        end
    else
        f(game, ...)
    end
end

function launch(romName)
    if romName == nil then
        local g = getGameByNumber(gameList, currentGame)
        if isGroup(g) then
            romName = getName(getGameOfGroup(g, groupSelection))
        else
            romName = getName(g)
        end
    end
    
    local inpFileName = romName .. "." .. os.date("%a.%d.%b.%H.%M")
	cmd = ("cd " .. pathToMame .. " & mame " .. romName .. " -record " .. inpFileName)
	os.execute(cmd)
end

nextGame = function()
	currentGame = currentGame + 1
	infoMessage = getInfo()
	Gamestate.switch(Gamestate.nextGame)
end

previousGame = function()
    currentGame = currentGame - 1
    if currentGame < 1 then 
        currentGame = #gameList 
    end
	infoMessage = getInfo()
	Gamestate.switch(Gamestate.previousGame)
end

previousLetter = function()
    if isGroup(getGameByNumber(gameList, currentGame)) then
        groupSelection = groupSelection - 1
        infoMessage = getInfo()
    else
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
        infoMessage = getInfo()
        Gamestate.switch(Gamestate.previousLetter, oldGame, currentGame)
    end
end

nextLetter = function()
    if isGroup(getGameByNumber(gameList, currentGame)) then
        groupSelection = groupSelection + 1
        infoMessage = getInfo()
    else
        oldGame = currentGame
        local gameName = getDescriptionOfNumber(gameList, currentGame)
        local firstLetter = string.sub(gameName, 1, 1)
        while string.sub(getDescriptionOfNumber(gameList, currentGame), 1, 1) == firstLetter do
            currentGame = currentGame + 1
        end
        infoMessage = getInfo()
        Gamestate.switch(Gamestate.nextLetter, oldGame, currentGame)
    end
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

function getInfo()
	local game = getGameByNumber(gameList, currentGame)
    if isGroup(game) then
        game = getGameOfGroup(game, groupSelection)
    end
    
    local info = ""
    
    genre = getTagValue(game, "genre")
    if genre == nil then
        genre = "unknown"
    end
    info = info .. "Genre : " .. genre .. "\n"
	info = info .. "Year : " .. getTagValue(game, "year") .. "\n"
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
    
function drawBackground() --separated from st:draw because re-used in other states
	local game = getGameByNumber(gameList, currentGame)
    if isGroup(game) then
        game = getGameOfGroup(game, groupSelection)
    end
	
    --print outlines for snaps and marquees
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(10,10,10)
    love.graphics.rectangle("fill", W/5, H/5, W*3/5, H*3/5)
    love.graphics.rectangle("fill", W/5, H/60, W*3/5, H/6)
    love.graphics.setColor(r,g,b,a)
    
	if game["Snap"] ~= nil then
		local X = game["Snap"]:getWidth()
		local Y = game["Snap"]:getHeight()
		local scale = (W*3/5)/X
		if Y*scale > H*3/5 then
			scale = (H*3/5)/Y
		end
		love.graphics.draw(game["Snap"], W/2 - X*scale/2, H/2 - (Y/2)*scale, 0, scale)	
	end
	
    if game["Marquee"] ~= nil and game["Marquee"]:getWidth() > game["Marquee"]:getHeight() then
        local X = game["Marquee"]:getWidth()
        local Y = game["Marquee"]:getHeight()
        local scale = (W*3/5)/X
        if Y*scale > H/6 then
            scale = (H/6)/Y
        end
        love.graphics.draw(game["Marquee"], (W/2) - X*scale/2, (H/5)/2 - Y*scale/2, 0, scale)
    elseif game["Logo"] ~= nil then
        local X = game["Logo"]:getWidth()
        local Y = game["Logo"]:getHeight()
        local scale = (W*3/6)/X
        if Y*scale > H/6 then
            scale = (H/6)/Y
        end
        love.graphics.draw(game["Logo"], (W/2) - X*scale/2, (H/5)/2 - Y*scale/2, 0, scale)
    else
        love.graphics.printf(getTagValue(game, "description"), 0, (H/6)/2, W, "center")
    end
	
    love.graphics.printf(infoMessage, 5, H/2 -fontHeight*3, (W/5)-5)
    
    love.graphics.draw(im.joystick, W/20, H*4/5 + H/10 - joystickHeight/2, 0, joystickScaleX, joystickScaleY)
    love.graphics.draw(im.joystick, W/2, H*4/5 + H/10 - joystickHeight/2, 0, joystickScaleX, joystickScaleY)
    
    love.graphics.draw(im.tdArrow, W/20 + (W/5)/3 + 10, H*4/5 + H/10 - tdArrowHeight/2, 0, tdArrowScaleX, tdArrowScaleY)
    love.graphics.print("next/previous game", W/20 + (W/5)/3 + 20 + (W/5)/4, H*4/5 + H/10 - fontHeight)
    
    love.graphics.draw(im.lrArrow, W/2 + (W/5)/3 + 10, H*4/5 + H/10 - lrArrowHeight/2, 0, lrArrowScaleX, lrArrowScaleY)
    local message
    if isGroup(getGameByNumber(gameList, currentGame)) then
        message = "next/previous game"
    else
        message = "next/previous letter"
    end
    love.graphics.print(message, W/2 + (W/5)/3 + 20 + (W/5)/4, H*4/5 + H/10 - fontHeight)
    
    --arrow pointing the selected game
    love.graphics.draw(im.arrow, W - pointingArrowWidth, H/2 - pointingArrowHeight/2, 0, pointingArrowScaleX, pointingArrowScaleY)
end

function drawGroupArrows()
    local d = (love.timer.getTime() % 2) - 1
    if d < 0 then
        d = d * ((W/25)/2)
    else
        d = -d * ((W/25)/2)
    end
    
    local r,g,b,a = love.graphics.getColor()
    if not isGroup(getGameByNumber(gameList, currentGame)) then --if current selection is not a group, arrows are drawn in gray
        love.graphics.setColor(0,50,50,255/2)
        d = -(W/25)/2
    end
    
    love.graphics.draw(im.arrow, W/5 + d, (H/5)/2 - groupArrowHeight/2, 0, groupArrowScaleX, groupArrowScaleY)
    love.graphics.draw(im.arrow, W*4/5 - d, (H/5)/2 - groupArrowHeight/2, 0, -groupArrowScaleX, groupArrowScaleY)
    love.graphics.setColor(r,g,b,a)
end

--launch.lua

--first real state activated, loads everything requiered and displays logo

require "frontend"

Gamestate.launch = Gamestate.new()
local st = Gamestate.launch

local logo
local numLoaded
local toLoad
local first

function st:enter()
	logo = love.graphics.newImage("Logo.png")
    loadingBar = love.graphics.newImage("Loading Start.png")
    loadingBarEnd = love.graphics.newImage("Loading End.png")
    
	timerLogo = 0
	loaded = false
    first = true
	
	W = love.graphics.getWidth()
	H = love.graphics.getHeight()
	
	--thickness of red lines
	LW = W/32 
	LH = H/24
    
    numLoaded = 0
    toLoad = 100
    
    love.graphics.setFont(love.graphics.newFont("SWEETASCANDY.TTF"))
end

function st:update(dt)
    if first then
        timerLogo = 0
        first = false
    else
        timerLogo = timerLogo + dt
    end
	
	if timerLogo > 1 and not loaded then
		load()
		loaded = true
        first = true
        timerLogo = 0
	end
    
    if loaded and timerLogo > 1 then
		love.graphics.setColor(255,255,255,255)
		Gamestate.switch(Gamestate.frontend)
	end
    
	if not loaded then
		love.graphics.setColor(255,255,255,255*timerLogo)
	else
		love.graphics.setColor(255,255,255,255 - 255*timerLogo)
	end
end

function st:draw()
	if loaded then
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(255,255,255,255)
		--drawBackground()
        Gamestate.frontend:draw()
		love.graphics.setColor(r,g,b,a)
	end
	
	love.graphics.draw(logo, W/2 - logo:getWidth()/2, H/2 - logo:getHeight()/2)
    
    if numLoaded ~= nil then
        local X = W/5
        local length = W*3/5
        local Y = H*3/4
        local height = H/8
        local scaleX = length/loadingBar:getWidth()
        local scaleY = height/loadingBar:getHeight()
        
        if numLoaded < toLoad then
            love.graphics.draw(loadingBar, X, Y, 0, scaleX, scaleY)
            
            local r,g,b,a = love.graphics.getColor()
            love.graphics.setColor(230,88,160)
            love.graphics.rectangle('fill', X + 33*scaleX, Y + 19*scaleY, (length - 2*33*scaleX)*(numLoaded/toLoad), height - 2*19*scaleY)
            love.graphics.setColor(r,g,b,a)
        else
            love.graphics.draw(loadingBarEnd, X, Y, 0, scaleX, scaleY)
        end
        
        if numLoaded ~= 0 then
            love.graphics.printf(numLoaded .. "/" .. toLoad, W/2, Y + 30, 0, "center")
        end
    end
end

function st:leave()
	logo = nil
    loadingBar = nil
    loadingBarEnd = nil
end

function load()
    print("Reading game list")
	love.filesystem.load("availableList.lua")() -- gives a gameList table with all games in
	math.randomseed(os.time())
    -- it is said that the first random numbers aren't really random.
	math.random(#gameList);math.random(#gameList);math.random(#gameList);math.random(#gameList);math.random(#gameList)
	currentGame = math.random(#gameList)
    
    fontHeight = 12
    
    groupSelection = 1
    
    im = {}
    im.arrow = love.graphics.newImage("Arrow.png")
    im.joystick = love.graphics.newImage("Joystick.png")
    im.tdArrow = love.graphics.newImage("topDownArrow.png")
    im.lrArrow = love.graphics.newImage("leftRightArrow.png")
    im.redButton = love.graphics.newImage("RedButton.png")
    im.yellowButton = love.graphics.newImage("YellowButton.png")
    im.notSelectedSquare = love.graphics.newImage("Square.png")
    im.selectedSquare = love.graphics.newImage("SelectedSquare.png")
    im.unavailable = love.graphics.newImage("Unavailable.png")
    
    Gamestate.frontend:enter()
    
	mt = {}
	mt.__index = function(o, key)
		if key == 0 then
			return o[table.maxn(o)]
		else
            return o[key%table.maxn(o)]
        end
	end
	setmetatable(gameList, mt)
	
	infoMessage = getInfo()
    
    local snapList = love.filesystem.enumerate("MAME/Snap")
    local marqueeList = love.filesystem.enumerate("MAME/Marquee")
    local logoList = love.filesystem.enumerate("MAME/Logo")
    local romList = love.filesystem.enumerate("MAME/roms")
    toLoad = #romList*3
    numLoaded = 0
    
    for _, rom in pairs(romList) do
        local gameName = string.gsub(rom, ".zip", "")
        local game = getGameByName(gameList, gameName)
        if game ~= nil then
            if love.filesystem.exists("MAME/Snap/"..gameName..".png") then
                game["Snap"] = love.graphics.newImage("MAME/Snap/"..gameName..".png")
            end
            if love.filesystem.exists("MAME/Marquee/"..gameName..".png") then
                game["Marquee"] = love.graphics.newImage("MAME/Marquee/"..gameName..".png")
            end
            if love.filesystem.exists("MAME/Logo/"..gameName..".png") then
                game["Logo"] = love.graphics.newImage("MAME/Logo/"..gameName..".png")
            end
        end
        numLoaded = numLoaded + 3
        love.graphics.clear()
        love.draw()
        love.graphics.present()
    end
	
	love.filesystem.load("customControls.lua")()  --controls are saved in there
	nbJoy = love.joystick.getNumJoysticks()
	for i=0,nbJoy do
		love.joystick.open(i)
	end
end
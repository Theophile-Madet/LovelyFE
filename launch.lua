--launch.lua

--first real state activated, loads everything requiered and displays logo

require "frontend"

Gamestate.launch = Gamestate.new()
local st = Gamestate.launch

local logo
local numLoaded
local toLoad

function st:enter()
	logo = love.graphics.newImage("Logo.png")
	timerLogo = 0
	loaded = false
	first = true
	
	W = love.graphics.getWidth()
	H = love.graphics.getHeight()
	
	--thickness of red lines
	LW = W/32 
	LH = H/24
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
	elseif timerLogo > 3 then
		love.graphics.setColor(255,255,255,255)
		Gamestate.switch(Gamestate.frontend)
	end
	
	if timerLogo < 1 then
		love.graphics.setColor(255,255,255,255*timerLogo)
	elseif timerLogo > 2 then
		love.graphics.setColor(255,255,255,255*(3-timerLogo))
	end
end

function st:draw()
	if loaded then
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(255,255,255,255)
		drawBackground()
		love.graphics.setColor(r,g,b,a)
	end
	
	local W = love.graphics.getWidth()
	local H = love.graphics.getHeight()
	love.graphics.draw(logo, W/2 - logo:getWidth()/2, H/2 - logo:getHeight()/2)
    
    if numLoaded ~= nil then
        local r, g, b, a = love.graphics.getColor()
        local X = W/5
        local length = W*3/5
        local Y = H*3/4
        local height = H/10
        love.graphics.setColor(100,100,100)
        love.graphics.polygon('fill', X, Y, X + length, Y, X + length, Y + height, X, Y + height)
        love.graphics.setColor(200, 0, 0)
        love.graphics.polygon('fill', X, Y, X + length*(numLoaded/toLoad), Y, X + length*(numLoaded/toLoad), Y + height, X, Y + height)
        love.graphics.setColor(255,255,255)
        love.graphics.printf(numLoaded .. "/" .. toLoad, W/2, Y + 2, 0, "center")
        love.graphics.setColor(r,g,b,a)
    end
end

function st:leave()
	logo = nil
end

function load()
    print("Reading game list")
	love.filesystem.load("availableList.lua")() -- gives a gameList table with all games in
	math.randomseed(os.time())
	math.random(#gameList) -- it is said that the first random numbers aren't really random.
	math.random(#gameList)
	math.random(#gameList)
	math.random(#gameList)
	math.random(#gameList)
	currentGame = math.random(#gameList)
	
    fontHeight = 12
    
    groupSelection = 1
    
    arrow = love.graphics.newImage("Arrow.png")
    
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
	
    love.graphics.setFont(love.graphics.newFont("SWEETASCANDY.TTF"))
    
	timer = love.timer.getTime()
	timeLimit = 0.2
end
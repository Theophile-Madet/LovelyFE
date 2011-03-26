--launch.lua

--first real state activated, loads everything requiered and displays logo

require "frontend"

Gamestate.launch = Gamestate.new()
local st = Gamestate.launch

local logo

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
end

function st:leave()
	logo = nil
end

function load()
	love.filesystem.load("availableList.lua")() -- gives a gameList table with all games in
	math.randomseed(os.time())
	math.random(#gameList) -- it is said that the first random numbers aren't really random.
	math.random(#gameList)
	math.random(#gameList)
	math.random(#gameList)
	math.random(#gameList)
	currentGame = math.random(#gameList)
	currentImage = 13
	images={"Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title"}
	
	mt = {}
	mt.__index = function(o, key)
		if key == 0 then
			return o[table.maxn(o)]
		end
		return o[key%table.maxn(o)]
	end
	setmetatable(gameList, mt)
	setmetatable(images, mt)
	
	loadGameImages(gameList[currentGame], "Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title")
	infoMessage = getInfo()
	
	borne = love.graphics.newImage("Base.png")
	dkface = love.graphics.newImage("DKface.png")
	dkcote = love.graphics.newImage("DKcote.png")
	tonneaux = {}
	tonneaux[1] = love.graphics.newImage("Tonneau1.png")
	tonneaux[2] = love.graphics.newImage("Tonneau2.png")
	tonneaux[3] = love.graphics.newImage("Tonneau3.png")
	tonneaux[4] = love.graphics.newImage("Tonneau4.png")
	love.graphics.setBackgroundColor(30,30,30)
	
	love.filesystem.load("customControls.lua")()  --controls are saved in there
	nbJoy = love.joystick.getNumJoysticks()
	for i=0,nbJoy do
		love.joystick.open(i)
	end
	
	timer = love.timer.getTime()
	timeLimit = 0.2
end
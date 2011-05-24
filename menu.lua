--menu.lua

--simple menu showing the "advanced" functions, such as search.
--only search and images are available at this time

Gamestate.menu = Gamestate.new()
local st = Gamestate.menu

local selected = 1
local scaleX, scaleY
local X, Y
local unavailable
local game
local oldState
local lastInputTime = 0
--local numberOfSquares = 3
--local squaresPerLine = 3
--local numberOfLines = math.ceil(numberOfSquares/squaresPerLine)

local treatInput

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	
	scaleX = (W/4)/im.selectedSquare:getWidth()
	scaleY = (H/4)/im.selectedSquare:getHeight()
	
	X = im.selectedSquare:getWidth()*scaleX
	Y = im.selectedSquare:getHeight()*scaleY

	game = gameList[currentGame]
end

function st:draw()
	love.graphics.setColor(255,255,255,255/2)
	drawBackground()
	love.graphics.setColor(255,255,255,255)
	
	local square,message
	
	for i=1,3 do
		if i == selected then
			square = im.selectedSquare
		else
			square = im.notSelectedSquare
		end
		love.graphics.draw(square, (W/16)*i + X*(i-1), H/2 - Y/2, 0, scaleX, scaleY)
		if i == 1 then
			message = "Images"
		elseif i == 2 then
			message = "Search"
		elseif i == 3 then
			message = "Unused"
		end
		love.graphics.print(message, (W/16)*i + X*(i-1), H/2 - Y/2)
	end
end

function st:update(dt)
	for i=0,(nbJoy-1) do
		for j=0,joys[i]["nbHats"]-1 do
			local input = controools[i][love.joystick.getHat(i,j)]
			if input ~= nil and input ~= joys[i]["lastInput"] then
				treatInput(input)
			end
		end
	end
end

function st:keypressed(key, unicode)
	local input = controools["keyboard"][key]
	if input ~= nil then
		treatInput(input)
	end
end

function st:joystickpressed(joystick, button)
	local input = controools[joystick][button]
	if input ~= nil then
		treatInput(input)
	end
end

treatInput = function(input)
	if input == "menu/cancel" then
		Gamestate.switch(Gamestate.frontend)
	elseif input == "action" then
		if     selected == 1 then Gamestate.switch(Gamestate.imagesMenu)
		elseif selected == 2 then Gamestate.switch(Gamestate.search)
		end
    elseif input == "exit" then
        love.event.push("q")
	elseif love.timer.getTime() - lastInputTime > 0.2 then
		if input == input == "next game" then 
			selected = selected + 3 
			lastInputTime = love.timer.getTime()
		elseif input == "previous game" then
			selected = selected - 3
			lastInputTime = love.timer.getTime()
		elseif input == "next letter" then
			selected = selected + 1
			lastInputTime = love.timer.getTime()
		elseif input == "previous letter" then
			selected = selected - 1
			lastInputTime = love.timer.getTime()
		end
	end
	
	if selected > 3 then
		selected = selected % 3
	end
	if selected <= 0 then
		selected = 3
	end
end
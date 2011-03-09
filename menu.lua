--menu.lua

Gamestate.menu = Gamestate.new()
local st = Gamestate.menu

local selected = 1
local selectedSquare, notSelectedSquare
local scaleX, scaleY
local X, Y
local unavailable
local game
local oldState
--local numberOfSquares = 3
--local squaresPerLine = 3
--local numberOfLines = math.ceil(numberOfSquares/squaresPerLine)

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	if selectedSquare == nil then
		notSelectedSquare = love.graphics.newImage("Square.png")
		selectedSquare = love.graphics.newImage("SelectedSquare.png")
	end
	
	if unavailable == nil then
		unavailable = love.graphics.newImage("Unavailable.png")
	end
	
	scaleX = (W/4)/selectedSquare:getWidth()
	scaleY = (H/4)/selectedSquare:getHeight()
	
	X = selectedSquare:getWidth()*scaleX
	Y = selectedSquare:getHeight()*scaleY

	game = gameList[currentGame]
end

function st:draw()
	love.graphics.setColor(255,255,255,255/2)
	drawBackground()
	love.graphics.setColor(255,255,255,255)
	
	local square,message
	
	for i=1,3 do
		if i == selected then
			square = selectedSquare
		else
			square = notSelectedSquare
		end
		love.graphics.draw(square, (W/16)*i + X*(i-1), H/2 - Y/2, 0, scaleX, scaleY)
		if i == 1 then
			message = "Images"
		elseif i == 2 then
			message = "Recherche"
		elseif i == 3 then
			message = "Commentaire"
		end
		love.graphics.print(message, (W/16)*i + X*(i-1), H/2 - Y/2)
	end
end

function st:update(dt)
	for i=0,(nbJoy-1) do
		for j=0,joys[i]["nbHats"]-1 do
			local input = controools[i][love.joystick.getHat(i,j)]
			if input == "next game" and joys[i]["lastInput"] ~= input then
				selected = selected + 3
			elseif input == "previous game" and joys[i]["lastInput"] ~= input then
				selected = selected - 3
			elseif input == "next letter" and joys[i]["lastInput"] ~= input then
				selected = selected + 1
			elseif input == "previous letter" and joys[i]["lastInput"] ~= input then
				selected = selected - 1
			end
			
			joys[i]["lastInput"] = input
			if selected > 3 or selected < 0 then
				selected = selected % 3
			end
			if selected == 0 then
				selected = 3
			end
		end
	end
end

function st:keypressed(key, unicode)
	local input = controools["keyboard"][key]
	if input == "menu/cancel" then
		Gamestate.switch(Gamestate.frontend)
	elseif input == "action" then
		if selected == 1 then
			Gamestate.switch(Gamestate.imagesMenu)
		elseif selected == 2 then
			Gamestate.switch(Gamestate.search)
		end
	elseif input == "next game" then
		selected = selected + 3
	elseif input == "previous game" then
		selected = selected - 3
	elseif input == "next letter" then
		selected = selected + 1
	elseif input == "previous letter" then
		selected = selected - 1
	end
	
	if selected > 3 or selected < 0 then
		selected = selected % 3
	end
	if selected == 0 then
		selected = 3
	end
end

function st:joystickpressed(joystick, button)
	local input = controools[joystick][button]
	if input == "menu/cancel" then
		Gamestate.switch(Gamestate.frontend)
	elseif input == "action" then
		if selected == 1 then
			Gamestate.switch(Gamestate.imagesMenu)
		elseif selected == 2 then
			Gamestate.switch(Gamestate.search)
		end
	elseif input == "next game" then 
		selected = selected + 1 
	elseif input == "previous game" then
		selected = selected - 1
	elseif input == "next letter" then
		selected = selected + 3
	elseif input == "previous letter" then
		selected = selected - 3
	end
	
	if selected > 3 then
		selected = selected % 3
	end
	if selected == 0 then
		selected = 3
	end
end
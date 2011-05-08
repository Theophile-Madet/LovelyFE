--search.lua

--search menu used to search games by name

Gamestate.search = Gamestate.new()
local st = Gamestate.search

local selected
local searchString
local resultString
local searchList
local numberOfSelectable
local typeOfSelected
local squareWidth, squareHeight
local rectangleWidth, rectangleHeight
local selectedSquare, notSelectedSquare
local scaleX, scaleY
local rectScaleX, rectScaleY
local numberOfRectangles
local numberOfSelectable
local oldState

local treatInput

function st:enter(in_oldState)
	oldState = in_oldState
	typeOfSelected = "letter"
	selected = 1
	searchString = ""
	resultString  = ""
	searchList = {}
	space = 10
	squareWidth = ((W-(W/5))-9*space)/10
	squareHeight = ((H/3)-2*space)/3
	
	rectangleWidth = W-W/5
	rectangleHeight = squareHeight/2
	if notSelectedSquare == nil then
		notSelectedSquare = love.graphics.newImage("Square.png")
		selectedSquare = love.graphics.newImage("SelectedSquare.png")
	end
	
	square = notSelectedSquare
	
	scaleX = squareWidth / square:getWidth()
	scaleY = squareHeight / square:getHeight()
	
	rectScaleX = rectangleWidth / square:getWidth()
	rectScaleY = rectangleHeight / square:getHeight()
	
	numberOfRectangles = math.floor((H -(H/5 + 3*space + 3*squareHeight))/(rectangleHeight+space))
	numberOfSelectable = 30 + numberOfRectangles
	textFont = love.graphics.newFont(20)
    searchStringFont = love.graphics.newFont(40)
    oldFont = love.graphics.getFont()
end

function st:draw()
	love.graphics.setColor(255,255,255,255/2)
	drawBackground()
	love.graphics.setColor(255,255,255,255)
	
    love.graphics.setFont(textFont)
    
	for i=1,10 do
		for j=1,3 do
			squareNumber = ((j-1)*10)+i
			if typeOfSelected == "letter" and squareNumber == selected then
				square = selectedSquare
			else
				square = notSelectedSquare
			end
			
			x = (W/5)/2 + (i-1)*space + (i-1)*squareWidth
			y = H/5 + (j-1)*space + (j-1)*squareHeight
			love.graphics.draw(square, x, y, 0, scaleX, scaleY)
			love.graphics.print(string.char(string.byte('a')+squareNumber-1), x + squareWidth/2 - 10, y + squareHeight/2 - 10)
		end
	end
	
	for i = 1,numberOfRectangles do
		if typeOfSelected == "game" and i == selected then
			square = selectedSquare
		else
			square = notSelectedSquare
		end
		love.graphics.draw(square, (W/5)/2, H/5 + 3*space + 3*squareHeight + (i-1)*(rectangleHeight+space), 0, rectScaleX, rectScaleY)
		if searchList[i] ~= nil then
			love.graphics.print(getDescriptionOfNumber(gameList, searchList[i]), (W/5)/2+space, H/5 + 3*space + 3*squareHeight + (i-1)*(rectangleHeight+space) + space)
		end
	end
    
    love.graphics.setFont(searchStringFont)
	love.graphics.printf(searchString, W/2, (H/5)/3 - (searchStringFont:getHeight()/2), 0, "center")
end

function st:leave()
	love.graphics.setFont(oldFont)	
end

function st:update(dt)
	for i=0,(nbJoy-1) do
		for j=0,joys[i]["nbHats"]-1 do
			local input = controools[i][love.joystick.getHat(i,j)]
			if input ~= nil and input ~= joys[i]["lastInput"] then
				treatInput(input)
			end
			joys[i]["lastInput"] = input
		end
	end		
end

function st:joystickpressed(joystick, button)
	local input = controools[joystick][button]
	if input ~= nil then
		treatInput(input)
	end
end

function st:keypressed(key, unicode)
	local input = controools["keyboard"][key]
	if input ~= nil then
		treatInput(input)
	end
end

treatInput = function(input)
	--"next game" and "previous game" are supposed to be mapped to down/up and "next/previous letter" to left/right
	--there should be a better, more general solution
	if     input == "menu/cancel" then Gamestate.switch(oldState)
    elseif input == "exit"        then os.exit()
	end
	
	if typeOfSelected == "letter" then
		if input == "next game" then
			selected = selected + 10
		elseif input == "previous game" then
			selected = selected - 10
		elseif input == "next letter" then
			selected = selected + 1
		elseif input == "previous letter" then
			selected = selected - 1
		elseif input == "action" then
			updateSearchList()
		end
		
		if selected > 30 then
			typeOfSelected = "game"
			selected = 1
		elseif selected <= 0 then
			typeOfSelected = "game"
			selected = numberOfRectangles
		end
	elseif typeOfSelected == "game" then
		if input == "next game" then
			selected = selected + 1
		elseif input == "previous game" then
			selected = selected - 1
		elseif input == "action" then
			if searchList[selected] ~= nil then
				launch(getNameOfNumber(gameList, searchList[selected]))
			end
		end
		if selected > numberOfRectangles then
			typeOfSelected = "letter"
			selected = 1
		elseif selected <= 0 then
			typeOfSelected = "letter"
			selected = 30
		end
	end
end

function updateSearchList()
	searchList = {}
	searchString = searchString .. string.char(string.byte('a')+selected-1)
	for k in pairs(gameList) do
		if string.find(string.lower(getDescriptionOfNumber(gameList, k)), searchString) ~= nil then
			table.insert(searchList, k)
		end
	end
end

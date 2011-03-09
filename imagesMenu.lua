--imagesMenu.lua

--a menu showing all images available (cabinet, controls, adverts...)

Gamestate.imagesMenu = Gamestate.new()
local st = Gamestate.imagesMenu

require "imageDetail"

local selected = 1
local selectedSquare, notSelectedSquare
local scaleX, scaleY
local unavailable
local game
local oldState

function st:enter(in_oldState)
	oldState = in_oldState
	if selectedSquare == nil then
		notSelectedSquare = love.graphics.newImage("Square.png")
		selectedSquare = love.graphics.newImage("SelectedSquare.png")
	end
	
	scaleX = (W/4)/selectedSquare:getWidth()
	scaleY = (H/4)/selectedSquare:getHeight()
	
	if unavailable == nil then
		unavailable = love.graphics.newImage("Unavailable.png")
	end
	game = gameList[currentGame]
end

function st:draw()
	love.graphics.setColor(255,255,255,255/2)
	drawBackground()
	love.graphics.setColor(255,255,255,255)
	
	images={"Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title"}
	local image
	
	if game["Advert"] ~= nil then
		image = game["Advert"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, W/16 + W/4/2 - image:getWidth()*scaleImage/2, H/16 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 1 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, W/16, H/16, 0, scaleX, scaleY)
	love.graphics.print("Advert", W/16, H/16)
	
	if game["Artwork"] ~= nil then
		image = game["Artwork"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, 2*(W/16) + W/4 + W/4/2 - image:getWidth()*scaleImage/2, H/16 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 2 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, 2*(W/16) + W/4, H/16, 0, scaleX, scaleY)
	love.graphics.print("Artwork", 2*(W/16) + W/4, H/16)
	
	if game["Cabinet"] ~= nil then
		image = game["Cabinet"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, 3*(W/16) + 2*W/4 + W/4/2 - image:getWidth()*scaleImage/2, H/16 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 3 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, 3*(W/16) + 2*W/4, H/16, 0, scaleX, scaleY)
	love.graphics.print("Cabinet", 3*(W/16) + 2*W/4, H/16)
	
	
	if game["Controls"] ~= nil then
		image = game["Controls"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, W/16 + W/4/2 - image:getWidth()*scaleImage/2, 2*(H/16) + H/4 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 4 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, W/16, 2*(H/16) + H/4, 0, scaleX, scaleY)
	love.graphics.print("Controls", W/16, 2*(H/16) + H/4)
	
	if game["CP"] ~= nil then
		image = game["CP"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, 2*(W/16) + W/4 + W/4/2 - image:getWidth()*scaleImage/2, 2*(H/16) + H/4 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 5 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, 2*(W/16) + W/4, 2*(H/16) + H/4, 0, scaleX, scaleY)
	love.graphics.print("CP", 2*(W/16) + W/4, 2*(H/16) + H/4)
	
	if game["Logo"] ~= nil then
		image = game["Logo"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, 3*(W/16) + 2*W/4 + W/4/2 - image:getWidth()*scaleImage/2, 2*(H/16) + H/4 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 6 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, 3*(W/16) + 2*W/4, 2*(H/16) + H/4, 0, scaleX, scaleY)
	love.graphics.print("Logo", 3*(W/16) + 2*W/4, 2*(H/16) + H/4)
	
	
	if game["Marquee"] ~= nil then
		image = game["Marquee"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, W/16 + W/4/2 - image:getWidth()*scaleImage/2, 3*(H/16) + 2*H/4 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 7 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, W/16, 3*(H/16) + 2*H/4, 0, scaleX, scaleY)
	love.graphics.print("Marquee", W/16, 3*(H/16) + 2*H/4)
	
	if game["Select"] ~= nil then
		image = game["Select"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, 2*(W/16) + W/4 + W/4/2 - image:getWidth()*scaleImage/2, 3*(H/16) + 2*H/4 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 8 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, 2*(W/16) + W/4, 3*(H/16) + 2*H/4, 0, scaleX, scaleY)
	love.graphics.print("Select", 2*(W/16) + W/4, 3*(H/16) + 2*H/4)
	
	if game["Title"] ~= nil then
		image = game["Title"]
	else
		image = unavailable
	end
	scaleImage = (W/4)/image:getWidth()
	if image:getHeight()*scaleImage > H/4 then
		scaleImage = (H/4)/image:getHeight()
	end
	love.graphics.draw(image, 3*(W/16) + 2*W/4 + W/4/2 - image:getWidth()*scaleImage/2, 3*(H/16) + 2*H/4 + H/4/2 - image:getHeight()*scaleImage/2, 0, scaleImage)
	if selected == 9 then
		square = selectedSquare
	else
		square = notSelectedSquare
	end
	love.graphics.draw(square, 3*(W/16) + 2*W/4, 3*(H/16) + 2*H/4, 0, scaleX, scaleY)
	love.graphics.print("Title", 3*(W/16) + 2*W/4, 3*(H/16) + 2*H/4)
end

function st:joystickpressed(joystick, button)
	local input = controools[joystick][button]
	if input == "menu/cancel" then
		Gamestate.switch(Gamestate.menu)
	elseif input == "action" then
		goToImageDetail()
	elseif input == "next game" then 
		selected = selected + 1 
	elseif input == "previous game" then
		selected = selected - 1
	elseif input == "next letter" then
		selected = selected + 3
	elseif input == "previous letter" then
		selected = selected - 3
	end
	
	if selected > 9 then
		selected = selected % 9
	end
	if selected == 0 then
		selected = 9
	end
end

function st:keypressed(key, unicode)
	local input = controools["keyboard"][key]
	if input == "menu/cancel" then
		Gamestate.switch(Gamestate.menu)
	elseif input == "action" then
		goToImageDetail()
	elseif input == "next game" then
		selected = selected + 3
	elseif input == "previous game" then
		selected = selected - 3
	elseif input == "next letter" then
		selected = selected + 1
	elseif input == "previous letter" then
		selected = selected - 1
	end
	
	if selected > 9 or selected < 0 then
		selected = selected % 9
	end
	if selected == 0 then
		selected = 9
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
			if selected > 9 or selected < 0 then
				selected = selected % 9
			end
			if selected == 0 then
				selected = 9
			end
		end
	end
end

function goToImageDetail()
	local image
	local x,y
	
	if selected == 1 then
		if game["Advert"] == nil then
			return
		end
		image = game["Advert"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = W/16 + W/4/2 - image:getWidth()*scaleImage/2
		y = H/16 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	if selected == 2 then
		if game["Artwork"] == nil then
			return
		end
		image = game["Artwork"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = 2*(W/16) + W/4 + W/4/2 - image:getWidth()*scaleImage/2
		y =	H/16 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	if selected == 3 then
		if game["Cabinet"] == nil then
			return
		end
		image = game["Cabinet"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = 3*(W/16) + 2*W/4 + W/4/2 - image:getWidth()*scaleImage/2
		y = H/16 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	if selected == 4 then
		if game["Controls"] == nil then
			return
		end
		image = game["Controls"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = W/16 + W/4/2 - image:getWidth()*scaleImage/2
		y = 2*(H/16) + H/4 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	if selected == 5 then
		if game["CP"] == nil then
			return
		end
		image = game["CP"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = 2*(W/16) + W/4 + W/4/2 - image:getWidth()*scaleImage/2
		y = 2*(H/16) + H/4 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	if selected == 6 then
		if game["Logo"] == nil then
			return
		end
		image = game["Logo"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = 3*(W/16) + 2*W/4 + W/4/2 - image:getWidth()*scaleImage/2
		y = 2*(H/16) + H/4 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	if selected == 7 then
		if game["Marquee"] == nil then
			return
		end
		image = game["Marquee"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = W/16 + W/4/2 - image:getWidth()*scaleImage/2
		y = 3*(H/16) + 2*H/4 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	if selected == 8 then
		if game["Select"] == nil then
			return
		end
		image = game["Select"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = 2*(W/16) + W/4 + W/4/2 - image:getWidth()*scaleImage/2
		y = 3*(H/16) + 2*H/4 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	if selected == 9 then
		if game["Title"] == nil then
			return
		end
		image = game["Title"]
		scaleImage = (W/4)/image:getWidth()
		if image:getHeight()*scaleImage > H/4 then
			scaleImage = (H/4)/image:getHeight()
		end
		x = 3*(W/16) + 2*W/4 + W/4/2 - image:getWidth()*scaleImage/2
		y = 3*(H/16) + 2*H/4 + H/4/2 - image:getHeight()*scaleImage/2
	end
	
	Gamestate.switch(Gamestate.imageDetail, image, x, y, scaleImage)
end
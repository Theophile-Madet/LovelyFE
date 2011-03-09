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


function st:draw()
	local game = gameList[currentGame]

	drawBackground()
	
	-- Prints useful messages for debugging
	--[[ love.graphics.print(xml.find(game, "description")[1], 0, 0)
	love.graphics.print("currentGame = " ..currentGame, 0, 15)
	love.graphics.print("currentImage = " ..currentImage, 0, 30)
	love.graphics.print(images[currentImage], 0, 45)
	love.graphics.printf(infoMessage, LW + 0.1*LW, 2*LH + H/5 + 20, (250/1600)*W) --]]

	--Print game names on the right
	love.graphics.print(xml.find(gameList[currentGame-2], "description")[1], (1300/1600)*W, (550/1200)*H, -0.05)
	love.graphics.print(xml.find(gameList[currentGame-1], "description")[1], (1280/1600)*W, (690/1200)*H, 0.05)
	love.graphics.print(xml.find(gameList[currentGame], "description")[1], (1300/1600)*W, (835/1200)*H, -0.05)
	love.graphics.print(xml.find(gameList[currentGame+1], "description")[1], (1280/1600)*W, (950/1200)*H, 0.05)
	love.graphics.print(xml.find(gameList[currentGame+2], "description")[1], (1280/1600)*W, (1140/1200)*H)
	
	love.graphics.draw(tonneaux[1], (1300/1600)*W - tonneaux[1]:getWidth(), (835/1200)*H)
	
end

function st:keypressed(key, unicode)
	if controools["keyboard"][key] ~= nil then
		f[controools["keyboard"][key]]()
	elseif key == "escape" then
		os.exit()
	end
end

function st:update(dt)
	for i=0,(nbJoy-1) do
		for j=0,joys[i]["nbHats"]-1 do
			if love.joystick.getHat(i,j) ~= "c" then
				if f[controools[i][love.joystick.getHat(i,j)]] ~= nil then
					f[controools[i][love.joystick.getHat(i,j)]]()
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
	if f[controools[joystick][button] ] ~= nil then
		f[controools[joystick][button] ]()
	end
end

function loadGameImages(game, ...)
	local name = game["name"]
	for _, folder in ipairs{...} do
		if game[folder] == nil then
			local path = "MAME/"..folder.."/"..name
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

function emptyGameImages(game) --remove some images from memory
	print("emptying "..game["name"])
	for _, image in ipairs(images) do
		game[image]=nil
	end
	collectgarbage()
end

function launch(romName)
	if romName == nil then
		romName = gameList[currentGame]["name"]
	end
	cmd = "mame.exe.lnk ".. romName
	print(cmd)
	os.execute(cmd)
end

function nextGame()
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

function previousGame()
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

function previousLetter()
	oldGame = currentGame
	if love.timer.getTime() - timer > timeLimit then
		if string.sub(xml.find(gameList[currentGame], "description")[1],1) == "a" then
				currentGame = 1
		end
		firstLetterCode = string.byte(string.lower(xml.find(gameList[currentGame], "description")[1]), 1)
		while string.byte(string.lower(xml.find(gameList[currentGame], "description")[1]),1) >= (firstLetterCode) do
			currentGame = currentGame - 1
			if currentGame < 1 then 
				currentGame = #gameList
				break
			end
		end
		firstLetterCode = string.byte(string.lower(xml.find(gameList[currentGame], "description")[1]), 1)
		while string.byte(string.lower(xml.find(gameList[currentGame], "description")[1]),1) == (firstLetterCode) do
			currentGame = currentGame - 1
			if currentGame < 1 then 
				currentGame = #gameList
				break
			end
		end
		currentGame = currentGame + 1
		loadGameImages(gameList[currentGame], "Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title")
		timer = love.timer.getTime()
	end
	infoMessage = getInfo()
	Gamestate.switch(Gamestate.previousLetter, oldGame, currentGame)
	love.draw()
end

function nextLetter()
	oldGame = currentGame
	if love.timer.getTime() - timer > timeLimit then
		firstLetterCode = string.byte(string.lower(xml.find(gameList[currentGame], "description")[1]), 1)
		while xml.find(gameList[currentGame], "description")~=nil and string.byte(string.lower(xml.find(gameList[currentGame], "description")[1]),1) == firstLetterCode do
			currentGame = currentGame + 1
		end
		loadGameImages(gameList[currentGame], "Advert", "Artwork", "Cabinet", "Controls", "CP", "GameOver", "Logo", "Marquee", "Panels", "PCB", "Score", "Select", "Snap", "Title")
		timer = love.timer.getTime()
	end
	infoMessage = getInfo()
	Gamestate.switch(Gamestate.nextLetter, oldGame, currentGame)
	love.draw()
end

function menu()
	Gamestate.switch(Gamestate.menu)
end

function getInfo()
	info = "Année : "
	info = info .. xml.find(gameList[currentGame], "year")[1] .. "\n"
	info = info .. "Développeur : " .. xml.find(gameList[currentGame], "manufacturer")[1] .. "\n"
	display = xml.find(gameList[currentGame], "display")
	if display["width"] ~= nil and display["height"] ~= nil then
		info = info .. "Résolution : " .. display["width"].."*"..display["height"] .."\n"
	end
	input = xml.find(gameList[currentGame], "input")
	info = info .. "Nombre de joueurs : " .. input["players"] .. "\n"
	if input["buttons"] ~= nil then
		info = info .. "Nombre de boutons : " .. input["buttons"] .. "\n"
	else
		info = info .. "Nombre de boutons : 0\n"
	end
	info = info .. "Qualité de l'émulation : " .. xml.find(gameList[currentGame], "driver")["status"]
	return info
end

function drawBackground() --separated from st:draw because reused several times in other states
	local game = gameList[currentGame]
	
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


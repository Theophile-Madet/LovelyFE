--panels.lua

Gamestate.panels = Gamestate.new()
local st = Gamestate.panels

local panel, PW, PH
local stick, SW, SH
local button, BW, BH

function st:enter()
	os.execute("dir " .. pathToMame .. "\\roms\\*.zip /b > romsList.txt")
	
	if not love.filesystem.exists("Panels") then
		love.filesystem.mkdir("Panels")
	end
	
	print("Loading images for panel creation")
	panel = love.graphics.newImage("Images/Panel.png")
	PW = panel:getWidth()
	PH = panel:getHeight()
	stick = love.graphics.newImage("Images/Stick.png")
	SW = stick:getWidth()
	SH = stick:getHeight()
	button = love.graphics.newImage("Images/Bouton.png")
	BW = button:getWidth()
	BH = button:getHeight()
	
	love.graphics.setMode(PW, PH, false, false, 0)
	
	frameBuffer = love.graphics.newFramebuffer()
	love.graphics.setRenderTarget(frameBuffer)
	
	local romList = xml.load("availableList.xml")
	
	io.input("romsList.txt")
	local currentRom = io.read("*line")
	while currentRom ~= nil do
		currentRom = string.gsub(currentRom, ".zip", "")
		drawPanel(currentRom, romList)
		currentRom = io.read("*line")
	end
end

function st:leave()
	local default = {}
	default.screen = {}
	default.modules = {}
	love.conf(default)
	love.graphics.setMode(default.screen.width, default.screen.height, default.screen.fullscreen, default.screen.vsync, default.screen.fsaa)
	love.graphics.setRenderTarget()
end

function st:draw()
	love.graphics.draw(panel, 0, 0)
	if nbOfButtons ~= nil and nbOfPlayers ~= nil then
		if nbOfPlayers == 1 then
			if nbOfButtons <= 3 then
				TW = SW + nbOfButtons*BW + (nbOfButtons+1)*5
				for i=1,nbOfButtons do
					love.graphics.draw(button, PW/2 - TW/2 + SW + i*BW + i*5, PH/2 - BH/2)
				end
			else
				TW = SW + (nbOfButtons/2)*BW + (nbOfButtons/2+1)*5
				for i=1,nbOfButtons/2 do
					love.graphics.draw(button, PW/2 - TW/2 + SW + i*BW + i*5, PH/2 - BH - 2.5)
					love.graphics.draw(button, PW/2 - TW/2 + SW + i*BW + i*5, PH/2 + 2.5)
				end
			end
			love.graphics.draw(stick, PW/2 - TW/2, PH/2 - SH/2)
			
		elseif nbOfPlayers == 2 then
			if nbOfButtons <= 3 then
				TW = 2*SW + 2*nbOfButtons*BW + ((2*nbOfButtons)+1)*5
				for i=1,nbOfButtons do
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 - BH/2)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 - BH/2)
				end
			else
				TW = 2*SW + 2*(nbOfButtons/2)*BW + ((2*nbOfButtons/2)+1)*5
				for i=1,nbOfButtons/2 do
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 - BH - 2.5)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 - BH - 2.5)
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 + 2.5)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 + 2.5)
				end
			end
			love.graphics.draw(stick, PW/2 - TW/2, PH/2 - SH/2)
			love.graphics.draw(stick, PW/2 + 2.5, PH/2 - SH/2)
			
		elseif nbOfPlayers == 3 then
			if nbOfButtons <= 3 then
				TW = 3*SW + 3*nbOfButtons*BW + ((3*nbOfButtons)+2)*5
				for i=1,nbOfButtons do
					for j=0,nbOfPlayers-1 do
						love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1) * BW + i*5 + TW*j/3 + j*5, PH/2 - BH/2)
					end
				end
			else
				TW = 3*SW + 3*(nbOfButtons/2)*BW + ((3*(nbOfButtons/2))+2)*5
				for i=1,nbOfButtons/2 do
					for j=0,nbOfPlayers-1 do
						love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1) * BW + i*5 + TW*j/3 + j*5, PH/2 - BH - 2.5)
						love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1) * BW + i*5 + TW*j/3 + j*5, PH/2 + 2.5)
					end
				end
			end
			love.graphics.draw(stick, PW/2 - TW/2, PH/2 - SH/2)
			love.graphics.draw(stick, PW/2 - TW/2 + TW/3 + 5, PH/2 - SH/2)
			love.graphics.draw(stick, PW/2 - TW/2 + TW*2/3 + 10, PH/2 - SH/2)
			
		elseif nbOfPlayers == 4 then
			if nbOfButtons <= 3 then
				TW = 2*SW + 2*nbOfButtons*BW + ((2*nbOfButtons)+1)*5
				for i=1,nbOfButtons do
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 - SH/2 - BH/2)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 - SH/2 - BH/2)
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 + SH/2 + 2.5 - BH/2)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 + SH/2 + 2.5 - BH/2)
				end
			else
				TW = 2*SW + 2*(nbOfButtons/2)*BW + ((2*nbOfButtons/2)+1)*5
				for i=1,nbOfButtons/2 do
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 - SH/2 - BH - 2.5)
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 - SH/2 + 2.5)
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 + SH/2 - BH)
					love.graphics.draw(button, PW/2 - TW/2 + SW + (i-1)*BW + i*5, PH/2 + SH/2 + 5)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 - SH/2 - BH - 2.5)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 - SH/2 + 2.5)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 + SH/2 - BH)
					love.graphics.draw(button, PW/2 + SW + (i-1)*BW + i*5 + 2.5, PH/2 + SH/2 + 5)
				end
			end
			love.graphics.draw(stick, PW/2 - TW/2, PH/2 - SH - 2.5)
			love.graphics.draw(stick, PW/2 + 2.5, PH/2 - SH - 2.5)
			love.graphics.draw(stick, PW/2 - TW/2, PH/2 + 2.5)
			love.graphics.draw(stick, PW/2 + 2.5, PH/2 + 2.5)
		else
			print("Number of players not found")
		end
	end
end

function drawPanel(rom, romList)
	local romData = xml.find(romList, "game", "name", rom)
	if romData == nil then
		print("Game data not found : "..rom)
		return
	else
		print("Drawing panel of " .. romData["name"])
	end
	
	local inputData = xml.find(romData, "input")
	if inputData == nil then
		print("    Input data not found.")
		return
	end
	
	local nbOfPlayers = tonumber(inputData["players"])
	local nbOfButtons = tonumber(inputData["buttons"])
	if nbOfPlayers ~= nil and nbOfButtons ~= nil then
		print("    Number of players : " .. nbOfPlayers .. " Number of buttons : " .. nbOfButtons)
	end
	
	st.draw()
	
	local tempImage = frameBuffer:getImageData()
	file = love.filesystem.newFile("Panels/" .. rom .. ".bmp")
	if file:open('w') then
		file:write(tempImage:encode("bmp"))
		file:close()
	else
		print("Error writing to Panels/"..rom..".bmp")
	end
end
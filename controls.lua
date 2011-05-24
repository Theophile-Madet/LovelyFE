--controls.lua

--Control configuration
--A lot can be done to improve ergonomics here

Gamestate.controls = Gamestate.new()
local st = Gamestate.controls

local nbJoy
local joys
local controls
local oldControls

function st:enter()
	nbJoy = love.joystick.getNumJoysticks()
	joys = {}
	controls = {}
	controls["keyboard"] = {}
	for i=0,(nbJoy-1) do
		love.joystick.open(i)
		controls[i] = {}
		joys[i] = {}
		joys[i]["name"] = love.joystick.getName(i)
		joys[i]["nbAxes"] = love.joystick.getNumAxes(i)
		joys[i]["nbBalls"] = love.joystick.getNumBalls(i)
		joys[i]["nbButtons"] = love.joystick.getNumButtons(i)
		joys[i]["nbHats"] = love.joystick.getNumHats(i)
	end
	oldControls = deepcopy(controls)
	

	commands = {"next game", "previous game", "next letter", "previous letter", "action", "exit", "menu/cancel"}
	currentCommand = 1
	message = "Press commands for function " .. commands[currentCommand] .. ".\nPress Tab to input next command or backspace to empty current command.\n"
end

function st:draw()
	local currentInput = ""
	for i=0,(nbJoy-1) do
		for k,v in pairs(joys[i]) do
			currentInput = currentInput..k.."="..v.."\n"
		end
		for j=0,joys[i]["nbAxes"]-1 do
			currentInput = currentInput.."axis"..j.."="..love.joystick.getAxis(i,j).."\n"
		end
		for j=0,joys[i]["nbBalls"]-1 do
			currentInput = currentInput.."ball"..j.."="..love.joystick.getBall(i,j).."\n"
		end
		for j=0,joys[i]["nbHats"]-1 do
			currentInput = currentInput.."hat"..j.."="..love.joystick.getHat(i,j).."\n"
		end
		for j=0,joys[i]["nbButtons"]-1 do
			if love.joystick.isDown(i,j) then
				currentInput = currentInput.."button"..j.." is pressed\n"
			end
		end
		currentInput = currentInput.."\n"
	end
	love.graphics.print(currentInput,0, 0)
	love.graphics.printf(message,0,love.graphics.getHeight()/2,love.graphics.getWidth(),"center")
end

function st:update(dt)
	for i=0,(nbJoy-1) do
		for j=0,joys[i]["nbHats"]-1 do
			if love.joystick.getHat(i,j) ~= "c" then
				if controls[i][love.joystick.getHat(i,j)] ~= commands[currentCommand] then
					message = message .. "J"..(i+1)..love.joystick.getHat(i,j).." "
				end
				controls[i][love.joystick.getHat(i,j)] = commands[currentCommand]
			end
		end
		for j=0,joys[i]["nbButtons"]-1 do
			if love.joystick.isDown(i,j) then
				if controls[i][j] ~= commands[currentCommand] then
					message = message .. "J"..(i+1).."B"..(j+1).." "
				end
				controls[i][j] = commands[currentCommand]
			end
		end
	end
end

function st:keypressed(key, unicode)
	if key == "escape" then
		love.event.push("q")
	elseif key == "tab" then
		oldControls = deepcopy(controls)
		if not love.keyboard.isDown("lshift") then
			currentCommand = currentCommand + 1
			if commands[currentCommand] == nil then
				local file = love.filesystem.newFile("customControls.lua")
				if file == nil then error("Cannot create saved.lua") end
				file:open('w')
				file:write("joys = ")
				serialize(joys, file)
				file:write("controools = ")
				serialize(controls, file)
				file:close()
				message = "Config finished, you can now press escape"
			else
				message = "Press commands for function " .. commands[currentCommand] .. ".\nPress Tab to input next command or backspace to empty current command.\n"
			end
		else
			currentCommand = currentCommand - 1
			if currentCommand < 1 then currentCommand = 1 end
			message = "Press commands for function " .. commands[currentCommand] .. ".\nPress Tab to input next command or backspace to empty current command.\n"
		end
	elseif key == "backspace" then
		controls = deepcopy(oldControls)
		message = "Press commands for function " .. commands[currentCommand] .. ".\nPress Tab to input next command or backspace to empty current command.\n"
	else
		if key ~= "lshift" then
			controls["keyboard"][key] = commands[currentCommand]
			message = message.."KB"..key.." "
		end
	end
end

function st:keyreleased(key, unicode)
	if key == "lshift" and not love.keyboard.isDown("tab") then
		controls["keyboard"][key] = commands["currentCommand"]
		message = message.."KB"..key.." "
	end
end
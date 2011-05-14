--main.lua

require "config"
require "HUMP/gamestate"

function love.load(arg)
	Gamestate.registerEvents()
	for _, v in pairs(arg) do
		if v == "list" then
			require "list"
			Gamestate.switch(Gamestate.list)
		elseif v == "panels" then
			require "panels"
			Gamestate.switch(Gamestate.panels)
		elseif v == "controls" then
			require "controls"
			Gamestate.switch(Gamestate.controls)
		elseif v == "frontend" then
			require "launch" 
			Gamestate.switch(Gamestate.launch)
		end
	end
end

function serialize(o, file) --"stolen" from Lua book page 112
	if type(o) == "number" then
		file:write(o)
	elseif type(o) == "string" then
		file:write(string.format("%q", o))
	elseif type(o) == "table" then
		file:write("{\n")
		for k,v in pairs(o) do
			file:write(" ["); serialize(k, file); file:write("] = ")
			serialize(v, file)
			file:write(",\n")
		end
		file:write("}\n")
	else
		error("cannot serialize a " .. type(o))
	end
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function drawGame(game, posX, posY, selected)
    local r,g,b,a = love.graphics.getColor()
    if not selected then
        love.graphics.setColor(100,100,100)
    end
    local X = notSelectedSquare:getWidth()
    local Y = notSelectedSquare:getHeight()
    local scaleX = W/5/X
    local scaleY = H/10/Y
    
    --love.graphics.draw(notSelectedSquare, posX, posY - Y*scaleY/2, 0, scaleX, scaleY)
    
    if isGroup(game) then
        game = getGameOfGroup(game)
    end
    
    toDisplay = game["Logo"]
    if toDisplay == nil then
        toDisplay = game["Marquee"]
    end
    if toDisplay ~= nil then
        local X = toDisplay:getWidth()
        local Y = toDisplay:getHeight()
        local scale = (W/5)/X
        if Y*scale > H/10 then
            scale = (H/10)/Y
        end
        love.graphics.draw(toDisplay, posX + (W/5)/2 - X*scale/2, posY - Y*scale/2, 0, scale)
    else 
        love.graphics.print(getTagValue(game, "description"), 10 + posX, posY - fontHeight/2)
    end
    love.graphics.setColor(r,g,b,a)
end
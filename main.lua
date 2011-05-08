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
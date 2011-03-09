--main.lua

require "config"
require "HUMP/gamestate"
require "LuaXml"

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

function gameSort(A, B)
	if A == nil then
		return false
	end
	if B == nil then
		return true
	end
	A = xml.find(A, "description")
	B = xml.find(B, "description")
	return string.lower(A[1]) < string.lower(B[1])
end
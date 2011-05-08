--list.lua

--Converts MAME list of emulated games from XML to Lua, then filter unavailable games and unused infos.

require "xml"
require "config"

Gamestate.list = Gamestate.new()
local st = Gamestate.list

local removeUnusedRoms
local filterList
local gameSort

function st:enter()
	print("Asking mame about all games...")
	os.execute(pathToMame .. "\\mame.exe -listxml > fullList.xml")
	
	print("Reading result...")
	local xmlFile = io.open("fullList.xml")
	local xmlTable = xmlParse(xmlFile:read("*all"))

	print("Creating list of all roms in " .. pathToMame .. "/roms")
	local roms = love.filesystem.enumerate(pathToMame.."/roms")

	--now we compare the two list to delete the unavailable games
	print("Getting info for all roms...")
	local tempXmlTable = {}
	for _, rom in ipairs(roms) do
		rom = string.gsub(rom, ".zip", "")
		tempXmlTable[#tempXmlTable+1] = getGameByName(xmlTable, rom)
	end
	xmlTable = tempXmlTable
	tempXmlTable = nil
	
	print("Deleting unused infos")
	availableList = filterList(xmlTable)
	print("Removing unused roms")
	removeUnusedRoms(xmlTable)
	print("Customizing list")
	custom(xmlTable)
	print("Sorting list")
	table.sort(xmlTable, gameSort)
	
	print("Saving infos in availableList.lua")
	local file = love.filesystem.newFile("availableList.lua")
	if file == nil then
		error("Could not create availableList.lua")
	end
	file:open('w')
	file:write("gameList = ")
	serialize(xmlTable, file)
	file:close()
	print("done")
end

removeUnusedRoms = function(xmlTable)
	for k, rom in pairs(xmlTable) do
		romName = getName(rom)
		for _, v in pairs(romsNotToInclude) do
			if romName == v then
				xmlTable[k] = nil
				print("    Removing " .. romName)
			end
		end
	end
end

filterList = function(xmlTable) --remove unecessary infos like roms, chips...
	for _, game in pairs(xmlTable) do
		removeTag(game, "rom", "dipswitch", "configuration", "chip", "sound", "biosset")
	end
end

gameSort = function(A, B) --used in a few places to sort the game list
	if A == nil then
		return false
	end
	if B == nil then
		return true
	end
	A = getTagValue(A, "description")
	B = getTagValue(B, "description")
	return string.lower(A) < string.lower(B)
end
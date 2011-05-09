--list.lua

--Converts MAME list of emulated games from XML to Lua, then filter unavailable games and unused infos.

require "xml"
require "config"

Gamestate.list = Gamestate.new()
local st = Gamestate.list

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
	filterList(xmlTable)
	print("Removing unused roms")
	removeRoms(xmlTable, romsNotToInclude)
	print("Customizing list")
	custom(xmlTable)
    print("Creating roms groups")
    group(xmlTable)
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
    if isGroup(A) then
        A = getName(A)
    else
        A = getTagValue(A, "description")
    end
    if isGroup(B) then
        B = getName(B)
    else
        B = getTagValue(B, "description")
    end
	return string.lower(A) < string.lower(B)
end
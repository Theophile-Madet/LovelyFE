--list.lua

require "LuaXml"
require "config"

Gamestate.list = Gamestate.new()
local st = Gamestate.list

function st:enter()
	print("Asking mame about all games...")
	os.execute(pathToMame .. "\\mame.exe -listxml > fullList.xml")
	--the generated file has a "doctype" stuff at the beginning that makes LuaXml crash, so we filter it.
	print("Reading result...")
	io.input("fullList.xml")
	local currentLine
	while currentLine ~= "" do
		currentLine = io.read("*line")
	end
	local fullListXml = xml.eval(io.read("*all"))

	print("Creating list of all roms in " .. pathToMame .. "/roms")
	local roms = love.filesystem.enumerate(pathToMame.."/roms")

	--now we compare the two list to delete the unavailable games
	print("Getting info for all roms...")
	local availableList = {}
	for _, currentRom in ipairs(roms) do
		currentRom = string.gsub(currentRom, ".zip", "")
		availableList[currentRom] = xml.find(fullListXml, "game", "name", currentRom)
		if availableList[currentRom] == nil then
			print("    Game not found : " .. currentRom)
		else
			print("    Game found : " .. currentRom .. " : " .. xml.find(availableList[currentRom], "description")[1])
		end
	end
	
	print("Deleting unused infos")
	availableList = filterList(availableList)
	print("Removing unused roms")
	removeUnusedRoms(availableList)
	print("Customizing list")
	custom(availableList)
	print("Sorting list")
	local n = 1
	local availableListCopy = {}
	for i in pairs(availableList) do -- replace all string index with intergers so we can use table.sort
		availableListCopy[n] = availableList[i]
		n=n+1
	end
	table.sort(availableListCopy, gameSort)
	
	print("Saving infos in availableList.xml")
	xml.save(availableListCopy, "availableList.xml")
	print("done")
end

function removeUnusedRoms(L)
	for _, rom in ipairs(romsNotToInclude) do
		for k in pairs(L) do
			if k == rom then
				L[k] = nil
				print("    Removing " .. rom)
			end
		end
	end
end

function filterList(L) --remove unecessary infos like roms, chips...
	local shortL = xml.new()
	for k in pairs(L) do
		shortL[k] = xml.new()
		xml.tag(shortL[k], xml.tag(L[k]))
		for k2 in pairs(L[k]) do
			if(type(k2) == "string") then
				shortL[k][k2] = L[k][k2]
			else
				tag = xml.tag(L[k][k2])
				if tag == "description" or
				   tag == "year" or
				   tag == "manufacturer" or
				   tag == "display" or
				   tag == "input" or
				   tag == "driver" then
					xml.append(shortL[k], L[k][k2])
				end
			end
		end
	end
	return shortL
end
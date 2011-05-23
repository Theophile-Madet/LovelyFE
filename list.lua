--list.lua

--Converts MAME list of emulated games from XML to Lua, then filter unavailable games and unused infos.

require "xml"
require "config"

Gamestate.list = Gamestate.new()
local st = Gamestate.list

local filterList
local gameSort
local group
local removeRoms
local genre
local custom

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
        if love.filesystem.isFile(pathToMame.."/roms/"..rom) then
            rom = string.gsub(rom, ".zip", "")
            tempXmlTable[#tempXmlTable+1] = getGameByName(xmlTable, rom)
        end
	end
	xmlTable = tempXmlTable
	tempXmlTable = nil
	
	print("Deleting unused infos")
	filterList(xmlTable)
	print("Removing unused roms")
	removeRoms(xmlTable)
	print("Customizing list")
	custom(xmlTable)
    print("Classifying games by genre")
    genre(xmlTable)
    print("Creating roms groups")
    group(xmlTable)
    print("Remove holes in the array")
    tempXmlTable = {}
    for i=1,table.maxn(xmlTable) do
        if xmlTable[i] ~= nil then
            table.insert(tempXmlTable, xmlTable[i])
        end
    end
    xmlTable = tempXmlTable
	print("Sorting list")
	table.sort(xmlTable, gameSort)
	
	print("Saving infos in availableList.lua")
	local file = love.filesystem.newFile("availableList.lua")
	if file == nil then
		error("Could not create availableList.lua")
	end
	file:open('w')
	file:write("fullGameList = ")
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

group = function(L)
    local function f(groupName, gameList)
        print(" Creating group " .. groupName)
        local tableEntry = {}
        tableEntry["xarg"] = {}
        tableEntry["xarg"]["name"] = groupName
        tableEntry["label"] = "group"
        
        local groupList = {}
        for _, gameName in pairs(gameList) do
            if not love.filesystem.exists(pathToMame.."/roms/"..gameName..".zip") then
                print("Game "..gameName.." does not exists. Group " .. groupName .. " won't be created")
                return
            end
            print("     Adding " .. gameName .. " to group")
            groupList[#groupList+1] = deepcopy(getGameByName(L, gameName))
        end
        tableEntry[1] = groupList
        
        L[#L+1] = tableEntry
        removeRoms(L, gameList)
    end
    
    if love.filesystem.exists("groups.txt") then
        local file = love.filesystem.newFile("groups.txt")
        file:open("r")
        for line in file:lines() do
            local groupName = string.match(line, "%[.+%]") 
            groupName = string.gsub(groupName, "[%[%]]", "")
            line = string.gsub(line, groupName, "")
            line = string.gsub(line, "[%[%]]", "")
            
            
            local games = {}
            for i in string.gmatch(line, "%w+") do
                table.insert(games, i)
            end
            f(groupName, games)
        end
    else
        print("groups.txt not found. No group will be created")
    end
    
end

removeRoms = function(xmlTable, list)
    if list == nil then
        if not love.filesystem.exists("remove.txt") then
            print("File remove.txt not found. No rom will be removed from the list")
            return
        end
    
        local file = love.filesystem.newFile("remove.txt")
        file:open("r")
        
        list = {}
        for line in file:lines() do
			table.insert(list, line)
		end
    end
    
	for k, rom in pairs(xmlTable) do
		romName = getName(rom)
		for _,v in pairs(list) do
			if romName == v then
				xmlTable[k] = nil
				print("    Removing " .. romName)
			end
		end
	end
end

genre = function(L)
    local function f(name, genre)
        local game = getGameByName(L, name)
        if game ~= nil then
            createTag(game, "genre", genre)
        else
            print("In function genre, game " .. name .. "not found.")
        end
    end
    
    if love.filesystem.exists("genres.txt") then
        local file = love.filesystem.newFile("genres.txt")
        file:open("r")
        
        for line in file:lines() do
            name = string.match(line, "%w+")
            genre = string.match(line, "\".+\"")
            genre = string.gsub(genre, "\"", "")
            f(name, genre)
        end
    else
        print("genres.txt not found. No game genre will be specified")
    end
end

custom = function(L) --used to customize game names
	local function f(name, description)
		print("	Changing " .. name .. " description to " .. description)
		local game = getGameByName(L, name)
		if game ~= nil then
			setTagValue(game, "description", description)
		end
	end
    
    if love.filesystem.exists("names.txt") then
        local file = love.filesystem.newFile("names.txt")
        file:open("r")
        
        for line in file:lines() do
            romName = string.match(line, "%w+")
            description = string.match(line, "\".+\"")
            description = string.gsub(description, "\"", "")
            f(romName, description)
        end
    else
        print("names.txt not found. Game names won't be customized")
    end
end
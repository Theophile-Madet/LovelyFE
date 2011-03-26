--xml.lua

function getGameByNumber(tbl, index)
	if tbl[2][index] == nil then
		error("No game at index " .. index .. " in getGameByNumber")
	end
	
	return tbl[2][index]
end

function getGameByName(tbl, name)
	for _,v in pairs(tbl[2]) do
		if v["xarg"] ~= nil and v["xarg"]["name"] == name then
			return v
		end
	end
	error("No game with name " .. name)
end

function setTagValue(game, tag, value)
	if game == nil then
		error("Sending nil as game to " .. debug.getinfo(1)["name"])
	end
	
	for _, v in pairs(game) do
		if v["label"] == tag then
			v[1] = value
			return
		end
	end
	
	error("Tag not found : " .. tag)
	
end

function getTagValue(game, tag)
	if game == nil then
		error("Sending nil as game to " .. debug.getinfo(1)["name"])
	end
	
	for _, v in pairs(game) do
		if v["label"] == tag then
			return v[1]
		end
	end
	
	error("Tag not found : " .. tag)
	
end

function removeTag(game, ...)
	if game == nil then
		error("Sending nil as game to " .. debug.getinfo(1)["name"])
	end
	
	for k,v in pairs(game) do
		for _,tag in pairs{...} do
			if v["label"] == tag then
				game[k] = nil
			end
		end
	end
end

function xmlParse(s)
	local stack = {}
	local top = {}
	table.insert(stack, top)
	local ni,c,label,xarg, empty
	local i, j = 1, 1
	while true do
		ni,j,c,label,xarg, empty = string.find(s, "<(%/?)(%w+)(.-)(%/?)>", i)
		if not ni then break end
		local text = string.sub(s, i, ni-1)
		if not string.find(text, "^%s*$") then
			table.insert(top, text)
		end
		if empty == "/" then  -- empty element tag
			table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
		elseif c == "" then   -- start tag
			top = {label=label, xarg=parseargs(xarg)}
			table.insert(stack, top)   -- new level
		else  -- end tag
			local toclose = table.remove(stack)  -- remove top
			top = stack[#stack]
			if #stack < 1 then
				error("nothing to close with "..label)
			end
			if toclose.label ~= label then
				error("trying to close "..toclose.label.." with "..label)
			end
			table.insert(top, toclose)
		end
		i = j+1
	end
	local text = string.sub(s, i)
	if not string.find(text, "^%s*$") then
		table.insert(stack[#stack], text)
	end
	if #stack > 1 then
	  error("unclosed "..stack[stack.n].label)
	end
	return stack[1]
end
	
local function parseargs(s)
	local arg = {}
	string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
	arg[w] = a
	end)
	return arg
end
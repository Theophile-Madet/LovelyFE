--previousLetter.lua

Gamestate.previousLetter = Gamestate.new()
local st = Gamestate.previousLetter

local oldSate
local duree, timerAnimation
local old, new
local first, last
local len

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	duree = 0.4
	old = in_old
	new = in_new
	first = true
	last = false
	timerAnimation = 0
	len = math.max(
		string.len(xml.find(gameList[old-2], "description")[1]),
		string.len(xml.find(gameList[old-1], "description")[1]),
		string.len(xml.find(gameList[old], "description")[1]),
		string.len(xml.find(gameList[old+1], "description")[1]),
		string.len(xml.find(gameList[old+2], "description")[1]),
		string.len(xml.find(gameList[new-2], "description")[1]),
		string.len(xml.find(gameList[new-1], "description")[1]),
		string.len(xml.find(gameList[new], "description")[1]),
		string.len(xml.find(gameList[new+1], "description")[1]),
		string.len(xml.find(gameList[new+2], "description")[1]))
	print(len)
end

function st:update(dt)
	if first then
		timerAnimation = 0
		first = false
	else
		timerAnimation = timerAnimation + dt
	end
	
	if last == false and timerAnimation > duree then
		last = true
	end
end

function st:draw()
	drawBackground()
	
	local nameNew, nameOld
	
	nameNew = xml.find(gameList[new-2], "description")[1]
	nameNew = nameNew .. string.rep(" ", len - string.len(nameNew))
	nameOld = xml.find(gameList[old-2], "description")[1]
	nameOld = nameOld .. string.rep(" ", len - string.len(nameOld))
	toprint = string.sub(nameOld, 1, len-(timerAnimation/duree)*len) .. string.sub(nameNew, len-(timerAnimation/duree)*len+1)
	love.graphics.print(toprint, (1300/1600)*W, (550/1200)*H, -0.05)
	
	nameNew = xml.find(gameList[new-1], "description")[1]
	nameNew = nameNew .. string.rep(" ", len - string.len(nameNew))
	nameOld = xml.find(gameList[old-1], "description")[1]
	nameOld = nameOld .. string.rep(" ", len - string.len(nameOld))
	toprint = string.sub(nameOld, 1, len-(timerAnimation/duree)*len) .. string.sub(nameNew, len-(timerAnimation/duree)*len+1)
	love.graphics.print(toprint, (1280/1600)*W, (690/1200)*H, 0.05)
	
	nameNew = xml.find(gameList[new], "description")[1]
	nameNew = nameNew .. string.rep(" ", len - string.len(nameNew))
	nameOld = xml.find(gameList[old], "description")[1]
	nameOld = nameOld .. string.rep(" ", len - string.len(nameOld))
	toprint = string.sub(nameOld, 1, len-(timerAnimation/duree)*len) .. string.sub(nameNew, len-(timerAnimation/duree)*len+1)
	love.graphics.print(toprint, (1300/1600)*W, (835/1200)*H, -0.05)
	
	nameNew = xml.find(gameList[new+1], "description")[1]
	nameNew = nameNew .. string.rep(" ", len - string.len(nameNew))
	nameOld = xml.find(gameList[old+1], "description")[1]
	nameOld = nameOld .. string.rep(" ", len - string.len(nameOld))
	toprint = string.sub(nameOld, 1, len-(timerAnimation/duree)*len) .. string.sub(nameNew, len-(timerAnimation/duree)*len+1)
	love.graphics.print(toprint, (1280/1600)*W, (950/1200)*H, 0.05)
	
	nameNew = xml.find(gameList[new+2], "description")[1]
	nameNew = nameNew .. string.rep(" ", len - string.len(nameNew))
	nameOld = xml.find(gameList[old+2], "description")[1]
	nameOld = nameOld .. string.rep(" ", len - string.len(nameOld))
	toprint = string.sub(nameOld, 1, len-(timerAnimation/duree)*len) .. string.sub(nameNew, len-(timerAnimation/duree)*len+1)
	love.graphics.print(toprint, (1280/1600)*W, (1140/1200)*H)
	
	numTonneau = math.ceil(timerAnimation*10) % 4 + 1
	love.graphics.draw(tonneaux[numTonneau], (1300/1600)*W - tonneaux[1]:getWidth(), (835/1200)*H)
	
	if last then Gamestate.switch(oldState) end
end
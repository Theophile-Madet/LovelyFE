--previousGame.lua

Gamestate.previousGame = Gamestate.new()
local st = Gamestate.previousGame

local timerAnimation, duree
local oldState
local first, last
local fontHeight
local X
local Y
local scaleX
local scaleY
local drawGame

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	timerAnimation = 0
	duree = 0.2
	last = false
	first = true
    fontHeight = love.graphics.getFont():getHeight()
    X = notSelectedSquare:getWidth()
    Y = notSelectedSquare:getHeight()
    scaleX = W/5/X
    scaleY = H/10/Y
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
	if oldState == Gamestate.menu then
		Gamestate.menu:draw()
	else
		drawBackground()
	end
    
    drawGame(currentGame-3, W*4/5 + 4*(W/5)/4, W*4/5 + 3*(W/5)/4, H/2 - 4*Y*scaleY, H/2 - 3*Y*scaleY)
	drawGame(currentGame-2, W*4/5 + 3*(W/5)/4, W*4/5 + 2*(W/5)/4, H/2 - 3*Y*scaleY, H/2 - 2*Y*scaleY)
    drawGame(currentGame-1, W*4/5 + 2*(W/5)/4, W*4/5 + (W/5)/4, H/2 - 2*Y*scaleY, H/2 - Y*scaleY)
    drawGame(currentGame, W*4/5 + (W/5)/4, W*4/5, H/2 - Y*scaleY, H/2)
	drawGame(currentGame+1, W*4/5, W*4/5 + (W/5)/4, H/2, H/2 + Y*scaleY)
    drawGame(currentGame+2, W*4/5 + (W/5)/4, W*4/5 + 2*(W/5)/4, H/2 + Y*scaleY, H/2 + 2*Y*scaleY)
    drawGame(currentGame+3, W*4/5 + 2*(W/5)/4, W*4/5 + 3*(W/5)/4, H/2 + 2*Y*scaleY, H/2 + 3*Y*scaleY)
    drawGame(currentGame+4, W*4/5 + 3*(W/5)/4, W*4/5 + 4*(W/5)/4, H/2 + 3*Y*scaleY, H/2 + 4*Y*scaleY)
	
	if last then Gamestate.switch(oldState) end
end

drawGame = function(gameNumber, startPosX, endPosX, startPosY, endPosY)
    local d = timerAnimation/duree
	local dx, dy
	local game = getGameByNumber(gameList, gameNumber)
    local delta = -(W/5/4)
    startPosX = startPosX + delta
    endPosX = endPosX + delta
    
    dx = (endPosX - startPosX)*d
    dy = (endPosY - startPosY)*d
    love.graphics.draw(notSelectedSquare, startPosX + dx, startPosY - Y*scaleY/2 + dy, 0, scaleX, scaleY)
    
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
        love.graphics.draw(toDisplay, startPosX + dx + ((W/5)/2 - X*scale/2), startPosY + dy - Y*scale/2, 0, scale)
    else
        love.graphics.print(getDescriptionOfNumber(gameList, gameNumber), 10 + startPosX + dx, startPosY - fontHeight/2 + dy)
    end
end
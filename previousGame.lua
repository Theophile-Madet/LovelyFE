--previousGame.lua

Gamestate.previousGame = Gamestate.new()
local st = Gamestate.previousGame

local timerAnimation, duree
local oldState
local first, last

local X
local Y
local scaleX
local scaleY

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
    
    local d = timerAnimation/duree
    drawGame(getGameByNumber(gameList, currentGame-3), W*4/5 + 5*(W/5)/4 - 2*d*(W/5)/4, H/2 - 4*Y*scaleY + d*Y*scaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame-2), W*4/5 + 3*(W/5)/4 - d*(W/5)/4, H/2 - 3*Y*scaleY + d*Y*scaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame-1), W*4/5 + 2*(W/5)/4 - d*(W/5)/4, H/2 - 2*Y*scaleY + d*Y*scaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame)  , W*4/5 + 1*(W/5)/4 - d*(W/5)/4, H/2 - 1*Y*scaleY + d*Y*scaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame+1), W*4/5 + d*(W/5)/4, H/2 + d*Y*scaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame+2), W*4/5 + 1*(W/5)/4 + d*(W/5)/4, H/2 + 1*Y*scaleY + d*Y*scaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame+3), W*4/5 + 2*(W/5)/4 + d*(W/5)/4, H/2 + 2*Y*scaleY + d*Y*scaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame+4), W*4/5 + 3*(W/5)/4 + 2*d*(W/5)/4, H/2 + 3*Y*scaleY + d*Y*scaleY, -(W/5)/4)
    
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(200,0,0,255*2/3)
    love.graphics.polygon("fill", W - (W/25)*3/2, H/2, W, H/2 - (H/10)/2, W, H/2 + (H/10)/2)
    love.graphics.setColor(r,g,b,a)
	
	if last then Gamestate.switch(oldState) end
end
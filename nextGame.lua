--nextGame.lua

Gamestate.nextGame = Gamestate.new()
local st = Gamestate.nextGame

local timerAnimation, duree
local oldState
local first, last

local X
local Y
local squareScaleX
local squareScaleY

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	timerAnimation = 0
	duree = 0.2
	last = false
	first = true
    fontHeight = love.graphics.getFont():getHeight()
    X = notSelectedSquare:getWidth()
    Y = notSelectedSquare:getHeight()
    squareScaleX = W/5/X
    squareScaleY = H/10/Y
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
    drawGame(getGameByNumber(gameList, currentGame-4), W*4/5 + 3*(W/5)/4 + 2*d*(W/5)/4, H/2 - 3*Y*squareScaleY - d*Y*squareScaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame-3), W*4/5 + 2*(W/5)/4 + d*(W/5)/4, H/2 - 2*Y*squareScaleY - d*Y*squareScaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame-2), W*4/5 + 1*(W/5)/4 + d*(W/5)/4, H/2 - 1*Y*squareScaleY - d*Y*squareScaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame-1), W*4/5 + 0*(W/5)/4 + d*(W/5)/4, H/2 - 0*Y*squareScaleY - d*Y*squareScaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame+0), W*4/5 + 1*(W/5)/4 - d*(W/5)/4, H/2 + 1*Y*squareScaleY - d*Y*squareScaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame+1), W*4/5 + 2*(W/5)/4 - d*(W/5)/4, H/2 + 2*Y*squareScaleY - d*Y*squareScaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame+2), W*4/5 + 3*(W/5)/4 - d*(W/5)/4, H/2 + 3*Y*squareScaleY - d*Y*squareScaleY, -(W/5)/4)
    drawGame(getGameByNumber(gameList, currentGame+3), W*4/5 + 5*(W/5)/4 - 2*d*(W/5)/4, H/2 + 4*Y*squareScaleY - d*Y*squareScaleY, -(W/5)/4)
    
    local scaleX = ((W/25)*3/2)/arrow:getWidth()
    local scaleY = (H/10)/arrow:getHeight()
    love.graphics.draw(arrow, W - arrow:getWidth()*scaleX, H/2 - arrow:getHeight()*scaleY/2, 0, scaleX, scaleY)
	
	if last then Gamestate.switch(oldState) end
end
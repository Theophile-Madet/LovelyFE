--nextGame.lua

Gamestate.nextGame = Gamestate.new()
local st = Gamestate.nextGame

local timerAnimation, duree
local oldState

local X
local Y
local squareScaleX
local squareScaleY

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	timerAnimation = 0
	duree = 0.2
    X = im.notSelectedSquare:getWidth()
    Y = im.notSelectedSquare:getHeight()
    squareScaleX = W/5/X
    squareScaleY = H/10/Y
end

function st:update(dt)
	timerAnimation = timerAnimation + dt
    if timerAnimation > duree then
        Gamestate.switch(oldState)
    end
end

function st:draw()
	if oldState == Gamestate.menu then
		Gamestate.menu:draw()
	else
		drawBackground()
	end
    
    local d = timerAnimation/duree
    drawGame(getGameByNumber(gameList, currentGame-4), W*4/5 + 2*(W/5)/4 + 2*d*(W/5)/4, H/2 - 3*Y*squareScaleY - d*Y*squareScaleY)
    drawGame(getGameByNumber(gameList, currentGame-3), W*4/5 + 1*(W/5)/4 + d*(W/5)/4, H/2 - 2*Y*squareScaleY - d*Y*squareScaleY)
    drawGame(getGameByNumber(gameList, currentGame-2), W*4/5 + 0*(W/5)/4 + d*(W/5)/4, H/2 - 1*Y*squareScaleY - d*Y*squareScaleY)
    drawGame(getGameByNumber(gameList, currentGame-1), W*4/5 - 1*(W/5)/4 + d*(W/5)/4, H/2 - 0*Y*squareScaleY - d*Y*squareScaleY)
    drawGame(getGameByNumber(gameList, currentGame+0), W*4/5 + 0*(W/5)/4 - d*(W/5)/4, H/2 + 1*Y*squareScaleY - d*Y*squareScaleY, true)
    drawGame(getGameByNumber(gameList, currentGame+1), W*4/5 + 1*(W/5)/4 - d*(W/5)/4, H/2 + 2*Y*squareScaleY - d*Y*squareScaleY)
    drawGame(getGameByNumber(gameList, currentGame+2), W*4/5 + 2*(W/5)/4 - d*(W/5)/4, H/2 + 3*Y*squareScaleY - d*Y*squareScaleY)
    drawGame(getGameByNumber(gameList, currentGame+3), W*4/5 + 4*(W/5)/4 - 2*d*(W/5)/4, H/2 + 4*Y*squareScaleY - d*Y*squareScaleY)
    
    drawGroupArrows()
end
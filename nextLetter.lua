--nextLetter.lua

Gamestate.nextLetter = Gamestate.new()
local st = Gamestate.nextLetter

local oldSate
local duree, timerAnimation
local old, new

local X
local Y
local squareScaleX
local squareScaleY

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	duree = 0.4
	old = in_old
	new = in_new
	timerAnimation = 0
    
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
	drawBackground()
	
    local d = (timerAnimation/duree)*(W/5)
    local r, g, b, a = love.graphics.getColor()
    
    love.graphics.setColor(r,g,b, 255 - 255*(timerAnimation/duree))
	drawGame(getGameByNumber(gameList, old+3), W*4/5 + 2*(W/5)/4 - d, H/2 + 3*H/10)
    drawGame(getGameByNumber(gameList, old+2), W*4/5 + 1*(W/5)/4 - d, H/2 + 2*H/10)
    drawGame(getGameByNumber(gameList, old+1), W*4/5 - d, H/2 + H/10)
    drawGame(getGameByNumber(gameList, old-3), W*4/5 + 2*(W/5)/4 - d, H/2 - 3*H/10)
    drawGame(getGameByNumber(gameList, old-2), W*4/5 + 1*(W/5)/4 - d, H/2 - 2*H/10)
    drawGame(getGameByNumber(gameList, old-1), W*4/5 - d, H/2 - H/10)
    
    local game = getGameByNumber(gameList, old)
    
    if isGroup(game) then
        drawGame(getGameOfGroup(game, groupSelection), W*4/5 - (W/5)/4 - d, H/2, true)
    else
        drawGame(game, W*4/5 - (W/5)/4 - d, H/2, true)
    end
    
    love.graphics.setColor(r,g,b, 255*(timerAnimation/duree))
    drawGame(getGameByNumber(gameList, new+3), W*4/5 + W/5 + 2*(W/5)/4 - d, H/2 + 3*H/10)
    drawGame(getGameByNumber(gameList, new+2), W*4/5 + W/5  + 1*(W/5)/4 - d, H/2 + 2*H/10)
    drawGame(getGameByNumber(gameList, new+1), W*4/5 + W/5  - d, H/2 + H/10)
    drawGame(getGameByNumber(gameList, new-3), W*4/5 + W/5  + 2*(W/5)/4 - d, H/2 - 3*H/10)
    drawGame(getGameByNumber(gameList, new-2), W*4/5 + W/5  + 1*(W/5)/4 - d, H/2 - 2*H/10)
    drawGame(getGameByNumber(gameList, new-1), W*4/5 + W/5  - d, H/2 - H/10)
    
    local game = getGameByNumber(gameList, new)
    
    if isGroup(game) then
        drawGame(getGameOfGroup(game, groupSelection), W*4/5 + W/5  - (W/5)/4 - d, H/2, true)
    else
        drawGame(game, W*4/5 + W/5  - (W/5)/4 - d, H/2, true)
    end
    
    love.graphics.setColor(r,g,b,a)
    
    drawGroupArrows()
end
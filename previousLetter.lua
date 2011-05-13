--previousLetter.lua

Gamestate.previousLetter = Gamestate.new()
local st = Gamestate.previousLetter

local oldSate
local duree, timerAnimation
local old, new
local first, last

local X
local Y
local squareScaleX
local squareScaleY

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	duree = 0.4
	old = in_old
	new = in_new
	first = true
	last = false
	timerAnimation = 0
    
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
	drawBackground()
	
    local d = (timerAnimation/duree)*(W/5)
    local r, g, b, a = love.graphics.getColor()
    
    love.graphics.setColor(r,g,b, 255*(timerAnimation/duree))
	drawGame(getGameByNumber(gameList, new+3), W*4/5 - W/5 + 2*(W/5)/4 + d, H/2 + 3*H/10)
    drawGame(getGameByNumber(gameList, new+2), W*4/5 - W/5  + 1*(W/5)/4 + d, H/2 + 2*H/10)
    drawGame(getGameByNumber(gameList, new+1), W*4/5 - W/5  + d, H/2 + H/10)
    drawGame(getGameByNumber(gameList, new-3), W*4/5 - W/5  + 2*(W/5)/4 + d, H/2 - 3*H/10)
    drawGame(getGameByNumber(gameList, new-2), W*4/5 - W/5  + 1*(W/5)/4 + d, H/2 - 2*H/10)
    drawGame(getGameByNumber(gameList, new-1), W*4/5 - W/5  + d, H/2 - H/10)
    
    local game = getGameByNumber(gameList, new)
    
    if isGroup(game) then
        drawGame(getGameOfGroup(game, groupSelection), W*4/5 - W/5  - (W/5)/4 + d, H/2)
    else
        drawGame(game, W*4/5 - W/5  - (W/5)/4 + d, H/2)
    end
    
    love.graphics.setColor(r,g,b, 255 - 255*(timerAnimation/duree))
    drawGame(getGameByNumber(gameList, old+3), W*4/5 + 2*(W/5)/4 + d, H/2 + 3*H/10)
    drawGame(getGameByNumber(gameList, old+2), W*4/5 + 1*(W/5)/4 + d, H/2 + 2*H/10)
    drawGame(getGameByNumber(gameList, old+1), W*4/5 + d, H/2 + H/10)
    drawGame(getGameByNumber(gameList, old-3), W*4/5 + 2*(W/5)/4 + d, H/2 - 3*H/10)
    drawGame(getGameByNumber(gameList, old-2), W*4/5 + 1*(W/5)/4 + d, H/2 - 2*H/10)
    drawGame(getGameByNumber(gameList, old-1), W*4/5 + d, H/2 - H/10)
    
    local game = getGameByNumber(gameList, old)
    
    if isGroup(game) then
        drawGame(getGameOfGroup(game, groupSelection), W*4/5  - (W/5)/4 + d, H/2)
    else
        drawGame(game, W*4/5  - (W/5)/4 + d, H/2)
    end
    
    love.graphics.setColor(r,g,b,a)
    local scaleX = ((W/25)*3/2)/arrow:getWidth()
    local scaleY = (H/10)/arrow:getHeight()
    love.graphics.draw(arrow, W - arrow:getWidth()*scaleX, H/2 - arrow:getHeight()*scaleY/2, 0, scaleX, scaleY)
    
    scaleX = ((W/25)*2)/arrow:getWidth()
    scaleY = (H/6)/arrow:getHeight()
    love.graphics.setColor(0,50,50,255/2)
    d = -(W/25)/2
    love.graphics.draw(arrow, W/5 + d, (H/5)/2 - arrow:getHeight()*scaleY/2, 0, scaleX, scaleY)
    love.graphics.draw(arrow, W*4/5 - d, (H/5)/2 - arrow:getHeight()*scaleY/2, 0, -scaleX, scaleY)
    love.graphics.setColor(r,g,b,a)
    
	if last then Gamestate.switch(oldState) end
end
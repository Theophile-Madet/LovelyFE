--previousGame.lua

Gamestate.previousGame = Gamestate.new()
local st = Gamestate.previousGame

local timerAnimation, duree
local oldState
local first, last

function st:enter(in_oldState, in_old, in_new)
	oldState = in_oldState
	timerAnimation = 0
	duree = 0.2
	last = false
	first = true
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
	local dx, dy, dr
	
	dx = (1300-1331)*d
	dy = (550-340)*d
	dr = -0.05*d
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame-2), ((1331+dx)/1600)*W, ((340+dy)/1200)*H, dr)
	dx = (1280-1300)*d
	dy = (690-550)*d
	dr = (0.05-(-0.05))*d
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame-1), ((1300+dx)/1600)*W, ((550+dy)/1200)*H, -0.05+dr)
	dx = (1300-1280)*d
	dy = (835-690)*d
	dr = (-0.05-0.05)*d
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame), ((1280+dx)/1600)*W, ((690+dy)/1200)*H, 0.05+dr)
	dx = (1280-1300)*d
	dy = (950-835)*d
	dr = (0.05-(-0.05))*d
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame+1), ((1300+dx)/1600)*W, ((835+dy)/1200)*H, -0.05+dr)
	dy = (1140-950)*d
	dr = (-0.05-0)*d
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame+2), ((1280)/1600)*W, ((950+dy)/1200)*H, 0.05+dr)
	dy = (1200-1140)*d
	love.graphics.print(getDescriptionOfNumber(gameList, currentGame+3), (1280/1600)*W, ((1140+dy)/1200)*H)
	
	local numTonneau = math.ceil(timerAnimation*10) % 4 + 1
	love.graphics.draw(tonneaux[numTonneau], (1300/1600)*W - tonneaux[1]:getWidth(), (835/1200)*H)
	
	if last then Gamestate.switch(oldState) end
end
--imageDetail.lua

--called by imagesMenu to show an image in full screen

Gamestate.imageDetail = Gamestate.new()
local st = Gamestate.imageDetail

local oldState
local image
local initialX
local initialY
local initialScale
local duree
local first
local timerAnimation
local objectiveX
local objectiveY

function st:enter(in_oldState, in_image, in_initialX, in_initialY, in_initialScale)
	oldState = in_oldState
	image = in_image
	initialX = in_initialX
	initialY = in_initialY
	initialScale = in_initialScale
	duree = 0.4
	
	first = true
	
	local X = image:getWidth()
	local Y = image:getHeight()
	
	scale = (W-W/5)/X
	if Y*scale > (H-H/5) then
		scale = (H-H/5)/Y
	end
	
	objectiveX = W/2 - X*scale/2
	objectiveY = H/2 - Y*scale/2
end

function st:draw()
	Gamestate.imagesMenu:draw()
	
	if timerAnimation < duree then
		love.graphics.draw(image, initialX + (objectiveX-initialX)*(timerAnimation/duree), initialY + (objectiveY-initialY)*(timerAnimation/duree), 0, initialScale + (scale-initialScale)*(timerAnimation/duree))
	else
		love.graphics.draw(image, objectiveX, objectiveY, 0, scale)
	end
end

function st:update(dt)
	if first then
		timerAnimation = 0
		first = false
	else
		timerAnimation = timerAnimation + dt
	end
end

function st:joystickpressed(joystick, button)
	local input = controools[joystick][button]
	if input == "action" or input == "menu/cancel" then
		Gamestate.switch(oldState)
	end
end

function st:keypressed(key, unicode)
	local input = controools["keyboard"][key]
	if input == "action" or input == "menu/cancel" then
		Gamestate.switch(oldState)
	end
end

local bump = require 'bump'

local cols_len = 0 -- how many collisions are happening

-- World creation
local world = bump.newWorld()



-- Player functions
local player = { x=50,y=50,w=20,h=20, speed = 120, vx = 0, vy = 0, jumps = 0 }
local jumpmax = 3
local wIsntDown = true
--Player control function
local function updatePlayer(dt)
  local speed = player.speed
	local gravity = 9.8

  local dx, dy = 0, 0
  if love.keyboard.isDown('d') then
    dx = speed * dt
  elseif love.keyboard.isDown('a') then
    dx = -speed * dt
  end
  if love.keyboard.isDown('s') then
    dy = speed * dt
	end

  if love.keyboard.isDown('w') and wIsntDown == true then
		wIsntDown = false
		if player.jumps < jumpmax then
			player.jumps = player.jumps + 1
			player.vy = 0
			player.vy = player.vy - 5
		end
		dy = -speed * dt

	elseif love.keyboard.isDown('w') == false then
		wIsntDown = true
  end


	if love.keyboard.isDown('space') then
		player.y = 100
		player.vy = 0
	end

		player.vy = player.vy + gravity * dt
		dy = dy + player.vy

  if dx ~= 0 or dy ~= 0 then
    local cols
    player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
		if cols_len > 0 then
			player.vy = 0
			player.jumps = 0
		end
  end
end




local block2 = {
  x = 89,
  y = 450,
  w = 89 * 3,
  h = 30
}
local block3 = {
  x = 89 * 5,
  y = 450,
  w = 89 * 3,
  h = 30
}
local block = {
  x = 89 - 30,
  y = 325,
  w = 89,
  h = 30
}
local block4 = {
  x = 89 * 7 + 30,
  y = 325,
  w = 89,
  h = 30
}


local bullets = {}

function CreateBullet()
  local bullet = {
    x = player.x + player.w/2,
    y = player.y + player.h/2,
    w = 5,
    h = 5
  }

  --finding the direction the bullet needs to move in.
  local x = love.mouse.getX() - bullet.x
  local y = love.mouse.getY() - bullet.y
  local length = math.sqrt( (x * x) + (y * y) )

  bullet.dx = (x * (1/length)) * 20
  bullet.dy = (y * (1/length)) * 20

  --finding which side of the player to spawn the bullet.
  bullet.x = player.x + player.w/2 + bullet.dx --* 4
  bullet.y = player.y + player.h/2 + bullet.dy --* 4


  table.insert(bullets, bullet)
  world:add(bullet, bullet.x, bullet.y, bullet.w, bullet.h)
end

function CreateDirectedBullet(dx,dy)
  local bullet = {
    x = player.x + player.w/2,
    y = player.y + player.h/2,
    w = 5,
    h = 5
  }

  --finding the direction the bullet needs to move in.
  bullet.dx = dx
  bullet.dy = dy

  --finding which side of the player to spawn the bullet.
  bullet.x = player.x + player.w/2 + bullet.dx --* 4
  bullet.y = player.y + player.h/2 + bullet.dy --* 4

  table.insert(bullets, bullet)
  world:add(bullet, bullet.x, bullet.y, bullet.w, bullet.h)
end

function CreateShotgun()
  local x = love.mouse.getX() - player.x + player.w/2
  local y = love.mouse.getY() - player.y + player.h/2
  local length = math.sqrt( (x * x) + (y * y) )
  local r = math.random(-10,10)
  bullet.dx = (x * (1/length)) * 20
  bullet.dy = (y * (1/length)) * 20
end

function BulletMovement(dt, bullet,bulletk)
  --collisions
  local cols
  --bump stuff that does the actual movement
  bullet.x, bullet.y, cols, cols_len = world:move(bullet, bullet.x + bullet.dx, bullet.y + bullet.dy)
  --if it collides with stuff, do these things
	if cols_len > 0 then
	   world:remove(bullet)
     table.remove(bullets, bulletk)
	end
end


local enemies = {}
for i=1,10 do
  local enemy = {
    x = math.random(100,680),
    y = math.random(50,250),
    w = math.random(5,20),
    h = math.random(5,20)
  }
  table.insert(enemies, enemy)
end

local crystals = {}
crystals.p1 = {
  x = 375,
  y = 50,
  w = 50,
  h = 50
}
crystals.p2 = {
  x = 375,
  y = 150,
  w = 50,
  h = 50
}
crystals.p3 = {
  x = 325,
  y = 100,
  w = 50,
  h = 50
}
crystals.p4 = {
  x = 425,
  y = 100,
  w = 50,
  h = 50
}
crystals.p5 = {
  x = 425 + 10,
  y = 75 - 10,
  w = 25,
  h = 25
}
crystals.p6 = {
  x = 425 + 10,
  y = 150 + 10,
  w = 25,
  h = 25
}
crystals.p7 = {
  x = 350 - 10,
  y = 75 - 10,
  w = 25,
  h = 25
}
crystals.p8 = {
  x = 350 - 10,
  y = 150 + 10,
  w = 25,
  h = 25
}
crystalhitbox = {
  x = 350,
  y = 75,
  w = 100,
  h = 100
}

local mouseIsntDown = true

-- Main LÖVE functions

function love.load()
  world:add(player, player.x, player.y, player.w, player.h)
  world:add(block, block.x,block.y,block.w,block.h)
	world:add(block2, block2.x,block2.y,block2.w,block2.h)
  world:add(block3, block3.x,block3.y,block3.w,block3.h)
  world:add(block4, block4.x,block4.y,block4.w,block4.h)
  -- for k,v in pairs(crystals) do
  --   world:add(v, v.x,v.y,v.w,v.h)
  -- end
  world:add(crystalhitbox, crystalhitbox.x, crystalhitbox.y, crystalhitbox.w, crystalhitbox.h)

  love.mouse.setVisible(false)

end

function love.update(dt)
  cols_len = 0
  updatePlayer(dt)

  if love.mouse.isDown(1) and mouseIsntDown == true then
    mouseIsntDown = false
    CreateBullet()
  elseif love.mouse.isDown(1) == false then
    mouseIsntDown = true
  end
  if love.mouse.isDown(2) then
    CreateDirectedBullet(0.05,0.14)
  end

  for k,v in pairs(bullets) do
    BulletMovement(dt,v,k)
  end

end

function love.draw()

  love.graphics.setColor(1,0,0)
  for k,v in pairs(crystals) do
    love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
  end
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("line", crystalhitbox.x, crystalhitbox.y, crystalhitbox.w, crystalhitbox.h)

  love.graphics.rectangle("line", block.x, block.y, block.w, block.h)
	love.graphics.rectangle("line", block2.x, block2.y, block2.w, block2.h)
  love.graphics.rectangle("line", block3.x, block3.y, block3.w, block3.h)
  love.graphics.rectangle("line", block4.x, block4.y, block4.w, block4.h)

  love.graphics.rectangle("line", player.x, player.y, player.w, player.h)

  mx, my = love.mouse.getX(), love.mouse.getY()
  love.graphics.line(mx, my - 10, mx, my - 5)
  love.graphics.line(mx, my + 10, mx, my + 5)
  love.graphics.line(mx - 10, my, mx - 5, my)
  love.graphics.line(mx + 10, my, mx + 5, my)

  for k,v in pairs(bullets) do
    love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
  end
end

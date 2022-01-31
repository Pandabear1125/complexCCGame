local Player = {
   x = 3, 
   y = 3
}

function initialize(mapW, mapH, monW, monH)
   Player.mapW, Player.mapH = mapW, mapH
   Player.widthRadius = math.floor(monW/2)
   Player.heightRadius = math.floor(monH/2)
end 

function getPosition()
   return Player.x, Player.y
end 

local function checkCollision(Map, x, y)
   local tile = Map.map[y][x]
   if tile == 'X' or tile == 'E' or tile == 'B' then 
      return false 
   else 
      return true 
   end 
end 

function move(map, dx, dy) 
   if checkCollision(map, Player.x+dx, Player.y+dy) then 
      Player.x = Player.x + dx 
      Player.y = Player.y + dy 
   end 
end 

function moveTo(x, y) 
   Player.x = x
   Player.y = y 
end 

function draw(mon, ox, oy)
   local curX, curY

   --figure out x 
   if Player.x >= Player.widthRadius and Player.x <= Player.mapW-Player.widthRadius then 
      curX = Player.widthRadius 
   elseif Player.x < Player.widthRadius then 
      curX = Player.x
   elseif Player.x > Player.mapW-Player.widthRadius then 
      curX = Player.x - (Player.mapW-Player.widthRadius) + Player.widthRadius
   else 
      curX = 0
   end 
   --figure for y
   if Player.y >= Player.heightRadius and Player.y <= Player.mapH-Player.heightRadius then 
      curY = Player.heightRadius 
   elseif Player.y < Player.heightRadius then 
      curY = Player.y
   elseif Player.y > Player.mapH-Player.heightRadius then 
      curY = Player.y - (Player.mapH-Player.heightRadius) + Player.heightRadius
   else 
      curY = 0
   end 

   mon.setCursorPos(curX, curY)
   mon.write("P") 
end 
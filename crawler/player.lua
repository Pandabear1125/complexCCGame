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

function move(dx, dy) 
   Player.x = Player.x + dx 
   Player.y = Player.y + dy 
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
   mon.setCursorPos(1, 1)
   mon.write(Player.x..' '..Player.y)
   mon.setCursorPos(1, 2)
   mon.write(Player.mapW..' '..Player.mapH)
   mon.setCursorPos(1, 3)
   mon.write(Player.widthRadius..' '..Player.heightRadius)
   mon.setCursorPos(1, 4)
   mon.write(tostring(curX)..' '..tostring(curY))   
end 
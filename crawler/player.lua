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
   return {Player.x, Player.y}
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
   --check if player should be center
   if Player.x >= Player.widthRadius and Player.y >= Player.heightRadius
   and Player.x <= Player.mapW-Player.widthRadius and Player.y <= Player.heightRadius then 
      mon.setCursorPos(Player.widthRadius, Player.heightRadius)
   --check if player should not be center (top right)
   elseif Player.x <= Player.widthRadius and Player.y <= Player.heightRadius then 
      mon.setCursorPos(Player.x, Player.y)
   --check if player should not be center (bottom left)
   elseif Player.x >= Player.mapW-Player.widthRadius and Player.y >= Player.heightRadius then 
      mon.setCursorPos(Player.x - (Player.mapW-Player.widthRadius), Player.y - (Player.mapH-Player.heightRadius))
   end 
   mon.write("P")
end 
local Player = {
   x = 3, 
   y = 3, 
   heightRadius = 0, 
   widthRadius = 0,
   mapH = 0, 
   mapW = 0
}

Player.inventory = inv.Inven:new{
   x = 1,
   y = 1, 
   width = 4, 
   height = 5
}
Player.inventory:setPrimary()
Player.inventory:select()

function initialize(Map, monW, monH, data)
   Player.mapW, Player.mapH = Map.data.width, Map.data.height
   Player.widthRadius = math.ceil(monW/2)
   Player.heightRadius = math.ceil(monH/2)
   if data then 
      moveTo(data.x, data.y)
   else 
      Player.x = Map.data.playerSpawn[1]
      Player.y = Map.data.playerSpawn[2]
   end 
   if Map.data.width < monW then 
      Player.ox = math.floor((monW-Map.data.width)/2)
   else 
      Player.ox = 0
   end 
   
   if Map.data.height < monH then 
      Player.oy = math.floor((monH-Map.data.height)/2)
   else 
      Player.oy = 0
   end 
end 

function getPosition()
   return Player.x, Player.y
end 

local function checkCollision(Map, x, y)
   local tile = Map.map[y][x]
   for k, v in ipairs(Map.data.dungeonList) do 
      if v.x == x and v.y == y then 
         map.changeMap(v.path, map.getActivePath()) 
         return false
      end 
   end 

   if tile == 'X' or tile == 'E' or tile == 'B' then 
      return false 
   elseif tile == '$' then -- check if on loot box
      loot.loadLootBox(x, y)
      return true  
   else 
      -- check if leaving lootbox
      if Map.map[Player.y][Player.x] == '$' then 
         loot.unloadLootBox(Player.x, Player.y)
      end 
      return true 
   end 
end 

function move(Map, dx, dy) 
   if checkCollision(Map, Player.x+dx, Player.y+dy) then 
      Player.x = Player.x + dx 
      Player.y = Player.y + dy 
   end 
end 

function moveTo(x, y) 
   Player.x = x
   Player.y = y 
end 

function draw(mon)
   local curX, curY

   --figure out x 
   if Player.mapW >= Player.widthRadius*2 then -- whether map is smaller than screen width
      if Player.x >= Player.widthRadius and Player.x <= Player.mapW-Player.widthRadius then 
         --center of screen
         curX = Player.widthRadius 
      elseif Player.x < Player.widthRadius then 
         -- left wall
         curX = Player.x
      elseif Player.x > Player.mapW-Player.widthRadius then 
         -- right wall
         curX = Player.x - (Player.mapW-Player.widthRadius) + Player.widthRadius
      else 
         curX = 0
      end 
   else 
      curX = Player.x 
   end 
   --figure for y
   if Player.mapH >= Player.heightRadius*2 then -- whether map is smaller than screen height
      if Player.y >= Player.heightRadius and Player.y <= Player.mapH-Player.heightRadius then 
         --center of screen
         curY = Player.heightRadius 
      elseif Player.y < Player.heightRadius then 
         -- top wall
         curY = Player.y
      elseif Player.y > Player.mapH-Player.heightRadius then 
         -- bottom wall
         curY = Player.y - (Player.mapH-Player.heightRadius) + Player.heightRadius
      else 
         curY = 0
      end 
   else 
      curY = Player.y 
   end 

   mon.setCursorPos(curX+Player.ox, curY+Player.oy)
   mon.write("P") 
   -- mon.setCursorPos(1, 1)
   -- mon.write(Player.x..' '..Player.y)
   -- mon.setCursorPos(1, 2)
   -- mon.write(Player.widthRadius..' '..Player.heightRadius)
   -- mon.setCursorPos(1, 3)
   -- mon.write(Player.mapW..' '..Player.mapH)
   -- mon.setCursorPos(1, 4)
   -- mon.write(curX..' '..curY)

end 
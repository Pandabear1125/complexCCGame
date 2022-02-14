os.loadAPI("crawler/file.lua")
os.loadAPI("crawler/gameVar.lua")
os.loadAPI("crawler/map.lua")
os.loadAPI("crawler/inv.lua")
os.loadAPI("crawler/items.lua")
os.loadAPI("crawler/loot.lua")
os.loadAPI("crawler/player.lua")


map.loadMapFile("mainWorld")
local monW, monH = term.getSize()
local centerX, centerY = math.ceil(monW/2), math.ceil(monH/2)

player.initialize(map.getActiveMap(), monW, monH)

function getInput() 
   local event, key = os.pullEvent('key') 
   if key == 15 then -- tab
      if gameVar.state == 1 then gameVar.state = 2 
      elseif gameVar.state == 2 then gameVar.state = 1 
      end 
   end 
   if gameVar.state == 1 then 
      if key == 208 then -- down arrow
         player.move(map.getActiveMap(), 0, 1)
      elseif key == 200 then -- up arrow 
         player.move(map.getActiveMap(), 0, -1)
      elseif key == 203 then -- left arrow 
         player.move(map.getActiveMap(), -1, 0)
      elseif key == 205 then -- right arrow
         player.move(map.getActiveMap(), 1, 0)
      elseif key == 57 then 
         loot.populateLootBox(2, 2)
      end 
   elseif gameVar.state == 2 then 
      inv.getInput(key)
   end 
end 

local function mainLoop() 
   while true do 
      if gameVar.state == 1 then 
         local pX, pY = player.getPosition()
         map.draw(term, pX-centerX, pY-centerY)
         player.draw(term)
      elseif gameVar.state == 2 then 
         inv.drawAll(term)
      else 
         return 1
      end 
      getInput()
   end 
end 

mainLoop() 

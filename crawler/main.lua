os.loadAPI("file")
os.loadAPI("gameVar")
os.loadAPI("map")
os.loadAPI("player")

local Map = map.loadMapFile("mainWorld")
local monW, monH = term.getSize()
local centerX, centerY = math.floor(monW/2), math.floor(monH/2)

player.initialize(Map.data.width, Map.data.height, monW, monH)

function getInput() 
   local event, key = os.pullEvent('key') 
   if key == 208 then -- down arrow
      player.move(Map, 0, 1)
   elseif key == 200 then -- up arrow 
      player.move(Map, 0, -1)
   elseif key == 203 then -- left arrow 
      player.move(Map, -1, 0)
   elseif key == 205 then -- right arrow
      player.move(Map, 1, 0)
   end 
end 

local function mainLoop() 
   while true do 
      if gameVar.state == 1 then 
         local pX, pY = player.getPosition()
         map.draw(term, pX-centerX, pY-centerY)
         player.draw(term)
         getInput()
      else 
         return 1
      end 
   end 
end 

mainLoop() 

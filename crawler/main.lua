os.loadAPI("file")
os.loadAPI("gameVar")
os.loadAPI("map")
os.loadAPI("player")

local mapW, mapH = map.loadMapFile("crawlerTest")
local monW, monH = term.getSize()
local centerX, centerY = math.floor(monW/2), math.floor(monH/2)

player.initialize(mapW, mapH, monW, monH)

function getInput() 
   local event, key = os.pullEvent('key') 
   if key == 208 then -- down arrow
      -- pY = pY + 1
      player.move(0, 1)
   elseif key == 200 then -- up arrow 
      -- pY = pY - 1
      player.move(0, -1)
   elseif key == 203 then -- left arrow 
      -- pX = pX - 1 
      player.move(-1, 0)
   elseif key == 205 then -- right arrow
      -- pX = pX + 1
      player.move(1, 0)
   end 
end 

local function mainLoop() 
   while true do 
      local pX, pY = player.getPosition()
      map.draw(term, pX-centerX, pY-centerY)
      player.draw(term)
      getInput()
   end 
end 

mainLoop() 

os.loadAPI("file")
os.loadAPI("gameVar")
os.loadAPI("map")

map.loadMapFile("crawlerTest")
local w, h = term.getSize()
local centerX, centerY = math.floor(w/2), math.floor(h/2)

local pX = 30
local pY = 12

function getInput() 
   local event, key = os.pullEvent('key') 
   if key == 208 then -- down arrow
      pY = pY + 1
   elseif key == 200 then -- up arrow 
      pY = pY - 1
   elseif key == 203 then -- left arrow 
      pX = pX - 1 
   elseif key == 205 then -- right arrow
      pX = pX + 1
   end 
end 

local function mainLoop() 
   while true do 
      map.draw(term, pX-centerX, pY-centerY)
      term.setCursorPos(pX, pY) 
      term.write('P')
      getInput()
   end 
end 

mainLoop() 

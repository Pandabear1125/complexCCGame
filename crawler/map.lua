local activeMap = nil 
local activePath = nil 
local monW, monH = term.getSize() 

local LX, LY, HX, HY = 1, 1, monW, monH

local function setTile(value, x, y)
   if x > 1 and x < activeMap.data.width and y > 1 and y < activeMap.data.height then
      activeMap.map[y][x] = value
   end 
end 

local function populateActiveMap()
   for i = 1, math.random(2, 5) do 
      local x = math.random(2, activeMap.data.width-1)
      local y = math.random(2, activeMap.data.height-1)
      setTile('!', x, y)
   end 
end 

function loadMapFile(path)
   assert(fs.exists("mapEditor/maps/"..path), "map file at path: \'"..path.."\' not found")
   file.setDirectory("mapEditor/maps/") 
   local Map = file.read(path) 
   activeMap = Map 
   activePath = path 
   populateActiveMap()
   return activeMap 
end 

function draw(mon, ox, oy)
   mon.clear()
   -- reset ox, oy if out of bounds
   if ox < 0 then ox = 0 end 
   if oy < 0 then oy = 0 end 
   if ox >= activeMap.data.width-monW then ox = activeMap.data.width-monW end 
   if oy >= activeMap.data.height-monH then oy = activeMap.data.height-monH end 
   -- draw
   for i = LX, HX do 
      for j = LY, HY do 
         mon.setCursorPos(i, j) 
         mon.write(activeMap.map[j+oy][i+ox])
      end 
   end 
end 

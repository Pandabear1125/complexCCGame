local activeMap = nil 
local activePath = nil
local dungeonList = nil
local monW, monH = term.getSize() 

local LX, LY, HX, HY = 1, 1, monW, monH

local function setTile(value, x, y)
   if x > 1 and x < activeMap.data.width and y > 1 and y < activeMap.data.height then
      activeMap.map[y][x] = value
   end 
end 

local function populateActiveMap(holdingTable)
   for i = 1, math.random(2, math.floor(activeMap.data.width/15)) do 
      local x = math.random(7, activeMap.data.width-6)
      local y = math.random(7, activeMap.data.height-6)
      local mapPath = math.random(1, 9)
      setTile('!', x, y)
      setTile(mapPath, x+2, y)
      table.insert(holdingTable, {x, y, mapPath})
   end 
end 

local function save(path) 
   assert(activeMap, "no map loaded/selected to save")
   file.setDirectory("mapEditor/maps/") 
   file.write(path, activeMap) 
end 

function loadMapFile(path)
   assert(fs.exists("mapEditor/maps/"..path), "map file at path: \'"..path.."\' not found")
   file.setDirectory("mapEditor/maps/") 
   local Map = file.read(path) 
   activeMap = Map 
   activePath = path
   dungeonList = {}
   populateActiveMap(dungeonList)
   return activeMap 
end 

function changeMap(newMapPath) 
   save(activePath)
   

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

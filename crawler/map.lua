local activeMap = nil
local activePath = nil

local dungeonList = {}
local monW, monH = term.getSize() 

local oldPlayerData = {0, 0}

local LX, LY, HX, HY = 1, 1, monW, monH

local function setTile(value, x, y)
   if x > 1 and x < activeMap.data.width and y > 1 and y < activeMap.data.height then
      activeMap.map[y][x] = value
   end 
end 

local function populateActiveMap(holdingTable)
   for i = 1, math.random(2, 5) do 
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
   file.write(path, {activeMap.map, activeMap.data}, true) 
end 

function loadMapFile(path)
   assert(fs.exists("mapEditor/maps/"..path), "map file at path: \'"..path.."\' not found")
   file.setDirectory("mapEditor/maps/")
   activeMap = {map = file.read(path, 1), data = file.read(path, 2)}
   activePath = path
   if activeMap.data.width < monW then 
      activeMap.data.offX = math.floor((monW-activeMap.data.width)/2)
   else 
      activeMap.data.offX = 0
   end 
   if activeMap.data.height < monH then 
      activeMap.data.offY = math.floor((monH-activeMap.data.height)/2)
   else 
      activeMap.data.offY = 0
   end 
   dungeonList = {}
   populateActiveMap(dungeonList)
end 

function getActiveMap() 
   --need this cause apparently 'activeMap' var is local when its global
   return activeMap
end 

function changeMap(newMapPath) 
   save(activePath)
   local px, py = player.getPosition()
   oldPlayerData = {px, py}
   assert(fs.exists("mapEditor/maps/"..newMapPath), "map file at path: \'"..newMapPath.."\' not found")
   file.setDirectory("mapEditor/maps/")
   activeMap = {map = file.read(newMapPath, 1), data = file.read(newMapPath, 2)}
   activePath = newMapPath
   if activeMap.data.width < monW then 
      activeMap.data.offX = math.floor((monW-activeMap.data.width)/2)
   else 
      activeMap.data.offX = 0
   end 
   if activeMap.data.height < monH then 
      activeMap.data.offY = math.floor((monH-activeMap.data.height)/2)
   else 
      activeMap.data.offY = 0
   end 
   player.initialize(activeMap, monW, monH)
end 
   
function draw(mon, ox, oy)
   local LX, LY, HX, HY = LX, LY, HX, HY
   mon.clear()
   -- reset ox, oy if out of bounds
   if ox < 0 then ox = 0 end 
   if oy < 0 then oy = 0 end 
   if ox >= activeMap.data.width-monW then ox = activeMap.data.width-monW end 
   if oy >= activeMap.data.height-monH then oy = activeMap.data.height-monH end 
   if activeMap.data.width < monW then ox = 0; HX = activeMap.data.width end 
   if activeMap.data.height < monH then oy = 0; HY = activeMap.data.height end 
   -- draw
   for i = LX, HX do 
      for j = LY, HY do 
         mon.setCursorPos(i+activeMap.data.offX, j+activeMap.data.offY) 
         mon.write(activeMap.map[j+oy][i+ox])
      end 
   end 
end 

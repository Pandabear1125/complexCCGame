local activeMap = nil
local activePath = nil

local monW, monH = term.getSize() 

local oldPlayerData = nil

local LX, LY, HX, HY = 1, 1, monW, monH

local function setTile(value, x, y)
   if x > 1 and x < activeMap.data.width and y > 1 and y < activeMap.data.height then
      activeMap.map[y][x] = value
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
   loot.populateLoot(activeMap.data.lootList)
end 

function getActiveMap() 
   --need this cause apparently 'activeMap' var is local when its global
   return activeMap
end 

function getActivePath()
   return activePath
end 

function changeMap(newMapPath, fromPath) 
   save(activePath)
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

   loot.populateLoot(activeMap.data.lootList)

   local data = {}
   for k, v in ipairs(activeMap.data.dungeonList) do 
      if v.path == fromPath then 
         data = {x = v.x, y = v.y}
      end 
   end 
   if data.x and data.y then 
   else 
      data = nil 
   end 
   player.initialize(activeMap, monW, monH, data)
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
         if activeMap.map[j+oy][i+ox] ~= "P" then 
            mon.write(activeMap.map[j+oy][i+ox])
         end 
      end 
   end 
end 

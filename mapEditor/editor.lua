local activeMap = nil 
local activePath = nil
local monW, monH = term.getSize()

local curX, curY = math.floor(monW/2)-7, math.floor(monH/2)-1
local mapX, mapY = 0, 0
local placement = {'X', 'P', 'E', 'B', '$', '*', '!'}
local desc = {"Wall", "Player Spawn: Max 1", "Enemy Spawn", "Boss Spawn: Max 2", "Loot", "Trap", "Dungeon"}
local placeSelect = 1 

local viewW, viewH = 38, 16

function createMap(path, width, height, emptyVal)
   local emptyVal = emptyVal or ''
   local width = width + 2
   local height = height + 2
   local Map = {
      data = {
         width = width, 
         height = height, 
         playerCount = 0, 
         bossCount = 0, 
         playerSpawn = nil,
         dungeonList = {},
         lootList = {}
      },
      map = {} 
   }
   for i = 1, height do 
      Map.map[i] = {}
      for j = 1, width do 
         Map.map[i][j] = emptyVal 
      end 
   end 

   for i = 1, width do 
      Map.map[1][i] = 'X'
      Map.map[height][i] = 'X'
   end 
   for i = 1, height do 
      Map.map[i][1] = 'X' 
      Map.map[i][width] = 'X'
   end 

   file.setDirectory("mapEditor/maps/") 
   file.create(path) 
   file.write(path, {Map.map, Map.data}, true) 
   activeMap = Map
   activePath = path 
   return path 
end 

function loadMap(path) 
   assert(fs.exists("mapEditor/maps/"..path), "map file at path: \'"..path.."\' not found")
   file.setDirectory("mapEditor/maps/") 
   local mapGrid = file.read(path, 1)
   local mapData = file.read(path, 2)
   activeMap = {map = mapGrid, data = mapData} 
   activePath = path 
   return path 
end 

function setTile(value, erase) 
   assert(activeMap, "no map loaded/selected to edit") 
   local cX, cY = curX-mapX, curY-mapY 
   if cX > 1 and cY > 1 and cX < activeMap.data.width and cY < activeMap.data.height then 
      if not erase then 
         if activeMap.map[cY][cX] == '' then 
            if value == "P" and activeMap.data.playerCount > 0 then 
            elseif value == "B" and activeMap.data.bossCount > 1 then 
            else 
               if value == "P" then 
                  activeMap.data.playerCount = activeMap.data.playerCount + 1 
                  activeMap.data.playerSpawn = {cX, cY}
               end 
               if value == "B" then activeMap.data.bossCount = activeMap.data.bossCount + 1 end 
               if value == "!" then 
                  local name = ui.getDungeonName(term)
                  table.insert(activeMap.data.dungeonList, {x = cX, y = cY, path = name})
               end 
               if value == "$" then 
                  local rarity = ui.getLootData(term)
                  table.insert(activeMap.data.lootList, {x = cX, y = cY, rarity = rarity})
               end 
               activeMap.map[cY][cX] = value 
            end
         end  
      else 
         local value = activeMap.map[cY][cX] 
         if value == "P" then 
            activeMap.data.playerCount = activeMap.data.playerCount - 1 
            activeMap.data.playerSpawn = nil
         end 
         if value == "B" then activeMap.data.bossCount = activeMap.data.bossCount - 1 end
         if value == "!" then 
            for k, v in ipairs(activeMap.data.dungeonList) do 
               if v.x == cX and v.y == cY then
                  table.remove(activeMap.data.dungeonList, k)
               end 
            end 
         end 
         if value == "$" then 
            for k, v in ipairs(activeMap.data.lootList) do 
               if v.x == cX and v.y == cY then
                  table.remove(activeMap.data.lootList, k)
               end 
            end 
         end
         activeMap.map[cY][cX] = '' 
      end 
   end 
end 

function save(path) 
   assert(activeMap, "no map loaded/selected to save")
   file.setDirectory("mapEditor/maps/") 
   file.write(path, {activeMap.map, activeMap.data}, true) 
end 

function draw(mon) 
   assert(activeMap, "no map loaded/selected to draw")
   local x, y = mapX, mapY 

   for i = 1, viewW do 
      for j = 1, viewH do 
         mon.setCursorPos(i, j)
         if j-mapY > 0 and i-mapX > 0 and j-mapY <= activeMap.data.height and i-mapX <= activeMap.data.width then 
            mon.write(activeMap.map[j-mapY][i-mapX])
         end 
      end 
   end 

   local w, h = mon.getSize()
   mon.setCursorPos(w-9, 1)
   mon.write("CONTROLS")
   mon.setCursorPos(w-10, 3)
   mon.write("move with")
   mon.setCursorPos(w-9, 4)
   mon.write("\'arrows\'")
   mon.setCursorPos(w-10, 6)
   mon.write("place with")
   mon.setCursorPos(w-8, 7)
   mon.write("\'space\'")
   mon.setCursorPos(w-11, 9)
   mon.write("select item")
   mon.setCursorPos(w-11, 10)
   mon.write("with numbers")
   mon.setCursorPos(w-9, 12)
   mon.write("exit with")
   mon.setCursorPos(w-6, 13)
   mon.write("\'e\'")
   mon.setCursorPos(w-10, 15)
   mon.write("erase with")
   mon.setCursorPos(w-6, 16)
   mon.write("\'x\'")
  
   for i = 1, h-3 do 
      mon.setCursorPos(w-12, i) 
      mon.write("|")
   end 
   mon.setCursorPos(1, h-2)

   for i = 1, w-13 do 
      mon.write('-') 
   end 
   mon.write("+")

   mon.setCursorPos(1, h+1) 
   mon.write("Currently Editing: \'"..activePath.."\'")
   mon.setCursorPos(1, h) 
   mon.write("("..curX-mapX..","..curY-mapY..") Selected Item: \'"..placement[placeSelect].."\' = "..desc[placeSelect])
end 

function update(mon)
   mon.setCursorPos(curX, curY)
end 

function handleInput(key) 
   if key == 200 then -- up arrow
      mapY = mapY + 1
   elseif key == 208 then -- down arrow 
      mapY = mapY - 1
   elseif key == 205 then -- right arrow
      mapX = mapX - 1 
   elseif key == 203 then -- left arrow
      mapX = mapX + 1
   elseif key == 57 then -- space bar
      setTile(placement[placeSelect])
      save(activePath) 
   elseif key == 18 then -- e 
      save(activePath) 
      gameVar.state = 0
      ui.loadMapFiles()
   elseif key >= 2 and key <= 8 then -- number keys (1-6) 
      placeSelect = key - 1
   elseif key == 45 then -- x
      setTile('', true) 
      save(activePath)
   end 
end 
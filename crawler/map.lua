local activeMap = nil 
local activePath = nil 
local monW, monH = term.getSize() 

local LX, LY, HX, HY = 1, 1, monW, monH

function loadMapFile(path)
   assert(fs.exists("mapEditor/maps/"..path), "map file at path: \'"..path.."\' not found")
   file.setDirectory("mapEditor/maps/") 
   local Map = file.read(path) 
   activeMap = Map 
   activePath = path 
   return activeMap.data.width, activeMap.data.height 
end 

function draw(mon, ox, oy)
   mon.clear()
   if ox < 0 then ox = 0 end 
   if oy < 0 then oy = 0 end 
   for i = LX, HX do 
      for j = LY, HY do 
         mon.setCursorPos(i, j) 
         mon.write(activeMap.map[j+oy][i+ox])
      end 
   end 
end 

button.createGroup("menu")
button.new("menu", 3, 5, "Create New Map", function(num) gameVar.state = num end, 1)
button.new("menu", 3, 7, "Load Map", function() button.selectGroup("mapSelect") end)
button.new("menu", 3, 9, "Quit Editor", function(num) gameVar.state = num end, 3)
button.selectGroup("menu") 

function loadMapFiles() 
   button.createGroup("mapSelect") 
   local fl = fs.list("mapEditor/maps") 
   if #fl > 0 then 
      for k, v in ipairs(fl) do 
         button.new("mapSelect", 3, 5+(2*(k-1)), v, function(num) editor.loadMap(v); gameVar.state = num end, 2)
      end 
      button.new("mapSelect", 3, 5+(2*#fl), "Back to main menu.", function() button.selectGroup("menu"); loadMapFiles() end)
   else 
      button.new("mapSelect", 3, 5, "No map files found. Create one?", function(num) gameVar.state = num end, 1)
      button.new("mapSelect", 3, 7, "Back to main menu.", function() button.selectGroup("menu"); loadMapFiles() end)
   end 
end 

function drawMenu(mon) 
   mon.clear()
   mon.setCursorPos(1, 1)
   mon.write("Panda's Map Creator") 
   mon.setCursorPos(2, 2) 
   mon.write("Navigate with up/down arrow keys") 
   mon.setCursorPos(3, 3) 
   mon.write("Select with right arrow key")
   button.draw(mon) 
end 

function drawMapCreate(mon)
   mon.clear()
   mon.setCursorPos(1, 6) 
   mon.write("Your map name? (no spaces)")
   mon.setCursorPos(1, 7) 
   mon.write("Type 'back' to return to main menu")
   mon.setCursorPos(3, 8)
   local mapName = read() 
   if string.lower(mapName) == 'back' then 
      gameVar.state = 0 
      return nil 
   end 
   mon.setCursorPos(1, 9) 
   
   mon.write("What is the map's width?") 
   mon.setCursorPos(3, 10) 
   local width = read(); local width = tonumber(width)
   mon.setCursorPos(3, 11) 
   if type(width) ~= "number" then 
      mon.write("width needs to be a number") 
      os.sleep(0.5) 
      return nil 
   end 

   mon.setCursorPos(1, 11)
   mon.write("What is the map's height?") 
   mon.setCursorPos(3, 12) 
   local height = read(); local height = tonumber(height) 
   mon.setCursorPos(3, 13) 
   if type(height) ~= "number" then 
      mon.write("height needs to be a number") 
      os.sleep(0.5) 
      return nil 
   end 
   mon.setCursorBlink(true) 
   return mapName, width, height 
end 

function getDungeonName(mon)
   mon.clear()
   os.sleep(0.1)
   mon.setCursorPos(1, 7)
   mon.write("What is the path to this dungeon?")
   mon.setCursorPos(3, 8)
   local name = read()
   mon.setCursorPos(1, 9)
   mon.write("If you need to rename this later, just delete")
   mon.setCursorPos(1, 10)
   mon.write("and replace the '!'")
   os.sleep(2)
   return name 
end 

function getLootData(mon)
   mon.clear()
   os.sleep(0.1)
   mon.setCursorPos(1, 7)
   mon.write("What is the rarity of this loot box?")
   mon.setCursorPos(1, 8)
   mon.write("Common/Rare/Boss")
   mon.setCursorPos(3, 9)
   local rarity = read()
   mon.setCursorPos(1, 10)
   if string.lower(rarity) ~= "common" and string.lower(rarity) ~= "rare" and string.lower(rarity) ~= "boss" then 
      mon.write("Invalid Option")
      os.sleep(0.25)
      getLootData(mon)
   end 

   os.sleep(1)
   return rarity
end 
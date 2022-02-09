os.loadAPI("mapEditor/editor.lua")
os.loadAPI("mapEditor/gameVar.lua")
os.loadAPI("mapEditor/button.lua")
os.loadAPI("mapEditor/file.lua")
os.loadAPI("mapEditor/input.lua")
os.loadAPI("mapEditor/ui.lua")

--gameVar.state 
--0 for main menu 
--1 for map creation ui
--2 for editor 

term.setCursorBlink(true) 

ui.loadMapFiles() 

local function update() 
   editor.update(term) 
   input.handle() 
end 

local function draw() 
   term.clear()
   editor.draw(term) 
end 

local function mainloop()
   while true do 
      if gameVar.state == 0 then 
         ui.drawMenu(term) 
         local event, key = os.pullEvent('key')
         button.input(key)
      elseif gameVar.state == 1 then 
         local name, w, h = ui.drawMapCreate(term) 
         if name and w and h then 
            editor.createMap(name, w, h, '') 
            gameVar.state = 2 
         end 
      elseif gameVar.state == 2 then 
         term.setCursorBlink(true) 
         draw() 
         update() 
      else 
         term.clear()
         term.setCursorPos(1,1) 
         return 
      end 
   end 
end 

mainloop()
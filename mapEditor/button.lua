local Button = {}
local selected = 0
local selectedGroup = ''

function createGroup(name)
   Button[name] = {}
end 

function new(group, x, y, text, cmd, arg)
   table.insert(Button[group], {x = x, y = y, text = text, cmd = cmd, arg = arg})
end 

function selectGroup(group)
   selectedGroup = group
   selected = 1
end 

function select(num)
   selected = num
end 

function highlight(mon) 
   if selected >= 1 and selectedGroup ~= '' then
      local x1, x2 = Button[selectedGroup][selected].x-1, Button[selectedGroup][selected].x+#Button[selectedGroup][selected].text
      local y = Button[selectedGroup][selected].y
      mon.setCursorPos(x1, y)
      mon.write('<')
      mon.setCursorPos(x2, y)
      mon.write('>')
   end
end 

function draw(mon, x, y)
   if selectedGroup ~= '' then
      for k, v in ipairs(Button[selectedGroup]) do
         mon.setCursorPos(v.x, v.y)
         mon.write(v.text)
      end
      highlight(mon) 
   end
end 

function input(key) 
   if key == 200 then 
      selected = selected - 1 
      if selected < 1 then selected = #Button[selectedGroup] end 
   elseif key == 208 then 
      selected = selected + 1 
      if selected > #Button[selectedGroup] then selected = 1 end 
   elseif key == 205 then 
      Button[selectedGroup][selected].cmd(Button[selectedGroup][selected].arg)
   end 
end 
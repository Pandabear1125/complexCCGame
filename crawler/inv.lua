local selectX, selectY = 1, 1
local selectedInv = nil
local selectedSlot = nil

Inven = {
   x = 0, 
   y = 0, 
   width = 1,
   height = 1, 
   buffer = 1,
   slotWidth = 3, 
   slotHeight = 3
}

function Inven:new(t)
   local t = t or {}
   setmetatable(t, self)
   self.__index = self 
   
   t.hash = {}
   for i = 1, t.height do 
      t.hash[i] = {}
      for j = 1, t.width do 
         t.hash[i][j] = {
         }
      end 
   end 
   
   return t 
end 

local function pickUpSlot()
   if selectedSlot then 
      if selectedInv.hash[selectY][selectX].id then 
         local oldSlot = {}
         oldSlot.id = selectedInv.hash[selectY][selectX].id
         oldSlot.level = selectedInv.hash[selectY][selectX].level
         selectedInv:setItem(selectX, selectY, selectedSlot)
         selectedSlot = oldSlot
      else 
         selectedInv:setItem(selectX, selectY, selectedSlot)
         selectedSlot = nil
      end 
   else 
      if selectedInv.hash[selectY][selectX].id then 
         selectedSlot = {}
         selectedSlot.id = selectedInv.hash[selectY][selectX].id
         selectedSlot.level = selectedInv.hash[selectY][selectX].level
         selectedInv:clearSlot(selectX, selectY)
      end 
   end 
end 

local function moveSelectSlot(dx, dy)
   selectX = selectX + dx
   selectY = selectY + dy
   if selectX < 1 then 
      selectX = 1
   elseif selectX > selectedInv.width then 
      selectX = selectedInv.width 
   end 
   
   if selectY < 1 then 
      selectY = 1
   elseif selectY > selectedInv.height then 
      selectY = selectedInv.height 
   end
end 

function getInput()
   local event, key = os.pullEvent('key')
   if key == 208 then -- down arrow
      moveSelectSlot(0, 1)
   elseif key == 200 then -- up arrow 
      moveSelectSlot(0, -1)
   elseif key == 203 then -- left arrow 
      moveSelectSlot(-1, 0)
   elseif key == 205 then -- right arrow
      moveSelectSlot(1, 0)
   elseif key == 57 then -- space 
      pickUpSlot()
   end 
end 

function Inven:clearSlot(x, y)
   self.hash[y][x] = {}
end 

function Inven:select()
   selectedInv = self 
end 

function Inven:setItem(x, y, itemTable)
   self.hash[y][x] = itemTable
end 

function Inven:highlightSlot(mon, x, y, ox, oy)
   mon.setCursorPos((x+ox) + (self.buffer+self.slotWidth)*(x-1), (y+oy) + (self.buffer+self.slotHeight)*(y-1))
   mon.write("/")
   mon.setCursorPos((x+ox) + (self.buffer+self.slotWidth)*(x), (y+oy) + (self.buffer+self.slotHeight)*(y-1))
   mon.write("\\")
   mon.setCursorPos((x+ox) + (self.buffer+self.slotWidth)*(x-1), (y+oy) + (self.buffer+self.slotHeight)*(y))
   mon.write("\\")
   mon.setCursorPos((x+ox) + (self.buffer+self.slotWidth)*(x), (y+oy) + (self.buffer+self.slotHeight)*(y))
   mon.write("/")
end 

function Inven:draw(mon, ox, oy)
   local ox, oy = ox or 0, oy or 0
   for i = 1, self.height do 
      for j = 1, self.width do 
         mon.setCursorPos((j+ox) + (self.buffer+self.slotWidth)*(j-1)+1, (i+oy) + (self.buffer+self.slotHeight)*(i-1)+1)
         if self.hash[i][j].id then 
            mon.write(items.equip.list[self.hash[i][j].id].name)
         end             
      end 
   end 
   self:highlightSlot(mon, selectX, selectY, ox, oy)
   local id = self.hash[selectY][selectX].id
   local level = self.hash[selectY][selectX].level
   mon.setCursorPos(1, 1)
   mon.write(selectX..' '..selectY..' '..tostring(selectedSlot))

   if id then
      mon.setCursorPos(40, 1)
      mon.write(items.equip.list[id].name)
      mon.setCursorPos(40, 2)
      mon.write(items.equip.list[id].desc)
      mon.setCursorPos(40, 4)
      mon.write("ATK: "..items.equip[level][id].atk)
      mon.setCursorPos(40, 5)
      mon.write("BLK: "..items.equip[level][id].blk)
   end 
end 
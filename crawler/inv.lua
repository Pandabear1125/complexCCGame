local selectX, selectY = 1, 1
local selectedInv = nil
local selectedSlot = nil
local primary = {}
local secondary = {}

Inven = {
   x = 0, 
   y = 0, 
   width = 1,
   height = 1, 
   buffer = -1,
   slotWidth = 4, 
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

local function getFreeSpace(inv)
   local free = false
   for i = 1, inv.height do 
      for j = 1, inv.width do 
         if inv.hash[i][j].id then 
            return j, i
         end 
      end 
   end 
   return false, false 
end 

function Inven:quickLoot()
   pickUpSlot()
   local toInv = nil
   if primary == self then 
      toInv = secondary 
   else 
      toInv = primary
   end 
   local toX, toY = getFreeSpace(toInv)
   if toX and toY then 
      toInv.hash[toY][toX] = selectedSlot
      selectedSlot = nil 
   else 
      pickUpSlot()
   end 
end 

local function moveSelectSlot(dx, dy)
   selectX = selectX + dx
   selectY = selectY + dy
   if selectX < 1 then 
      selectX = 1
      if selectedInv == primary then 
         selectedInv = secondary
         selectX = selectedInv.width
      else 
         selectedInv = primary
         selectX = selectedInv.width
      end 
   elseif selectX > selectedInv.width then 
      selectX = selectedInv.width 
      if selectedInv == primary then 
         selectedInv = secondary
         selectX = 1
      else 
         selectedInv = primary
         selectX = 1
      end 
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
   elseif key == 28 then 
      selectedInv:quickLoot()
   end 
end 

function Inven:clearSlot(x, y)
   self.hash[y][x] = {}
end 

function Inven:select()
   selectedInv = self 
end 

function Inven:setPrimary()
   primary = self 
end 

function Inven:setSecondary()
   secondary = self 
end 

function Inven:setItem(x, y, itemTable)
   self.hash[y][x] = itemTable
end 

local function highlightSlot(mon, ox, oy)
   mon.setCursorPos((selectX+ox) + (selectedInv.buffer*(selectX-1)) + (selectedInv.slotWidth)*(selectX-1)+selectedInv.x, (selectY+oy) + (selectedInv.buffer*(selectY-1)) + (selectedInv.slotHeight)*(selectY-1)+selectedInv.y)
   mon.write("/")
   mon.setCursorPos((selectX+ox) + (selectedInv.buffer*(selectX-1)) + (selectedInv.slotWidth)*(selectX)+selectedInv.x, (selectY+oy) + (selectedInv.buffer*(selectY-1)) + (selectedInv.slotHeight)*(selectY-1)+selectedInv.y)
   mon.write("\\")
   mon.setCursorPos((selectX+ox) + (selectedInv.buffer*(selectX-1)) + (selectedInv.slotWidth)*(selectX-1)+selectedInv.x, (selectY+oy) + (selectedInv.buffer*(selectY-1)) + (selectedInv.slotHeight)*(selectY)+selectedInv.y)
   mon.write("\\")
   mon.setCursorPos((selectX+ox) + (selectedInv.buffer*(selectX-1)) + (selectedInv.slotWidth)*(selectX)+selectedInv.x, (selectY+oy) + (selectedInv.buffer*(selectY-1)) + (selectedInv.slotHeight)*(selectY)+selectedInv.y)
   mon.write("/")
end 

function Inven:draw(mon, ox, oy)
   local ox, oy = ox or 0, oy or 0
   for i = 1, self.height do 
      for j = 1, self.width do 
         mon.setCursorPos((j+ox) + (self.buffer+self.slotWidth)*(j-1)+1+self.x, (i+oy) + (self.buffer+self.slotHeight)*(i-1)+1+self.y)
         if self.hash[i][j].id then 
            mon.write(items.equip.list[self.hash[i][j].id].name)
         end    
         mon.setCursorPos((j+ox) + (self.buffer*(j-1)) + (self.slotWidth)*(j-1)+self.x, (i+oy) + (self.buffer*(i-1)) + (self.slotHeight)*(i-1)+self.y)
         mon.write('+')
         mon.setCursorPos((j+ox) + (self.buffer*(j-1)) + (self.slotWidth)*(j)+self.x, (i+oy) + (self.buffer*(i-1)) + (self.slotHeight)*(i-1)+self.y)
         mon.write('+')
         mon.setCursorPos((j+ox) + (self.buffer*(j-1)) + (self.slotWidth)*(j-1)+self.x, (i+oy) + (self.buffer*(i-1)) + (self.slotHeight)*(i)+self.y)
         mon.write('+')
         mon.setCursorPos((j+ox) + (self.buffer*(j-1)) + (self.slotWidth)*(j)+self.x, (i+oy) + (self.buffer*(i-1)) + (self.slotHeight)*(i)+self.y)
         mon.write('+')      
      end 
   end 
   highlightSlot(mon, ox, oy)
   local id = selectedInv.hash[selectY][selectX].id
   local level = selectedInv.hash[selectY][selectX].level
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
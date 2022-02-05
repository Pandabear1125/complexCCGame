local selectX, selectY = 1, 1

function getInput()
   local event, key = os.pullEvent('key')
   if key == 208 then -- down arrow
      selectY = selectY + 1
   elseif key == 200 then -- up arrow 
      selectY = selectY - 1
   elseif key == 203 then -- left arrow 
      selectX = selectX - 1
   elseif key == 205 then -- right arrow
      selectX = selectX + 1
   end 
end 

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
            value = ''
         }
      end 
   end 

   return t 
end 

function Inven:setItem(x, y, itemTable)
   self.hash[x][y] = itemTable
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
         mon.setCursorPos((i+ox) + (self.buffer+self.slotWidth)*(i-1), (j+oy) + (self.buffer+self.slotHeight)*(j-1))
         mon.write(self.hash[i][j].value)
      end 
   end 
   self:highlightSlot(mon, selectX, selectY, ox, oy)
end 
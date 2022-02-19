local Box = {
   x = 0,
   y = 0, 
   rarity = 0
}

boxes = {}

function populateLoot(list) -- from map data
   for k, v in ipairs(list) do 
      local box = Box:new{
         x = v.x,
         y = v.y, 
         rarity = v.rarity
      }
      

      for i = 1, math.random(5) do 
         local item = {}
         item.id = math.random(1, 4) -- num of items in item.lua
         item.level = math.random(3)
         table.insert(box.items, item)
      end 
      -- error(#box.items)
      table.insert(boxes, box)
   end 
end 

function loadLootBox(x, y)
   secondaryLootBox = inv.Inven:new{
      x = 25, 
      y = 0, 
      width = 2, 
      height = 5
   }
   secondaryLootBox:setSecondary()
   secondaryLootBox:select()

   local activeBox;
   for k, v in ipairs(boxes) do 
      if v.x == x and v.y == y then 
         activeBox = v
      end 
   end 
   for k, v in ipairs(activeBox.items) do 
      local toX, toY = inv.getFreeSpace(secondaryLootBox)
      if toX and toY then 
         secondaryLootBox:setItem(toX, toY, v)
      end 
   end 
end

function unloadLootBox(x, y)
   local activeBox;
   for k, v in ipairs(boxes) do 
      if v.x == x and v.y == y then 
         activeBox = v
      end 
   end

   activeBox.items = {}
   for j = 1, secondaryLootBox.height do
      for i = 1, secondaryLootBox.width do 
         if secondaryLootBox.hash[j][i].id then 
            table.insert(activeBox.items, secondaryLootBox.hash[j][i])
            secondaryLootBox:clearSlot(i, j)
         end 
      end 
   end 

   secondaryLootBox:setSecondary()
   inv.selectPrimary()
   secondaryLootBox = nil
end 

function Box:new(t)
   local t = t or {}
   setmetatable(t, self)
   self.__index = self 

   t.items = {}

   return t
end
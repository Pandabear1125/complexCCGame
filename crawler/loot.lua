local Box = {
   x = 0,
   y = 0, 
   rarity = 0
}

secondaryLootBox = inv.Inven:new{
   x = 25, 
   y = 0, 
   width = 2, 
   height = 5
}
secondaryLootBox:setSecondary()

boxes = {}

function populateLoot(list) -- from map data
   for k, v in ipairs(list) do 
      local box = Box:new{
         x = v.x,
         y = v.y, 
         rarity = v.rarity
      }
      

      for i = 1, math.random(1, 3) do 
         local item = {}
         item.id = math.random(1, 4) -- num of items in item.lua
         local rarity = math.random(1, 100)
         if rarity > 0 and rarity <= 10 then 
            item.level = 3
         elseif rarity > 10 and rarity <= 30 then 
            item.level = 2
         else 
            item.level = 1
         end 
         table.insert(box.items, item)
      end 
      -- error(#box.items)
      table.insert(boxes, box)
   end 
end 

function populateLootBox(x, y)
   local activeBox;
   for k, v in ipairs(boxes) do 
      if v.x == x and v.y == y then 
         activeBox = v
      end 
   end 
   local count = 0
   for k, v in ipairs(activeBox.items) do 
      local toX, toY = inv.getFreeSpace(secondaryLootBox)
      secondaryLootBox:setItem(toX, toY, v)
      count = k
   end 
   error(count)
end

function Box:new(t)
   local t = t or {}
   setmetatable(t, self)
   self.__index = self 

   t.items = {}

   return t
end
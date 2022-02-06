local Box = {
   x = 0,
   y = 0, 
   items = {},
   rarity = 0
}

boxes = {}

function populateLoot(list) -- from map data
   for k, v in ipairs(list) do 
      Box:new{
         x = v.x,
         y = v.y, 
         rarity = v.rarity
      }

      for i = 1, math.random(1, 3) do 
         local item = {}
         item.id = math.random(1, 8) -- num of items in item.lua
         local rarity = math.random(1, 100)
         if rarity > 0 and rarity <= 10 then 
            item.rarity = 3
         elseif rarity > 10 and rarity <= 30 then 
            item.rarity = 2
         else 
            item.rarity = 1
         end 
         table.insert(boxes[k].items, item)
      end 
   end 
end 

function Box:new(t)
   local t = t or {}
   setmetatable(t, self)
   self.__index = self 

   table.insert(boxes, t)
end
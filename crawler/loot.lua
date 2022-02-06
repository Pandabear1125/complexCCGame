Box = {
   x = 0,
   y = 0, 
   items = {},
   rarity = 0
}

function Box:new(t)
   local t = t or {}
   setmetatable(t, self)
   self.__index = self 

   return t
end
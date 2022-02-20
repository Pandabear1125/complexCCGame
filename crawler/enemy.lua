local Enemy = {
   x = 0, 
   y = 0,
   health = 100, 
   loot = {}
}

local monW, monH = term.getSize()
local mapW, mapH;
local widthRadius = math.ceil(monW/2)
local heightRadius = math.ceil(monH/2)

enemies = {}

function initialize(Map)
   mapW, mapH = Map.data.width, Map.data.height
end 

function Enemy:new(t)
   local t = t or {}
   setmetatable(self, t)
   self.__index = self 

   t.loot = {}
   for i = 1, math.random(5) do 
      local item = {}
      item.id = math.random(1, 4) -- num of items in item.lua
      item.level = math.random(3)
      table.insert(t.loot, item)
   end 

   table.insert(enemies, t)
end 

function Enemy:move(dx, dy) 
   self.x = self.x + dx
   self.y = self.y + dy
end 

function draw(mon)

end 
-- craftOS test file
os.loadAPI("crawler/inv.lua")
os.loadAPI("crawler/items.lua")

t1 = inv.Inven:new{
   width = 4, 
   height = 5, 
}
t1:setPrimary()
t2 = inv.Inven:new{
   x = 25,
   y = 0,
   width = 3,
   height = 5,
}
t2:setSecondary()

t1:setItem(2, 3, {id = 1, level = 1})
t1:setItem(1, 2, {id = 4, level = 1})
t1:select()

t2:setItem(1, 2, {id = 2, level = 1})

while true do 
   term.clear()
   t1:draw(term)
   t2:draw(term)
   inv.getInput()
end 

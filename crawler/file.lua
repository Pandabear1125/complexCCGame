local directory = '' 

function setDirectory(dirPath) 
   directory = dirPath 
end 

function create(simplePath) 
   local h = fs.open(directory..simplePath, 'w') 
   h.close() 
   return simplePath 
end 

function read(simplePath) 
   assert(fs.exists(directory..simplePath), "file at \""..directory..simplePath.."\" does not exist")
   local h = fs.open(directory..simplePath, 'r') 
   local contents = h.readAll()
   h.close() 
   return textutils.unserialize(contents)
end 

function write(simplePath, text) 
   assert(fs.exists(directory..simplePath), "file at \""..directory..simplePath.."\" does not exist")
   local h = fs.open(directory..simplePath, 'w') 
   if type(text) == 'string' then 
      h.write(text) 
   elseif type(text) == 'number' then 
      h.write(tostring(text)) 
   elseif type(text) == 'table' then 
      local serText = textutils.serialize(text) 
      h.write(serText) 
   else 
      error("text of type \'"..type(text).."\' is not supported") 
   end 
   h.close() 
end
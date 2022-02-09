local directory = '' 

function setDirectory(dirPath) 
   directory = dirPath 
end 

function create(simplePath) 
   local h = fs.open(directory..simplePath, 'w') 
   h.close() 
   return simplePath 
end 

function read(simplePath, line) 
   assert(fs.exists(directory..simplePath), "file at \""..directory..simplePath.."\" does not exist")
   local h = fs.open(directory..simplePath, 'r') 
   local contents = nil
   if line then 
      for i = 1, line do 
         contents = h.readLine()
      end 
   else 
      contents = h.readAll()
   end 
   h.close() 
   return textutils.unserialize(contents)
end 

function write(simplePath, text, isMultiLine) -- text can be a table, with each index a line
   assert(fs.exists(directory..simplePath), "file at \""..directory..simplePath.."\" does not exist")
   local h = fs.open(directory..simplePath, 'w')
   
   if type(text) == "string" or type(text) == "number" then 
      h.writeLine(text) 
   elseif type(text) == "table" then 
      if isMultiLine then 
         for i = 1, #text do 
            if type(text[i]) == 'string' then 
               h.writeLine(text[i]) 
            elseif type(text[i]) == 'number' then 
               h.writeLine(tostring(text[i])) 
            elseif type(text[i]) == 'table' then 
               local serText = textutils.serialize(text[i], {compact = true}) 
               h.writeLine(serText) 
            else 
               error("text of type \'"..type(text[i]).."\' is not supported") 
            end 
         end 
      else 
         local serText = textutils.serialize(text, {compact = true}) 
         h.writeLine(serText) 
      end 
   else 
      error("text of type \'"..type(text).."\' is not supported") 
   end 
   h.close() 
end
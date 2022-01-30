function handle() 
   local event, arg1, arg2 = os.pullEvent() 
   if event == 'key' then
      editor.handleInput(arg1)
   end
end 
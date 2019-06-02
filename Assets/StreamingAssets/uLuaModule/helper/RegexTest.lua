local m = {}


-- local pair = "name = anna"
-- function  m:test1()
-- 	print("lzh *********************")
-- 	key, value = string.match(pair, "(%a+)%s*=%s*(%a+)")
-- 	print(key)  --> name anna
-- 	print(value .. key)  
-- 	print("lzh *********************")
-- end

-- local pair2 = "eafdfaf<type = blink, col=ff0088, col2=aa7700>dfafadf"
-- local pair3 = "eafdfaf<blink>dfafadf"
-- function  m:test()
-- 	print("lzh *********************")
-- 	key1 = string.match(pair2, "(<.+>)")
-- 	print(key1) 
-- 	key, value = string.match(key1, "(%a+)%s*=%s*(%a+)")
-- 	print(key .. "  " .. value)  
-- 	print("lzh *********************")
-- end

-- local pair = "hello world world"
-- function m:test()
-- 	print("lzh *********************")
-- 	local str = string.gsub(pair, "world", "tqm")
-- 	print(str)
-- 	print("lzh *********************")
-- end

-- local pair2 = "eafdfaf<type = blink, col=ff0088, col2=aa7700>dfafadf</blink>"
-- local pair3 = "eafdfaf<blink>dfafadf"
-- function  m:test()
-- 	print("lzh *********************")
-- 	--key1 = string.match(pair2, "(<.+>)")
-- 	--print(key1) 

-- 	for w in string.gmatch(pair2,  "(<.+>)") do
-- 	 	print(w)
-- 	end

-- 	print("lzh *********************")
-- end

-- local pair = "from=world, to=Lua"
-- local t = {}
-- function m:test()
-- 	print("lzh *********************")
-- 	for k,v in string.gmatch(pair, "(%w+)=(%w+)") do
-- 		t[k] = v
-- 	end
-- 	for k, v in pairs(t) do
-- 		print(k .. "  " .. v)
-- 	end
-- 	print("lzh *********************")
-- end

-- local pair = "from=world, to=Lua"
-- local t = {}
-- function m:test()
-- 	print("lzh *********************")
-- 	local i = 0
-- 	for k in string.gmatch(pair, "(%w+)") do
-- 		i = i+1
-- 		t[i] = k
-- 		--print(k)
-- 	end
-- 	for k,v in pairs(t) do
-- 		print(v)
-- 	end
-- 	print("lzh *********************")
-- end

-- local pair = "from=world, to=Lua"
-- local t = {}
-- function m:test()
-- 	print("lzh *********************")
-- 	local index = 1
-- 	local i = 1
-- 	local str_len = string.len(pair)
-- 	while index<str_len do
-- 		s,e = string.find(pair, "%w+", index)
-- 		t[i] = string.sub(pair, s,e)
-- 		i = i+1
-- 		index = e+1
-- 		print(s .. "  " .. e .. "  " .. index)
-- 	end

-- 	for k,v in pairs(t) do
-- 		print(v)
-- 	end
-- 	print("lzh *********************")
-- end

-- local pair = "from=world, to=Lua"
-- local t = {}
-- function m:test()
-- 	print("lzh *********************")
-- 	local index = 1
-- 	local i = 1
-- 	local str_len = string.len(pair)
-- 	while index<str_len do
-- 		s,e = string.find(pair, "%w+", index)
-- 		--t[i] = string.sub(pair, s,e)
-- 		--i = i+1
-- 		table.insert(t,string.sub(pair, s,e))
-- 		index = e+1
-- 		print(s .. "  " .. e .. "  " .. index)
-- 	end

-- 	for k,v in pairs(t) do
-- 		print(k .. " : " .. v)
-- 	end

-- 	table.remove(t, 3)

-- 	for k,v in pairs(t) do
-- 		print(k .. " : " .. v)
-- 	end
-- 	print("lzh *********************")
-- end

-- local pair = "1234<type = blink, col=ff0088>5678</blink>abcd<html>efgh</html>"
-- local t = {}
-- function m:test()
-- 	print("lzh *********************")
-- 	local index = 1
-- 	local i = 1
-- 	local str_len = string.len(pair)
-- 	while index<str_len do
-- 		s,e = string.find(pair, "<[^<>]+>", index)
-- 		if s~=nil and e~=nil then
-- 			t[i] = string.sub(pair, s,e)
-- 			i = i+1
-- 			index = e+1
-- 			print(s .. "  " .. e .. "  " .. index)
-- 		else
-- 			break
-- 		end
-- 	end

-- 	for k,v in pairs(t) do
-- 		print(v)
-- 	end
-- 	print("lzh *********************")
-- end

-- local pair = "1234<type = blink, col=ff0088>5678</blink>abcd<html>efgh</html>"
-- function  m:test()
-- 	print("lzh *********************")
-- 	--key1 = string.match(pair, "(<.+>)")
-- 	--print(key1) 

-- 	for w in string.gmatch(pair,  "<[^<>]+>") do
-- 	 	print(w)
-- 	end

-- 	print("lzh *********************")
-- end

-- local pair = "1234<blink col=ff0088>5678</blink>abcd<html>efgh</html>"
-- function  m:test()
-- 	print("lzh *********************")
-- 	--key1 = string.match(pair, "(<.+>)")
-- 	--print(key1) 

-- 	for w in string.gmatch(pair,  "<%s*/*%s*(%w+)%s*") do
-- 	 	print(w)
-- 	end

-- 	print("lzh *********************")
-- end

-- local pair = "from=world, to=Lua"
-- local t = {}
-- function m:test()
-- 	print("lzh *********************")
-- 	local index = 1
-- 	local i = 1
-- 	local str_len = string.len(pair)
-- 	while index<str_len do
-- 		s,e = string.find(pair, "%w+", index)
-- 		--t[i] = string.sub(pair, s,e)
-- 		--i = i+1
-- 		table.insert(t,string.sub(pair, s,e))
-- 		index = e+1
-- 		print(s .. "  " .. e .. "  " .. index)
-- 	end

-- 	for k,v in pairs(t) do
-- 		print(k .. " : " .. v)
-- 	end
-- 	-- print("lzh ---------------------------------------")

-- 	-- for k,v in pairs(t) do		
-- 	-- 	if k==2 then
-- 	-- 		table.remove(t,k)
-- 	-- 		print("lzh xxxxxxxxxxxxxxxxxxxxxxxx")
-- 	-- 	else
-- 	-- 		print(k .. " : " .. v)
-- 	-- 	end
-- 	-- end
-- 	print("lzh *********************")

-- 	while #t >0 do
-- 		table.remove(t,1)
-- 	 	print("lzh xxxxxxxxxxxxxxxxxxxxxxxx")
-- 	end
-- end

local pair = "1234<blink col=ff0088>5678</blink>abcd<html>efgh</html>"
function m:test()
    print("lzh *********************")
    --key1 = string.match(pair, "(<.+>)")
    --print(key1)

    for w in string.gmatch(pair, "<%s*/*%s*(%w+)%s*[>]*") do
        print(w)
    end

    print("lzh *********************")
end

return m

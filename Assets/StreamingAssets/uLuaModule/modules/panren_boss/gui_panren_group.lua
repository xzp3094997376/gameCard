local m = {}

function m:Start()
     for i = 1, 3 do 
		self["item"..i]:CallUpdateWithArgs({id = i})
   end  
end

function m:onClick(go, name)
    if name == "btnClose" then 
		UIMrg:popWindow()
    elseif name == "btn_shop" then
        LuaMain:showShop(15)
    elseif name == "Btn_buzhen" then
        LuaMain:showFormation(0)
    end
end


return m
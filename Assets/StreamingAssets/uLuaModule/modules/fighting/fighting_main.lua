local m = {}

function m:Start()
    LuaMain:ShowTopMenu()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_346"))
    Events.AddListener("ToRoot", funcs.handler(self, self.setToRoot))
	m:onUpdate()
end

function m:onUpdate()
	--if Player.TaoRenBoss.open == true then 
	--	self.btn_boss.gameObject:SetActive(true)
	--else 
	--	self.btn_boss.gameObject:SetActive(false)
	--end 
    local list = {}
    TableReader:ForEachLuaTable("zhengzhanConfig", function(index, item)
        table.insert(list, item)
        return false
    end)
    table.sort(list, function(a, b)
        return a.show_sequence < b.show_sequence
    end)
    self.scrollView:refresh(list, self, false, -1)
end 

function m:setToRoot()
    UIMrg:popToRoot()
end

function m:OnDestroy()
    Events.RemoveListener("ToRoot")
end

function m:onEnter()
	m:onUpdate()
    LuaMain:ShowTopMenu()
end 

function m:onClick(go, name)
	if name == "btnBack" then 
		UIMrg:pop()
	--elseif name == "btn_boss" then 
	--	uSuperLink.openModule(67)
	end 
end

return m
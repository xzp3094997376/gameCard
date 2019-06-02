local m = {}

function m:Start()
    LuaMain:ShowTopMenu()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_159"))
    local list = {}
    TableReader:ForEachLuaTable("jingjiConfig", function(index, item)
        table.insert(list, item)
        return false
    end)
    table.sort(list, function(a, b)
        return tonumber(a.show_sequence) < tonumber(b.show_sequence)
    end)
    self.scrollView:refresh(list, self, true, 0)
    self.binding:CallManyFrame(function()
        self.scrollView:ResetPosition()
    end)
end

return m
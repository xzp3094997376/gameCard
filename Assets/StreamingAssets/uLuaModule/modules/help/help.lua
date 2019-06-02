local helpList = {}
local hepData = {}

function helpList:create(binding)
    self.binding = binding
    return self
end

function helpList:Start()
    self.topMenu = LuaMain:ShowTopMenu()
    TableReader:ForEachLuaTable("girlHelp",
        function(index, item)
            table.insert(hepData, item)
            return false
        end)
    self.scrollView:refresh(hepData, self, false) --刷到上一次到的地方
end

return helpList
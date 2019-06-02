local m = {}

function m:Start(...)
end

--function m:update(curIconId, onSelectCallback)	
function m:update(args)
    self.onSelectCallback = args.onSelectCallback
    if self.curIconId ~= args.curIconId then
        self.curIconId = args.curIconId
        self.datas = {}
        for i = 1, tonumber(self._keyMap.maxIconId) do
            local t = {}
            t.iconId = i
            t.isSelect = false
            if i == self.curIconId then t.isSelect = true end
            table.insert(self.datas, t)
        end
        self.Table_Icon:refresh("Prefabs/moduleFabs/leagueModule/league_iconItem", self.datas, self)

        self.linesData = {}
        print("lzh print: columns = " .. self.Table_Icon.columns)
        local lineNum = math.ceil(self._keyMap.maxIconId / self.Table_Icon.columns)
        --for i=1, self.Table_Icon.columns do
        for i = 1, lineNum do
            local t = {}
            t.col = i
            table.insert(self.linesData, t)
        end
        self.Grid_Line:refresh("Prefabs/moduleFabs/leagueModule/league_iconLineItem", self.linesData)
    end
end


function m:onClick(go, btnName)
    if btnName == "btn_close" then
        self.gameObject:SetActive(false)
    end
end


return m
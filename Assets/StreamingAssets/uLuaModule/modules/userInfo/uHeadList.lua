local headList = {}


function headList:create(binding)
    self.binding = binding
    return self
end

function headList:onDestory()
    UIMrg:popWindow()
    -- SendBatching.DestroyGameOject(self.binding.gameObject)
end

function headList:onClick(go, name)
    if name == "btClose" then
        self:onDestory()
    end
end

function headList:update(delegate)
    self._headList = {}
    self._vipHeadList = {}
    --获取普通头像列表
    TableReader:ForEachLuaTable("headList",
        function(index, item)
            --	print(item.img_id)
            local info = {}
            if item.islock == 0 then --普通头像
            info.id = item.id
            info.img_id = item.img_id
            self._headList[index] = info
            info = nil
            end
            return false
        end)

    --获取进阶到紫色的头像
    local chars = Player.Chars:getLuaTable()

    for k, v in pairs(chars) do
        local char = Char:new(k)

        local row = TableReader:TableRowByID("headList", k)

        if row ~= nil then
            if char.stage >= row.islock and row.islock ~= 0 then
                local info = {}
                info.id = k
                info.img_id = row.img_id
                table.insert(self._vipHeadList, info)
                info = nil
            end
        end
    end
    self._basicInfo = {}
    self._vipInfo = {}
    self._basicInfo.delegate = delegate
    self._basicInfo.type = "basic"
    self._basicInfo.s = self
    self._vipInfo.delegate = delegate
    self._vipInfo.type = "vip"
    self._vipInfo.s = self
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/userinfoModule/head", self.basicTable, self._headList, self._basicInfo)
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/userinfoModule/head", self.VipTable, self._vipHeadList, self._vipInfo)
end

function headList:Start()
    -- ClientTool.AddClick(self.bg, function()
    --     UIMrg:popWindow()
    -- end)
end

return headList
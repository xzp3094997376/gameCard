local rankITem = {}

function rankITem:update(tableData)
    self.data = tableData
    self.arena_hangCell.name = tableData.rank
    self.rank = tableData.rank
    self.txt_lvl.text = tableData.level
    self.txt_hang.gameObject:SetActive(false)
    self.txt_hang_suffix.gameObject:SetActive(false)
    local vip = tableData.vip
    self.vipshow:SetActive(false)
    self.txt_name.gameObject:SetActive(false)
    if vip > 0 then
        self.vipshow:SetActive(true)
        self.vipLv.text = vip
        self.vipName.text = tableData.name
    else
        self.txt_name.gameObject:SetActive(true)
        self.txt_name.text = tableData.name
    end
    if tonumber(tableData.rank) < 4 and tonumber(tableData.rank) > 0 then
        self.txt_hang_suffix.gameObject:SetActive(true)
        self.txt_hang_suffix.spriteName = "paihang_" .. tableData.rank
    else
        self.txt_hang.gameObject:SetActive(true)
        self.txt_hang.text = tableData.rank
    end
    local headimg = "default"
    if tableData.head ~= nil then
        headimg = tableData.head
    end
    self.simpleImage:setImage(headimg, "headImage")
    self._type = tableData.type
    self.lingyaTXT.text = tableData.powerTxt
    self.lingya.text = tableData.power
end

function rankITem:onClick(go, name)
	Events.Brocast('selectRankItem', self.rank)
    if name == "arenaBtn" then
        if self._type == "arena" then
            Api:showDetailInfo(self.data.id,self.sid,self.rank,
                function(result)
                    local temp = {}
                    temp.type = self._type
                    temp.data = result.showRet[0]
                    temp.rank = self.rank
                    temp.pid = self.data.id
                    UIMrg:pushWindow("Prefabs/moduleFabs/ranksModule/arena_cell_info", temp)
                    temp = nil
                    result = nil
                end)
        elseif self._type == "peak" then
            Api:getPeakRankTeam(self.data.rank,
                function(result)
                    local temp = {}
                    temp.type = self._type
                    temp.data = self.data
                    temp.rank = self.rank
                    temp.pid = self.data.id
                    temp.defenceTeam = result.team
                    UIMrg:pushWindow("Prefabs/moduleFabs/ranksModule/arena_cell_info", temp)
                    temp = nil
                    result = nil
                end)
        end
    end
end


--初始化
function rankITem:create(binding)
    self.binding = binding
    return self
end

return rankITem
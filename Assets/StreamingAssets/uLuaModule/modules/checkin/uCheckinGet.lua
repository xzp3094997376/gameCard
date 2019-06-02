local m = {}

function m:update(data)
    local list = RewardMrg.getList(data.obj)
    local count = table.getn(list)
    local msg = string.gsub(TextMap.GetValue("LocalKey_698"),"{0}",data.vip)
    self.desVip.text =string.gsub(msg,"{1}",data.mul)
    if data.vip == -1 then
        self.desVip.text = " "
        self.desVip.gameObject:SetActive(false)
    end
    table.foreach(list, function(i, v)
        local tempObj = {}
        tempObj.isVipGift = false
        tempObj.vipLvel = data.vip
        tempObj.v = v
        if count == 1 and data.special == true then
            tempObj.isVipGift = true
            local msg = string.gsub(TextMap.GetValue("LocalKey_699"),"{0}",data.vip)
            self.desVip.text =string.gsub(msg,"{1}",data.mul)
        end
        if i > 1 then
            tempObj.isVipGift = true
            local msg = string.gsub(TextMap.GetValue("LocalKey_699"),"{0}",data.vip)
            self.desVip.text =string.gsub(msg,"{1}",data.mul)
        end
        local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/signModule/checkinDropitem", self.grid.gameObject)
        binding:CallUpdate(tempObj)
        binding = nil
        self.grid.repositionNow = true
    end)
    list = nil
end

function m:onClick(go, name)
    if name == "btn_queren" then
        UIMrg:popWindow()
    else
        DialogMrg.chognzhi()
        UIMrg:popWindow()
    end
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

return m
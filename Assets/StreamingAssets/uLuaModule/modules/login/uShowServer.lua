local showServer = {}
-- function showServer:create(binding)
--     self.binding = binding;
--     return self
-- end

function showServer:update(data, index)
    self.index = index
    self.data = data
    self.delegate = data.delegate
    self.servers = data.servers

    if self.servers == nil then --选中推荐服选项(首项为推荐服)
    self.entxt.text = TextMap.GetValue("Text1319")
    self.nortxt.text = TextMap.GetValue("Text1319")
    else --选中某个区
    self.entxt.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",((data.index - 1) * 20 + 1) .. " - " .. 20 * data.index)
    self.nortxt.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",((data.index - 1) * 20 + 1) .. " - " .. 20 * data.index)
    end
    showServer:isSelect(self.delegate.selectIndex == index)
end

function showServer:isSelect(ret)
    self.en.gameObject:SetActive(ret)
end

function showServer:onClick(go, btName)
    if btName == "btChoose" then
        local txt =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",(self.index * 10 + 1) .. " - " .. (self.index * 10 + 10))
        -- self.entxt.text = txt
        -- self.nortxt.text = txt
        Events.Brocast('select_qu')
        self.delegate.selectIndex = self.index
        showServer:isSelect(true)
        self.delegate:showServerList(self.servers, txt)
    end
end

function showServer:OnDestroy()
    Events.RemoveListener('select_qu')
end

function showServer:Start()
    Events.AddListener("select_qu", function()
        showServer:isSelect(false)
    end)
    if self.gameObject:GetComponent(UIDragScrollView) == nil then
        self.gameObject:AddComponent(UIDragScrollView)
    end
end

return showServer
local checkinDropItem = {}

function checkinDropItem:update(obj)
    self.img_vip:SetActive(false)
    self.img_kuangzi.gameObject:SetActive(false)
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackDropitem)
    binding:CallUpdate({ "char", obj.v, self.img_kuangzi.width, self.img_kuangzi.height })
    self.Label.text = obj.v:getDisplayName()
    if obj.isVipGift then
        self.img_vip:SetActive(true)
        self.txt_viplv.text = "V" .. obj.vipLvel .. TextMap.GetValue("Text576")
    end
end

--初始化
function checkinDropItem:create(binding)
    self.binding = binding
    return self
end

return checkinDropItem
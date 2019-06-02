local selfRank = {}

function selfRank:create(...)
    return self
end

function selfRank:update(tableData)
    self.lingya.gameObject:SetActive(false)
    self.txt_hang_suffix.gameObject:SetActive(false)
    self.txt_hang.gameObject:SetActive(false)
    local rank = tableData.rank
    local vip = Player.Info.vip
    self.vipshow:SetActive(false)
    self.txt_name.gameObject:SetActive(false)
    if vip > 0 then
        self.vipshow:SetActive(true)
        self.vipLv.text = vip
        self.vipName.text = Player.Info.nickname
    else
        self.txt_name.gameObject:SetActive(true)
        self.txt_name.text = Player.Info.nickname
    end
    if rank == nil then
        self.txt_hang.gameObject:SetActive(true)
        self.txt_hang.text = "9999"
    else
        self.lingya.gameObject:SetActive(true)
        self.txt_lvl.text = Player.Info.level
        --       self.txt_hang.text =
        if tonumber(rank) < 4 and tonumber(rank) > 0 then
            self.txt_hang_suffix.gameObject:SetActive(true)
            self.txt_hang_suffix.spriteName = "paihang_" .. rank
        elseif tonumber(rank) == 0 then
            self.txt_hang.gameObject:SetActive(true)
            self.txt_hang.text = "9999"
        else
            self.txt_hang.gameObject:SetActive(true)
            self.txt_hang.text = rank
        end

        local headimg = "default"
        if Player.Info.head ~= nil then
            headimg = Player.Info.head
        end
        self.simpleImage:setImage(headimg, "headImage")
        --self.simpleImage.Url = UrlManager.GetImagesPath("headImage/" .. headimg .. ".png")
        self.lingyaDes.text = tableData.powerTxt
        if tableData.power == nil or tableData.power.."" == "0"  then
            self.lingya.text = TextMap.GetValue("Text1362")
        else
            self.lingya.text = tableData.power
        end
    end
end

return selfRank
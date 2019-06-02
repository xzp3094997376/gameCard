local req = {}
local pid = ""

function req:Start()
    self.requestItem:SetActive(false)
end

function req:onClick(go, name)
    if name == "bt_find" then
        self:findFD()
    elseif name == "btn_close" then
        self:onClose()
    elseif name == "btn_add" then
        self:addFD()
    end
end

function req:findFD()
    local name = self.img_txtdi.value
    self.requestItem:SetActive(false)
    self.btn_add.isEnabled = true

    if name == "" then
        MessageMrg.show(TextMap.GetValue("Text847"))
        return true
    end

    Api:queryPlayer(name, function(result)
        if result.infos.Count > 0 then
            self:showPlayer(result.infos[0])
            return true
        else
            --MessageMrg.show("该玩家不存在")
        end
    end, function()
    end)
end

function req:showPlayer(res)
    self.requestItem:SetActive(true)
    self.txt_lv.text = TextMap.GetValue("Text_1_165")..res.level
    print_t(res)
    self.txt_name.text = Char:getItemColorName(res.quality, res.name)
    self.txt_power.text = TextMap.GetValue("Text_1_347")..toolFun.moneyNumberShowOne(math.floor(tonumber(res.power)))
    self.vipLv.text = "VIP "..res.vip
    pid = res.pid

    local  char = Char:new(res.dictid)
    local ima = char:getHeadSpriteName()

    self.simpleImage:setImage(ima, packTool:getIconByName(char:getHeadSpriteName()))
    self.icon_frame.spriteName = Tool.getFrame(res.quality)--char:getFrame()
    self.simpleImagebg.spriteName = Tool.getBg(res.quality)--char:getFrameBG()

    if res.guild then
        self.txt_gh.text =  "[ffff96ff]"..TextMap.GetValue("Text831") .."[-]".. res.guild
    else
        self.txt_gh.text = ""
    end
end

function req:addFD()
    Api:requestFriend(pid, function(result)
        self.btn_add.isEnabled = false
        MessageMrg.show(TextMap.GetValue("Text570"))
    end, function(result)
    end)
end

function req:onClose()
    pid = nil
    UIMrg:popWindow()
end

return req 
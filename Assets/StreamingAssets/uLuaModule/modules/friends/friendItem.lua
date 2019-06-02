local m = {}
local pid = ""
local _type = ""

function m:Start(...)
    ClientTool.AddClick(self.iconbg, function()
        if _type ~= "black" then
            UIMrg:pushWindow("Prefabs/moduleFabs/friendModule/friend_info", { info = self.data, delegate = self.delegate })
        end
    end)
end

function m:setFalse()
    self.giveBp.gameObject:SetActive(false)
    self.agreen.gameObject:SetActive(false)
    self.refuse.gameObject:SetActive(false)
    self.remove.gameObject:SetActive(false)
    self.acceptBp.gameObject:SetActive(false)
    self.giveStatus:SetActive(false)
    self.btn_chat.gameObject:SetActive(false)
end

function m:update(data, index, delegate)
    self.data = data
    self.delegate = delegate
    _type = data.type
    pid = data.pid
    self:setFalse()

    if _type == "friendList" then
        if data.tData.sendBp == 1 then
            self.giveStatus:SetActive(true)
            self.giveBp.isEnabled = false
            BlackGo.setBlack(0.5, self.giveBp.transform)
        else
            self.giveBp.gameObject:SetActive(true)
            self.giveBp.isEnabled = true
            BlackGo.setBlack(1, self.giveBp.transform)
        end
        local limitLv = TableReader:TableRowByID("Chatsetting",2).arg2
        if Player.Info.level>= limitLv then
            self.btn_chat.gameObject:SetActive(true) 
        end 
    elseif _type == "getBp" then
        self.acceptBp.gameObject:SetActive(true)
    elseif _type == "requestFD" then
        self.agreen.gameObject:SetActive(true)
        self.refuse.gameObject:SetActive(true)
    elseif _type == "black" then
        self.remove.gameObject:SetActive(true)
    end
    --print_t(data)
    self.txt_lv.text = data.level
    self.txt_name.text = Char:getItemColorName(data.tData.quality, data.name)--data.name
    self.txt_power.text = toolFun.moneyNumberShowOne(math.floor(tonumber(data.power)))--data.power
    if data.sociatyName then
        self.sociatyName.text = "[ffff96ff]"..TextMap.GetValue("Text831") .. "[-]"..data.sociatyName
    else
        self.sociatyName.text = ""
    end

    local char = Char:new(data.dictid)
    local ima = char:getHeadSpriteName()
    
    self.simpleImage:setImage(ima, packTool:getIconByName(char:getHeadSpriteName()))
    self.iconbg.spriteName = Tool.getFrame(data.tData.quality)--char:getFrame()
    self.SpriteBG.spriteName = Tool.getBg(data.tData.quality)--char:getFrameBG()
    self.vipLv.text = data.vip
    --self.txt_name.text = char:getItemColorName(char.star, data.name)--data.name

    m:setOnlineStatus(data.online)
end

function m:setOnlineStatus(online)
    local desc = ""
    local col = "[ffffff]"
    if online == 0 then
        desc = TextMap.GetValue("Text1648")
        col = "[00ff00]"
    elseif online == -1 then
        desc = TextMap.GetValue("Text1649")
    elseif online > 0 then
        local time = online/1000
        if time < 60 then
            desc = TextMap.GetValue("Text1650")
        elseif time < 3600 then
            desc =string.gsub(TextMap.GetValue("LocalKey_769"),"{0}",math.floor(time/60))
        elseif time < 86400 then
            desc =string.gsub(TextMap.GetValue("LocalKey_770"),"{0}",math.floor(time/3600))
        else
            desc =string.gsub(TextMap.GetValue("LocalKey_771"),"{0}",math.floor(time/86400))
        end
    end
    desc = col..desc.."[-]"
    self.txt_time.text = desc
end

--同意好友申请
function m:onAgreen(...)
    local arr = {}
    arr[1] = pid

    Api:acceptRequest(arr, function(result)
        if result.ret == 0 then
            MessageMrg.show(TextMap.GetValue("Text834"))
            if result.retVal ~= nil and result.retVal[0] ~= nil then
                local row = TableReader:TableRowByID("errCode", result.retVal[0].ret)
                MessageMrg.show(row.desc)
            end
        -- else
        --     local row = TableReader:TableRowByID("errCode", 124)
        --     local desc = row.desc
        --     MessageMrg.show(desc)
        end
        self.delegate:refresh(_type)
    end, function(...)
        -- body
    end)
end

function m:onRefuse(...)
    local arr = {}
    arr[1] = pid

    Api:ignoreRequest(arr, function(...)
        self.delegate:refresh(_type)
        MessageMrg.show(TextMap.GetValue("Text835"))
    end, function(...)
        -- body
    end)
end

--移除好友
function m:onRemove(...)
    Api:removeBlack(pid, function(...)
        local desc = TextMap.GetValue("Text836")
        DialogMrg.ShowDialog(desc, function()
            MessageMrg.show(TextMap.GetValue("Text569"))
            self.delegate:refresh(_type)
        end)
    end, function(...)
        -- body
    end)
end

--赠送体力
function m:onGiveBp(...)
    Api:sendBp(pid, function(...)
        MessageMrg.show(TextMap.GetValue("Text837"))
        self.delegate:refresh(_type)
    end, function(...)
        -- body
    end)
end

--领取体力
function m:onAcceptBp(...)
    Api:acceptBp(pid, function(result)
        packTool:showMsg(result, nil, 0)
        self.delegate:refresh(_type)
    end, function(...)
        -- body
    end)
end

function m:onClick(go, name)
    if name == "agreen" then
        self:onAgreen()
    elseif name == "refuse" then
        self:onRefuse()
    elseif name == "remove" then
        self:onRemove()
    elseif name == "giveBp" then
        self:onGiveBp()
    elseif name == "acceptBp" then
        self:onAcceptBp()
    elseif name == "btnBack" then
        UIMrg:pop()
    elseif name == "btn_chat" then  
        UIMrg:pushWindow("Prefabs/moduleFabs/chat/chat_dialog",{3,self.data.name}) 
    end
end

return m
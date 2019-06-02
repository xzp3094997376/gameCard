local PlayerInfo = {}
local userInfo = nil
local isFriend = false

function PlayerInfo:update(info)
    userInfo = info.data

    self.txt_lv.text = userInfo.level
    self.txt_name.text = userInfo.nickname
    self.txt_power.text = userInfo.power
    self.txt_gh.text = userInfo.sociatyName
    self.roleImg:setImage(userInfo.head, packTool:getIconByName(userInfo.head))
    self.txt_vip.text = userInfo.vip

    isFriend = ChatUtil.CheckIsFriend(userInfo.gameUserId)
    if isFriend then
        self.btn_delete.gameObject:SetActive(true)
        self.btn_add.gameObject:SetActive(false)
    else
        self.btn_delete.gameObject:SetActive(false)
        self.btn_add.gameObject:SetActive(true)
    end

    --获取战队信息
    self:getDefendInfo()
end

--获取玩家队伍信息
function PlayerInfo:getDefendInfo()
    Api:getFriendTeam(userInfo.gameUserId, function(result)
        if result.ret == 0 then
            self:setDefendGuys(result.team)
        end
    end, function(error)
    end)
end

--显示玩家队伍信息
function PlayerInfo:setDefendGuys(arr) --这个地方要主要，for 0,0会造成闪退
for j = 1, 6 do
    local index = j
    if j <= 3 then index = j + 3
    else index = j - 3
    end

    local temp_char = {}
    if index <= arr.Count and arr[index - 1].id ~= nil then
        temp_char = Char:new(arr[index - 1].id)
        temp_char.isHaveData = true
        temp_char.lv = arr[index - 1].level
        temp_char.star_level = arr[index - 1].star
        temp_char.stage = arr[index - 1].stage
        temp_char.customNameIndex = index - 1
    else
        temp_char.isHaveData = false
    end

    local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/myPeople", self.img_roleKuang)
    binding:CallUpdate(temp_char)
end

self.img_roleKuangGrid.repositionNow = true
end


--点击事件
function PlayerInfo:onClick(go, name)
    if name == "btn_delete" then
        self:onDelete()
    elseif name == "btn_add" then
        self:onAdd()
    elseif name == "btn_black" then
        self:onBlack()
    elseif name == "btn_chat" then
        self:onChat()
    elseif name == "btn_fight" then
        self:onFight()
    elseif name == "close" then
        self:onClose()
    end
end

--私聊
function PlayerInfo:onChat()
    ChatController.OpenP2PUserChat(userInfo, PlayerInfo.onClose)
end

--关闭
function PlayerInfo:onClose()
    UIMrg:popWindow()
end

--删除好友
function PlayerInfo:onDelete()
    local desc = TextMap.GetValue("Text568") .. userInfo.nickname .. "?"
    DialogMrg.ShowDialog(desc, function()
        Api:removeFriend(userInfo.gameUserId, function()
            self:onClose()
            MessageMrg.show(TextMap.GetValue("Text569"))
            --重新获取好友列表
            ChatController.GetFriendList()
        end, function()
            --error
        end)
    end)
end

--添加好友
function PlayerInfo:onAdd()
    Api:requestFriend(userInfo.gameUserId, function()
        self:onClose()
        MessageMrg.show(TextMap.GetValue("Text570"))
        return true
    end, function()
        --error
    end)
end

--拉黑好友
function PlayerInfo:onBlack()
    local desc =string.gsub(TextMap.GetValue("LocalKey_689"),"{0}",userInfo.nickname)
    DialogMrg.ShowDialog(desc, function()
        Api:pullBlack(userInfo.gameUserId, function()
            self:onClose()
            MessageMrg.show(TextMap.GetValue("Text573"))
            --重新获取黑名单
            ChatController.GetBlackList()
        end, function()
            --error
        end)
    end)
end

--切磋
function PlayerInfo:onFight()
    Api:challenge(userInfo.gameUserId, function(result)
        self:onClose()

        local fightData = {}
        fightData["battle"] = result.battle
        if userInfo.mdouleName ~= nil then
            if userInfo.mdouleName == "leagueFriendFight" then
                LuaMain:destroyGongHuiBuildName()
            end
            print("mdouleName" .. userInfo.mdouleName)
            fightData["mdouleName"] = userInfo.mdouleName
        else
            fightData["mdouleName"] = "friendFight"
        end
        UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
    end, function()
        --error
    end)
end

return PlayerInfo
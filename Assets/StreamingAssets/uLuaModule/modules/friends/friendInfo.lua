local info = {}
local friend = "friendList"
local black = "black"
local tbData = nil

function info:update(tableData)
    local data = tableData.info
    self.peppleData = tableData.info
    --print_t(self.peppleData)
    tbData = data
    self.txt_lv.text = data.level
    self.txt_power.text = toolFun.moneyNumberShowOne(math.floor(tonumber(data.power)))
    self.txt_gh.text = data.sociatyName

    local  char = Char:new(data.dictid)
    local ima = char:getHeadSpriteName()
    self.roleimage:setImage(ima, packTool:getIconByName(ima))--packTool:getIconByName(data.head)
    self.imabg.spriteName = Tool.getFrame(data.tData.quality)--char:getFrame()
    self.Sprite_bg.spriteName = Tool.getBg(data.tData.quality)--char:getFrame()
    self.txt_vip.text = "VIP "..data.vip
    self.txt_name.text = char:getItemColorName(data.tData.quality, data.name)
    self.delegate = tableData.delegate

    data.nickname = data.name
    data.gameUserId = data.pid

    --获取战队信息
    self:getDefendInfo()
    self:setBtnName()
end

--根据不同的类型设置不同的按钮
function info:setBtnName()
    if tbData.type == "friendList" or tbData.type == "getBp" or tbData.type == "requestFD" then      
        self.tb_black.transform:FindChild("Label").gameObject:GetComponent(UILabel).text = TextMap.GetValue("Text826")
        
        if tbData.type == "requestFD" then
            self.bt_delete.transform:FindChild("Label").gameObject:GetComponent(UILabel).text = TextMap.GetValue("Text827")
        else
            self.bt_delete.transform:FindChild("Label").gameObject:GetComponent(UILabel).text = TextMap.GetValue("Text828")
        end
    end

    
end

function info:getDefendInfo()
    Api:getFriendTeam(tbData.gameUserId, function(result)
        if result.ret == 0 then
            self:setDefendGuys(result.team)
        end
    end, function(error)
        -- body
    end)
end

function info:setDefendGuys(arr) --这个地方要主要，for 0,0会造成闪退
for j = 1, 6 do
    local index = j
    if j <= 3 then index = j + 3
    else index = j - 3
    end

    local temp_char = {}
    if index <= arr.Count and arr[index - 1].dictid ~= nil then
        temp_char = Char:new(arr[index - 1].dictid)--新的索引ID为dictid，旧的为id
        temp_char.isHaveData = true
        temp_char.lv = arr[index - 1].level
        temp_char.star_level = arr[index - 1].star
        temp_char.stage = arr[index - 1].stage
        temp_char.customNameIndex = index - 1
        temp_char.star = arr[index - 1].quality
    else
        temp_char.isHaveData = false
    end

    if self.peppleData.playerid ~= nil then
        id = self.peppleData.playerid
    elseif self.peppleData.dictid ~=nil then
        id = self.peppleData.dictid
    end
    if arr[index - 1].dictid == id then
        temp_char.name = self.peppleData.nickname
    end 
    local binding1 = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/myPeople", self.img_roleKuang)
    binding1:CallUpdate(temp_char)
end

self.img_roleKuangGrid.repositionNow = true
end

function info:onClose()
    UIMrg:popWindow()
end

--拒绝好友
function info:onRefuse()
    local desc =string.gsub(TextMap.GetValue("LocalKey_704"),"{0}",tbData.name)

    DialogMrg.ShowDialog(desc, function()
        local arr = {}
        arr[1] = tbData.gameUserId
        Api:ignoreRequest(arr, function(...)
            self.delegate:refresh(tbData.type)
            self:onClose()
            MessageMrg.show(TextMap.GetValue("Text830"))
        end, function()
        end)
    end)
end

--删除好友
function info:onDelete()
    if tbData.type == "friendList" or tbData.type == "getBp" then
        local desc = TextMap.GetValue("Text568") .. tbData.name .. "?"

        DialogMrg.ShowDialog(desc, function()
            Api:removeFriend(tbData.gameUserId, function(...)
                self.delegate:refresh(tbData.type)
                self:onClose()
                MessageMrg.show(TextMap.GetValue("Text569"))
            end, function()
            end)
        end)
    elseif tbData.type == "requestFD" then
        self:onRefuse()
    end
end

--拉黑好友
function info:onBlack()
    if tbData.type == "friendList" or tbData.type == "getBp" or tbData.type == "requestFD" then
        local desc =string.gsub(TextMap.GetValue("LocalKey_689"),"{0}",tbData.name)

        DialogMrg.ShowDialog(desc, function()
            Api:pullBlack(tbData.gameUserId, function(...)
                self.delegate:refresh(tbData.type)
                self:onClose()
                MessageMrg.show(TextMap.GetValue("Text573"))
                --只有拉黑需要重新获取
                ChatController.GetBlackList()
            end, function()
            end)
        end)
    end
end

--切磋
function info:onFight()
    Api:challenge(tbData.gameUserId, function(result)
        self:onClose()

        local fightData = {}
        fightData["battle"] = result.battle
        fightData["mdouleName"] = "friendFight"
        UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
    end, function()
    end)
end

--私聊
function info:onChat()
    ChatController.OpenP2PUserChat(tbData, info.onClose)
end

function info:onClick(go, name)
    if name == "bt_delete" then
        self:onDelete()
    elseif name == "tb_black" then
        self:onBlack()
    elseif name == "tb_chat" then
        self:onChat()
    elseif name == "tb_fight" then
        self:onFight()
    elseif name == "close" then
        self:onClose()
    end
end

return info
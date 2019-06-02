-- Created by IntelliJ IDEA.
-- User: Abigale
-- Date: 2014/10/27
-- Time: 9:42
-- To change this template use File | Settings | File Templates.
local changeName = {}

function changeName:Start()
    -- ClientTool.AddClick(self.bgBlack, function()
    --      self:onDestory(true)
    -- end)
end

function changeName:update(table)
    --用户的名字
    table = table or {}
    self.fore = table.fore
    self.nickname = table.nickname or Player.Info.nickname

    self.input_name.value = self.nickname
    self.delegate = table
    self.ok_NewPlayer.gameObject:SetActive(true)
    self.ok.gameObject:SetActive(true)
    self.cancel.gameObject:SetActive(true)
    --    self.isfirst = table.first
    --读表确定是消耗钻石还是金钱
    self.renameTime = Player.Resource.rename_times
    if self.fore then --非新手引导进入
    self.ok_NewPlayer.gameObject:SetActive(false)
    else --新手引导进入去掉取消按钮
    self.ok.gameObject:SetActive(false)
    self.cancel.gameObject:SetActive(false)
    end
    if self.renameTime == nil or self.renameTime > 0 then
        --self.Cose.gameObject:SetActive(false)
        self.isOk.text = TextMap.GetValue("LocalKey_727")
    else
        local _type = TableReader:TableRowByUnique("GMconfig", "id", 4).args1
        local _typeShow = ""
        local money = TableReader:TableRowByUnique("GMconfig", "id", 4).args2
        if _type == "gold" then
            _typeShow = TextMap.GetValue("Text41")
        else
            _typeShow = TextMap.GetValue("Text1451")
        end
        self.isOk.text = TextMap.GetValue("Text_1_2828") .. money .. TextMap.GetValue("Text_1_170")
    end
end

function changeName:onClick(go, btName)
    if btName == "ok" or btName == "ok_NewPlayer" then
        --print("ok")
        if self.input_name.value == "" then
            MessageMrg.show(TextMap.GetValue("Text1288"))
            return
        else
            local newName = self.input_name.value
            if newName == self.nickname then
                self:onDestory()
            else
                local isFirst  = false
                if self.delegate and self.delegate.isFirst then 
                    isFirst = self.delegate.isFirst
                end
                Api:changeName(newName,isFirst, function(result)
                    if (self.renameTime ~= nil and self.renameTime == 0) or self.fore then --表示确定更换名字
                    if self.delegate.refresh then
                        self.delegate:refresh()
                    end
                    --  if ClientTool.Platform == "android" or ClientTool.Platform == "ios"then
                    --      local ttFormat = "{\"nickname\":\"{0}\",\"uid\":\"{1}\",\"iconUrl\":\"{2}\",\"level\":{3},\"vip\":{4},\"ext\":\"{5}\"}"
                    --      ttFormat = string.gsub(ttFormat, "{0}",Player.Info.nickname)
                    --      ttFormat = string.gsub(ttFormat, "{1}", Player.playerId)
                    --      ttFormat = string.gsub(ttFormat, "{2}", Player.Info.head)
                    --      ttFormat = string.gsub(ttFormat, "{3}", Player.Info.level)
                    --      ttFormat = string.gsub(ttFormat, "{4}", Player.Info.vip)
                    --      ChatUtil.instance:changeInfo(ttFormat,NowSelectedServer,"0x001")
                    -- end
                    --增加修改名字后改变聊天信息
                    end
                    self:onDestory()
                end, function(ret)
                    --  MessageMrg.show("更换名字失败")
                    return false
                end)
            end
        end
    elseif btName == "cancel" then
        self:onDestory()
    elseif btName == "randName" then
        --获取玩家性别
        local sex = Player.Info.sex
        Api:randomName(sex, function(result)
            self.input_name.value = result.name
        end, function()
            return false
        end)
    end
end

function changeName:onDestory(ret)
    if (ret and self.delegate.onClose) then return end
    UIMrg:popWindow()
    if self.delegate.onClose then
        self.delegate:onClose()
    end
end

return changeName
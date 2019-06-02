
local page = {}

local shareData = require("uLuaModule/modules/shareSDK/shareSDKData.lua")

-- ALREADY_DRAW : 11, //已领取    
 -- CANNOT_SHARE : 12, //不可分享 未激活
    -- CAN_SHARE : 13,    //可分享
    -- CAN_DARW : 14,     //可领取

function page:create()
    return self
end

function page:update(data, index)
    
    self.isExt = false
    self.delegate = data.delegate
    self._index = index
    -- local drop = data.drop
    local drop = RewardMrg.getProbdropByTable(data.drop)
    local package = data.package
    self.gid = package.id
    self.status = self.delegate.data.status[self.gid]

    self.Title.text = package.name

    self.binding:Hide('txt_login_cost')
    self.btn_name.text = TextMap.GetValue("Text411")
    self.btGet.isEnabled = true
    if self.status ~= nil then
        if self.status == 13 then
            self.btn_name.text = TextMap.GetValue("Text412")
            self.btGet.isEnabled = true
        elseif self.status == 11 then
            self.btn_name.text = TextMap.GetValue("Text397")
            self.btGet.isEnabled = false
        elseif self.status == 12 then
            self.btn_name.text = TextMap.GetValue("Text413")
            self.btGet.isEnabled = false
        elseif self.status == 14 then
            self.btn_name.text = TextMap.GetValue("Text414")
            self.btGet.isEnabled = true
        end
    else
        self.btGet.isEnabled = false
        self.btn_name.text = TextMap.GetValue("Text413")
    end
    self.darg:SetActive(true)
    self.Grid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", drop)

    if self.slider then
        self.binding:CallManyFrame(function()
            self.slider.value = 0
            local len = table.getn(drop)
            if self.slider then
                self.slider.gameObject:SetActive(len > 4)
            end
            if len <= 4 then
                self.darg:SetActive(false)
                self.binding:Hide("btn_left")
                self.binding:Hide("btn_right")
            end
        end, 2)
    end


end

function page:createShareData()

     self.shareTrueData = shareData
     local taskData = TableReader:TableRowByUnique("ShareTasks","id",self.gid)
     local linkData = SettingConfig.getShareSDKConfig(GlobalVar.dataEyeChannelID).SinaWeibo
     if taskData == nil or linkData == nil then
         return
     end
     
     -- print(linkData)
     taskData = self:SetTaskDataForPlatform(taskData)

     self.shareTrueData["context"]["content"] =  taskData["content"]
     self.shareTrueData["context"]["image"]   =  linkData["image"]
     self.shareTrueData["context"]["title"]   =  taskData["title"]
     self.shareTrueData["context"]["description"]   =  taskData["description"]
     self.shareTrueData["context"]["url"]     =  linkData["siteUrl"]
     self.shareTrueData["context"]["site"] =  linkData["site"]
     self.shareTrueData["context"]["musicUrl"]        =  linkData["musicUrl"]
    
end

function page:SetTaskDataForPlatform(data)
    local replace = ""
    if GlobalVar.gameName == "ssll" then
        replace = TextMap.GetValue("Text415")
    elseif GlobalVar.gameName == "fknss" then
        replace = TextMap.GetValue("Text416")
    else
        replace = TextMap.GetValue("Text415")
    end

    local con = string.gsub(data["content"],"{0}",replace)
    local tit = string.gsub(data["title"],"{0}",replace)
    if con ~= nil and tit ~= nil then
        data["content"] = con
        data["title"] = tit
    end

    return data
end

-- 分享界面调用
function page:invokeShare() 

    self.shareTrueData = shareData
     local taskData = TableReader:TableRowByUnique("ShareTasks","id",self.gid)
     local linkData = SettingConfig.getShareSDKConfig(GlobalVar.dataEyeChannelID,GlobalVar.gameName).SinaWeibo
     if taskData == nil or linkData == nil then
         return
     end
    
     taskData = self:SetTaskDataForPlatform(taskData)
     self.shareTrueData["context"]["content"] =  taskData["content"]
     self.shareTrueData["context"]["image"]   =  linkData["image"]
     self.shareTrueData["context"]["title"]   =  taskData["title"]
     self.shareTrueData["context"]["description"]   =  taskData["description"]
     self.shareTrueData["context"]["url"]     =  linkData["siteUrl"]
     self.shareTrueData["context"]["site"] =  linkData["site"]
     self.shareTrueData["context"]["musicUrl"]        =  linkData["musicUrl"]

    local jsonData = json.encode(self.shareTrueData["context"])

    -- 回调,成功,分享结果处理
    ShareSDKManager.SetContext(jsonData,function(result)
        print("page:dealShareResult   131")
        if result == true then
             print("page:dealShareResult   133")
            Api:updateActivityStatue(self.gid,true,function(result)
                 print("page:dealShareResult   135")
                self.status = 14
                self.btn_name.text = TextMap.GetValue("Text414")
                self.btGet.isEnabled = true
                MessageMrg.show(TextMap.GetValue("Text417"))
            end)
        else
            print("page:dealShareResult   145")
            MessageMrg.show(TextMap.GetValue("Text418"))
        end
    end)
end

-- 点击领取奖励
function page:onBtGet()
    if self.status == 14 then
        --领取
        self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
    elseif self.status == 13 then
       self:invokeShare()
    end

     -- self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
end

function page:fillCheckIn()
    Api:fillCheckIn(self.delegate.data.id, self._index + 1, function(result)
        packTool:showMsg(result, nil, 1)
        page:getCallBack()
    end)
end

function page:onClick(go, name)
    if name == "btGet" then
        if self.status ~= nil then
            self:onBtGet()
        end
    elseif name == "btn_left" then
        self.c.value = 0
    elseif name == "btn_right" then
        self.slider.value = 1
    end
end

function page:getCallBack()
    self.delegate:countMutliPoint(false)
    if self.delegate.mutliPoint < 1 then
        self.delegate.delegate:hideEffect()
    end
    self.delegate:getCallBack()
end



return page
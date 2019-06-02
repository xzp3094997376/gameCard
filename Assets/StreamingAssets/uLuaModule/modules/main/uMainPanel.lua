local mainPanel = {}
local timerId = 0
-- 更新玩家信息
function mainPanel:update(mainScene)
    if mainScene ~= nil then
        self.mainScene = mainScene
        if self.buildName ~= nil then
            GameObject.DestroyObject(self.buildName.gameObject)
            self.buildName = nil
        end
        if self.buildName == nil then
            --ClientTool.load("Prefabs/moduleFabs/mainScene/mask", self.mainScene.gameObject)
            self.buildName = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/mainScene/buildName_new", GlobalVar.center)
            if UIMrg:GetRunningModuleName() ~= "main_menu" then
                Tool.SetActive(self.buildName, false)
                return
            end
        end
    end

    self:checkRedPoint()
    self:onUpdate()
end

function mainPanel:OnDestroy()
    LuaTimer.Delete(timerId)
    Player:removeListener("mainPanelcurrency")
    Player:removeListener("sdklevel")
end

function mainPanel:listener()
    local that = self
    Player.Resource:addListener("mainPanelcurrency", "gold", function(key, attr, newValue)
        that:updateCurrency()
    end)
    Player.Resource:addListener("mainPanelcurrency", "money", function(key, attr, newValue)
        that:updateCurrency()
    end)
    Player.Resource:addListener("mainPanelcurrency", "bp", function(key, attr, newValue)
        that:updateCurrency()
    end)
    Player.Resource:addListener("mainPanelcurrency", "max_bp", function(key, attr, newValue)
        that:updateCurrency()
    end)
    Player.Resource:addListener("mainPanelcurrency", "soul", function(key, attr, newValue)
        that:updateCurrency()
    end)
    Player:addListener("mainPanelcurrency", "Mails", function()
        mainPanel:checkRedPoint()
    end)
end

function mainPanel:updateCurrency(...)
    lua = {
        [1]={ 
            type="bp"
        },
        [2]={ 
            type="vp"
        },
        [3]={ 
            type="money"
        },
        [4]={ 
            type="gold"
        }
    },

    self.currency:CallUpdate(lua)
end

function mainPanel:onUpdate()
    self.ui:CallUpdate({})
    self.ButtonMenu_new:CallUpdate({})
    lua = {
        [1]={ 
            type="bp"
        },
        [2]={ 
            type="vp"
        },
        [3]={ 
            type="money"
        },
        [4]={ 
            type="gold"
        }
    },
    self.currency:CallUpdate(lua)
end

function mainPanel:reset()
    --    self.buildName = nil
    --    self.mainScene = nil
end

function mainPanel:checkRedPoint()
    if self.buildName == nil then return end
    if self.buildName then
        self.buildName:CallUpdate({})
    end
end

function mainPanel:isShowMainScene(ret)
    local go = GameObject.Find("main_scene")
    if go then
        local tran = go.transform:FindChild("scene")
        local com = tran:GetComponent("RotateCamera")
        if com then
            if ret then
                com:Show()
            else
                com:Hide()
            end
        end
    end
end

function mainPanel:onEnter()
    mainPanel:isShowMainScene(true)
    Tool.SetActive(self.buildName, true)

    Tool.resetRedPoint()
    MusicManager.getMusicAudioCamera();
    MusicManager.openMusicBG();
    DataEyeTool.SetLevel(Player.Info.level)
    local ret = DialogMrg.levelUp()
    self:onUpdate()
    self:checkRedPoint()
    if Player.Info.vip ~= self._oldVip then
        DataEye.vipLevel(Player.Info.vip, Player.Info.level)
        self._oldVip = Player.Info.vip
    end

    self:listener()
    local cdTime = Player.CdTime["bp_inc"]
    --  print("cd Time "..cdTime)
    local time = ClientTool.GetNowTime(cdTime)
    self.binding:StopAllCoroutines()
    if time > 0 then
        self.binding:CallAfterTime(time, function(...)
            local that = self
            Api:checkUpdate(function(res)
                mainPanel:onUpdate()
                mainPanel:checkRedPoint()
            end)
        end)
    end
    --    UluaModuleFuncs.Instance.uTimer:removeSecondTime("updatePlayerInfo")
    LuaTimer.Delete(timerId)
    local times = 0
    timerId = LuaTimer.Add(10000, 60000, function(id)
        if times > 3 then
            return false
        end
        Api:checkUpdate(function(res)
            times = 0
            Tool.resetRedPoint()
            mainPanel:onUpdate()
            mainPanel:checkRedPoint()
        end, function()
            times = times + 1
            return true
        end)
        return true
    end)
    if ret == false then
        self.binding:CallManyFrame(function()
            Tool.pushActive()
        end, 2)
    end
	
	if self.guideMsg ~= nil then 
		if Player.Info.level >= 5 and Player.Info.level < 90 then 
			self.guideMsg.gameObject:SetActive(true)
			self.guideMsg:CallTargetFunction("onUpdate")
			self.guideMsg:CallTargetFunction("onPos")
		else 
			self.guideMsg.gameObject:SetActive(false)
		end 
		if self.guideMsg.gameObject.activeInHierarchy then 
			if Player.Info.level >= 5 and Player.Info.level <= 10 then 
				self.guideMsg:CallTargetFunction("flyOut")
			end 
		end 
	end
    -- Tool.gc(1)
end

function mainPanel:onExit()
    -- local mainScene = self.mainScene
    -- if mainScene then
    --     mainScene:Hide()
    -- end
    mainPanel:isShowMainScene(false)

    --if  GlobalVar.currentScene ~= "gonghui_map" then
    Tool.SetActive(self.buildName, false)
    --end

    LuaTimer.Delete(timerId)
    Player:removeListener("mainPanelcurrency")
end



function mainPanel:Start()
    Tool.resetRedPoint()
    MusicManager.getMusicAudioCamera()
    MusicManager.openMusicBG()
    self:listener()
    local times = 0

    timerId = LuaTimer.Add(60000, 60000, function(id)
        if times > 3 then
            return false
        end
        Api:checkUpdate(function(res)
            times = 0
            mainPanel:onUpdate()
            mainPanel:checkRedPoint()
        end, function()
            times = times + 1
            return true
        end)
        return true
    end)
    self.binding:CallManyFrame(function()
        Tool.pushActive()
    end, 2)
    Player.Info:addListener("sdklevel", "level", function(key, attr, newvalue)
        local vip = 0
        if (Player.Info.vip == nil) then
            vip = 0
        else
            vip = Player.Info.vip
        end
        local serverId = PlayerPrefs.GetString("serverId") or NowSelectedServer
        mysdk:levelUp(PlayerPrefs.GetString("uid"), Player.Info.nickname, newvalue, serverId, PlayerPrefs.GetString("serverName"), Player.Resource.gold, vip, "")
    end)
    require("uLuaModule/dialog/rollNoticeMrg")
    RollNoticeMrg.create() --添加滚动广播
    require("uLuaModule/modules/newChat/chatMrg")
    chatMrg.create()--添加聊悬浮窗口
end



function mainPanel:create()
    DialogMrg.levelUp(true)
    DataEye.vipLevel(Player.Info.vip, Player.Info.level)
    self._oldVip = Player.Info.vip
    return self
end

return mainPanel
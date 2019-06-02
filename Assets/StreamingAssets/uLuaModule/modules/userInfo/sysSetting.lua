--
-- Created by IntelliJ IDEA.
-- User: Abigale
-- Date: 2014/11/3
-- Time: 9:42
-- To change this template use File | Settings | File Templates.
-- 系统设置
local m = {}


function m:Start()
    if self.inputCDKey.value == "" then
        self.btn_cdkey.isEnabled = false
    end
    -- ClientTool.AddClick(self.bg, function()
    -- --关闭界面时保存用户设置
    --     self.SettingManager:quitAndSaveState()
    --     UIMrg:popWindow()
    -- end)
end

function m:OnChange()
    if self.inputCDKey.value ~= "" then
        self.btn_cdkey.isEnabled = true
    else
        self.btn_cdkey.isEnabled = false
    end
end

function m:create()
    return self
end

function m:quit()
    LuaMain:logout()
end

function m:gift_key(...)

    local key = self.inputCDKey.value
    if key == "" then
        MessageMrg.show(TextMap.GetValue("Text452"))
        return
    else
        Api:CDKEy(key, function(result)
            --UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/cdgiftList", { obj = result })
            packTool:showMsg(result, nil, 1)
        end, function(...)
            return false
        end)
    end
end

function m:update()
    if self.inputCDKey.value == "" then
        self.btn_cdkey.isEnabled = false
    else
        self.btn_cdkey.isEnabled = true
    end
    self.SettingManager:getLastState()
end

function m:close()
    self.SettingManager:quitAndSaveState()
    UIMrg:popWindow()
end

function m:onClick(go, btName)
    if btName == "btn_Close" then
        self:close()
    elseif btName == "btn_blackList" then
        --  UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/blacklist", {})
    elseif btName == "bt_logout" then
        self:quit()
    elseif btName == "btn_cdkey" then
        self:gift_key()
        --    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/cdkey", {})
    end

    if btName == "btn_music" then
        self.SettingManager:changeSprite(go.gameObject, self.btn_musicOn.gameObject)
    elseif btName == "btn_musicOn" then 
		self.SettingManager:changeSprite(self.btn_music.gameObject, go.gameObject)
	elseif btName == "btn_sound" then
        self.SettingManager:changeSprite(go.gameObject, self.btn_soundOn.gameObject)
    elseif btName == "btn_soundOn" then 
		self.SettingManager:changeSprite(self.btn_sound.gameObject, go.gameObject)
	end
    -- if btName == "btn_store" then
    --     self.SettingManager:changeSprite(go.gameObject)
    -- end
    -- if btName == "btn_strength" then
    --     self.SettingManager:changeSprite(go.gameObject)
    -- end
    -- if btName == "btn_energy" then
    --     self.SettingManager:changeSprite(go.gameObject)
    -- end
    -- if btName == "btn_arena" then
    --     self.SettingManager:changeSprite(go.gameObject)
    -- end
    -- if btName == "btn_skill" then
    --     self.SettingManager:changeSprite(go.gameObject)
    -- end
end

return m

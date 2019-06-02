--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/12/7
-- Time: 15:57
-- To change this template use File | Settings | File Templates.
-- 创建角色

local m = {}
local imgList = {
    "dongshilang",
    "luqiya",
    "shitianyulong",
    "sifengyuanyeyi",
    "gelimuqiao",
    "niliailu"
}
function m:update(scene)
    --场景对象
    self.scene = scene

    local that = self
    table.foreachi(imgList, function(i, v)
        that["img" .. i].spriteName = v
    end)
end

--随机名
function m:onRandomName()
    local that = self
    Api:randomName(1, function(result)
        that.input.value = result.name
    end)
end

function m:onSelect(index)
    self._oldIndex = index
    self.scene:RotateTo(index % 6)
    self:toggleInfo(true)
end

function m:toggleInfo(ret)
    if ret == false then
        self.scene:BackToAutoRotate()
    end
    self.user_name_info:SetActive(ret)
end

function m:onEnterGame()
    local that = self
    local name = self.input.value
    if self._oldIndex ~= 1 then
        MessageMrg.show(TextMap.GetValue("Text814"))
        return
    end
    Api:createPlayer(name, Tool.CUR_UID, self._oldIndex, function(result)

        if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
            local vip = 0
            if (Player.Info.vip == nil) then
                vip = 0
            else
                vip = Player.Info.vip
            end
            mysdk:createRole(that._pid, Player.Info.nickname, Player.Info.level, sel_sever.number, sel_sever.name, Player.Resource.gold, vip, "")
        end

        -- PlayerPrefs.SetString("uid", that._uid)
        -- 去新手
        print (TextMap.GetValue("Text_1_305"))
        if not GuideConfig:isEnd() then
            local guide = GuideManager.getInstance()
            guide:PlayThePlot()
            --            GuideConfig:init(1)
            --            guide:PlayStep(1)
        else
            --ClientTool.beginLoadScene("main_scene", function()
            --end)
        end
        --        ClientTool.beginLoadScene("main_scene", function()
        --        end)
    end, function(resut)
        return false
    end)
end

function m:onClick(go, name)
    if name == "hero1" then
        self:onSelect(1)
    elseif name == "hero2" then
        self:onSelect(2)
    elseif name == "hero3" then
        self:onSelect(3)
    elseif name == "hero4" then
        self:onSelect(4)
    elseif name == "hero5" then
        self:onSelect(5)
    elseif name == "hero6" then
        self:onSelect(6)
    elseif name == "btn_enter" then
        self:onEnterGame()

    elseif name == "btn_back" then
        self:toggleInfo(false)
    elseif name == "btn_random" then
        self:onRandomName()
    end
end

function m:Start()
    self:onRandomName()
end

function m:create()
    return self
end

return m


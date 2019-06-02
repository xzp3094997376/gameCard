--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/1/23
-- Time: 14:24
-- To change this template use File | Settings | File Templates.
-- 英雄列表项

local m = {}
function m:update(char, index, delegate)
    self.delegate = delegate
    self.index = index
    m:onUpdate(char)
end

function m:onUpdate(char)
    self.char = char
    if char.empty == true then
        self.info:SetActive(false)
        self.binding:Show("node_empty")
        if self.delegate:isFull() then
            self.txt_desc.text = TextMap.GetValue("Text1130")
        else
            self.txt_desc.text = TextMap.GetValue("Text1131")
        end
    else
        self.info:SetActive(true)
        self.binding:Hide("node_empty")

        self.txt_name.text = char:getDisplayName() --名字
        if char.teamIndex ~= 7 then
            self.binding:Show("has_formation")
        else
            self.binding:Hide("has_formation")
        end
        self.txt_lv.text = char.lv
        self.pic:setImage(char:getHeadSpriteName(), packTool:getIconByName(char:getHeadSpriteName()))
        self.icon_frame.spriteName = char:getFrame()
        self.xibie.spriteName = char:getStarFrame()
        self.bg.spriteName = char:getFrameBG()
        m:isSelect(self.delegate.selectIndex == self.index)

        self.txt_power.text = char.power

        m:setRedPoint()
    end
end

function m:setRedPoint()
    self.red_point:SetActive(Tool.checkGhostRedPiont(self.index))
end

function m:isSelect(ret)
    self.select:SetActive(ret)
    if ret == true then
        self.delegate.selectIndex = self.index
    end
end

function m:onClick(go, name)
    if name == "lock" then
        if self.delegate:isFull() then
            local lv = Player.Info.level
            lv = lv + 5 - lv % 5
            MessageMrg.show(string.gsub(TextMap.GetValue("Text111"),"{0}",lv)
            return
        end
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "single", module = "ghost", delegate = self.delegate, index = self.index })
        return
    end

    Events.Brocast('select_char')
    m:isSelect(true)
    self.delegate:onUpdate(self.char)
end

function m:OnDestroy()
    Events.RemoveListener('select_char')
    Events.RemoveListener('updateChar')
    Events.RemoveListener('showEffect')
end

function m:updateChar()
    if self.delegate.selectIndex == self.index then
        self.char:updateInfo()
        m:onUpdate(self.char)
    end
    m:setRedPoint()
end

--点击升级在人物头像位置播放特效
function m:showEffect()
    if self.delegate.selectIndex == self.index then
        if self.effNode == nil then
            self.effNode = ClientTool.load("Effect/Prefab/UI_jinengshengji", self.pic.gameObject)
        else
            self.effNode:SetActive(true)
        end
    end
end

function m:Start()
    Events.AddListener("select_char", function()
        m:isSelect(false)
    end)
    local that = self
    Events.AddListener("updateChar", funcs.handler(self, m.updateChar))
    Events.AddListener("showEffect", funcs.handler(self, m.showEffect))
end

return m
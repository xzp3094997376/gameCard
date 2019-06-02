--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/1/23
-- Time: 14:24
-- To change this template use File | Settings | File Templates.
-- 英雄列表项

local m = {}
function m:update(ghost, index, delegate)
    self.delegate = delegate
    self.index = index
    m:onUpdate(ghost)
end

function m:onUpdate(ghost)
    self.ghost = ghost
    self.txt_name.text = "Lv." .. ghost.lv .. " " .. Tool.getNameColor(ghost.star) .. ghost.name .. "[-]"
    self.icon:setImage(ghost:getHeadSpriteName(), packTool:getIconByName(ghost:getHeadSpriteName()))
    self.frame.spriteName = ghost:getFrameNormal()
    self.has_formation:SetActive(ghost.hasWear == 1)
    if ghost.hasWear == 1 then
        self.txt_char_name.text = ghost.charName
    elseif ghost.key == nil then
        self.txt_char_name.text = ghost:getMainAttr()
    else
        self.txt_char_name.text = TextMap.GetValue("Text1132")
    end
    self.power.text = ghost.power
    self.power.gameObject:SetActive(ghost.power > 0)
    m:isSelect(self.delegate.selectIndex == self.index)
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
    Events.Brocast('select_char')
    m:isSelect(true)
    self.delegate:onUpdate(self.ghost)
end

function m:OnDestroy()
    Events.RemoveListener('select_char')
    Events.RemoveListener('updateChar')
    Events.RemoveListener('showEffect')
end

function m:updateChar(ghost)
    if self.delegate.selectIndex == self.index then
        if ghost ~= nil then self.ghost = ghost end
        self.ghost:updateInfo()
        m:onUpdate(self.ghost)
    end
    -- m:setRedPoint()
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
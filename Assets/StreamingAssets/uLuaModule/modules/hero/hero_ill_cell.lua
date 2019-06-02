--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/1/23
-- Time: 20:49
-- To change this template use File | Settings | File Templates.
-- 图鉴。
local m = {}
local _firstLoad = true
function m:update(char, index, delegate)
    self.delegate = delegate
    self.char = char
    self.txt_lv_name.text = char:getDisplayColorName()
    self.desc.text=self.char.des 
    if char:getType()=="char" or char:getType()=="charPiece" or char:getType()=="pet" or char:getType()=="petPiece" or char:getType()=="yuling" or char:getType()=="yulingPiece" then
        local modelid=0 
        if char:getType()=="charPiece" then 
            local _char = Char:new(nil, char.id)
            modelid=_char.modelid
        elseif char:getType()=="petPiece" then 
            local _char = Pet:new(nil, char.id)
            modelid=_char.modelid 
        elseif char:getType()=="petPiece" then 
            local _char = Yuling:new(char.id)
            modelid=_char.modelid 
        else 
            modelid=char.modelid 
        end 
        self.hero.enabled=true
        self.item.gameObject:SetActive(false)
        if char:getType()=="char" or char:getType()=="charPiece" then 
            self.hero:LoadByModelId(modelid, "idle", function() end, false, 0, 1, 255, 1)
        else 
            self.hero:LoadByModelId(modelid, "idle", function() end, false, 100, 1, 255, 1) 
        end   
    else
        self.hero.enabled=false
        self.item.gameObject:SetActive(true)
        if self.itemAll ==nil then 
            self.itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item.gameObject)
        end
        self.itemAll:CallUpdate({"char", char, self.item.width, self.item.height, true, nil})
    end  
    if self.char.des ~="" then 
        self:updateDrawShow()
    else 
        self.desc.gameObject:SetActive(false)
    end 
    --m:loadModel(char.id)
end

local REFRESH_DRAWSHOW = 0
function m:updateDrawShow( )
   LuaTimer.Delete(REFRESH_DRAWSHOW)
   REFRESH_DRAWSHOW = LuaTimer.Add(0, 1, function (id)
    if self.obj ~=nil then
        if self.obj.transform.position.x <0.3 and self.obj.transform.position.x >-0.3 then
         self.desc.gameObject:SetActive(true)
        else
            self.desc.gameObject:SetActive(false)
            end
        end
    return true
   end)
end

function m:OnDestroy()
    LuaTimer.Delete(REFRESH_DRAWSHOW)
end
function m:onTooltip(name)

end

--进化
function m:onStarUp(go)
    --跳到进化页面
    UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 2 })
end


function m:onClick(go, name)

    local tp = self.char:getType()
    if tp == "char" then
        m:onStarUp(go)
    else
        if self.pieceValue < 1 then
            self.delegate:showDrop(self.char)
            return
        end
        self.delegate:showSummon(self.char)
    end
end

function m:loadModel(model)
    self.hero:LoadByCharId(model, "stand", function(ctl)
    end, false, -1)
end

function m:showInfo()
    Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
end

function m:Start()
    ClientTool.AddClick(self.hero, funcs.handler(self, self.showInfo))
end

return m


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
    ------------------------------------------------------------------- fix at 2015年5月6日 去掉星星------------------------------------------------------------------------------
    -- self.txt_lv_name.text = char:getDisplayName()
    self.txt_lv_name.text = "Lv" .. (char.lv or "1") .. " " .. Tool.getNameColor(char.star) .. char:getDisplayName() .. "[-]"
    -- local stars = {}
    -- for i = 1, 5 do
    --     stars[i] = i <= char.star
    -- end
    -- ClientTool.UpdateGrid("", self.star, stars)
    -- self.txt_lv.text = "Lv" .. (char.lv or "1")
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    m:loadModel(char.id)
    local tp = char:getType()
    local star = nil
    local piece = char
    local btn_name = TextMap.GetValue("Text92")
    if char.teamIndex < 7 then
        self.binding:Show("formation_pos")
    else
        self.binding:Hide("formation_pos")
    end
    self.pieceValue = 0
    local info
    if tp == "char" then
        --        piece = char:getPiece()
        btn_name = TextMap.GetValue("Text94")
        self.binding:Show("xibie")
        self.binding:Show("power_bg")
        self.txt_power.text = char.power
        self.xibie.spriteName = char:getStarFrameBig()
        self.dw_text = char.Table.dingwei_desc

    else
        self.binding:Hide("xibie")
        self.binding:Hide("power_bg")
        self.dw_text = char._charTable.dingwei_desc
        info = piece:pieceInfo(star)
        self.pieceValue = info.value
    end

    if tp == "charPiece" and info then
        self.binding:Show("slider")
        if info.value < 1 then
            self.sp_btn.spriteName = "TY-blue-zhong"
            self.btn_challenge.normalSprite = "TY-blue-zhong"
            btn_name = TextMap.GetValue("Text93")
            self.binding:Show("txt_btnName_get")
            self.binding:Hide("txt_btnName")
        end
        self.slider.value = info.value
        self.txt_piece.text = info.desc
    else
        self.txt_piece.text = Player.CharPieceBagIndex[char.id].count
        self.binding:Hide("slider")
        self.sp_btn.spriteName = "TY-yellow-zhong"
        self.btn_challenge.normalSprite = "TY-yellow-zhong"
        self.binding:Hide("txt_btnName_get")
        self.binding:Show("txt_btnName")
    end
    self.txt_btnName.text = btn_name
    self.txt_btnName_get.text = btn_name
    self.dingwei.spriteName = char:getDingWei()
end

function m:onTooltip(name)
    if name == "dingwei" then
        return self.dw_text
    end
end

--进化
function m:onStarUp(go)
    --跳到进化页面
    -- uSuperLink.open("powerUp", { 3, self.char }, 0, 2)
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
    --    local hero = self.hero
    self.hero:LoadByCharId(model, "stand", function(ctl)
        --        if _firstLoad == true then
        --            local go = ClientTool.load("Effect/Prefab/xuanRenDiZuo")
        --            hero:showBottom(go)
        --            go.transform.localPosition = Vector3(0,0,0)
        --            local s = go.transform.localScale
        --            go.transform.localScale = Vector3(s.x * 1.2,s.y * 1.2,s.z * 1.2)
        --            _firstLoad = false
        --        end
    end, false, -1)
end

function m:showInfo()
    Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
end

function m:Start()
    ------------------------------------------------------------------- fix at 2015年5月6日 去掉星星------------------------------------------------------------------------------
    self.binding:Hide("star")
    self.binding:Hide("txt_lv")
    self.txt_lv_name.transform.localPosition = Vector3(0, 224, 0)
    self.txt_lv_name.fontSize = 20
    local child = self.txt_lv_name.transform:GetChild(0)
    child:GetComponent(UISprite).width = 240
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ClientTool.AddClick(self.hero, funcs.handler(self, self.showInfo))
end

return m


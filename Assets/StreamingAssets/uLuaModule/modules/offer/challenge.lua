-- region challenge.lua
-- Author : xiyou
-- Date   : 2014/10/10
-- 此文件由[BabeLua]插件自动生成
-- 挑战


-- endregion
local Challenge = {}
local TXT_CHALLENGE = TextMap.GetValue("Text1322")
local TXT_OFFER = TextMap.GetValue("Text1323")
local moduleName = "challenge"
local CHALLENGE_CHAPTER_ID = {
    ONE = 3,
    TWO = 4,
    THREE = 5
}


-- 关闭
function Challenge:onClose(go)
    --	SendBatching.OpenOrCloseModule(moduleName, "Prefabs/moduleFabs/tiaoZhanModule/tiaoZhan_zhuJieMian", { - 1 }, function() end)
    UIMrg:pop()
end

function Challenge:update(lua)

    local _type = lua[1]
    self._type = _type
    if _type == 1 then
        CHALLENGE_CHAPTER_ID = {
            ONE = 3,
            TWO = 4,
            THREE = 5
        }
        --禁地试炼
        --self.txt_tittle.text = TXT_CHALLENGE
        -- self.topMenu:CallUpdate({ title = "shilian" })
        self.topMenu = LuaMain:ShowTopMenu()

    else
        CHALLENGE_CHAPTER_ID = {
            ONE = 1,
            TWO = 2,
            THREE = 6
        }
        --廷内悬赏
        --        self.txt_tittle.text = TXT_OFFER
        self.topMenu = LuaMain:ShowTopMenu()

        --self.topMenu:CallUpdate({ title = "xuanshang" })
    end
    self:onUpdate()
end

-- 事件
function Challenge:onClick(go, name)
    if name == "btnBack" then
        self:onClose(go)
    elseif name == "UpButton1" then
        if self.ScrollView1 == nil then
            Debug.LogError("fuck the self.ScrollView1");
            return
        end
        self.UpButton1.gameObject:SetActive(false)
        self.DownButton1.gameObject:SetActive(true)
        -- self.ScrollView1:Scroll(252 / self.ScrollView1.momentumAmount)
        -- self.ScrollView1:SetDragAmount(0,0,false)
        self.slider1.value = 0
    elseif name == "DownButton1" then
        if self.ScrollView1 == nil then
            Debug.LogError("fuck the self.ScrollView1");
            return
        end
        self.UpButton1.gameObject:SetActive(true)
        self.DownButton1.gameObject:SetActive(false)
        -- self.ScrollView1:Scroll(-252 / self.ScrollView1.momentumAmount)
        -- self.ScrollView1:SetDragAmount(0,1,false)
        self.slider1.value = 1

    elseif name == "UpButton2" then
        if self.ScrollView2 == nil then
            Debug.LogError("fuck the self.ScrollView2");
            return
        end
        self.UpButton2.gameObject:SetActive(false)
        self.DownButton2.gameObject:SetActive(true)
        -- self.ScrollView2:Scroll(252 / self.ScrollView2.momentumAmount)
        -- self.ScrollView2:SetDragAmount(0,0,true)
        self.slider1.value = 0

    elseif name == "DownButton2" then
        if self.ScrollView2 == nil then
            Debug.LogError("fuck the self.ScrollView2");
            return
        end
        self.UpButton2.gameObject:SetActive(true)
        self.DownButton2.gameObject:SetActive(false)
        -- self.ScrollView2:Scroll(-252 / self.ScrollView2.momentumAmount)
        -- self.ScrollView2:SetDragAmount(0,1,true)
        self.slider2.value = 1

    elseif name == "UpButton3" then
        if self.ScrollView3 == nil then
            Debug.LogError("fuck the self.ScrollView3");
            return
        end
        self.UpButton3.gameObject:SetActive(false)
        self.DownButton3.gameObject:SetActive(true)
        -- self.ScrollView3:Scroll(252 / self.ScrollView3.momentumAmount)
        -- self.ScrollView3:SetDragAmount(0,0,true)
        self.slider3.value = 0

    elseif name == "DownButton3" then
        if self.ScrollView3 == nil then
            Debug.LogError("fuck the self.ScrollView3");
            return
        end
        self.UpButton3.gameObject:SetActive(true)
        self.DownButton3.gameObject:SetActive(false)
        -- self.ScrollView3:SetDragAmount(0,1,true)
        -- self.ScrollView3:Scroll(-252 / self.ScrollView3.momentumAmount)
        self.slider3.value = 1
    end
end

--点击按钮滚动一页
function Challenge:scoll(scollView)
end

-- 显示tips
function Challenge:showTips(tag)
    if tag == CHALLENGE_CHAPTER_ID.ONE then
        self.tips:CallUpdate(self.tb1)
    elseif tag == CHALLENGE_CHAPTER_ID.TWO then
        self.tips:CallUpdate(self.tb2)
    elseif tag == CHALLENGE_CHAPTER_ID.THREE then
        self.tips:CallUpdate(self.tb3)
    end
    self.binding:Play("tips", "scale")
end



-- 显示挑战页面
function Challenge:show(chapter, delegate)
    self.chapter = chapter
end

-- 进挑战页面
function Challenge:showBoss(tag)
    self:show(tag, self)
end

-- 读表
function Challenge:readTableByUniqueKey(chapter, section)
    return TableReader:TableRowByUniqueKey("specialChapter", chapter, section)
end

-- 更新
function Challenge:onUpdate()
    local specialChapter1 = Player.specialChapter[CHALLENGE_CHAPTER_ID.ONE]
    local specialChapter2 = Player.specialChapter[CHALLENGE_CHAPTER_ID.TWO]
    local specialChapter3 = Player.specialChapter[CHALLENGE_CHAPTER_ID.THREE]
    local last_section1 = specialChapter1.last_section
    local last_section2 = specialChapter2.last_section
    local last_section3 = specialChapter3.last_section

    if last_section1 == 0 then last_section1 = 1 end
    if last_section2 == 0 then last_section2 = 1 end
    if last_section3 == 0 then last_section3 = 1 end

    self.tb1 = self:readTableByUniqueKey(CHALLENGE_CHAPTER_ID.ONE, last_section1)
    self.tb2 = self:readTableByUniqueKey(CHALLENGE_CHAPTER_ID.TWO, last_section2)
    self.tb3 = self:readTableByUniqueKey(CHALLENGE_CHAPTER_ID.THREE, last_section3)
    self._open1 = specialChapter1.open
    self._open2 = specialChapter2.open
    self._open3 = specialChapter3.open

    self.hard_select1:SetActive(false)
    self.hard_select2:SetActive(false)
    self.hard_select3:SetActive(false)

    local cfg = self.tb1._chapter
    local show_name = self.tb1.show_name

    self.img_name1.text = show_name
    local img = cfg.bg_img
    img = UrlManager.GetImagesPath("offer_challenge_image/" .. img .. ".png")
    self.model_bg1.Url = img
    self.tiem_Desc1.text = cfg.remark
    self.time_Desc1.text = cfg.des3
    self.pro_Desc1.text = cfg.desc2
    if self._type == 1 then --试炼
    self.level_Desc1.spriteName = cfg.stage_icon2
    else
        self.level_Desc1.gameObject:SetActive(false);
    end
    self.lock_1:SetActive(not specialChapter1.open)
    Challenge:cerateItems(cfg, self.grid1)

    cfg = self.tb2._chapter
    show_name = self.tb2.show_name

    self.img_name2.text = show_name
    img = cfg.bg_img
    img = UrlManager.GetImagesPath("offer_challenge_image/" .. img .. ".png")
    self.model_bg2.Url = img
    self.tiem_Desc2.text = cfg.remark
    self.time_Desc2.text = cfg.des3
    self.pro_Desc2.text = cfg.desc2
    if self._type == 1 then
        self.level_Desc2.spriteName = cfg.stage_icon2
    else
        self.level_Desc2.gameObject:SetActive(false);
    end
    self.lock_2:SetActive(not specialChapter2.open)
    Challenge:cerateItems(cfg, self.grid2)

    cfg = self.tb3._chapter
    show_name = self.tb3.show_name

    self.img_name3.text = show_name
    img = cfg.bg_img
    img = UrlManager.GetImagesPath("offer_challenge_image/" .. img .. ".png")
    self.model_bg3.Url = img
    self.tiem_Desc3.text = cfg.remark
    self.time_Desc3.text = cfg.des3
    self.pro_Desc3.text = cfg.desc2
    if self._type == 1 then --试炼
    self.level_Desc3.spriteName = cfg.stage_icon2
    else
        self.level_Desc3.gameObject:SetActive(false);
    end
    self.lock_3:SetActive(not specialChapter3.open)
    self.maxtime = specialChapter1.max_fight
    self.curtime = specialChapter1.fight
    Challenge:cerateItems(cfg, self.grid3)
    self.binding:CallAfterTime(0.5, function()
        if self._open1 == true then
            self.chapter_num1.text = TextMap.GetValue("Text1324") .. (specialChapter1.max_fight - specialChapter1.fight)
        else
            BlackGo.setBlack(0.5, self.f1.transform)
            self.chapter_num1.text = TextMap.GetValue("Text1325")
        end
        if self._open2 == true then
            self.chapter_num2.text = TextMap.GetValue("Text1324") .. (specialChapter2.max_fight - specialChapter2.fight)
        else
            BlackGo.setBlack(0.5, self.f2.transform)
            self.chapter_num2.text = TextMap.GetValue("Text1325")
        end
        if self._open3 == true then
            self.chapter_num3.text = TextMap.GetValue("Text1324") .. (specialChapter3.max_fight - specialChapter3.fight)
        else
            BlackGo.setBlack(0.5, self.f3.transform)
            self.chapter_num3.text = TextMap.GetValue("Text1325")
        end
    end)
end

function Challenge:cerateItems(itemobj, grids)
    local dropCount = itemobj.probdrop.Count - 1
    if dropCount > 3 then
        dropCount = 3
    end
    for i = 0, dropCount do
        local vo = itemvo:new(itemobj.probdrop[i]["type"], 1, itemobj.probdrop[i]["arg"], 1, "1")
        vo.isShowName = false
        local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/offer_challenge/challengeItemCell", grids.gameObject)
        infobinding:CallUpdate(vo)
        infobinding.gameObject.transform.localScale = Vector3(0.6, 0.6, 0.6)
    end
    itemobj = nil
    grids.repositionNow = true
end

function Challenge:getImg(tb)
    local cfg = TableReader:TableRowByID("specialChapter_config", tb.chapter)
    local img = cfg.stage_icon
    img = UrlManager.GetImagesPath("offer_challenge_image/" .. img .. ".png")
    return img
end

-- 开始
function Challenge:Start()
    -- self.topMenu = LuaMain:ShowTopMenu("", 1)
    local that = self
    self.isOnce1 = false
    self.isOnce2 = false
    self.isOnce3 = false

    ClientTool.AddClick(self.f1, function()
        if that._open1 == false then
            MessageMrg.show(TextMap.GetValue("Text1326") .. self.tiem_Desc1.text)
        else
            if self.curHidePage ~= nil then
                self.curHidePage.transform.rotation = Quaternion.identity
                self.curHidePage:SetActive(true)
                self.curShowPage:SetActive(false)
            end
            that:showBoss(CHALLENGE_CHAPTER_ID.ONE)
            if not self.isOnce1 then
                self.isOnce1 = true
                self:createHardItem(self.Grid1, 1)
            end
            self:rotPage(self.f1, self.hard_select1, self.Grid1, 1)
            self.curHidePage = self.f1
            self.curShowPage = self.hard_select1
        end
    end)
    ClientTool.AddClick(self.f2, function()
        if that._open2 == false then
            MessageMrg.show(TextMap.GetValue("Text1326") .. self.tiem_Desc2.text)
        else
            if self.curHidePage ~= nil then
                self.curHidePage.transform.rotation = Quaternion.identity
                self.curHidePage:SetActive(true)
                self.curShowPage:SetActive(false)
            end
            that:showBoss(CHALLENGE_CHAPTER_ID.TWO)
            if not self.isOnce2 then
                self.isOnce2 = true
                self:createHardItem(self.Grid2, 2)
            end
            self:rotPage(self.f2, self.hard_select2, self.Grid2, 2)
            self.curHidePage = self.f2
            self.curShowPage = self.hard_select2
        end
    end)
    ClientTool.AddClick(self.f3, function()
        if that._open3 == false then
            MessageMrg.show(TextMap.GetValue("Text1326") .. self.tiem_Desc3.text)
        else
            if self.curHidePage ~= nil then
                self.curHidePage.transform.rotation = Quaternion.identity
                self.curHidePage:SetActive(true)
                self.curShowPage:SetActive(false)
            end
            that:showBoss(CHALLENGE_CHAPTER_ID.THREE)
            if not self.isOnce3 then
                self.isOnce3 = true
                self:createHardItem(self.Grid3, 3)
            end
            self:rotPage(self.f3, self.hard_select3, self.Grid3, 3)
            self.curHidePage = self.f3
            self.curShowPage = self.hard_select3
        end
    end)
end

function Challenge:rotPage(page1, page2, Grid, index)
    if page1 == nil and page2 == nil then
        return
    end
    if index == 1 then
        self.curItems = self.itemhards1
    elseif index == 2 then
        self.curItems = self.itemhards2
    elseif index == 3 then
        self.curItems = self.itemhards3
    end
    local rotation = Quaternion.identity;
    rotation.eulerAngles = Vector3(0, 80, 0);
    self.binding:RotTo(page1, 0.2, rotation, function()
        page1:SetActive(false)
        page2.transform.rotation = Quaternion.Euler(Vector3(0, 90, 0))
        page2:SetActive(true)
        self.binding:CallAfterTime(0.1, function()
            if self.curItems ~= nil and self.curItems ~= {} then
                for i = 0, table.getn(self.curItems) do
                    self.curItems[i].gameObject.transform.localPosition = Vector3(0, 600, 0)
                end
            end
        end)
        self.binding:RotTo(page2, 0.2, Quaternion.identity, function()
            Grid:Reposition()
            page2.transform.rotation = Quaternion.Euler(Vector3(0, 0, 0))
        end)
    end)
end

function Challenge:createHardItem(Grid, index)
    local items = {}
    for i = 0, 5 do
        local tempObj = {}
        tempObj.myself = self
        tempObj.chapter = self.chapter
        tempObj.index = i + 1
        tempObj.maxtime = self.maxtime
        tempObj.curtime = self.curtime
        local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/offer_challenge/hard_item", Grid.gameObject)
        items[i] = infobinding
        infobinding:CallUpdate(tempObj)
        infobinding = nil
        tempObj = nil
    end
    if index == 1 then
        self.itemhards1 = {}
        self.itemhards1 = items
    elseif index == 2 then
        self.itemhards2 = {}
        self.itemhards2 = items
    elseif index == 3 then
        self.itemhards3 = {}
        self.itemhards3 = items
    end
end

function Challenge:onEnter()
    local specialChapter1 = Player.specialChapter[CHALLENGE_CHAPTER_ID.ONE]
    local specialChapter2 = Player.specialChapter[CHALLENGE_CHAPTER_ID.TWO]
    local specialChapter3 = Player.specialChapter[CHALLENGE_CHAPTER_ID.THREE]
    if self._open1 == true then
        self.chapter_num1.text = TextMap.GetValue("Text1324") .. (specialChapter1.max_fight - specialChapter1.fight)
    else
        BlackGo.setBlack(0.5, self.f1.transform)
        self.chapter_num1.text = TextMap.GetValue("Text1325")
    end
    if self._open2 == true then
        self.chapter_num2.text = TextMap.GetValue("Text1324") .. (specialChapter2.max_fight - specialChapter2.fight)
    else
        BlackGo.setBlack(0.5, self.f2.transform)
        self.chapter_num2.text = TextMap.GetValue("Text1325")
    end
    if self._open3 == true then
        self.chapter_num3.text = TextMap.GetValue("Text1324") .. (specialChapter3.max_fight - specialChapter3.fight)
    else
        BlackGo.setBlack(0.5, self.f3.transform)
        self.chapter_num3.text = TextMap.GetValue("Text1325")
    end

    local _type = self._type
    -- if _type == 1 then

    --     --禁地试炼
    --     self.topMenu:CallUpdate({ title = "shilian" })
    -- else

    --     --廷内悬赏
    --     --        self.txt_tittle.text = TXT_OFFER
    --     self.topMenu:CallUpdate({ title = "xuanshang" })
    -- end
end

function Challenge:create()
    return self
end

return Challenge
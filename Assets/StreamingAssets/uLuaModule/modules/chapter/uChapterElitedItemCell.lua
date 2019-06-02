--章节cell
local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
local eliteDiffSelectItem = {}
local islock1 = false
local islock2 = false
local islock3 = false
local islockTip1 = ""
local islockTip2 = ""
local islockTip3 = ""
local capterEasyID = 1
local capterNorID = 2
local capterDiffID = 3
local Url = "nothing"
local objs
local totaltimes = -1 --可挑战的次数-1
--关闭界面
function eliteDiffSelectItem:destory()
    SendBatching.DestroyGameOject(self.binding.gameObject)
end

local tipsShowStr = ""
function eliteDiffSelectItem:onClick(go, name)
    if eliteDiffSelectItem:isHaveUnlock(self.data.chars[0].easy) then
        local sendData = {}
        sendData[1] = self.data
        local bind = Tool.push("chapterEliteSelecte", "Prefabs/moduleFabs/EliteModule/chapterEliteDiff")
        bind:CallUpdate(sendData)
        sendData = nil
        bind = nil
    else
        MessageMrg.show(tipsShowStr)
    end
end


function eliteDiffSelectItem:onClick(go, name)
    if name == "button1" then
        if islock1 then
            chapterFightPanel.Show("heroChapter", capterEasyID, 3)
        else
            MessageMrg.show(islockTip1)
        end
    elseif name == "button2" then
        if islock2 then
            chapterFightPanel.Show("heroChapter", capterNorID, 3)
        else
            MessageMrg.show(islockTip2)
        end
    elseif name == "button3" then
        if islock3 then
            chapterFightPanel.Show("heroChapter", capterDiffID, 3)
        else
            MessageMrg.show(islockTip3)
        end
    elseif name == "imageBtn" then
        if islock1 then
            local rotation = Quaternion.identity;
            rotation.eulerAngles = Vector3(0, 80, 0);
            self.binding:RotTo(self.normal, 0.2, rotation, function()
                self.normal:SetActive(false)
                self.open:SetActive(true)
                self.binding:RotTo(self.open, 0.2, Quaternion.identity)
            end)
            self.data:callBack(self)
        else
            MessageMrg.show(islockTip1)
        end
    end
end

--false 未解锁  true 已解锁
function eliteDiffSelectItem:isHaveUnlock(id)
    local lastChapter = Player.Chapter.lastChapter --普通关卡等级
    local lastSection = Player.Chapter.lastSection --普通关卡小节
    local row = TableReader:TableRowByID("heroChapter", id)
    if row.unlock_chapter > lastChapter then
        tipsShowStr =string.gsub(TextMap.GetValue("LocalKey_665"),"{0}",row.unlock_chapter)
        tipsShowStr =string.gsub(tipsShowStr,"{1}",row.unlock_section)
        row = nil
        return false
    end
    if row.unlock_chapter == lastChapter and row.unlock_section >= lastSection then
        tipsShowStr =string.gsub(TextMap.GetValue("LocalKey_665"),"{0}",row.unlock_chapter)
        tipsShowStr =string.gsub(tipsShowStr,"{1}",row.unlock_section)
        row = nil
        return false
    end
    row = nil
    return true
end

--打开界面，设置值
function eliteDiffSelectItem:setData()
    objs = self.data.chars[0]
    capterEasyID = objs.easy
    capterNorID = objs.normal
    capterDiffID = objs.diffcult
    local row = TableReader:TableRowByUnique("avter", "name", objs.char)
    -- self.name.text = objs.char
    --local totelTimes = Player.NBChapter.status[capterEasyID].fight + Player.NBChapter.status[capterNorID].fight + Player.NBChapter.status[capterDiffID].fight
    local totelTimes = eliteDiffSelectItem:getTotaltimes()
    self.times.text = ""
    if totelTimes > 0 then
        self.times.text = TextMap.GetValue("Text496")
    end
    self.star1:setStar(Player.NBChapter.status[capterEasyID].star)
    self.star2:setStar(Player.NBChapter.status[capterNorID].star)
    self.star3:setStar(Player.NBChapter.status[capterDiffID].star)
    if eliteDiffSelectItem:isHaveUnlock(self.data.chars[0].easy) then
        self.normallock:SetActive(false)
        islock1 = true
    else
        self.times.text = tipsShowStr
        BlackGo.setBlack(0.5, self.normal.transform)
    end
    islockTip1 = tipsShowStr
    if eliteDiffSelectItem:isHaveUnlock(self.data.chars[0].normal) then
        self.Sprite2:SetActive(false)
        self.content2:SetActive(true)
        islock2 = true
    else
        self.content2:SetActive(false)
        BlackGo.setBlack(0.5, self.obj2.transform)
    end
    islockTip2 = tipsShowStr
    if eliteDiffSelectItem:isHaveUnlock(self.data.chars[0].diffcult) then
        islock3 = true
        self.content3:SetActive(true)
        self.Sprite3:SetActive(false)
    else
        self.content3:SetActive(false)
        BlackGo.setBlack(0.5, self.obj3.transform)
    end
    islockTip3 = tipsShowStr
    -- self.txt_times1.text = TextMap.GetValue("Text15") .. Player.NBChapter.status[capterEasyID].fight .. "/" .. objs._easy.fight_times
    -- self.txt_times2.text = TextMap.GetValue("Text15") .. Player.NBChapter.status[capterNorID].fight .. "/" .. objs._normal.fight_times
    -- self.txt_times3.text = TextMap.GetValue("Text15") .. Player.NBChapter.status[capterDiffID].fight .. "/" .. objs._diffcult.fight_times
    if Url == "nothing" then
        Url = UrlManager.GetImagesPath('chapterImage/jingying_' .. capterEasyID .. '.png')
        self.simpleImage.Url = UrlManager.GetImagesPath('chapterImage/jingying_' .. capterEasyID .. '.png')
    end
end


function eliteDiffSelectItem:update(table)
    self.data = table
    eliteDiffSelectItem:setData()
end

--初始化
function eliteDiffSelectItem:create(binding)
    self.binding = binding
    return self
end

-- lzh 2015.05.07
-- 获取可挑战的次数
-- function eliteDiffSelectItem:getTotaltimes()
--     if totaltimes~=-1 then
--         return totaltimes
--     else
--         local row = TableReader:TableRowByID("heroChapter_config", "max_time")
--         local temp = 0
--         if row.args1~=nil and tonumber(row.args1)~=nil then
--             temp = row.args1            
--         else
--             temp = 0
--         end
--         totaltimes = temp + Player.NBChapter.resettimes - Player.NBChapter.totaltimes
--         return totaltimes
--     end
-- end
-- lzh 2015.05.07
-- 获取可挑战的次数
function eliteDiffSelectItem:getTotaltimes()
    if totaltimes == -1 then
        local row = TableReader:TableRowByID("heroChapter_config", "max_time")
        if row.args1 ~= nil and tonumber(row.args1) ~= nil then
            totaltimes = row.args1
        else
            totaltimes = 0
        end
    end
    local lefttimes = totaltimes + Player.NBChapter.resettimes - Player.NBChapter.totaltimes
    return lefttimes;
end

return eliteDiffSelectItem
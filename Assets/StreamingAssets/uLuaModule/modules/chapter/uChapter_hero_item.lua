--章节cell
local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
local m = {}
local islock = false
local islockTip = ""

local objs = nil
local totaltimes = -1 --可挑战的次数-1
local diffText = {}
diffText[1] = TextMap.GetValue("Text_1_210")
diffText[2] = TextMap.GetValue("Text_1_211")
diffText[3] = TextMap.GetValue("Text_1_212")
diffText[4] = TextMap.GetValue("Text_1_213")
diffText[5] = TextMap.GetValue("Text_1_214")
diffText[6] = TextMap.GetValue("Text_1_215")

--关闭界面
function m:destory()
    SendBatching.DestroyGameOject(self.binding.gameObject)
end

local tipsShowStr = ""


function m:onClick(go, name)
    if m:isHaveUnlock(self.data.id) then
		chapterFightPanel.Show("heroChapter", self.data.id, 3)
    else
        MessageMrg.show(tipsShowStr)
    end
end

--false 未解锁  true 已解锁
function m:isHaveUnlock(id)
    local lastChapter = Player.Chapter.lastChapter --普通关卡等级
    local lastSection = Player.Chapter.lastSection --普通关卡小节
    local row = TableReader:TableRowByID("heroChapter", id)
    if row.unlock_chapter > lastChapter then
        tipsShowStr=string.gsub(TextMap.GetValue("LocalKey_807"),"{0}",row.unlock_chapter)
        tipsShowStr=string.gsub(tipsShowStr,"{1}",row.unlock_section)
        row = nil
        return false
    end
    if row.unlock_chapter == lastChapter and row.unlock_section >= lastSection then
        tipsShowStr=string.gsub(TextMap.GetValue("LocalKey_807"),"{0}",row.unlock_chapter)
        tipsShowStr=string.gsub(tipsShowStr,"{1}",row.unlock_section)
        row = nil
        return false
    end
    row = nil
    return true
end

--打开界面，设置值
function m:setData()
    objs = self.data
	
	local totelTimes = m:getTotaltimes()
    self.imgIcon.spriteName = "chapter_diff" .. self.index
    if totelTimes > 0 then
        --self.times.text = "可免费挑战"
    end
	
    if m:isHaveUnlock(self.data.id) then
        self.txtHint.gameObject:SetActive(false)
		self.imgIcon.color = Color(255, 255, 255)
        islock = true
    else
	    self.txtHint.gameObject:SetActive(true)
		self.imgIcon.color = Color(0.5, 0.5, 0.5)
        islock = false
	end
	
	self.txtName.text = m:getDiffName()
    
end

function m:getDiffName()
	return diffText[self.index]
end

function m:update(lua)
	self.data = lua.data
	self.index = lua.index
    m:setData()
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

-- lzh 2015.05.07
-- 获取可挑战的次数
function m:getTotaltimes()
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

return m
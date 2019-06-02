-- 敌方入侵
local m = {}
-- 1 正在入侵， 2 已被打败
function m:update(lua, index, delegate)
	self.delegate = delegate
	self.data = lua
	local section = lua.section
	local chapterId = lua.cid
	self.tbData = TableReader:TableRowByUniqueKey("invadeChapter", chapterId, section)
	local tb = self.tbData
	--local hard = TableReader:TableRowByUniqueKey("hardChapter", tb.chapterID, 1)
	local avter = TableReader:TableRowByID("avter", tb.model)  
	self.txt_chapter_name.text = Tool.getNameColor(tb.star) .. string.gsub(TextMap.GetValue("LocalKey_667"),"{0}",tb.chapterID) .. "[-]"
	self.txt_name.text = tb.name .. TextMap.GetValue("Text_1_199")
	self.name = tb.name
	self.img_frame.spriteName = Tool.getFrame(tb.star)
	self.img_bg.spriteName = Tool.getBg(tb.star)
	self.pic:setImage(avter.head_img,"headImage")
	-- 已被打败
	self.img_killed:SetActive(self.data.status == 2)
	self:isGray(self.data.status == 2)
end

function m:isGray(isGray)
	if isGray == true then
		self.pic:isShowGray(true)
		self.img_frame.spriteName = "kuang_baise"
		self.img_bg.spriteName="tubiao_1"
	end
end

function m:Start()

end

function m:onClick(go, name)
    if name == "btnCell" then
		-- 跳转章节
		if self.data.status == 1 then
			local chapterFight = require("uLuaModule/modules/chapter/uChapterFight.lua")
			chapterFight.Show("invadeChapter", self.data.cid, self.data.section, 0, self.name)
			self.delegate:gotoChapter(self.tbData.chapterID)
		elseif self.data.status == 2 then 
			MessageMrg.showMove(TextMap.GetValue("Text_1_200"))
		end 
    end
end

return m


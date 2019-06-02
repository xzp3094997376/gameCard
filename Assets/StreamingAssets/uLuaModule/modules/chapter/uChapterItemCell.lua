--chapterTips = require("uLuaModule/modules/chapter/uChapterTips.lua")
local chapterItemCell = {}
local tipPanell = {}

-- function chapterItemCell:onPress(go, name, bool)
--     if bool == true then
--         local postions = self.itemPostion.beginGetPosition
--         tipPanell = chapterTips:show(self.itemVO, "item", postions.x, postions.y + self.char_kuang.height / 2)
--     else
--         if tipPanell~=nil then
--            tipPanell:CallTargetFunction("destory")
--         end
--     end
-- end


function chapterItemCell:updateItem()
    self.char_kuang.gameObject:SetActive(false)

    if self.infobinding == nil then
        self.infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.char)
    end
    self.infobinding:CallUpdate({ "itemvo", self.itemVO, self.char_kuang.width, self.char_kuang.height,true})
    if self.itemVO.isShowName ~= nil and self.itemVO.isShowName == false then
        return
    else
        self.Label.text = self.itemVO.itemColorName
    end
	if self.itemVO.isShowName then 
		self.Label.gameObject:SetActive(true)
	else 
		self.Label.gameObject:SetActive(false)
	end
	if self.itemVO.minDrop ~= nil then 
		if self.itemVO.maxDrop ~= nil then 
			self.txt_count.text = self.itemVO.minDrop .. "~" .. self.itemVO.maxDrop
		else 
			self.txt_count.text = self.itemVO.minDrop
		end
		self.infobinding:CallManyFrame(function()
			self.infobinding:Hide("shuliang")
		end, 1)
		--self.infobinding:CallUpdate({ "itemvo", self.itemVO, self.char_kuang.width, self.char_kuang.height, true }) --:Hide("shuliang") -- target.shuliang.gameObject:SetActive(false)		
	else 
		if self.txt_count then 
			self.txt_count.text = ""
		end
		self.infobinding:CallManyFrame(function()
			self.infobinding:Show("shuliang")
		end, 1)
	end 
end

function chapterItemCell:update(table)
    self.itemVO = table
	--print_t(self.itemVO)
    chapterItemCell:updateItem()
end

--初始化
function chapterItemCell:create(binding)
    self.binding = binding

    return self
end

return chapterItemCell
-- 通关奖励页面
local m = {}

function m:update(datas)
    print("datas.chaperProgress")
    print(datas.chaperProgress)
    self.chaperProgress = datas.chaperProgress
    self.data = datas
    --
    self:setCurChapterName()
    -- 读取副本章节奖励
    self.datas = {}
    TableReader:ForEachLuaTable("Guild_chapter_reward", function(index, item)
        local data = {}
        data.isGotReward = self:IsGotReward(item.id)
        data.chaperProgress = self.chaperProgress
        data.row = item
        table.insert(self.datas, data)
        return false
    end)
    self.svChapterRewardList:refresh(self.datas, self, true, 0)
end

function m:onClick(go, btnName)
    if btnName == "btn_close" then
        UIMrg:popWindow()
    end
end

function m:setCurChapterName(...)
    local _curChapterId = tonumber(self.chaperProgress)
    TableReader:ForEachLuaTable("GuildCopy", function(index, item)
        local _chapterId = tonumber(item.chapterId)
        if _chapterId == _curChapterId then
            --self.txt_jindu.text = item["$chapter"]
            self.txt_jindu.text =TextMap.GetValue("LocalKey_413") .. "[DFEC00]" .. item["chapterName"] .. "[-]"
            return true
        end
        return false
    end)
end

-- 是否已经领过
function m:IsGotReward(chapterId)
    local t = GuildDatas:getGuildRewardStatus().chapter
    local count = 0
    if t ~= nil then
        count = t.Count
    end
    print("count" .. t.Count)
    for i = 0, count do
        if chapterId == t[i] then
            return true
        end
    end
    return false
end

return m
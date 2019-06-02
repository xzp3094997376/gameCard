local chapterName = {}
local isLock = false
--选章节
function chapterName:onClick()
    if isLock then
        MessageMrg.show(TextMap.GetValue("Text509"))
        return
    end
    self.data.fun(self.data.chapterIndex)
    self.data:destory()
    self.data = nil
end

function chapterName:update(tables)
    if tables == nil then
        self.allGo:SetActive(false)
        return
    end
    self.allGo:SetActive(true)
    self.data = tables
    BlackGo.setBlack(1, self.chapterName.transform)
    local obj = TableReader:TableRowByUniqueKey("chapter", self.data.chapterIndex, tables.chapterType)
    local tasks = Player.Tasks:getLuaTable() --任务表
    local taskid = obj["taskID"]
    if tasks[taskid] ~= nil and tasks[taskid].state == 2 then
        self.red_point:SetActive(true)
    else
        self.red_point:SetActive(false)
    end
    tasks = nil
    local someting = UluaModuleFuncs.Instance.uOtherFuns:DivisionStr(obj.name, ":")
    self.lock:SetActive(true)
    self.chaptetName_txt.text = someting[2]
    self.chaptetIndex_txt.text = someting[1]
    self.simpleImage.Url = UrlManager.GetImagesPath("chapterImage/" .. obj.bgimage .. ".png")
    if tables.chapterType == "commonChapter" then
        local lvl = obj.unlock["0"].unlock_arg
        if self.data.chapterIndex > Player.Chapter.lastChapter or lvl > Player.Info.level then
            BlackGo.setBlack(0.5, self.chapterName.transform)
            isLock = true
        else
            isLock = false
            self.lock:SetActive(false)
        end
    elseif tables.chapterType == "hardChapter" then
        if self.data.chapterIndex > Player.HardChapter.lastChapter then
            BlackGo.setBlack(0.5, self.chapterName.transform)
            isLock = true
        else
            isLock = false
            self.lock:SetActive(false)
        end
    end
end

function chapterName:create(binding)
    self.binding = binding
    return self
end

return chapterName

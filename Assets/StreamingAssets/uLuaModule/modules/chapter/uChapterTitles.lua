local chapterTitle = {}
local listData = {}
function chapterTitle:destory()
    UIMrg:popWindow()
end

function chapterTitle:onClick()
    chapterTitle:destory()
end

function chapterTitle:update(tables)
    self.data = tables
    local totelcount = TableReader:getTableRowCount("chapter") / 2 --获得表格行数
    if tables.chapter_type == "commonChapter" then
        self.titleLabel.text = TextMap.GetValue("Text510")
        self.titleSprite.spriteName = "simple_normal"
    elseif tables.chapter_type == "hardChapter" then
        self.titleLabel.text = TextMap.GetValue("Text511")
        self.titleSprite.spriteName = "diff_normal"
    end
    for i = 1, totelcount do
        local tempdata = {}
        tempdata.destory = chapterTitle.destory
        tempdata.chapterIndex = i
        tempdata.fun = tables.fun
        tempdata.view = tables.view
        tempdata.chapterType = tables.chapter_type
        table.insert(listData, tempdata)
        tempdata = nil
    end
    self.binding:CallAfterTime(0.05,
        function()
            self.scrollview:refresh(listData, self)
        end)
end

function chapterTitle:create(binding)
    self.binding = binding
    return self
end

return chapterTitle

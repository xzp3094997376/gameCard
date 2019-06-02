chapterMonsterVo = {
    monsterObj = {},
    monsterIndex = 0,
    monserStageLvlStr = "",
    monserLvlSte = "",
    monserLevel = 1,
    monsterImg = "",
    monstrStageColor = "",
    isBoss = 0
}

function chapterMonsterVo:init(tableName, key, value, isBoss, monsterIndex)
    self.monsterIndex = monsterIndex
    if isBoss == -1 then
        self.monserLvlSte = -1 --表示该位置没有人
        return
    end
    self.monsterObj = TableReader:TableRowByUnique(tableName, key, value)
    local obj = TableReader:TableRowByUnique("powerColor", "stage", self.monsterObj._stage.color)
    self.monstrStageColor = obj.frameSpriteName
    self.monserLevel = self.monsterObj.level
    self.monserStar = self.monsterObj.star
    self.monsterImg = self.monsterObj._model_id.head_img --头像改了读表方式
    self.monsterStageLvl = self.monsterObj._stage.level
    if obj.level ~= nil and obj.level ~= "" then
        self.monserStageLvlStr = "[" .. self.monsterObj._stage.colorRGB .. "]+" .. obj.level .. "[-]"
    else
        self.monserStageLvlStr = "[" .. self.monsterObj._stage.colorRGB .. "]"
    end
    self.isBoss = isBoss
    if isBoss == 1 then
        self.monserLvlSte = "Lv." .. self.monsterObj.level .. "  " .. "[ff00ff]BOSS[-]"
    else
        self.monserLvlSte = "Lv." .. self.monsterObj.level
    end
end

function chapterMonsterVo:new(tableName, key, value, isBoss, monsterIndex)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(tableName, key, value, isBoss, monsterIndex)
    return o
end

return chapterMonsterVo

chapterTips = require("uLuaModule/modules/chapter/uChapterTips.lua")
local chapterMonsterCell = {}
local tipPanell = {}

function chapterMonsterCell:onPress(go, name, bool)
    if self.monsterVo.monserLvlSte == -1 then
        return
    end
    if bool == true then
        local postions = self.itemPostion.beginGetPosition
        tipPanell = chapterTips:show(self.monsterVo, "monster", postions.x, postions.y + self.item_kuangzi.height / 2)
    else
        tipPanell:CallTargetFunction("destory")
    end
end

function chapterMonsterCell:updateMonster()
    self.item_kuangzi.gameObject:SetActive(false)
    if self.monsterVo.monserLvlSte ~= -1 then
        self.Sprite:SetActive(false)
        self.Label:SetActive(true)
        local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.chapterMonsterCell)
        infobinding:CallUpdate({ "monstervo", self.monsterVo, self.item_kuangzi.width, self.item_kuangzi.height })
        if self.monsterVo.isBoss ~= 1 then
            self.Label:SetActive(false)
        end
    else
        self.Sprite:SetActive(true)
        self.Label:SetActive(false)
    end
end

--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@table 列表容器
function chapterMonsterCell:update(table)
    self.monsterVo = table
    chapterMonsterCell:updateMonster()
end

--初始化
function chapterMonsterCell:create(binding)
    self.binding = binding
    return self
end

return chapterMonsterCell
local unifPeoplecell = {}

function unifPeoplecell:setCheckinData()
end

function unifPeoplecell:update(tableData, index)
    self.data = tableData
    --self.img_heimage.spriteName=
    self.txt_menmbername.text = tableData.name
    self.txt_lv.text = tableData.lvl
    self.txt_zhiwu.text = tableData.zhiwei
end

function unifPeoplecell:onClick(go, name)
    if self.data.type ~= "setting" then
        return
    end
    if unionSetting.peopleCell ~= nil then
        unionSetting.peopleCell.spriteName = "tongyong_fudongk"
    end
    unionSetting.peopleCell = self.img_di1
    unionSetting.peopleCell.spriteName = "tongyong_fudongdb"
    unionSetting.peopleID = 1
end

--初始化
function unifPeoplecell:create(binding)
    self.binding = binding
    return self
end

return unifPeoplecell
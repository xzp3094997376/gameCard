--未加入公会的界面
local unifcell = {}

function unifcell:setCheckinData()
end

function unifcell:update(tableData, index)
    self.data = tableData
    --self.img_unionicon.spriteName=
    self.unifname.text = tableData.name
    self.txt_lv.text = tableData.needlvl
    self.txt_description.text = tableData.desc
    self.numfnumber.text = tableData.number
end

function unifcell:onClick(go, name)
    if name == "btn_join" then
        --      print("加入"..self.data.id)
    end
end

--初始化
function unifcell:create(binding)
    self.binding = binding
    return self
end

return unifcell
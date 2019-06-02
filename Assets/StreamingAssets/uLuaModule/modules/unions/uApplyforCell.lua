--未加入公会的界面
local unifApplycell = {}

function unifApplycell:setCheckinData()
end

function unifApplycell:update(tableData, index)
    self.data = tableData
    --self.img_heimage.spriteName=
    self.txt_menmbername.text = tableData.name
    self.txt_lv.text = tableData.lvl
    self.applyforCell.name = index
end

function unifApplycell:onClick(go, name)
    if name == "btn_reject" then
        --   print("同意")
    else
        --    print("拒绝")
    end
    self.data.fun:doresult(self.data.id)
end

--初始化
function unifApplycell:create(binding)
    self.binding = binding
    return self
end

return unifApplycell
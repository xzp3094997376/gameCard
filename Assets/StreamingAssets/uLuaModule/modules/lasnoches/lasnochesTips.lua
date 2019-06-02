local lasnochesTips = {}

--设置基本信息
function lasnochesTips:setData()
end

function lasnochesTips:update(tableData)
    self.data = tableData
    self.moneyLab.text = tableData.money
end

function lasnochesTips:onClick(go, name)
    if name == "closeBtn" then
        UIMrg:popWindow()
    end
end

--初始化
function lasnochesTips:create(binding)
    self.binding = binding
    return self
end

return lasnochesTips
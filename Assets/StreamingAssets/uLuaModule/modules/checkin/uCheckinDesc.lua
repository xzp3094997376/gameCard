local checkindesc = {}

--初始化界面
function checkindesc:Start()
    local obj = TableReader:TableRowByID("moduleExplain", 1) --到时候改成3或者4
    if obj ~= nil then
        self.Label.text = string.gsub(obj.desc, '\\n', '\n')
    end
end

function checkindesc:onClick(go, name)
    UIMrg:popWindow()
end

--初始化
function checkindesc:create(binding)
    self.binding = binding
    return self
end

return checkindesc
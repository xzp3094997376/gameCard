local help = {}

function help:update(...)
    --读表显示内容
    local helpId = 4
    local obj = TableReader:TableRowByID("moduleExplain", helpId)
    if obj ~= nil then
        self.txt_rule.text = string.gsub(obj.desc, '\\n', '\n')
    else
        self.txt_rule.text = TextMap.GetValue("Text1376")
    end
end

function help:onClick(go, name)
    --   UluaModuleFuncs.Instance.uTimer:removeFrameTime("sureArenaDesc")
    UIMrg:popWindow()
end

return help
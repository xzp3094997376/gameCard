local m = {}

function m:update(id)

    local obj = TableReader:TableRowByID("moduleExplain", id[1])
    if obj ~= nil then
        self.txt_rule.text = string.gsub(obj.desc, '\\n', '\n')
        self.title.text = obj.type
    end
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

return m

--UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule",{5})
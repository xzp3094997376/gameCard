local lasnochesDes = {}


function lasnochesDes:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

function lasnochesDes:create()
    return self
end

function lasnochesDes:Start()
    local obj = TableReader:TableRowByID("moduleExplain", 2)
    if obj ~= nil then
        self.txt_rule.text = string.gsub(obj.desc, '\\n', '\n')
    end
end

return lasnochesDes
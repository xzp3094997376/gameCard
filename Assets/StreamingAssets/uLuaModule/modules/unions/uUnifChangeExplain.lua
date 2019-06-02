local unionChangeExplain = {}

function unionChangeExplain:destory()
    self.obj = nil
    unionChangeExplain = nil
    UIMrg:popWindow()
end

function unionChangeExplain:onClick(go, name)
    if name == "okBtn" then
        if self.Label.text ~= "" then
            self.obj["label"].text = self.Label.text
        else
            MessageMrg.show(TextMap.GetValue("Text1436"))
            return
        end
    end
    unionChangeExplain:destory()
end


function unionChangeExplain:update(obj)
    self.obj = obj
end


function unionChangeExplain:create(binding)
    self.binding = binding
    return self
end

return unionChangeExplain
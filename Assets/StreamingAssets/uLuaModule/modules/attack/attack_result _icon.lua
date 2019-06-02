-- 比武结果icon
local m = {}

function m:Start(...)
    self.title_1 = TextMap.GetValue("Text1722")
    self.title_2 = TextMap.GetValue("Text1723")
    self.title_3 = TextMap.GetValue("Text1724")
end

function m:update(data,index,delegate)
    if data == nil then return end
    for i=1,3 do
        if data[i] ~= nil then
            self["txt_name_"..i].text = self["title_"..i]..data[i].name.."  [00ff00]["..data[i].sid.."][-]"
        end
    end
    if data.index ~= nil then
        self.txt_title.text = data.index..TextMap.GetValue("Text1721")
    end
end

function m:onClick(go, name)

end

return m
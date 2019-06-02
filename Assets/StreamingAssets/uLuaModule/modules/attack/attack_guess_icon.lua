-- 比武历史竞猜icon
local m = {}

function m:Start(...)
    self.group = {"A","B","C","D","E","F","G","H"}
end

function m:update(data,index,delegate)
    self.data = data
    self.delegate = delegate

    local title = ""
    if data.topNum == 2 then      --总决赛
        title = TextMap.GetValue("Text1689")
    elseif data.topNum == 3 then  --三四名决赛
        title = TextMap.GetValue("Text1690")
    elseif data.topNum == 4 then
        if data.group <= 1 then
            title = TextMap.GetValue("Text1691")
        else
            title = TextMap.GetValue("Text1692")
        end
    else
        if data.topNum/4 >= data.group then --上半区
            title = TextMap.GetValue("Text1693")..(data.topNum/2)..TextMap.GetValue("Text1694")..self.group[data.group]..TextMap.GetValue("Text1695")
        else                                                  --下半区
            title = TextMap.GetValue("Text1696")..(data.topNum/2)..TextMap.GetValue("Text1694")..self.group[data.group-data.topNum/4]..TextMap.GetValue("Text1695")
        end
    end
    title = title..data.nth
    self.title = title
    self.txt_title.text = title
end

function m:onClick(go, name)
    if name == "button" then 
        local temp = {}
        temp.info = self.data
        temp.title = self.title
        temp.delegate = self.delegate
        UIMrg:pushWindow("Prefabs/moduleFabs/attack/attack_guess_info", temp)
    end
end

return m
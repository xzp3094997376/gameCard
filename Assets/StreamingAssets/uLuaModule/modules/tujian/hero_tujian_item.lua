local m = {} 

function m:update(data,index,delegate)
    self.index = index
    self.char = data.char
    self.type=data.type
    self.delegate = delegate
    self.typeName.text=self:getItemColorName(self.type)
    self.charList=self:GetData()
    self.scrollview:refresh(self.charList,self,true,0)
    self:setHaveNum()
end

function m:GetData()
    local index = 1
    local List={}
    local charList={}
    self.hasNum=0
    for i=1,#self.char do
        if Player.CharsShows[self.char[i].dictid] ==1 then 
            self.hasNum=self.hasNum+1
        end 
        table.insert(List,self.char[i])
        index=index+1 
        if index>7 then 
            table.insert(charList,List)
            List={}
            index=1
        end 
    end 
    if #List>0 then 
        table.insert(charList,List)
    end 
    return charList
end

function m:setHaveNum()
    self.num.text=self.hasNum .. "/" ..#self.char
end

function m:getItemColorName(type)
    local _names = names
    if type == 1 then
        _names = TextMap.GetValue("Text_1_2817")
    elseif type == 2 then
        _names = TextMap.GetValue("Text_1_2818")
    elseif type == 3 then
        _names = TextMap.GetValue("Text_1_2819")
    elseif type == 4 then
        _names = TextMap.GetValue("Text_1_2820")
    elseif type == 5 then
        _names = TextMap.GetValue("Text_1_2821")
    elseif type == 6 then
        _names = TextMap.GetValue("Text_1_2822")
    end
    return _names
end

return m
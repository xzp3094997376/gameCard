-- 比武历史详情
local m = {}

function m:Start(...)
end

function m:update(data)
    if data == nil then return end
    self.temp = {"A. ","B. ","C. ","D. "}
    self.data = data
    self.info = data.info
    self.delegate = data.delegate
    self.txt_title.text = "["..data.title.."]"
    local id = self.info.question_id
    local row = TableReader:TableRowByID("quiz", id)
    if row ~= nil then 
        self.txt_contest.text = row.question_desc
        for i=1,4 do
            if row["show_arg"..i] ~= nil and row["show_arg"..i] ~="" then
                self["txt_answer_"..i].gameObject:SetActive(true)
                self["txt_answer_"..i].text = self.temp[i]..row["show_arg"..i]
            else
                self["txt_answer_"..i].gameObject:SetActive(false)
            end
        end
    end

    --您的答案
    if self.delegate ~= nil then
        if self.delegate.result ~= nil then
            local id = self.info.topNum..self.info.nth
            if self.delegate.result[id] ~= nil then --有答案
                local index = self.delegate.result[id].index
                self.txt_yours.text = TextMap.GetValue("Text1697")..self.temp[index]..row["show_arg"..index]
            else                                                  --无答案
                self.txt_yours.text = TextMap.GetValue("Text1698")
            end
        else
            self.txt_yours.text = TextMap.GetValue("Text1698")
        end
    else
        self.txt_yours.text = TextMap.GetValue("Text1698")
    end
    --正确答案
    local index = tonumber(self.info.index)
    if index ~= nil and self.info.index ~= 0 then
        self.txt_correct.text = TextMap.GetValue("Text1699")..self.temp[index]..row["show_arg"..index]
    else
        self.txt_correct.text = TextMap.GetValue("Text1699")..self.temp[1]..row["show_arg1"]
    end
end

function m:onClick(go, name)
    if name == "btn_close" then 
        UIMrg:popWindow()
    end
end

return m
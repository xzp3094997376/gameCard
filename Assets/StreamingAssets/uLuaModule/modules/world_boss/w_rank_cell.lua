local m = {}

function m:update(data)
    if self.txt_no then
        self.txt_no.text = data.no
    end
    self.txt_name.text = data.name
    self.txt_dps.text = data.dps
    if self.txt_no_rank then
        self.txt_no_rank.text = ""
        if data.name == "" and data.dps == "" then
            self.txt_no_rank.text = TextMap.GetValue("Text1134")
        end
    end
    if self.bg ~= nil then
        if data.index ~= nil and data.index % 2 == 0 then
            self.bg.gameObject:SetActive(true)
        else
            self.bg.gameObject:SetActive(false)
        end
    end

end

return m
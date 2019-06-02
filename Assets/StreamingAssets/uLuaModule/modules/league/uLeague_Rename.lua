local LeagueReName = {} 


function LeagueReName:update(table)
    --公会的名字
    table = table or {}
    self.guildname = table.guildname

    self.input_name.value = self.guildname
    self.delegate = table

    --读表确定消耗
    local league_NameChange_cost = TableReader:TableRowByID("GuildSetting", "league_NameChange_cost")
    local league_NameChange_donate_cost = TableReader:TableRowByID("GuildSetting", "league_NameChange_donate_cost")
    
    if league_NameChange_cost == nil then
        self.rename_cost = 1
    else
        self.rename_cost = league_NameChange_cost.args2
    end

    if league_NameChange_donate_cost == nil then
        self.rename_donate_cost = 1000
    else
        self.rename_donate_cost = league_NameChange_donate_cost.args2
    end
    
    self.have_count = Player.ItemBagIndex[league_NameChange_cost.args1].count
    local msg = string.gsub(TextMap.GetValue("LocalKey_726"),"{0}",self.rename_cost)
    self.isOk.text =string.gsub(msg,"{1}",self.rename_donate_cost) 
  
end

function LeagueReName:onClick(go, btName)
    local newName = self.input_name.value
    local len = self:checkLeagueNameLen(newName)
    if btName == "btn_ensure" then
        if self.input_name.value == "" then
            MessageMrg.show(TextMap.GetValue("Text1288"))
        elseif len > 12 then
            MessageMrg.show(TextMap.GetValue("Text1151"))
        elseif newName == self.guildname then
            self:onDestory()
        else
            if self.have_count < self.rename_cost then
                if Player.Resource.donate < self.rename_donate_cost then
                    MessageMrg.show(TextMap.GetValue("Text1289"))
                else
                    DialogMrg.ShowDialog(string.gsub(TextMap.GetValue("LocalKey_728"),"{0}",self.rename_donate_cost), function()
                         Api:changeGuildInfo(4,newName, function(result)
                            if self.delegate.refresh then
                                self.delegate:refresh()
                            end
                            self:onDestory()
                            end, function(ret)
                                return false
                        end)
                    end)
                end
            else
                Api:changeGuildInfo(4,newName, function(result)
                    if self.delegate.refresh then
                        self.delegate:refresh()
                    end
                    self:onDestory()
                end, function(ret)
                    return false
                end)
            end
        end
    elseif btName == "btn_cancel" then
        self:onDestory()
    end
end

-- 协会名称长度限制为1~12字符,即1~6个汉字或1~12个字母,数字
function LeagueReName:checkLeagueNameLen(str)
    if str == nil or type(str) ~= "string" then
        return 0
    end
    local length = 0
    local lenOfByte = #str or 0
    local i = 1
    while i <= lenOfByte do
        local curByte = string.byte(str, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1
            length = length + 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
            length = length + 2
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
            length = length + 2
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
            length = length + 2
        end
        i = i + byteCount
    end
    return length
end


function LeagueReName:onDestory(ret)
    if (ret and self.delegate.onClose) then return end
    UIMrg:popWindow()
    if self.delegate.onClose then
        self.delegate:onClose()
    end
end

return LeagueReName
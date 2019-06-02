local m = {} 
local timerId = 0

function m:update(data)
    self.uid = data.name
    self.delegate = data.delegate
    self.Label_dis.text = self.uid
    self.AccountView.gameObject:SetActive(false)
    self.time = 5
    self.uidIndex = 1
    m:showHisAccount()
    m:timeset()
end

function m:timeset()
    LuaTimer.Delete(timerId)
    timerId = LuaTimer.Add(0, 1000, function()
            self.time = self.time - 1
            self.Label_Time.text = self.time
            if self.time <= 0 then
                LuaTimer.Delete(timerId)
                UIMrg:popWindow()
                self.delegate:choiseACuLogin(self.uidIndex, self.uid, false)--5秒内没有反应直接登录账号
            end
        end)
end

function m:showHisAccount()
    self.accountList = {}
    for i = 10, 1, -1 do
        local str = PlayerPrefs.GetString("uid"..i)
        if string.len(str) > 0 then
            if str == self.uid then
                table.insert(self.accountList, 1, {name = str, delegate = self.delegate, index = i})
                self.uidIndex = i
            else
                table.insert(self.accountList, {name = str, delegate = self.delegate, index = i})
            end
        end
    end
    table.insert(self.accountList, {name = TextMap.GetValue("Text_1_932"), delegate = self.delegate, isRegist = true, index = #self.accountList + 1})
end


function m:onExit()
    LuaTimer.Delete(timerId)
end

function m:onClick(go, name)
    if name == "btn_change" then
        LuaTimer.Delete(timerId)
        self.AccountView.gameObject:SetActive(true)
        self.Grid:refresh(self.item, self.accountList)
    elseif name == "Btn_closeView" then
        self.AccountView.gameObject:SetActive(false)
        self.time = 5
        m:timeset()
    end
end

return m
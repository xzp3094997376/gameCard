--奖励角色
local RewardChar = {}
--确定
function RewardChar:onOk(go)
    UluaModuleFuncs.Instance.uTimer:removeSecondTime("gotonext")
    if self.cb ~= nil then
        self.cb()
    end
end

--更新角色信息
function RewardChar:update(luaTable)
    self.char = luaTable.char
    self.cb = luaTable.cb
    self.auto = luaTable.auto
	self.isShowInfo = luaTable.isShowInfo
    if luaTable.char.isDes ~= nil then 
        self.isDes=luaTable.char.isDes
    else
        self.isDes=true
    end
    if self .isDes==true then 
        self.bg:SetActive(true)
    else
        self.bg:SetActive(false)
    end
	
	if self.isShowInfo ~= nil and self.isShowInfo == true then 
		self.hero_info.gameObject:SetActive(true)
	else 
		self.hero_info.gameObject:SetActive(false)
	end 

    Events.Brocast('Next_hide')
    local tp = self.char:getType()
    if (tp == "charPieceSplit") then
        self.binding:Show("tips")
        self.txt_name.text = self.char.Table.name
        self.tips.text = string.gsub(TextMap.TXT_CHAR_TO_PIECE_COUNT, "{0}", self.char.rwCount)
    else
        self.binding:Hide("tips")
    end

    ------------------------------------------------------------------- fix at 2015年5月6日 去掉星星,加名字颜色------------------------------------------------------------------------------
    local na = self.char.name
    if tp == "charPiece" or tp == "charPieceSplit" then
        na = na .. " x" .. self.char.rwCount
    end
    self.txt_name.text = Tool.getNameColor(self.char.star) .. na .. "[-]"
    local star = self.char.star

    if star >= 5 then
        self.binding:Hide("hero")
        self.zhaohuan_door:SetActive(true)
        MusicManager.playByID(24)
        self.binding:CallAfterTime(2.5, function()
            self.effectZhaokai:SetActive(true)
            --self.binding:CallAfterTime(0.1, function()
                self.zhaohuan_door:SetActive(false)
                self.bg_black:SetActive(false)
                if self.char.star==4 then
                    self.effectZi:SetActive(true)
                elseif self.char.star==5 then
                    self.effectHuang:SetActive(true)
                elseif self.char.star==6 then
                    self.effectHong:SetActive(true)
                end
                self.binding:Show("hero")
                self.ani:ResetToBeginning()
                if self.char:getType()=="char" then 
                    self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 0, 1)
                else 
                    self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 100, 1)
                end 
                self.binding:CallAfterTime(0.2, funcs.handler(self, self.showModel))
                self.binding:CallAfterTime(0.8,function ()
                    self.effectZhaokai:SetActive(false)
                    Events.Brocast('Next_show')
                    end)
                end)
        
        if star ~= nil and star > 3 then
        local time = 0.8
        if star > 4 then
            time = 3
        end
        if tp ~= "char" then return end 
        local soundInfo = TableReader:TableRowByID("avter", self.char.dictid)
        if soundInfo.jianjie_audio ~= nil and soundInfo.jianjie_audio ~= "" and soundInfo.jianjie_audio > 0 then
            self.binding:CallAfterTime(time, function()
                 MusicManager.playByID(soundInfo.jianjie_audio)
           end)
        end
    end
            --end)
    else
       -- self.binding:Hide("btn_queding")
        self.binding:Hide("hero")
        self.effectZhaokai:SetActive(true)
        MusicManager.playByID(23) --五星及以下英雄木有开门的特效
        --self.binding:CallAfterTime(0.1, function()
            self.bg_black:SetActive(false)
            if self.char.star >3 then 
                if self.char.star==4 then
                    self.effectZi:SetActive(true)
                elseif self.char.star==5 then
                    self.effectHuang:SetActive(true)
                elseif self.char.star==6 then
                    self.effectHong:SetActive(true)
                end
                self.binding:Show("hero")
                self.ani:ResetToBeginning()
                if self.char:getType()=="char" then 
                    self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 0, 1)
                else 
                    self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 100, 1)
                end 
                self.binding:CallAfterTime(0.2, funcs.handler(self, self.showModel))
                self.binding:CallAfterTime(0.8,function ()
                    self.effectZhaokai:SetActive(false)
                    Events.Brocast('Next_show')
                    end)
            else
                self.binding:Show("hero")
                self.ani:ResetToBeginning()
                if self.char:getType()=="char" then 
                    self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 0, 1)
                else 
                    self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 100, 1)
                end 
                self.binding:CallAfterTime(0.2, funcs.handler(self, self.showModel))
                self.binding:CallAfterTime(0.8,function ()
                    self.effectZhaokai:SetActive(false)
                    Events.Brocast('Next_show')
                end)
            end
        --end)
    end
end

function RewardChar:showModel()
    self.ani.enabled = true
    if self.char.star >= 6 then
        if self.isDes == true then
            self.Next.gameObject:SetActive(true)
        end
        return
    end
    if self.char.star < 6 then
        if self.isDes == true then
            self.Next.gameObject:SetActive(true)
        end
    end
end

--点击事件
function RewardChar:onClick(go, name)
    print (name)
    if name == "hero_info" then
        self:showInfo()
    else
        if self.cb then 
            self.cb() 
        end
    end
end

function RewardChar:showInfo()
    if self.char == nil then return end
    local char = self.char
    char.isGo=false
    Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info_two", char)
end


local leftTimes = 0
function RewardChar:Start()
    self.binding:Hide("char_star")
    --self.bg_black:SetActive(true)
     if self._keyMap["isEditor"] == 1 then
        self.hero:LoadByModelId(1, "idle", function() end, false, 0, 1)
  end
end



function RewardChar:show(char,cb)
    local luaTable = { char = char, cb = cb}
    UIMrg:pushWindow("Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
end

return RewardChar
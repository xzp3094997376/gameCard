local saodang = {}
local maxCount = 0
local showCount = 0
local linkData = {}
local timerId = 0

function saodang:update(tempdata)
    self._chapterType = tempdata._chapterType
    if self._chapterType == "commonChapter" then
        linkData = Tool.readSuperLinkById( 129)
    elseif self._chapterType == "hardChapter" then
        linkData = Tool.readSuperLinkById( 130)
    elseif self._chapterType == "heroChapter" then
        linkData = Tool.readSuperLinkById( 131)
    end
    if linkData ~= nil then
        local lockArg = linkData.unlock[0].arg
        local lockType = linkData.unlock[0].type
        local lockdes = linkData.from
        if lockType == "level" then
            if Player.Info.level < lockArg then
                local msg = string.gsub(TextMap.GetValue("LocalKey_664"),"{0}",lockArg)
                MessageMrg.show(string.gsub(msg,"{1}",lockdes))
                linkData = nil
                UIMrg:popWindow()
                return
            end
        end
        if lockType == "vip" then
            if Player.Info.vip < lockArg then
                MessageMrg.show("VIP" .. lockArg .. "," .. lockdes)
                linkData = nil
                UIMrg:popWindow()
                return
            end
        end
    end
    linkData = nil
    self._senceID = tempdata._senceID
    self.saodangDeVip = tempdata._saodangDeVip
    self.saodangMulVIP = tempdata._saodangMulVIP
    self.go = tempdata._go
    self._target = tempdata._targert
    self._needdp = tempdata._needdp
    --self.SDQ = Player.ItemBagIndex[26].count   
    self.saodangNeed.text = TextMap.GetValue("Text_1_222").. self._needdp ..TextMap.GetValue("Text_1_223")
    self:limitNum()
    self.numberSelect:maxNumValue(maxCount) --传过去最大值
    self.numberSelect.selectNum = showCount
    self.numberSelect:setCallFun(saodang.setMoneyChange, self)
end

function saodang:setMoneyChange()
    showCount = tonumber(self.selectNum.text)
end

--扫荡次数设置
function saodang:limitNum()

    local chapterObj = TableReader:TableRowByID(self._chapterType, self._senceID) --拿到关卡数据
    if self._chapterType == "commonChapter" then
        maxCount = chapterObj.fight_times - Player.Chapter.status[self._senceID].fight
    elseif self._chapterType == "hardChapter" then
        maxCount = chapterObj.fight_times - Player.HardChapter.status[self._senceID].fight
    elseif self._chapterType == "heroChapter" then
        maxCount = chapterObj.fight_times - Player.HeroChapter.status[self._senceID].fight
    end

    local befor = Player.Resource.bp
    if befor >= maxCount * self._needdp then
        showCount = maxCount
    else
        showCount = befor / self._needdp
        if befor < self._needdp then
            showCount = 1
        end
    end
    chapterObj = nil
------------------------------------------------------------------------

    -- if self._chapterType == "heroChapter" then
    --     maxCount = self._target:getTotaltimes()
    -- elseif self._chapterType == "hardChapter" then
    --     local chapterObj = TableReader:TableRowByID(self._chapterType, self._senceID) --拿到关卡数据
    --     maxCount = chapterObj.fight_times - Player.HardChapter.status[self._senceID].fight
    --     if maxCount <= 0 then
    --         maxCount = 0
    --     end
    -- else
    --     maxCount = 10
    -- end

    
    -- if self.SDQ >= maxCount then
    --     showCount = maxCount
    -- else
    --     showCount = self.SDQ
    --     if self.SDQ == 0 then
    --         showCount = 1
    --     end
    -- end
end

function saodang:useSellBack()
    UIMrg:popWindow()
end

function saodang:saodangFun()
    local that = self
    local chapterObj = TableReader:TableRowByID(self._chapterType, self._senceID) --拿到关卡数据
    if chapterObj == nil then
        return
    end
    if chapterObj.consume[0].consume_arg * showCount > Player.Resource.bp then
        local cb = function()
            LuaMain:refreshTopMenu()
        end
        DialogMrg:BuyBpAOrSoul("bp", "", cb ,cb) --体力不足
        chapterObj = nil
        return
    end
    chapterObj = nil
    that:sendDaoDangAPI()
end

function saodang:sendDaoDangAPI()
    UIMrg:popWindow()
    self.uSaodangList = UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/saodang_result")  
    local saodangList = {}
    self.daxu = false
    for i=1, showCount do
            Api:sweepChapter(self._chapterType, self._senceID, 1,
            function(result)    
                table.insert(saodangList,i,result)  
                self.go = nil
                self._target:setCanFightTimes()
				print("_______________________saodang ...")
                --打开大虚
                DAXU_NAME = result.daxuName or nil
                if DAXU_NAME then
                    if self.daxu then
                    else
                        self.daxu = true
                        print(result.daxuName)
                        self.name_daxu = result.daxuName
                    end
                end 
                DAXU_NAME = nil
                if i == showCount then 
                    self.uSaodangList:CallUpdateWithArgs(saodangList)
                    if self.daxu then
                        DialogMrg.ShowFindDaxu(string.gsub(TextMap.GetValue("Text119"),"{0}",self.name_daxu ), function()
                            uSuperLink.openModule(69, 2)
                        end)
                    end
                end
            end) 
    end



    ------------------以前的
    -- Api:sweepChapter(self._chapterType, self._senceID, showCount,
    --     function(result)
    --         DAXU_NAME = result.daxuName or nil
    --         packTool:showMsg(result, self.go, 2, function()
    --             --打开大虚
    --              if DAXU_NAME then
    --                  DialogMrg.ShowFindDaxu(TextMap.getText("FindDaXu", { DAXU_NAME }), function()
    --                      uSuperLink.openModule(69, 2)
    --                  end)
    --                  DAXU_NAME = nil
    --              end
    --         end)
    --         self.go = nil
    --         self._target:setCanFightTimes()
    --         UIMrg:popWindow()
    --     end)
end





function saodang:onClick(go, name)
    if name == "btn_quxiao" or name == "SpriteClose" then
        UIMrg:popWindow()
    end
    if name == "btn_queren" then
        --UIMrg:popWindow()
        if showCount == 0 then
            MessageMrg.show(TextMap.GetValue("Text_1_224"))
        else
            saodang:saodangFun()
        end     
    end
end

--初始化
function saodang:create(binding)
    self.binding = binding
    return self
end

return saodang
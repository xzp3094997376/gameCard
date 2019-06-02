local saodangList = {}
local saodangCount = 0
local index= 0
local _chapterType = 1
local _senceID  = 0
local daxu = false
local saodangTotal = {}
function saodangList:create(binding)
    self.binding = binding;
    return self
end

function saodangList:onClick(go, name)
    if name == "btnclose" or name == "bt_wancheng" then
        self.delegate:chapterRefreashData()
        UIMrg:popWindow()
        if DialogMrg.levelUp() then
            saodangList:judgeChapterOpen()
        end
    elseif name == "bt_chongzhi" then
        saodangCount = 0
    end
end

function saodangList:judgeChapterOpen()
    local hardLockLv = Tool.readSuperLinkById(240).unlock[0].arg
    local heroLockLv = Tool.readSuperLinkById(5).unlock[0].arg
    local DailyLockLv = Tool.readSuperLinkById(10).unlock[0].arg
    if Player.Info.level == hardLockLv then 
        Events.Brocast("CheckChapterOpen")
    elseif Player.Info.level == heroLockLv then
        Events.Brocast("CheckChapterOpen", "heroChapter")
    elseif Player.Info.level == DailyLockLv then
        Events.Brocast("CheckChapterOpen", "btnDaily")
    end
end

function saodangList:Start()
	self.daxu = false
    self.item_list = {}
    index = 0
end

function saodangList:update(data)
    saodangCount = data.saodangCount
    _chapterType = data._chapterType
    _senceID = data._senceID
    self.delegate = data.delegate
    saodangTotal = {}
    self.bt_chongzhi.gameObject:SetActive(true)
    self.bt_wancheng.gameObject:SetActive(false)
    self:SendSweepChapter()
end

function saodangList:SendSweepChapter()
    Api:sweepChapter(_chapterType, _senceID, 1,
    function(result)
        saodangCount = saodangCount - 1
        index = index + 1
        local m = {}
        m.key = index
        m.saodang = result
        m.delegate = self
        table.insert(saodangTotal, result)
        local tmp = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/saodang_item", self.grid.gameObject)
        tmp:CallUpdate(m)
        self.grid.repositionNow = true
        if index > 2 then  --若个数大于三，每次添加移动一次滚动条，固定值为175
            local v = self.scrollview.gameObject.transform.localPosition
           SpringPanel.Begin(self.scrollview.gameObject,Vector3(v.x, v.y+185, v.z),10)
        end
        if saodangCount <= 0 then
            self.bt_chongzhi.gameObject:SetActive(false)
            self.bt_wancheng.gameObject:SetActive(true)
            if self.daxu then
                Events.Brocast("FindDaXu")
                if Player.DaXu.daXuId ~= nil then
                    local row = TableReader:TableRowByID("daxueMaster", Player.DaXu.daXuId)
                    local color = TableReader:TableRowByID("daxuColor", row.star)
                    self.name_daxu = color.color ..self.name_daxu .. "[-]"
                end
                DialogMrg.ShowFindDaxu(string.gsub(TextMap.GetValue("Text119"),"{0}",self.name_daxu), function()
                    UIMrg:popWindow()
                    self.delegate.closeWindow()
                    uSuperLink.openModule(69, 2)
                end)
            end
             local tempTotal = {}
            tempTotal.key = 0
            tempTotal.saodang = saodangTotal
            tempTotal.delegate = self

            local tmp = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/saodang_item", self.grid.gameObject)

            tmp:CallUpdate(tempTotal)

            self.binding:CallAfterTime(0.6, function()
                 if index > 2 then  --若个数大于三，每次添加移动一次滚动条，固定值为175
                    local v = self.scrollview.gameObject.transform.localPosition
                   SpringPanel.Begin(self.scrollview.gameObject,Vector3(v.x, v.y+185, v.z),10)
                end
            end)

        else
            self:SendSweepChapter()
        end
        --打开大虚
        DAXU_NAME = result.daxuName or nil
        if DAXU_NAME then
            if self.daxu then
            else
                self.daxu = true
                self.name_daxu = result.daxuName
            end
        end 
        --DAXU_NAME = nil
    end, function(ret)
		--print("error: " .. tostring(ret))
		self.bt_wancheng.gameObject:SetActive(true)
		self.bt_chongzhi.gameObject:SetActive(false)
	end) 
end
function saodangList:getScrollView()
    return self.scrollview;
end
return saodangList
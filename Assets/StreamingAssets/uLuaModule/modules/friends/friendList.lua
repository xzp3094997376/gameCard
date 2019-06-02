local fList = {}
local tempObj = {}

--local currentSelectType = 1 --1巅峰  2总体 3竞技场 4小资 5 土豪
local selfRank = 0
local selfPower = 0
local startType = "friendList"
local currentType = "friend"
local itemType = "friendList"
local mainUI = {} --主界面的table

function fList:Start()
    --标题
    LuaMain:ShowTopMenu()
    self:setRedPoint()
    self:getFDList()
end

function fList:onEnter()
	    --标题
    LuaMain:ShowTopMenu()
end 

--刷新主界面小红点
function fList:setMainUIRedPoint()
    local ui_root = self.gameObject.transform.root
    local goName = "/GameManager/Camera/mainUI/center/Module_main_menu/main_menu/MainUi_new"
    local mainUIGo = GameObject.Find(goName)
    if mainUIGo then
        mainUI = mainUIGo:GetComponent(UluaBinding).target
        --mainUI:setFriendRedPoint()
    end
end


function fList:update(...)
    self:getFDList()
end

function fList:create(binding)
    self.binding = binding
    return self
end

function fList:destory()
    UIMrg:pop()
end

function fList:OnDestroy()
    self:setMainUIRedPoint()
end

--申请好友
function fList:getFDRequestList(...)
    currentType = "request"
    self:SetBtSp()
    itemType = "requestFD"
    self.binding:Hide("db_getbp")
    self.binding:Hide("db_fdList")
    self.binding:Show("bg_FDNum")
    self:getData()
end

function fList:SetBtSp()
    if currentType == "friend" then
        self.Checkmark_fl:SetActive(true)
        self.Checkmark_gb:SetActive(false)
        self.Checkmark_fr:SetActive(false)
        self.Checkmark_bl:SetActive(false)
        self.scrollView.gameObject:SetActive(true)
        self.arena_bp.gameObject:SetActive(false)
        self.arena_request.gameObject:SetActive(false)
        self.arena_black.gameObject:SetActive(false)
    elseif currentType == "bp" then
        self.Checkmark_fl:SetActive(false)
        self.Checkmark_gb:SetActive(true)
        self.Checkmark_fr:SetActive(false)
        self.Checkmark_bl:SetActive(false)
        self.scrollView.gameObject:SetActive(false)
        self.arena_bp.gameObject:SetActive(true)
        self.arena_request.gameObject:SetActive(false)
        self.arena_black.gameObject:SetActive(false)
    elseif currentType == "request" then
        self.Checkmark_fl:SetActive(false)
        self.Checkmark_gb:SetActive(false)
        self.Checkmark_fr:SetActive(true)
        self.Checkmark_bl:SetActive(false)
        self.scrollView.gameObject:SetActive(false)
        self.arena_bp.gameObject:SetActive(false)
        self.arena_request.gameObject:SetActive(true)
        self.arena_black.gameObject:SetActive(false)
    elseif currentType == "black" then
        self.Checkmark_fl:SetActive(false)
        self.Checkmark_gb:SetActive(false)
        self.Checkmark_fr:SetActive(false)
        self.Checkmark_bl:SetActive(true)
        self.scrollView.gameObject:SetActive(false)
        self.arena_bp.gameObject:SetActive(false)
        self.arena_request.gameObject:SetActive(false)
        self.arena_black.gameObject:SetActive(true)
    end
end

--好友列表
function fList:getFDList(...)
    currentType = "friend"
    self:SetBtSp()
    itemType = "friendList"
    self.binding:Hide("db_getbp")
    self.binding:Show("db_fdList")
    self.binding:Show("bg_FDNum")
    self:getData()
end


--领取体力
function fList:getBPList(...)
    currentType = "bp"
    self:SetBtSp()
    itemType = "getBp"
    self.binding:Show("db_getbp")
    self.binding:Hide("db_fdList")
    self.binding:Hide("bg_FDNum")
    self:getData()
end

--黑名单列表
function fList:getBlackList(...)
    currentType = "black"
    self:SetBtSp()
    itemType = "black"

    self.binding:Hide("db_getbp")
    self.binding:Hide("db_fdList")
    self.binding:Hide("bg_FDNum")
    self:getData()
end


function fList:onClick(go, name)
    if name == "btFDRequest" then
        self:getFDRequestList("fdRequest")
    elseif name == "btFDList" then
        self:getFDList("fdList")
    elseif name == "btGetBP" then
        self:getBPList("getBP")
    elseif name == "btBlackList" then
        self:getBlackList("blackList")
    elseif name == "btClose" then
        self:destory()
    elseif name == "btnBack" then
        UIMrg:pop()
    end
end

--设置数量
function fList:setFdNum(count)
    local row = nil
    local id
    local desc = ""

    if currentType == "friend" then
        id = 1
        desc = TextMap.GetValue("Text838")
    elseif currentType == "request" then
        id = 4
        desc = TextMap.GetValue("Text839")
    elseif currentType == "black" then
        id = 2
        desc = TextMap.GetValue("Text840")
    end

    local fd_numGo = self.fd_num.transform.parent.gameObject
    if currentType == "friend" or currentType == "request" or currentType == "black" then
        fd_numGo:SetActive(true)
        row = TableReader:TableRowByID("FriendConfig", id)
        row = json.decode(row:toString())
        self.fd_num.text = desc .. "[fedb4f]" .. count .. "/" .. row.args2 .. "[-]" --args2上限
    else
        fd_numGo:SetActive(false)
    end
end

--设置聊天中的好友列表和黑名单列表
function fList:setChatList(result)
    if currentType == "friend" then
        --ChatController.SetFriendList(result)
    elseif currentType == "black" then
        --ChatController.SetBlackList(result)
    end
end

--设置描述提示
function fList:setDesc()
    local desc = ""

    if currentType == "friend" then
        desc = TextMap.GetValue("Text841")
    elseif currentType == "bp" then
        desc = TextMap.GetValue("Text842")
    elseif currentType == "request" then
        desc = TextMap.GetValue("Text843")
    elseif currentType == "black" then
        desc = TextMap.GetValue("Text844")
    end
    self.msg.text = desc
end

function fList:sortFriendList(list)
    table.sort(list, function (a,b)
        if a.online ~= b.online then
            return a.online < b.online
        end
    end)
    return list
end

--好友列表,黑名单列表,好友申请列表
function fList:getData(...)
    self.msg.text = ""
    tempObj = {}

    Api:getSocialList(currentType, function(result)

        self:setRedPoint() --设置小红点
        self:setFdNum(result.list.Count)
        local count = result.list.Count
        local canGive = 0
        --设置聊天中的好友列表和黑名单列表
        self:setChatList(result)

        if count == 0 then
            self:setDesc()
        else
            for i = 0, count - 1 do
                local m = {}
                m.type = itemType
                m.pid = result.list[i].pid
                m.gameUserId = result.list[i].pid
                m.name = result.list[i].name
                m.level = result.list[i].level
                m.vip = result.list[i].vip
                m.head = result.list[i].head
                m.power = result.list[i].power
                m.online = result.list[i].online
                m.tData = result.list[i]
                m.sociatyName = result.list[i].guild
                m.dictid = result.list[i].dictid

                if currentType == "friend" and result.list[i]:ContainsKey("sendBp") == false then
                    canGive = canGive + 1
                end
                table.insert(tempObj, m)
            end
        end

        tempObj = fList:sortFriendList(tempObj)

        if currentType == "friend" then
            self.db_fdList:CallUpdate({ delegate = self, num = count, canGive = canGive })
        elseif currentType == "bp" then
            local vip = Player.Info.vip
            local row = TableReader:TableRowByUnique("BpConfig", "vip_level", vip)
            row = json.decode(row:toString())
            local num = row.bp_limit_times - Player.Social.acceptBpTimes
            if num < 0 then num = 0 end
            self.db_getbp:CallUpdate({ delegate = self, num = num, listCount = count})
        end
        if currentType == "friend" then
            self.scrollView:refresh(tempObj, self, true, 0)
        elseif currentType == "bp" then
            self.arena_bp:refresh(tempObj, self, true, 0)
        elseif currentType == "request" then
            self.arena_request:refresh(tempObj, self, true, 0)
        elseif currentType == "black" then
            self.arena_black:refresh(tempObj, self, true, 0)
        end
        tempObj = nil
    end, function()
    end)
end

--刷新
function fList:refresh(_type)
    if _type == "friendList" then
        self:getFDList()
    elseif _type == "getBp" then
        self:getBPList()
    elseif _type == "requestFD" then
        self:getFDRequestList()
    elseif _type == "black" then
        self:getBlackList()
    end
end

--显示小红点
function fList:setRedPoint()
    local friend = Player.Social
    local row = TableReader:TableRowByUnique("BpConfig", "vip_level", Player.Info.vip)
    local num = row.bp_limit_times - Player.Social.acceptBpTimes
    if num <= 0 then 
        self.bpRedPoint:SetActive(false)
    else
        self.bpRedPoint:SetActive(friend.acceptBp.Count > 0)
    end
    self.requestRedPoint:SetActive(friend.request.Count > 0)
end

return fList
local detailInfo = {}
local userInfo = nil

function detailInfo:setArenaData(tableData)
    self.txt_lv.text = tableData.data.level
    self.txt_zhanli.text = math.ceil(tableData.data.power)
    self.txt_hang.text = tableData.rank
    self.txt_name.text = tableData.data.nickname
	self.txt_vipnum.text = tableData.data.vip

    --聊天信息加入
    userInfo = tableData.data
    userInfo.gameUserId = tableData.pid
    userInfo.sociatyName = tableData.data.guild

    local tempArr = Player.Team["0"].chars --获取自己的英雄人数
    local headimg = "default"
    if tableData.data.head ~= "" then
        headimg = tableData.data.head
    end
	
	for i = 0, tableData.data.defenceTeam.Count - 1 do 
		local item = tableData.data.defenceTeam[i]
		if tostring(item.id) == tostring(tableData.data.playerid) then 
			self:setHead(item.dictid, item.quality)
			break
		end 
	end 
		
    --self.roleimage:setImage(headimg, "headImage")
    self:setDefendGuys(tableData.data.defenceTeam, tempArr.Count)
end

function detailInfo:setHead(dictid, star)
	local char = Char:new(nil, dictid)
	char.star = star
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.roleimage.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", char, self.roleimage.width, self.roleimage.height, true, nil, true })
end 

function detailInfo:setDefendGuys(arr, lenght) --这个地方要主要，for 0,0会造成闪退
local tempCount = lenght
if lenght > 0 then
    for j = 1, tempCount do
        local temp_char = {}
        if arr[j - 1] then
            temp_char = Char:new(arr[j - 1].id)
            temp_char.isHaveData = true
            temp_char.lv = arr[j - 1].level
            temp_char.star_level = arr[j - 1].star
            temp_char.stage = arr[j - 1].stage
            temp_char.customNameIndex = j - 1
            local binding1 = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/myPeople", self.img_roleKuang)
            binding1:CallUpdate(temp_char)
            binding1 = nil
            temp_char = nil
        end
    end
end
self.img_roleKuangGrid.repositionNow = true
end

function detailInfo:setPeakData(tableData)
    self.txt_lv.text = tableData.data.level
    self.txt_zhanli.text = math.ceil(tonumber(tableData.data.pw))
    self.txt_hang.text = tableData.data.rank
    self.txt_name.text = tableData.data.name

    --聊天信息加入
    userInfo = tableData.data
    userInfo.nickname = tableData.data.name
    userInfo.gameUserId = tableData.pid

    local headimg = "default"
    if tableData.data.head ~= "" then
        headimg = tableData.data.head
    end
    --self.roleimage:setImage(headimg, "headImage")
	for i = 0, tableData.data.Count - 1 do 
		local item = tableData.data[i]
		if tostring(item.id) == tostring(tableData.playerid) then 
			self:setHead(item.dictid, item.quality)
			break
		end 
	end 
    local memberCount = tableData.defenceTeam.Count
    self:setDefendGuys(tableData.defenceTeam, memberCount)
end

--事件
function detailInfo:onClick(go, name)
    if name == "chat_Button" then
        if self.pid == Player.playerId then
            MessageMrg.show(TextMap.GetValue("Text466"))
            return
        end
        ChatController.OpenP2PUserChat(userInfo)
	elseif name == "btnClose" then 
		UIMrg:popWindow()
    end
end

function detailInfo:update(tableData)
    self.pid = tableData.pid
    -- if Player.noTalk == 1 then
    --     self.chat_Button.gameObject:SetActive(false)
    -- end
    if tableData.type == "arena" then --竞技场
    self:setArenaData(tableData)
    elseif tableData.type == "peak" then
        self:setPeakData(tableData)
    end
end

function detailInfo:create(...)
    return self
end

function detailInfo:Start()
	UIEventListener.Get(self.mask).onClick = function(go)
        UIMrg:popWindow()
    end
end

return detailInfo
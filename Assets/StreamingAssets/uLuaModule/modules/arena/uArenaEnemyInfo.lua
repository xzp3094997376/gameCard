local arenaEnemyInfo = {}
local userInfo = {}
function arenaEnemyInfo:setDefendGuys(arr) --这个地方要主要，for 0,0会造成闪退
    for j = 1, 6 do
        local index = j
        if j <= 3 then index = j + 3
        else index = j - 3
        end
        local temp_char = {}
        if index <= arr.Count then
            local id
            temp_char = Char:new(nil, arr[index - 1].dictid)
            temp_char.isHaveData = true
            temp_char.lv = arr[index - 1].level
            temp_char.star_level = arr[index - 1].star
            temp_char.stage = arr[index - 1].stage
    		temp_char.star = arr[index - 1].quality
            temp_char.customNameIndex = index - 1
            if self.peppleData.peopleVO["info"].playerid ~= nil then
                id = self.peppleData.peopleVO["info"].playerid
            elseif self.peppleData.peopleVO["info"].dictid ~=nil then
                id = self.peppleData.peopleVO["info"].dictid
            end
    		if arr[index - 1].dictid == id then
    			temp_char.name = self.peppleData.peopleVO["info"].nickname
                temp_char.star = self.peppleData.peopleVO["info"].quality
    		end 
        else
            temp_char.isHaveData = false
        end
        local binding1 = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/myPeople", self.img_roleKuang)
        binding1:CallUpdate(temp_char)
        binding1 = nil
        temp_char = nil
    end
    self.img_roleKuangGrid.repositionNow = true
end

--到时候记得加所属工会
function arenaEnemyInfo:update(peppleData)
    -- if Player.noTalk == 1 then
    --     self.chat_Button.gameObject:SetActive(false)
    -- end
	self.peppleData = peppleData
    self.sid = peppleData.sid
    self.rank = peppleData.rank
    self.tp = peppleData.tp
    -- if self.tp.."" == "2" then --若为跨服类型，隐藏聊天按钮
    --     self.chat_Button.gameObject:SetActive(false)
    -- else
    --     self.chat_Button.gameObject:SetActive(true)
    -- end
    self.show = peppleData.show
    if self.show ~= nil then
        self.tiaozhan_Button.gameObject:SetActive(false)
    end
    self.tables = peppleData.tables
    self.pid = peppleData.pid
    if peppleData.peopleVO["info"] then
        self.txt_lv.text = peppleData.peopleVO["info"].level
        self.txt_zhanli.text = toolFun.moneyNumberShowOne(math.floor(tonumber(math.ceil(peppleData.peopleVO["info"].power))))
        self.txt_vipnum.text = "VIP " .. peppleData.peopleVO["info"].vip
        
        self.Sprite_jiangpai.gameObject:SetActive(true)
        self.txt_hang.gameObject:SetActive(false)
        if peppleData.peopleVO.rank == 1 then
            self.Sprite_jiangpai.spriteName = "jiangpai_1"
        elseif peppleData.peopleVO.rank == 2 then
            self.Sprite_jiangpai.spriteName = "jiangpai_2"
        elseif peppleData.peopleVO.rank == 3 then
            self.Sprite_jiangpai.spriteName = "jiangpai_3"
        else
            self.Sprite_jiangpai.gameObject:SetActive(false)
            self.txt_hang.gameObject:SetActive(true)
            self.txt_hang.text = peppleData.peopleVO.rank
        end
        self.txt_name.text = Char:getItemColorName(peppleData.peopleVO["info"].quality, peppleData.peopleVO["info"].nickname) 

        --聊天信息加入
        userInfo = peppleData.peopleVO["info"]
        userInfo.gameUserId = peppleData.pid
        userInfo.sociatyName = peppleData.peopleVO["info"].guild

        local headimg = "default"
        if peppleData.peopleVO["info"].head ~= "" then
            headimg = peppleData.peopleVO["info"].head
        end
		for i = 0, peppleData.data.Count - 1 do 
			local item = peppleData.data[i]
			if tostring(item.id) == tostring(peppleData.playercharid) then 
				self:setHead(item.dictid, item.quality)
				break
			end 
		end
        --print_t(peppleData.peopleVO["info"])
    if peppleData.peopleVO["info"].playerid ~= nil then
        self:setHead(peppleData.peopleVO["info"].playerid, peppleData.peopleVO["info"].quality)
    elseif peppleData.peopleVO["info"].dictid ~= nil then
        self:setHead(peppleData.peopleVO["info"].dictid, peppleData.peopleVO["info"].quality)
    end
        --self.roleimage:setImage(headimg, packTool:getIconByName(headimg))

    end

    local tempArr = Player.Team["0"].chars

    arenaEnemyInfo:setDefendGuys(peppleData.data, tempArr.Count)

    --if peppleData.title then
        --local lab = self.gameObject.transform:Find("titleSprite/Label")
        --lab = lab:GetComponent(UILabel)
        --lab.text = peppleData.title
    --end
end

function arenaEnemyInfo:setHead(dictid, star)
	local char = Char:new(nil, dictid)
	char.star = star
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.roleimage.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", char, self.roleimage.width, self.roleimage.height, nil, nil, true })
end 

function arenaEnemyInfo:refershVStime()
    Events.Brocast('vstime_refrash')
end

function arenaEnemyInfo:onClick(go, name)
    if name == "tiaozhan_Button" then
	    local times = Player.VSBattle.max_fight - Player.VSBattle.has_fight
		if times <= 0 then
			if self.tp == "crossArena" then
				--DialogMrg:BuyBpAOrSoul("kftzq", "", toolFun.handler(self, self.refershVStime))
				return
			else
				MessageMrg.showMove(TextMap.GetValue("Text_1_164"))
				--DialogMrg:BuyBpAOrSoul("tzq", "", funcs.handler(self, self.refershVStime))
				return
			end
		end
		
		-- 检查精力
		if Player.Resource.vp < 2 then 
			DialogMrg:BuyBpAOrSoul("vp", "", nil)
			return 
		end 
        arenaEnemyInfo:fightIng(LuaMain:getTeamByIndex(0))
        UIMrg:popWindow()
    elseif name == "Sprite" then
        UIMrg:popWindow()
    elseif name == "chat_Button" then
        if self.pid == Player.playerId then
            MessageMrg.show(TextMap.GetValue("Text466"))
            return
        end

       -- ChatController.OpenP2PUserChat(userInfo)
    end
end

function arenaEnemyInfo:fightIng(arr)
    if arr == nil then
        DialogMrg.ShowDialog(TextMap.GetValue("Text83"))
        return
    end
    Api:challengePlayer(arr, self.pid, 5,self.sid, self.rank,
        function(result)
            local fightData = {}
            fightData["battle"] = result.change_rank
            Events.Brocast("vsfight_callback", result.change_rank.win)
            fightData["drop"] = result.drop
            fightData["mdouleName"] = "arena"
            UIMrg:pushObject(GameObject())
            UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
            fightData = nil
        end)
end

return arenaEnemyInfo
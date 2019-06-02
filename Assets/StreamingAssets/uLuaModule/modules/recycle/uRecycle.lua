local recycle = {}
Toptype = {
    [1] = {
        [1]={ 
            type="hunyu"
        },
        [2]={ 
            type="money"
        },
        [3]={ 
            type="gold"
        }
    },
    [2] = {
        [1]={ 
            type="honor"
        },
        [2]={ 
            type="money"
        },
        [3]={ 
            type="gold"
        }
    },
    [3] = {
        [1]={ 
            type="shouhun"
        },
        [2]={ 
            type="money"
        },
        [3]={ 
            type="gold"
        }
    },
    [4] = {
        [1]={ 
            type="bp"
        },
        [2]={ 
            type="vp"
        },
        [3]={ 
            type="money"
        },
        [4]={ 
            type="gold"
        }
    },
}

local btns ={
	TextMap.GetValue("Text257"), 
	TextMap.GetValue("Text258"),
	TextMap.GetValue("Text1799"), 
	TextMap.GetValue("Text1800"), 
	TextMap.GetValue("Text1801")
	}


function recycle:create(binding)
    self.binding = binding
    return self
end

function recycle:Start(...)
	self.lock={}
    table.insert(self.lock, 1)--忍者分解
    self:getLockData(227)--忍者重生
    table.insert(self.lock, 1)--装备分解
    self:getLockData(237)--装备重生
    self:getLockData(803) --宝物重生
    self:getLockData(150)--宠物分解
    self:getLockData(150)--宠物重生
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_983"))
    self:onFenjie()
end

function recycle:getLockData(id)
    local linkData = Tool.readSuperLinkById( id)
    local limitLv = linkData.unlock[0].arg
    table.insert(self.lock, limitLv)
end

function recycle:update(lua)
    local _type = lua[1]
    if _type == "fenjie" then
        self:onFenjie()
    elseif _type == "ghost" then
        self:onGhostFJ()
    end
end

function recycle:onEnter()
    LuaMain:refreshTopMenu()
end 

function recycle:getTeamType()
    return self.temaType
end

function recycle:getTeam(...)
    local teams = Player.Team[self.teamIndex].chars
    local list = {}
    for i = 0, 5 do
        if teams.Count > i then
            list[i + 1] = teams[i]
        else
            list[i + 1] = 0
        end
    end
    return list
end


function recycle:showMsg(drop)
    if drop == nil then return end
    local name = ""
    local goodsname = ""
    local num = 0
    local ms = {}
    local _type = 0
    for i, v in pairs(drop) do
        local char = RewardMrg.getDropItem(v)
        name = char.Table.img or char.Table.iconid
        num = char.rwCount or 0
        goodsname =Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]"
        local g = {}
        g.type = v.type
        g.icon = name
        g.text = num
        g.goodsname = goodsname
		g.goodsType = v.type
        table.insert(ms, g)
        g = nil
    end
	OperateAlert.getInstance:showGetGoods(ms, self.node)
    --OperateAlert.getInstance:showGetGoods(ms, UIMrg.top)
	--	UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_show_msg", ms)
end

--英雄分解功能模块
function recycle:onFenjie(go)
    if Player.Info.level>=self.lock[1] then 
        LuaMain:ShowTopMenu(6,nil,Toptype[1])
        self:isActiveOrNot("H_FJ")
        self.fenjieContent:CallUpdate({ delegate = self })
        self:setSelect(1)
    end 
end

--英雄重生功能模块
function recycle:onCS(go)
    if Player.Info.level>=self.lock[2] then 
        LuaMain:ShowTopMenu(6,nil,Toptype[1])
        self:isActiveOrNot("H_CS")
        self.chongshengContent:CallUpdate({ delegate = self })
        self:setSelect(2)
    end 
end

--鬼道分解模块
function recycle:onGhostFJ(go)
    if Player.Info.level>=self.lock[3] then 
        LuaMain:ShowTopMenu(6,nil,Toptype[2])
        self:isActiveOrNot("G_FJ")
        Tool.ghostPowerUp()
        Tool.getGhostPieceList()
        self.gohostfenjieContent:CallUpdate({ delegate = self })
        self:setSelect(3)
    end 
end

--鬼道重生模块
function recycle:onGhostCS(go)
    if Player.Info.level>=self.lock[4] then 
        LuaMain:ShowTopMenu(6,nil,Toptype[2])
        self:isActiveOrNot("G_CS")
        self.ghost_chongshengContent:CallUpdate({ delegate = self })
        Tool.ghostPowerUp()
        self:setSelect(4)
    end 
end

function recycle:onTreasureCS()
    if Player.Info.level>=self.lock[5] then 
        LuaMain:ShowTopMenu(6,nil,Toptype[4])
        self:isActiveOrNot("T_CS")
        self.treasure_chongshengContent:CallUpdate({ delegate = self })
        self:setSelect(5)
    end 
end

function recycle:onPTFJ()
    if Player.Info.level>=self.lock[6] then 
        LuaMain:ShowTopMenu(6,nil,Toptype[3])
        self:isActiveOrNot("pt")
        self.pet_Content:CallUpdate({ delegate = self,model="pet_fenjie"})
        self:setSelect(6)
    end 
end

function recycle:onPTCs()
    if Player.Info.level>=self.lock[7] then 
        LuaMain:ShowTopMenu(6,nil,Toptype[3])
        self:isActiveOrNot("pt")
        self.pet_Content:CallUpdate({ delegate = self,model="pet_chongshen"})
        self:setSelect(7)
    end 
end

function recycle:onEnter()
    if self._tp~=nil and self._tp<3 then 
        LuaMain:ShowTopMenu(6,nil,Toptype[1])
    elseif self._tp~=nil and self._tp==5 then 
        LuaMain:ShowTopMenu(6,nil,Toptype[4])
    elseif self._tp~=nil and self._tp>5 then 
        LuaMain:ShowTopMenu(6,nil,Toptype[3])  
    elseif self._tp~=nil then 
        LuaMain:ShowTopMenu(6,nil,Toptype[2]) 
    end 
end 
function recycle:isActiveOrNot( types )
    self.fenjieContent.gameObject:SetActive(types == "H_FJ")
    self.chongshengContent.gameObject:SetActive(types == "H_CS")
    self.gohostfenjieContent.gameObject:SetActive(types == "G_FJ")
    self.ghost_chongshengContent.gameObject:SetActive(types == "G_CS")
    self.treasure_chongshengContent.gameObject:SetActive(types == "T_CS")
    self.pet_Content.gameObject:SetActive(types == "pt")
end


function recycle:setFYShow()
    -- self.fenjieToggle.value = true
end

function recycle:setGFYShow(...)
    -- self.ghostToggle.value = true
end

function recycle:onHelp(go)
    UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/lunhui_instructions", {})
end

--设置切页选中图标
function recycle:setSelect(index)
    self._tp=index
    if index == nil then return end
    for i = 1, 7 do 
        if index == i then
            if Player.Info.level>=self.lock[i] then 
                self["check_"..i]:SetActive(true)
                self["gray" .. i]:SetActive(false)
            else 
                self["check_"..i]:SetActive(false)
                self["gray" .. i]:SetActive(true)
            end
        else
            if Player.Info.level>=self.lock[i] then 
                self["check_"..i]:SetActive(false)
                self["gray" .. i]:SetActive(false)
            else 
                self["check_"..i]:SetActive(false)
                self["gray" .. i]:SetActive(true)
            end
        end
    end
end

function recycle:setButtonEnable(bool)
    if true then return end
    if bool == false then
        self.btn_fenjie.isEnabled = false
        self.btn_chongsheng.isEnabled = false
        self.btn_ghost_fj.isEnabled = false
        self.btn_ghost_chongsheng.isEnabled = false
    else
        self.btn_fenjie.isEnabled = true
        self.btn_chongsheng.isEnabled = true
        self.btn_ghost_fj.isEnabled = true
        self.btn_ghost_chongsheng.isEnabled = true
    end
end

function recycle:onClick(go, name)
    print (name)
    if name == "item_cell1" then --忍者分解
        self:onFenjie(go)
    elseif name == "item_cell2" then --忍者重生
        self:onCS(go)
    elseif name == "bt_help" then
        self:onHelp(go)
    elseif name == "item_cell3" then  --装备分解
        self:onGhostFJ(go)
    elseif name == "item_cell4" then  --装备重生
        self:onGhostCS(go)
    elseif name == "item_cell5" then  --宝物重生
        self:onTreasureCS()
    elseif name == "item_cell6" then  --宠物分解
        self:onPTFJ(go)
    elseif name == "item_cell7" then  --宠物重生
        self:onPTCs(go)   
	elseif name == "btnBack" then
		UIMrg:pop()
    end
end

return recycle
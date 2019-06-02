local m = {}

--获取掉落列表
--type 提示 1  领奖2
function m:getDropByTable(drop)
    local _list = {}

    if drop.Count == 2 then
        if self:isUsedType(drop[1].type) then
            local m = {}
            m.type = drop[1].type
            m.arg = drop[1].arg
            m.arg2 = drop[1].arg2 or 0
            table.insert(_list, m)
            m = nil
        end
    else
        for i = 1, drop.Count - 1 do
            if self:isUsedType(drop[i].type) then
                local d = drop[i]
                local m = {}
                m.type = d.type
                m.arg = d.arg
                m.arg2 = d.arg2
                table.insert(_list, m)
                m = nil
            end
        end
    end
    return _list
end

function m:isUsedType(_type)
    local typeAll = { "treasure", "treasurePiece", "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece", "money", "gold", "bp", "soul", "popularity", "credit", "honor", "donate", "exp", "hunyu", "ghost", "ghostPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function m:updateTable(drop, isGet)
    local m = {}
    table.foreach(drop, function(k, v)
        local l = {}
        l.v = v
        l.showName = true
        l.isGet = isGet
        l.isShowTips = false
        table.insert(m, l)
        l = nil
    end)
    return m -- body
end

function m:onClose(go)
    UIMrg:popWindow()
end

function m:onClick(go, btnName)
    if  btnName == "btn_go" then
		if self.type == 1 then 
			if self.goID ~= nil then
				UIMrg:popWindow()
				uSuperLink.openModule(self.goID)
			end
		elseif self.type == 2 then 
			Api:submitTask(self.data.id, function(result)
				print("领取成功")
				packTool:showMsg(result, nil, 2)
				self.delegate:refreshTarget()
				UIMrg:popWindow()
			end)
		end 
	elseif btnName == "btnclose" then 
		self:onClose()
    end
end

function m:update(data)
    self.data = data.data
	self.delegate = data.delegate
    if self.data == nil then return end
	self.type = data.type
    local  tb = TableReader:TableRowByID("allTasks", self.data.id)
    self.goID = tb.jump
    --设置角色图片
	self.img_hero:LoadByCharId(tb.icon, "idle", function(ctl)
    end, false, -1)
    --设置标题
    local text = TableReader:TableRowByID("allTasks", self.data.id).target_desc
    self.txt_title.text = text.."[00ff00]（"..self.data.progress.."/"..self.data.total.."）[-]"
    if self.type == 1 then 
		self.txt_btn.text = TextMap.GetValue("Text_1_943")
	elseif self.type == 2 then 
		self.txt_btn.text = TextMap.GetValue("Text_1_2804")
	end 
	
	--显示奖励列表
    self.drop = tb.drop
    local list = self:getDropByTable(self.drop)
    local drop = self:updateTable(list, false)
    self.scrollView:refresh(drop, self, true, 0)
end

function m:Start()
    ClientTool.AddClick(self.back, funcs.handler(self, self.onClose))
end

return m
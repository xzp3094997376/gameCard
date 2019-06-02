local m = {}

function m:Start()
	m:refresh()
end

function m:refresh()
	local list = {}
	Api:getBattlefieldReport(function(ret)
		local tbs = ret.battlefieldReports
		if tbs ~= nil then 
			for i = 0, tbs.Count-1 do
				if tbs[i] ~= nil then 
                    local temp = {}
                    temp.bossName = tbs[i].name
                    temp.lv = tbs[i].lv
                    if tbs[i].killPlayer ~= nil then 
                        temp.time = tbs[i].killPlayer.time
                        temp.name = tbs[i].killPlayer.name
                        temp.drop = tbs[i].killPlayer.drop
                    end
                    temp.ltime = tbs[i].luckyPlayer.time
                    temp.lname = tbs[i].luckyPlayer.name
                    temp.ldrop = tbs[i].luckyPlayer.drop
					table.insert(list, temp)
				end 
			end 
		end 
		
		if #list > 0 then 
			self.binding:CallManyFrame(function()
				self.content:refresh(list, self, true, 0)
			end, 2)
		end
	end, nil)
end

function m:getDrop(info)
    -- body
    --从服务器获取奖励的物品
    local drop = info.drop:getLuaTable()
    local _list = {}
    for i, v in pairs(drop) do
        if self:isUsedType(v.type) then
            local m = {}
            m.type = v.type
            m.arg = v.arg
            m.arg2 = v.arg2
            table.insert(_list, m)
            m = nil
        end
    end
    return _list
end

function m:isUsedType(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece", "money", "gold", "bp", "shouhun", "shenhun", "soul", "popularity", "credit", "honor", "donate", "exp", "hunyu", "ghost", "ghostPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function m:onClick(go, name)
	if name == "btn_close" then 
		UIMrg:popWindow()
	end 
end

return m
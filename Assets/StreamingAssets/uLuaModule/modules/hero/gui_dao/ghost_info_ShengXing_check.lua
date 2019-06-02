
-- "consume":[
-- {"consume_type":"money","consume_arg":800000,"consume_arg2":"","rate_addstar":200,"$consume_arg":800000},
-- {"consume_type":"gold","consume_arg":800,"consume_arg2":"","rate_addstar":200,"$consume_arg":800},
-- {"consume_type":"ghostPiece","consume_arg":36,"consume_arg2":3,"rate_addstar":200,"$consume_arg":"神乐忍刀"}]

local m = {} 

function m:update(data)
	if data ~= nil then
		self.data = data
		--local atlasName = packTool:getIconByName("res_"..data.consume_type)
	    --self.item_icon:setImage("res_"..data.consume_type, atlasName)
		self.costNum.text = data.consume_arg

        self.Icon_gold.gameObject:SetActive(false)
        self.Icon_piece.gameObject:SetActive(false)
        self.Icon_money.gameObject:SetActive(false)

		if data.consume_type == "money" then
			self.costType.text = TextMap.GetValue("Text1807")
            self.Icon_money.gameObject:SetActive(true)
		elseif data.consume_type == "gold" then
			self.costType.text = TextMap.GetValue("Text1808")
            self.Icon_gold.gameObject:SetActive(true)
		elseif data.consume_type == "ghostPiece" then
			self.costType.text = TextMap.GetValue("Text1809")
            self.Icon_piece.gameObject:SetActive(true)
            self.costNum.text = "0/"..self.data.consume_arg2
			m:checkPieceByequip()
		end
	end
end

function m:checkPieceByequip()
	local pieces = Player.GhostPieceBagIndex:getLuaTable()
    local list = {}
    table.foreach(pieces, function(i, v)
        if v.count > 0 then
	         local row = TableReader:TableRowByID("ghostPiece", i)
            if row then
                local consume = row.consume
                local _costList = RewardMrg.getConsumeTable(consume)
                for i = 1, #_costList do
                    local it = _costList[i]
                    if it["Table"].name == self.data["$consume_arg"] then
                    	if v.count >= tonumber(self.data.consume_arg2) then
                    		self.costNum.text = v.count.."/"..self.data.consume_arg2
                    	else
                    		self.costNum.text = "[ff0000]"..v.count.."[-]".."/"..self.data.consume_arg2
                    	end
                    	return
                	end
                end
            end
        end
    end)
end

return m
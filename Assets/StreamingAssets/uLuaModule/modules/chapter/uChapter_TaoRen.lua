local m = {} 

local taoRenInfo

function m:update(datas)
    if Tool.checkTaoRen() then
        local dataInfo = Player.DaXu
        if dataInfo ~= nil then
            local row = TableReader:TableRowByID("daxueMaster", tonumber(dataInfo.daXuId))
            --taoRenInfo = dataList[1]
            rwo = row
            local color = TableReader:TableRowByID("daxuColor", row.star)
            self.taoren_Name.text = color.color .. row.name .. "[-]"
            local  char = Char:new(row.model)
            local ima = char:getHeadSpriteName()
            self.taoren_kuang_img.spriteName = Char:getDaxuFrameKuang(row.star + 1)
            self.taoren_bg_img.spriteName = Char:getDaxuFrameBG(row.star + 1)

            self.taoren_ima:setImage(ima, packTool:getIconByName(ima))--packTool:getIconByName(data.head)

            TableReader:ForEachLuaTable("zhengzhanConfig", function(index, item)
                if item.name == TextMap.GetValue("Text_1_221") then
                    self.id = item.droptype[0]
                end
                return false
            end)
        end
    end
    -- Api:checkDaxu(function(result)
    --     local dataInfo = result.daxu
    --     if dataInfo ~= nil then 
    --         dataList = json.decode(dataInfo:toString())
    --     end
    --     if #dataList ~= 0 then
    --         local row = TableReader:TableRowByID("daxueMaster", dataList[1].id)
    --         taoRenInfo = dataList[1]
    --         rwo = row
    --         local color = TableReader:TableRowByID("daxuColor", row.star)
    --         self.taoren_Name.text = color.color .. row.name .. "[-]"
    --         local  char = Char:new(row.model)
    --         local ima = char:getHeadSpriteName()
    --         self.taoren_kuang_img.spriteName = Char:getDaxuFrameKuang(row.star + 1)
    --         self.taoren_bg_img.spriteName = Char:getDaxuFrameBG(row.star + 1)

    --         self.taoren_ima:setImage(ima, packTool:getIconByName(ima))--packTool:getIconByName(data.head)

    --         TableReader:ForEachLuaTable("zhengzhanConfig", function(index, item)
    --             if item.name == TextMap.GetValue("Text_1_221") then
    --                 self.id = item.droptype[0]
    --             end
    --             return false
    --         end)
    --     end
    -- end)
end


function m:onClick(go, name)
	local id = self.id
    if name == "TaoRenInfo" then
        uSuperLink.openModule(id)
        if taoRenInfo ~= nil then
            UIMrg:pushWindow("Prefabs/activityModule/encirclementModule/BossInfo", taoRenInfo)
        end
    end
end

function m:Start(...)
end

return m
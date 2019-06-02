--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/22
-- Time: 12:54
-- To change this template use File | Settings | File Templates.
--

MessageMrg = {}
MessageMrgMove = {}

function MessageMrg.show(msg)
    if MessageMrg._msg then
        MessageMrg._msg:CallUpdateWithArgs(msg)
    else
        MessageMrg._msg = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/message", UIMrg.top) --UIMrg:pushMessage("Prefabs/publicPrefabs/message")
        MessageMrg._msg:CallUpdateWithArgs(msg)
    end
end

function MessageMrg.showTips(temp)
	local type =  temp._type -- temp.obj:getType()
	if temp._type == "treasure" or temp._type == "treasurePiece" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/hero/treasure_info_dialog", temp)
	elseif temp._type == "ghost" or temp._type == "ghostPiece" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/hero/equip_info_dialog", temp)
	elseif temp._type == "char" or temp._type == "charPiece" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/hero/hero_info_dialog", temp)
	elseif temp._type == "pet" or temp._type == "petPiece" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/hero/pet_info_dialog", temp)
	elseif temp._type == "renling" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/renlingModule/renlingContent", temp.obj)     
	elseif temp._type == "yuling" or temp._type == "yulingPiece" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/yuling/yuling_info_dialog", temp)
	elseif temp._type == "equip" or temp._type == "item" or (temp._type~=nil and Tool.typeId(temp._type)) then 
			MessageMrg.showDaoJuTips(temp)
	elseif temp._type == "itemvo" then  
		if temp.obj.itemType == "ghost" or temp.obj.itemType == "ghostPiece"  then 
			local id = -1
			if temp.obj.itemType == "ghost" then 
				id = temp.obj.itemTable.id
			elseif temp.obj.itemType == "ghostPiece" then
				id = TableReader:TableRowByUnique("ghost", "name", temp.obj.itemTable.name).id
			end
			local ghost = Ghost:new(id)
			temp.obj = ghost
			UIMrg:pushWindow("Prefabs/moduleFabs/hero/equip_info_dialog", temp)
		elseif temp.obj.itemType == "treasure" or temp.obj.itemType == "treasurePiece" then 
			local id = -1
			if temp.obj.itemType == "treasure" then 
				id = temp.obj.itemTable.id
			elseif temp.obj.itemType == "treasurePiece" then
				id = temp.obj.itemTable.treasureId
			end
			local treasure = Treasure:new(id)
			temp.obj = treasure
			UIMrg:pushWindow("Prefabs/moduleFabs/hero/treasure_info_dialog", temp)
		elseif temp.obj.itemType == "char" or temp.obj.itemType == "charPiece" then 
			local id = temp.obj.itemTable.id
			local char ={}
			if temp.obj.itemType == "char" then 
				char=Char:new(nil,id)
			elseif temp.obj.itemType == "charPiece" then
				char=CharPiece:new(id)
			end
			temp.obj = char
			UIMrg:pushWindow("Prefabs/moduleFabs/hero/hero_info_dialog", temp) 	
		elseif temp.obj.itemType == "equip" or temp.obj.itemType == "item" or Tool.typeId(temp.obj.itemType) then 
			MessageMrg.showDaoJuTips(temp)		
		else
			UIMrg:pushWindow("Prefabs/publicPrefabs/ItemTips", temp)
		end 
	else 
		UIMrg:pushWindow("Prefabs/publicPrefabs/ItemTips", temp)
	end 
end

function MessageMrg.showDaoJuTips(temp)
	if temp.obj.Table ~= nil and temp.obj.Table.use_type==2 then
		UIMrg:pushWindow("Prefabs/publicPrefabs/N_Choose_OneTip", {data=temp.obj.itemTable.drop})
	else 
		UIMrg:pushWindow("Prefabs/publicPrefabs/DaojuTips", temp)
	end 
end

function MessageMrg.showByID(id)
    local linkData = Tool.readSuperLinkById( moduleId)
    if linkData == nil then
        return
    end
    local msg = linkData.from .. TextMap.GetValue("Text352")
    MessageMrg.show(msg)
end

--带移动效果的提示框
function MessageMrg.showMove(msg)
    if MessageMrgMove._msg then
        MessageMrgMove._msg:CallUpdateWithArgs(msg)
    else
        MessageMrgMove._msg = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/messageMove", UIMrg.top) --UIMrg:pushMessage("Prefabs/publicPrefabs/messageMove")
        MessageMrgMove._msg:CallUpdateWithArgs(msg)
    end
end

function MessageMrg.showInMyCamera(msg, gameobj)
    if MessageMrg.bing then
        MessageMrg.bing:CallUpdateWithArgs(msg)
    else
        local binding = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/message", gameobj)
        binding:CallUpdateWithArgs(msg)
        MessageMrg.bing = binding
    end
end



return MessageMrg


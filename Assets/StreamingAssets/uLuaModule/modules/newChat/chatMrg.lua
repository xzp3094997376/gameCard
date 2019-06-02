chatMrg = {} 

function chatMrg.create()
    if chatMrg.bind == nil then
        chatMrg.bind = UIMrg:pushNotice("Prefabs/moduleFabs/chat/ChatPage")
        chatMrg.rowList={}
        chatMrg.isEnabled={}
    end
end

function chatMrg.cdTime(scope)
	chatMrg.isEnabled[scope]=false
	if chatMrg.rowList[scope]==nil then 
	 	chatMrg.rowList[scope]= TableReader:TableRowByID("ChatConfig",data.scope)  
	end 
	LuaTimer.Add(chatMrg.getTime(chatMrg.rowList[scope].time_limit)*1000, function()
 		chatMrg.isEnabled[scope]=true
 		Events.Brocast('changeSureBtn')
 	end)
end

function chatMrg.getTime(time)
    local p = string.find(time, "h")
    local h = 0
    if p then
        h = string.sub(time, 1, p - 1) or 0
    else
        p = 0
    end

    local p_m = string.find(time, "m")
    local m = 0
    if p_m then
        m = string.sub(time, p + 1, p_m - 1) or 0
    else
        p_m = p
    end
    local p_s = string.find(time, "s")
    local s = 0
    if p_m and p_s then
        s = string.sub(time, p_m + 1, p_s - 1) or 0
    end
    return h*60*60+m*60+s 
end

function chatMrg.ShowChatBtn()
	if chatMrg.bind~=nil then 
		chatMrg.bind:CallTargetFunctionWithLuaTable("ShowBtn")
	end 
end

function chatMrg.HideChatBtn()
	if chatMrg.bind~=nil then 
		chatMrg.bind:CallTargetFunctionWithLuaTable("HideBtn")
	end 
end

function chatMrg.getChatList(tp)
	if tp==1 then 
		return chatMrg.shijieList
	elseif tp==2 then 
		return chatMrg.xueyuanList 
	elseif tp==3 then 
		return chatMrg.miyuList 
	end 
end

--scope   聊天区: P为私聊  G为公会频道  A为世界频道
--content   聊天内容
--from   说话方名字
--head   说话方头像
--vip   说话方vip
--quality
function chatMrg:showNewChat(data)
	if chatMrg.rowList==nil then 
		chatMrg.rowList={}
	end 
	if chatMrg.rowList[data.scope]==nil then 
	 	chatMrg.rowList[data.scope]= TableReader:TableRowByID("ChatConfig",data.scope)  
	end 
	local max_num = chatMrg.rowList[data.scope].message_limit
	if data.scope=="P" then 
		if chatMrg.miyuList==nil then 
			chatMrg.miyuList={}
		end 
		data.isNew=true
		if chatMrg.bind~=nil then 
			chatMrg.bind:CallTargetFunctionWithLuaTable("ShowRed")
		end 
		table.insert(chatMrg.miyuList, data)
		if #chatMrg.miyuList>max_num then 
			table.remove(chatMrg.miyuList,1)
		end 
	elseif data.scope=="G" then 
		if chatMrg.xueyuanList==nil then 
			chatMrg.xueyuanList={}
		end 
		table.insert(chatMrg.xueyuanList, data)
		if #chatMrg.xueyuanList>max_num then 
			table.remove(chatMrg.xueyuanList,1)
		end
	elseif data.scope=="A" then 
		if chatMrg.shijieList==nil then 
			chatMrg.shijieList={}
		end 
		table.insert(chatMrg.shijieList, data)
		if #chatMrg.shijieList>max_num then 
			table.remove(chatMrg.shijieList,1)
		end 
	end 
	Events.Brocast('creatOneChat')
end

return chatMrg
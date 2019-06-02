local m = {}
local pid = 0
local item_index

function m:update(data, index, delegate)
    self.delegate = delegate
    --print_t(data)
    self.txt_lv.text = TextMap.GetValue("Text_1_165")..data.level
    self.txt_name.text = Char:getItemColorName(data.star, data.name) 
    self.txt_power.text = TextMap.GetValue("Text_1_347")..toolFun.moneyNumberShowOne(math.floor(tonumber(data.power)))
    pid = data.pid
    item_index = index
    self.vipLv.text = "VIP " .. data.vip
    if data.guild then
        self.txt_gh.text = TextMap.GetValue("Text831") .. data.guild
    else
        self.txt_gh.text = ""
    end
	m:setHead(data.dictid, data.star)
    m:setOnlineStatus(data.online)
end

function m:setHead(dictid, star)
	local char = Char:new(nil, dictid)
	char.star = star
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.simpleImage.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", char, self.simpleImage.width, self.simpleImage.height, nil, nil, true })
end 

function m:setOnlineStatus(online)
    local desc = ""
    local col = "[ffffff]"
    if online ~= nil then
        if online == 0 then
            desc = TextMap.GetValue("Text1648")
            col = "[00ff00]"
        elseif online == -1 then
            desc = TextMap.GetValue("Text1649")
        elseif online > 0 then
            local time = online/1000
            if time < 60 then
                desc = TextMap.GetValue("Text1650")
            elseif time < 3600 then
                desc =string.gsub(TextMap.GetValue("LocalKey_769"),"{0}",math.floor(time/60))
            elseif time < 86400 then
                desc =string.gsub(TextMap.GetValue("LocalKey_770"),"{0}",math.floor(time/3600))
            else
                desc =string.gsub(TextMap.GetValue("LocalKey_771"),"{0}",math.floor(time/86400))
            end
        end
        desc = col..desc.."[-]"
        self.txt_time.text = desc
    else
        self.txt_time.text = ""
    end

end


function m:request(...)
    Api:requestFriend(pid, function(...)
        self.delegate:deleteItem(item_index + 1)
        MessageMrg.show(TextMap.GetValue("Text570"))
        return true
    end, function(...)
        -- body
    end)
end

function m:onClick(go, name)
    if name == "btn_add" then
        self:request()
    end
end

return m
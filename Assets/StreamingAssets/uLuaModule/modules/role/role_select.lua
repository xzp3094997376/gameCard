local m = {}

local lastCenter = nil 

function m:onClick(go, name)
	if name == "randName" then 
		m:randomName()
	elseif name == "btn_start" then 
		m:createRole()
	elseif name == "btn_item1" then 
		m:selectHead(1)
	elseif name == "btn_item2" then 
		m:selectHead(2)
	elseif name == "btn_item3" then 
		m:selectHead(3)
	end 
end

function m:createRole()
	if self.input_name.value == "" then 
		MessageMrg.show(TextMap.GetValue("Text1288"))
		return 
	end 
	self.btn_start.isEnabled = false
    local that = self
        local name = self.input_name.value
        Api:createPlayer(name, Tool.CUR_UID, 1, that.data.id, function(result)
			that.btn_start.isEnabled = true
			Messenger.Broadcast("CreatePlayer")
			that.delegate:onCreateCallback()
			UmengAnalytics.Event("creae_role", TextMap.GetValue("Text241")..":"..name)
        	UmengAnalytics.Event("pay_7", name)
        end, function(resut)
			that.btn_start.isEnabled = true
            return false
        end)
end 

function m:randomName()
	--获取玩家性别
    local sex = Player.Info.sex
    Api:randomName(sex, function(result)
        self.input_name.value = result.name
    end, function()
        return false
    end)
end 

function m:selectHead(id)
	for i = 1, 3 do 
		if id == i then 
			self["select"..i]:SetActive(true)
		else 
			self["select"..i]:SetActive(false)
		end 
	end 
	self.data = self.roles[id]
	self:updateHeroInfo()
end 

function m:updateHeroInfo()
	self.img_hero:LoadByModelId(self.data.charid, "idle", function() end, false, 0, 1)
	self.txtDes.text = self.data.desc
end 

function m:update(tb)
	self.nickname = tb.nickname or Player.Info.nickname
	self.delegate = tb.delegate
end 

function m:updateHead()
	for i = 1, #self.roles do 
		local item = self.roles[i]
		local char = Char:new(item.charid)
		self["img_icon"..i].Url = char:getHead()
	end 
end

function m:Start()
	self.data = nil
	self.roles = {}
	TableReader:ForEachLuaTable("initPlayer", function(index, item)
		self.roles[index+1] = item
		return false
	end)
	
	m:selectHead(1)
	m:updateHead()
	
	m:randomName()
end

return m
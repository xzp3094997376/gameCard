

local m = {}
-- type = more  更多
-- type = shop  商店

function m:update(data)
	self.pos = data.pos
	self.type = data.type
	
	self.panel.transform.position = self.pos
	
	if self.type == "more" then 
		self.panel.transform.localPosition = self.panel.transform.localPosition + Vector3(self.bg.width / 2 + 10, self.bg.height / 2 + 10, 0)
		self.mail = Tool.checkRedPoint("mail")
		self.friend = Tool.checkRedPoint("friend")
		self.red_point_for_mail:SetActive(self.mail or false)
		self.red_point_for_fried:SetActive(self.friend or false)
	elseif self.type == "shop" then 
		self:updateShopData()
		self.panel.transform.localPosition = self.panel.transform.localPosition + Vector3(52, -136, 0)
	end 
end

function m:updateShopData()
	self.shopList={}
	local shopList = {}
	TableReader:ForEachLuaTable("shop_reset_config", function(k, v)
        if v.open ==1 then 
        	if shopList[v.main_shop]==nil then 
        		shopList[v.main_shop]={}
        		shopList[v.main_shop].lockLevel=9999
        	end 
        	local superLink = v.superLink
        	local level=Tool.getUnlockLevel(superLink)
        	shopList[v.main_shop].lockLevel=math.min(shopList[v.main_shop].lockLevel,level)
        	shopList[v.main_shop][v.sort]=v
        end
        return false
        end)
	for k,v in pairs(shopList) do
		table.insert(self.shopList, v)
	end
	table.sort(self.shopList, function (a,b)
		return tonumber(a.lockLevel)< tonumber(b.lockLevel)
	end )
	local index = 1
	local port =math.ceil(math.sqrt(#self.shopList))
	for k,v in ipairs(self.shopList) do
		local shopObj = nil
		if index==1 then 
			shopObj=self.btn_shop
		else 
			local go = NGUITools.AddChild(self.menu, self.btn_shop.gameObject)
			shopObj=go:GetComponent(UluaBinding)
		end 
		shopObj.transform.localPosition = Vector3(((index-1)%port)*100-50*port+187,math.floor((index-1)/port)*(-90)+30,0)
		shopObj:CallUpdate(v)
		shopObj.gameObject.name="btn_shop" .. index
		index=index+1
	end
	self.bg.width=100*port+14
	self.bg.height=90*port+42
end


function m:onClick(go, name)
	UIMrg:popWindow()
	if name == "btn_mail" then 
		LuaMain:openWithSound(51)
		--m:onMail()
	elseif name == "btn_friend" then 
		m:onFriend()
	elseif name == "btn_photo" then 
		m:onPhoto()
	elseif name == "btn_chenhao" then 
		m:onChenhao()	
	elseif name == "btn_renzhuanshen" then
		local lv = TableReader:TableRowByID("renzhuanshen", "renzhuanshen_unlock").value2
		lv=tonumber(lv)
		if Player.Info.level < lv then 
			MessageMrg.show(TextMap.GetValue("Text_1_803")..lv..TextMap.GetValue("Text_1_937"))
			return
		end 
		Tool.push("renzhuanshen", "Prefabs/moduleFabs/hero/gui_hero_renzhuanshen")
	elseif name == "btn_renhun" then 
		uSuperLink.openModule(233)
	elseif name == "btn_juexing" then 
	    uSuperLink.openModule(14)
	elseif name == "btn_shengwang" then
		uSuperLink.openModule(4)
	elseif name == "btn_zhangong" then 
		uSuperLink.openModule(9)
	elseif name == "btn_buji" then 
		uSuperLink.openModule(12)
	elseif name == "btn_shilian" then
		uSuperLink.openModule(2) 
	elseif name =="btn_pet" then 
		uSuperLink.openModule(15) 
	elseif name =="btn_kafu" then 
		uSuperLink.openModule(103) 
	end 
end 

function m:onMail()
	local superID = 51
	local linkData = Tool.readSuperLinkById( superID)
    --超链接的等级限制
    if linkData == nil then
        MessageMrg.show(TextMap.GetValue("Text142") .. superID)
        return nil
    else
        local moduleName = linkData.arg[0] --模块名
		local counts = linkData.arg.Count
        local args = {}
        if counts > 1 then
            for i = 1, counts - 1 do
                args[i] = linkData.arg[i]
            end
        end
        linkData = nil
		
		if moduleName ~= nil then 
			uSuperLink.open(moduleName, args, 1)
		else
			MessageMrg.show(TextMap.GetValue("Text142") .. superID) 
		end 		
	end
end 

function m:onFriend()
	uSuperLink.openModule(120)
end 

function m:onPhoto()
	--MessageMrg.showMove("暂未开放， 敬请期待！")	
	uSuperLink.openModule(231)
end 

function m:onChenhao()
	Tool.push("chenghao", "Prefabs/moduleFabs/chenghaoModule/chenghaoModule")
end 

function m:onVip()
	Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { m:getActIdByEvent("vipGift"),""})
end 

function m:getActIdByEvent(id)
    local act = Player.Activity.d
    if act and act[id] then
        return act[id].i
    end
    return "0"
end

function m:Start()
  UIEventListener.Get(self.mask).onClick = function(go)
	UIMrg:popWindow()
  end
  
  --local goName = "/GameManager/Camera"
  --curCamera = GameObject.Find(goName):GetComponent(Camera)
end

return m


local m = {} 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2993"))
	m:onUpdate()
end

function m:onUpdate()
	LuaMain:ShowTopMenu(6,nil,{[1]={ type="yuhun"},[2]={ type="money"},[3]={ type="gold"}})
	local name = TableReader:TableRowByUnique("resourceDefine", "name","yuhun").cnName
	local resNum = Tool.getCountByType("yuhun")
	self.name1.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	name = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").cnName
	resNum = Tool.getCountByType("haogandu")
	self.name2.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	name = TableReader:TableRowByUnique("resourceDefine", "name","max_haogandu").cnName
	resNum = Tool.getCountByType("max_haogandu")
	self.name3.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	local red_lvup = Tool.getCanYulingshu()
	self.redPoint_lvup:SetActive(red_lvup)
	local red_reward = Tool.getCanReceiveReward()
	self.redPoint_reward:SetActive(red_reward)
	local freen_nun=Player.Times.xihaofreetime
	local freen_nun2=Player.Times.yulingfreetime
	local red_summon = false
	if freen_nun>0 or freen_nun2>0 then 
		red_summon=true
	end 
	self.redPoint_summon:SetActive(red_summon)
	local ret = Tool.checkRedPoint("yulingPiece")
	if ret==false then 
		ret= Tool.checkRedPoint("yuling") or false
	end
	self.redPoint_cultivate:SetActive(ret)
end

function m:onClick(go, name)
	if name == "cultivate_btn" then
		Tool.push("yuling", "Prefabs/moduleFabs/yuling/yuling_select_char")
	elseif name == "shop_btn" then 
		uSuperLink.openModule(16)
	elseif name == "summon_btn" then 
		Tool.push("yuling", "Prefabs/moduleFabs/yuling/yuling_summon")
	elseif name == "chart_btn" then
		Tool.push("yuling", "Prefabs/moduleFabs/yuling/yuling_tujian")
	elseif name == "reward_btn" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/yuling/yuling_reward",{delegate=self})
	elseif name =="haogan_btn" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/yuling/yuling_haogandu")
	elseif name == "lvup_btn" then 
		Tool.push("yuling", "Prefabs/moduleFabs/yuling/yuling_yulingshu")
	end 
end 

function m:onEnter()
	m:onUpdate()
end

function m:create(binding)
    self.binding = binding
    return self
end

return m
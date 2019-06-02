local summonZhenying = {} 
local REFRESH_SCROLL = 0
local timerId = 0

--初始化
function summonZhenying:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function summonZhenying:onEnter()
    self:update()
end

function summonZhenying:OnEnable()
    self:update()
end

function summonZhenying:Scorllupdate()
    local chars = {}
    local charsList = {}
    local hasChar = {}
    local index = 1
    TableReader:ForEachLuaTable("drawShow", function(index, item)
        if item.type==self.delegate.camp+2 then
        	table.insert(chars, item)
        end 
        return false
    end)

    self.allHeroName=""
    local hong=1
    for k, v in pairs(chars) do
        local cell = chars[index].showchar[0]
        local char = RewardMrg.getDropItem({type=cell.type,arg=cell.showchar,arg1=1})
        if char.star==6 then 
        	if hong==1 then 
        		self.allHeroName=char:getDisplayColorName()
        	else 
        		self.allHeroName=self.allHeroName .. TextMap.GetValue("Text_1_2798") .. char:getDisplayColorName()
        	end
        	hong=hong+1
        end
       char.desc=cell.desc
       charsList[index] = char
       hasChar[char.id] = true
       index = index + 1
    end
    if self.campShow~=nil then 
    	GameObject.Destroy(self.campShow.gameObject)
    	self.campShow=nil 
    end 
    if self.campShow==nil then 
    	local obj = ClientTool.load("Prefabs/moduleFabs/choukaModule/CampSummon")
    	obj.transform.parent=self.Container.transform
    	obj.transform.localPosition = Vector3(0,0,0)
        obj.transform.localScale = Vector3.one
    	self.campShow = obj:GetComponent(UluaBinding)
    end
    self.campShow:CallUpdate(charsList)
    
    for i=1, index-1 do
        local randNum = math.random(1, index-2)
        charsList[i],charsList[randNum]=charsList[randNum],charsList[i]
    end

    local heroindex = 1
    if index >1 then 
    	self:updataHero(charsList[heroindex])
    	LuaTimer.Delete(REFRESH_SCROLL)
    	REFRESH_SCROLL = LuaTimer.Add(0,6000, function(id)
    		heroindex=heroindex+1
    		if heroindex>=index then 
    			heroindex = 1
    		end
    		self:updataHero(charsList[heroindex])
        end)
    end

end

function summonZhenying:Start()
    local _camera = GameObject.Find("CampCamera")
    if _camera==nil then return end 
    local camera= _camera:GetComponent("Camera")
    if camera==nil then return end
    local cur = Screen.width/Screen.height
    local old = 1334/750
    camera.fieldOfView=old*60/cur
end

function summonZhenying:OnDestroy()
    LuaTimer.Delete(timerId)
    LuaTimer.Delete(REFRESH_SCROLL)
    self.topMenu = LuaMain:ShowTopMenu(1, nil)
end

function summonZhenying:updataHero(char)
	if self.heroContainer==nil then return end 
	self.heroContainer.enabled=true
	self.heroContainer:ResetToBeginning()
	self.heroContainer.from=Vector3(0.5,0.5,0.5)
    self.heroContainer.to=Vector3.one
	self.hero:LoadByModelId(char.modelid, "idle", function() end, false, 0, 1)
	self.binding:CallAfterTime(5, function()
		self.heroContainer.enabled=true
        self.heroContainer:ResetToBeginning()
        self.heroContainer.from=Vector3.one
        self.heroContainer.to=Vector3(0.5,0.5,0.5)
        end)
	self.heroname.text=char:getDisplayColorName()
end

function summonZhenying:setRefreshCampTime()
    LuaTimer.Delete(timerId)
    timerId = LuaTimer.Add(0,1000, function(id)
        local time  =Tool.FormatTime(self.delegate.zTime / 1000 -os.time()) 
        self.time.text=time 
    end)
end

function summonZhenying:update(data)
    self.topMenu = LuaMain:ShowTopMenu(4, nil)
	if data~=nil then 
		self.delegate=data.delegate
        self:Scorllupdate()
	end
    self.isCanClick=true

    self:setRefreshCampTime()
    if self.delegate.camp == "1" then
        self.icon1.spriteName="zhenying_shan"
    elseif self.delegate.camp == "2" then
        self.icon1.spriteName="zhenying_e"
    elseif self.delegate.camp == "3" then
        self.icon1.spriteName="zhenying_ying"
    end
    self:updateZhanxingNum()
    local i = 0
    local consume=TableReader:TableRowByID("draw",30).consume[i]
    if consume.consume_type=="gold" or consume.consume_type=="money" then 
        self.cost_camp = TableReader:TableRowByID("draw", 30).consume[i].consume_arg
        self.cost_camp_ten = TableReader:TableRowByID("draw", 40).consume[i].consume_arg
        local iconName = Tool.getResIcon(consume.consume_type)
        self.cost_camp_icon=iconName
    elseif consume.consume_type=="item" then 
        self.cost_camp = TableReader:TableRowByID("draw", DrawId.NorOne).consume[i].consume_arg2
        self.cost_camp_ten = TableReader:TableRowByID("draw", DrawId.NorTen).consume[i].consume_arg2
        local item = TableReader:TableRowByID("item", consume.consume_arg)
        self.cost_camp_icon=item.iconid
    end
    self.icon_money1.Url=UrlManager.GetImagesPath("itemImage/" .. self.cost_camp_icon.. ".png")
    self.icon_money2.Url=UrlManager.GetImagesPath("itemImage/" .. self.cost_camp_icon.. ".png")
    if consume.consume_type=="gold" then 
    	self.txt_price_money1.text ="[F0E77B]" .. self.cost_camp .. "[-]"
        self.txt_price_money2.text ="[F0E77B]" .. self.cost_camp_ten .. "[-]"
    else
        self.txt_price_money1.text ="[FFFFFF]" .. self.cost_camp .. "[-]"
        self.txt_price_money2.text ="[FFFFFF]" .. self.cost_camp_ten .. "[-]"
    end
    if Player.Times.draw_party1time>0 then 
    	self.icon_money1.gameObject:SetActive(false)
    	self.txt_price_money1.gameObject:SetActive(false)
    	self.txt_jiage1.gameObject:SetActive(true)
    else 
    	self.icon_money1.gameObject:SetActive(true)
    	self.txt_price_money1.gameObject:SetActive(true)
    	self.txt_jiage1.gameObject:SetActive(false)
    end
end

function summonZhenying:updateZhanxingNum()
	local totalXingyun = TableReader:TableRowByID("drawSetting", 18).arg1
    self.slider_di.value=Player.Resource.xingyunzhi/totalXingyun
    self.labPieceCount.text=TextMap.GetValue("Text_1_2799") .. Player.Resource.xingyunzhi .. "/" .. totalXingyun
    self.msg.text=TextMap.GetValue("Text_1_2800") .. self.allHeroName
    local totalZhan = TableReader:TableRowByID("drawSetting", 16).arg1
    local zhanxing =totalZhan-Player.Times.dailyCampDraw
    if zhanxing<0 then
    	zhanxing=0
    end
    local consume = TableReader:TableRowByID("draw_xingyunzhi",self.delegate.camp).consume
    if Player.Resource.xingyunzhi>=consume[0].consume_arg then 
        self.baoxiangqude:SetActive(true)
    else 
        self.baoxiangqude:SetActive(false)
    end 
    self.shengyuLabel.text=TextMap.GetValue("Text_1_2801") .. zhanxing
end

local summon_one = 0
local summon_ten = 0

function summonZhenying:onClick(go, name)
    if name == "btnNorSummon" and self.isCanClick==true then
        self.isCanClick=false
    	if self.delegate.camp == 1 then
    		summon_one=30
        elseif self.delegate.camp == 2 then
        	summon_one=31
        elseif self.delegate.camp == 3 then
        	summon_one=32
        end
        self:onSummonZhenying("one",summon_one)
    elseif name == "btnNorSummonTen" and self.isCanClick==true then
        self.isCanClick=false
        if self.delegate.camp == 1 then
    		summon_ten=40
        elseif self.delegate.camp == 2 then
        	summon_ten=41
        elseif self.delegate.camp == 3 then
        	summon_ten=42
        end
        self:onSummonZhenying("ten",summon_ten)
    elseif name=="btn_chick" then 
        self.isCanClick=false
    	if self.campShow~=nil then 
    		self.btn_chick.isEnabled=false
    		self.campShow:CallTargetFunction("RotateEulerAngles", {angle=30,time=1} )
    		self.binding:CallAfterTime(1, function()
                self.isCanClick=true
    			self.btn_chick.isEnabled=true
    			end)
    	end 
    elseif name == "btn_box" and self.isCanClick==true then
        self.isCanClick=false
    	UIMrg:pushWindow("Prefabs/moduleFabs/choukaModule/summon_box", {camp=self.delegate.camp,delegate=self})
    	self.Container:SetActive(false)
    elseif name == "btnBack" then
        Events.Brocast('update_summon_date')
        UIMrg:pop()
    end
end

function summonZhenying:activeEvent(ret)
    self.eventMake:SetActive(ret)
end

function summonZhenying:onSummonZhenying(type,id)
    local that = self
    self:activeEvent(true)
    Api:campDraw(type,id, function(result)
    	if type =="one" then 
    		self.zhenying_shengqisuipian:SetActive(true)
    		self.binding:CallAfterTime(1, function()
    			self.zhenying_shengqisuipian:SetActive(false)
    			that:updataDropArr(result)
    			that:update()
    			that:activeEvent(false)
                self.isCanClick=true
    			end )
    	else 
    		self.btn_chick.isEnabled=false
    		self.campShow:CallTargetFunction("RotateEulerAngles", {angle=360,time=2} )
    		self.binding:CallAfterTime(2, function()
    			self.campShow:CallTargetFunction("playEffect")
    			self.binding:CallAfterTime(1, function()
    				self.zhenying_shengqisuipian:SetActive(true)
    				self.binding:CallAfterTime(1, function()
    					self.btn_chick.isEnabled=true
    					self.zhenying_shengqisuipian:SetActive(false)
    					that:updataDropArr(result)
    					that:update()
    					that:activeEvent(false)
                        self.isCanClick=true
    				end)
    			end) 
    		end)
    	end
    end,function()
        self.btn_chick.isEnabled=true
        that:activeEvent(false)
        self.isCanClick=true
        return false
        end)
end

function summonZhenying:updataDropArr(result)
	local drop =json.decode(result.dropArr:toString())
	local resNum = 0
	table.foreach(drop, function(i, o)
		o = drop[i]
		table.foreach(o, function(i, v)
			if i=="xingyunzhi" then 
				resNum=resNum+v
			end
            end)
        end)
	local resultlist = {}
	local list = RewardMrg.getList(result)
	for k, v in pairs(list) do
		if v.id~="xingyunzhi" then 
			table.insert(resultlist,v)
		end 
	end 
	local resItem = uRes:new("xingyunzhi", resNum)
	local ms = {}
	local g = {}
	g.type = resItem:getType()
	g.icon = resItem:getHeadSpriteName()
	g.text = resNum
	g.goodsname = resItem.name
	g.frame = resItem:getFrame()
	g.atlasName = packTool:getIconByName(g.icon)
	table.insert(ms, g)
	OperateAlert.getInstance:showGetGoods(ms, UIMrg.top, 0, function()
		DialogMrg.levelUp()
		end)
	self.binding:CallAfterTime(0.1, function()
		packTool:showRewardMrg(nil, 2,nil,resultlist)
	end)
end



return summonZhenying
local enhanced_master = {} 
local JINLIAN_ZHUANGBEI=false
local QIANGHUA_BAOWU = false
local iscanClick = true

function enhanced_master:update(lua)
    self.delegate = lua.delegate
    self.index = lua.index
    self.char=lua.char
    self.isAllequip=lua.isAllequip
    self.isAlltreasure=lua.isAlltreasure
    self.check={}
    self.check[1]=self.check1
    self.check[2]=self.check2
    self.check[3]=self.check3
    self.check[4]=self.check4
    local char_id = self.char.id
    self.dashilist = Player.Chars[char_id].RefineMaster
    self:initBtnMessage()
    self:onUpdate(lua.char)
end

function enhanced_master:OnEnable()
    self:onUpdate(self.char)
end

function enhanced_master:initBtnMessage()
    if Player.Info.level < Tool.getUnlockLevel(237)  then
        self.btn_zhuangbeiqianghua.gameObject:SetActive(false)
    else 
        self.btn_zhuangbeiqianghua.gameObject:SetActive(true)
        if self.isAllequip==true then 
            self.dashiType = "zhuangbeiqianghua"
        end
    end
    if Player.Info.level < Tool.getUnlockLevel(239) then
        self.btn_zhuangbeijinglian.gameObject:SetActive(false)
        JINLIAN_ZHUANGBEI=false
    else 
        self.btn_zhuangbeijinglian.gameObject:SetActive(true)
        JINLIAN_ZHUANGBEI=true
        if self.dashiType==nil and self.isAllequip then 
            self.dashiType = "zhuangbeijinglian"
        end
    end
    if Player.Info.level < Tool.getUnlockLevel(237) or Player.Info.level < Tool.getUnlockLevel(804) then
        self.btn_baowuqianghua.gameObject:SetActive(false)
        QIANGHUA_BAOWU=false
    else 
        self.btn_baowuqianghua.gameObject:SetActive(true)
        QIANGHUA_BAOWU=true
        if JINLIAN_ZHUANGBEI==false then 
            self.btn_baowuqianghua.transform.localPosition=Vector3(-73,-2,0)
        else 
            self.btn_baowuqianghua.transform.localPosition=Vector3(81,-2,0)
        end
        if self.dashiType==nil and self.isAlltreasure then 
            self.dashiType = "baowuqianghua"
        end
    end 
    if Player.Info.level < Tool.getUnlockLevel(239) or Player.Info.level < Tool.getUnlockLevel(804) then
        self.btn_baowujinglian.gameObject:SetActive(false)
    else 
        self.btn_baowujinglian.gameObject:SetActive(true)
        if JINLIAN_ZHUANGBEI==true and QIANGHUA_BAOWU==true then 
            self.btn_baowujinglian.transform.localPosition=Vector3(235,-2,0)
        elseif JINLIAN_ZHUANGBEI==false or QIANGHUA_BAOWU==false then 
            self.btn_baowujinglian.transform.localPosition =Vector3(81,-2,0)
        else
            self.btn_baowujinglian.transform.localPosition =Vector3(-73,-2,0)
        end 
        if self.dashiType==nil and self.isAlltreasure then 
            self.dashiType = "baowujinglian"
        end
    end
end

function enhanced_master:onUpdate(char)
	if self.dashiType == "zhuangbeiqianghua"then 
        self:zhuangbeiContent()
        self:enhancedmaster_one()
	elseif self.dashiType == "zhuangbeijinglian" then 
        self:zhuangbeiContent()
        self:enhancedmaster_Two()
    elseif self.dashiType == "baowuqianghua" then 
        self:baowuContent()
            self:enhancedmaster_Three()
    elseif self.dashiType == "baowujinglian" then 
        self:baowuContent()
        self:enhancedmaster_Four()
	end
    self:changeBtnState()
end 
--装备强化大师信息
function enhanced_master:enhancedmaster_one()
    if self.dashilist ~=nil and self.dashilist[0]~=nil and self.dashilist[0] > 0 and self.isAllequip then 
        local curlv=self.dashilist[0]
        local curRow = TableReader:TableRowByID("master_ghost_lvUp",curlv)
        local curMagic=curRow.magic
        self.currentLv.text=string.gsub(TextMap.GetValue("LocalKey_831"),"{0}",curlv)
        local _text = ""
        for i=1 ,curMagic.Count do 
            if curMagic[i-1].magic_arg1~=0 and curMagic[i-1].magic_arg1~=nil then 
                local text = curMagic[i-1]._magic_effect.format
                if i==1 then 
                    _text=string.gsub(text,"{0}","+" .. (curMagic[i-1].magic_arg1 / curMagic[i-1]._magic_effect.denominator))
                else 
                    _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (curMagic[i-1].magic_arg1 / curMagic[i-1]._magic_effect.denominator))
                end
            end 
        end
        local nextRow = TableReader:TableRowByID("master_ghost_lvUp",curlv+1)
        self.currentdes.text=_text
        self.lvLabel.text=string.gsub(TextMap.GetValue("LocalKey_813"),"{0}",curlv)
        if nextRow == nil then 
             self.currentLv.text=string.gsub(TextMap.GetValue("LocalKey_813"),"{0}",curlv)
            self.nextLv.gameObject:SetActive(false)
            self.currentLv.gameObject.transform.localPosition =Vector3(0,80,0)
            self.Sprite:SetActive(false)
        else 
            self.nextLv.gameObject:SetActive(true)
            self.currentLv.gameObject.transform.localPosition =Vector3(-185,80,0)
            self.Sprite:SetActive(true)
            local nextMagic = nextRow.magic
            _text=string.gsub(TextMap.GetValue("LocalKey_813"),"{0}",curlv+1)
            _text=_text .. string.gsub(TextMap.GetValue("LocalKey_835"),"{0}",nextRow.lv)
            self.nextLv.text=_text
            _text=""
            for i=1 ,nextMagic.Count do 
                if nextMagic[i-1].magic_arg1~=0 and nextMagic[i-1].magic_arg1~=nil then 
                    local text = nextMagic[i-1]._magic_effect.format
                    if i==1 then 
                        _text=string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                    else 
                        _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                    end 
                end 
            end
            self.nextdes.text=_text
        end
    else
        self.currentLv.text=""
        if self.isAllequip then 
            self.currentdes.text=TextMap.GetValue("Text_1_1022")
        else 
            self.currentdes.text=TextMap.GetValue("Text_1_1023")
        end 
        local nextRow = TableReader:TableRowByID("master_ghost_lvUp",1)
        self.lvLabel.text=TextMap.GetValue("Text_1_1024")
        self.nextLv.gameObject:SetActive(true)
        self.currentLv.gameObject.transform.localPosition =Vector3(-185,80,0)
        self.Sprite:SetActive(true)
        local nextMagic = nextRow.magic
        local _text=TextMap.GetValue("Text_1_1025")
        _text=_text .. string.gsub(TextMap.GetValue("LocalKey_835"),"{0}",nextRow.lv)
        self.nextLv.text=_text
        _text=""
        for i=1 ,nextMagic.Count do 
            if nextMagic[i-1].magic_arg1~=0 and nextMagic[i-1].magic_arg1~=nil then 
                local text = nextMagic[i-1]._magic_effect.format
                if i==1 then 
                    _text=string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                else 
                    _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                end 
            end 
        end 
        self.nextdes.text=_text
    end
end

--装备精炼大师信息
function enhanced_master:enhancedmaster_Two()
    if self.dashilist ~=nil and self.dashilist[1] ~=nil and self.dashilist[1] > 0 and self.isAllequip then 
        local curlv=self.dashilist[1]
        local curRow = TableReader:TableRowByID("master_ghost_PowerUp",curlv)
        local curMagic=curRow.magic
        self.currentLv.text=string.gsub(TextMap.GetValue("LocalKey_832"),"{0}", curlv)
        local _text = ""
        for i=1 ,curMagic.Count do 
            if curMagic[i-1].magic_arg1~=0 and curMagic[i-1].magic_arg1~=nil then 
                local text = curMagic[i-1]._magic_effect.format
                if i==1 then 
                    _text=string.gsub(text,"{0}","+" .. (curMagic[i-1].magic_arg1 / curMagic[i-1]._magic_effect.denominator))
                else 
                    _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (curMagic[i-1].magic_arg1 / curMagic[i-1]._magic_effect.denominator))
                end 
            end 
        end
        local nextRow = TableReader:TableRowByID("master_ghost_PowerUp",curlv+1)
        self.currentdes.text=_text
        self.lvLabel.text=string.gsub(TextMap.GetValue("LocalKey_814"),"{0}",curlv)
        if nextRow == nil then 
            self.currentLv.text= string.gsub(TextMap.GetValue("LocalKey_814"),"{0}",curlv)
            self.nextLv.gameObject:SetActive(false)
            self.currentLv.gameObject.transform.localPosition =Vector3(0,80,0)
            self.Sprite:SetActive(false)
        else 
            _text=string.gsub(TextMap.GetValue("LocalKey_814"),"{0}",curlv+1)
            self.nextLv.gameObject:SetActive(true)
            self.currentLv.gameObject.transform.localPosition =Vector3(-185,80,0)
            self.Sprite:SetActive(true)
            local nextMagic = nextRow.magic
            _text=_text .. string.gsub(TextMap.GetValue("LocalKey_836"),"{0}",nextRow.lv)
            self.nextLv.text=_text
            _text=""
            for i=1 ,nextMagic.Count do 
                if nextMagic[i-1].magic_arg1~=0 and nextMagic[i-1].magic_arg1~=nil then 
                    local text = nextMagic[i-1]._magic_effect.format
                    if i==1 then 
                        _text=string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1/nextMagic[i-1]._magic_effect.denominator))
                    else 
                        _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1/nextMagic[i-1]._magic_effect.denominator))
                    end 
                end 
            end
            self.nextdes.text=_text
        end
     else
        self.currentLv.text=""
        if self.isAllequip ==true then
            self.currentdes.text=TextMap.GetValue("Text_1_1028")
        else 
            self.currentdes.text=TextMap.GetValue("Text_1_1029")
        end
        local nextRow = TableReader:TableRowByID("master_ghost_PowerUp",1)
        self.lvLabel.text=TextMap.GetValue("Text_1_1030")
        self.nextLv.gameObject:SetActive(true)
        self.currentLv.gameObject.transform.localPosition =Vector3(-185,80,0)
        self.Sprite:SetActive(true)
        local _text = TextMap.GetValue("Text_1_1031")
        local nextMagic = nextRow.magic
        _text=_text .. string.gsub(TextMap.GetValue("LocalKey_836"),"{0}",nextRow.lv)
        self.nextLv.text=_text
        _text=""
        for i=1 ,nextMagic.Count do 
            if nextMagic[i-1].magic_arg1~=0 and nextMagic[i-1].magic_arg1~=nil then 
                local text = nextMagic[i-1]._magic_effect.format
                if i==1 then 
                    _text=string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                else  
                    _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                end 
            end 
        end
        self.nextdes.text=_text
    end
end

--宝物强化大师信息
function enhanced_master:enhancedmaster_Three()
    if self.dashilist ~=nil and self.dashilist[2]~=nil and self.dashilist[2]>0 and self.isAlltreasure then 
        local curlv=self.dashilist[2]
        local curRow = TableReader:TableRowByID("master_treasure_lvUp",curlv)
        local curMagic=curRow.magic
        self.currentLv.text=string.gsub(TextMap.GetValue("LocalKey_830"),"{0}",curlv)
        local _text = ""
        for i=1 ,curMagic.Count do 
            if curMagic[i-1].magic_arg1~=0 and curMagic[i-1].magic_arg1~=nil then 
                local text = curMagic[i-1]._magic_effect.format
                if i==1 then 
                    _text=string.gsub(text,"{0}","+" .. (curMagic[i-1].magic_arg1 / curMagic[i-1]._magic_effect.denominator))
                else  
                    _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (curMagic[i-1].magic_arg1 / curMagic[i-1]._magic_effect.denominator))
                end 
            end 
        end
        local nextRow = TableReader:TableRowByID("master_treasure_lvUp",curlv+1)
        self.currentdes.text=_text
        self.lvLabel.text=string.gsub(TextMap.GetValue("LocalKey_815"),"{0}",curlv)
        if nextRow == nil then 
            self.currentLv.text=string.gsub(TextMap.GetValue("LocalKey_815"),"{0}",curlv)
            self.nextLv.gameObject:SetActive(false)
            self.currentLv.gameObject.transform.localPosition =Vector3(0,80,0)
            self.Sprite:SetActive(false)
        else 
            self.nextLv.gameObject:SetActive(true)
            self.currentLv.gameObject.transform.localPosition =Vector3(-185,80,0)
            self.Sprite:SetActive(true)
            local nextMagic = nextRow.magic
            _text=string.gsub(TextMap.GetValue("LocalKey_815"),"{0}",curlv+1)
            _text=_text .. string.gsub(TextMap.GetValue("LocalKey_837"),"{0}", nextRow.lv)
            self.nextLv.text=_text
            _text=""
            for i=1 ,nextMagic.Count do 
                if nextMagic[i-1].magic_arg1~=0 and nextMagic[i-1].magic_arg1~=nil then 
                    local text = nextMagic[i-1]._magic_effect.format
                    if i==1 then 
                        _text=string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                    else      
                        _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                    end 
                end 
            end
            self.nextdes.text=_text
        end
    else
        self.currentLv.text=""
        if self.isAlltreasure ==true then 
            self.currentdes.text=TextMap.GetValue("Text_1_1034")
        else 
            self.currentdes.text=TextMap.GetValue("Text_1_1035")
        end 
        local nextRow = TableReader:TableRowByID("master_treasure_lvUp",1)
        self.lvLabel.text=TextMap.GetValue("Text_1_1036")
        self.nextLv.gameObject:SetActive(true)
        self.currentLv.gameObject.transform.localPosition =Vector3(-185,80,0)
        self.Sprite:SetActive(true)
        local nextMagic = nextRow.magic
        local _text = TextMap.GetValue("Text_1_1037")
        _text=_text .. string.gsub(TextMap.GetValue("LocalKey_837"),"{0}", nextRow.lv)
        self.nextLv.text=_text
        _text=""
        for i=1 ,nextMagic.Count do 
            if nextMagic[i-1].magic_arg1~=0 and nextMagic[i-1].magic_arg1~=nil then 
                local text = nextMagic[i-1]._magic_effect.format
                if i==1 then 
                    _text=string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                else  
                    _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                end
            end  
        end
        self.nextdes.text=_text
    end
end

--宝物精炼大师信息
function enhanced_master:enhancedmaster_Four()
    if self.dashilist ~=nil and self.dashilist[3]~=nil and self.dashilist[3]>0 and self.isAlltreasure then 
        local curlv=self.dashilist[3]
        local curRow = TableReader:TableRowByID("master_treasure_PowerUp",curlv)
        local curMagic=curRow.magic
        self.currentLv.text=string.gsub(TextMap.GetValue("LocalKey_834"),"{0}",curlv)
        local _text = ""
        for i=1 ,curMagic.Count do 
            if curMagic[i-1].magic_arg1~=0 and curMagic[i-1].magic_arg1~=nil then 
                local text = curMagic[i-1]._magic_effect.format
                if i==1 then 
                    _text=string.gsub(text,"{0}","+" .. (curMagic[i-1].magic_arg1 / curMagic[i-1]._magic_effect.denominator))
                else 
                    _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (curMagic[i-1].magic_arg1 / curMagic[i-1]._magic_effect.denominator))
                end 
            end  
        end
        local nextRow = TableReader:TableRowByID("master_treasure_PowerUp",curlv+1)
        self.currentdes.text=_text
        self.lvLabel.text=string.gsub(TextMap.GetValue("LocalKey_816"),"{0}",curlv)
        if nextRow == nil then 
            self.currentLv.text=string.gsub(TextMap.GetValue("LocalKey_816"),"{0}",curlv)
            self.nextLv.gameObject:SetActive(false)
            self.currentLv.gameObject.transform.localPosition =Vector3(0,80,0)
            self.Sprite:SetActive(false)
        else 
            self.nextLv.gameObject:SetActive(true)
            self.currentLv.gameObject.transform.localPosition =Vector3(-185,80,0)
            self.Sprite:SetActive(true)
            local nextMagic = nextRow.magic
            _text=string.gsub(TextMap.GetValue("LocalKey_816"),"{0}",curlv+1)
            _text=_text .. string.gsub(TextMap.GetValue("LocalKey_838"),"{0}", nextRow.lv)
            self.nextLv.text=_text
            _text=""
            for i=1 ,nextMagic.Count do 
                if nextMagic[i-1].magic_arg1~=0 and nextMagic[i-1].magic_arg1~=nil then 
                    local text = nextMagic[i-1]._magic_effect.format
                    if i==1 then
                        _text=string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                    else   
                        _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                    end 
                end 
            end
            self.nextdes.text=_text
        end
    else
        self.currentLv.text=""
        if self.isAlltreasure ==true then 
            self.currentdes.text=TextMap.GetValue("Text_1_1039")
        else 
            self.currentdes.text=TextMap.GetValue("Text_1_1040")
        end 
        local nextRow = TableReader:TableRowByID("master_treasure_PowerUp",1)
        self.lvLabel.text=TextMap.GetValue("Text_1_1041")
        self.nextLv.gameObject:SetActive(true)
        self.currentLv.gameObject.transform.localPosition =Vector3(-185,80,0)
        self.Sprite:SetActive(true)
        local nextMagic = nextRow.magic
        local _text=TextMap.GetValue("Text_1_1042")
        _text=_text .. string.gsub(TextMap.GetValue("LocalKey_838"),"{0}", nextRow.lv)
        self.nextLv.text=_text
        for i=1 ,nextMagic.Count do 
            if nextMagic[i-1].magic_arg1~=0 and nextMagic[i-1].magic_arg1~=nil then 
                local text = nextMagic[i-1]._magic_effect.format
                if i==1 then
                    _text=string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                else   
                    _text=_text .. "\n" .. string.gsub(text,"{0}","+" .. (nextMagic[i-1].magic_arg1 / nextMagic[i-1]._magic_effect.denominator))
                end 
            end 
        end
        self.nextdes.text=_text
    end
end

function enhanced_master:onClick(go, name)
    if name == "btnClose" then
        UIMrg:popWindow()
	elseif name == "btn_zhuangbeiqianghua" then 
        if self.dashiType ~= "zhuangbeiqianghua" then 
            self.dashiType = "zhuangbeiqianghua"
            iscanClick=false
            self:onUpdate(self.char)
        end 
    elseif name == "btn_zhuangbeijinglian" then 
        if self.dashiType ~= "zhuangbeijinglian" then 
            self.dashiType = "zhuangbeijinglian"
            iscanClick=false
            self:onUpdate(self.char)
        end 
	elseif name == "btn_baowuqianghua" then 
        if self.dashiType ~= "baowuqianghua" then 
            self.dashiType = "baowuqianghua"
            iscanClick=false
            self:onUpdate(self.char)
        end 
	elseif name == "btn_baowujinglian" then 
        if self.dashiType ~= "baowujinglian" then 
            self.dashiType = "baowujinglian"
            iscanClick=false
            self:onUpdate(self.char)
        end 
    elseif name =="btnItem1"then 
        self:onclickItem(1)
    elseif name =="btnItem2"then 
        self:onclickItem(2)
    elseif name =="btnItem3"then 
        self:onclickItem(3)
    elseif name =="btnItem4"then 
        self:onclickItem(4)
    end
end

function enhanced_master:onclickItem(index)
    local item = {}
    if self.dashiType == "zhuangbeiqianghua" then 
        item=self.zhuangbei_list[index]
        uSuperLink.open("ghost",  {1,item})--装备强化界面
    elseif self.dashiType == "zhuangbeijinglian" then 
        item = self.zhuangbei_list[index]
        uSuperLink.open("ghost",  {2, item})--装备精炼界面
    elseif self.dashiType == "baowuqianghua" then 
        local infotemp = {}
        infotemp.treasure = self.baowu_list[index]
        infotemp.typemode = "strength"
        Tool.push("treasure_info","Prefabs/moduleFabs/TreasureModule/treasureInfo",infotemp)
    elseif self.dashiType == "baowujinglian" then 
        local infotemp = {}
        infotemp.treasure = self.baowu_list[index]
        infotemp.typemode = "jinglian"
        Tool.push("treasure_info","Prefabs/moduleFabs/TreasureModule/treasureInfo",infotemp)
    end
end

function enhanced_master:baowuContent()
	self:updateTreasure()
	for i = 1, #self.baowu_list do
		self ["Item" .. i]:SetActive(false)
        if self["itemAll" .. i] ==nil then 
            self["itemAll" .. i] = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self ["Pic" .. i].gameObject)
        end 
        self["itemAll" .. i]:CallUpdate({ "char", self.baowu_list[i], self ["Pic" .. i].width, self ["Pic" .. i].height })
        self ["Pic" .. i].enabled=false
		local name =self.baowu_list[i]:getDisplayColorName()
		self ["Name" .. i].text=name
		if self.dashiType == "baowuqianghua" then 
            local curlv=self.dashilist[2]
            if curlv ==nil or curlv<0 then 
                curlv=0
            end 
            local nextRow = TableReader:TableRowByID("master_treasure_lvUp",curlv+1)
            if nextRow==nil then nextRow = TableReader:TableRowByID("master_treasure_lvUp",curlv) end 
			local maxLv = nextRow.lv
			self["progress" .. i].text=self.baowu_list[i].lv .. "/" .. maxLv
			self["Slider" .. i].value =self.baowu_list[i].lv/maxLv
			self.progressLabel.text =TextMap.GetValue("Text_1_1044")
			self.tip.text=TextMap.GetValue("Text_1_1045")
		elseif self.dashiType == "baowujinglian" then 
            local curlv=self.dashilist[3]
            if curlv ==nil or curlv<0 then 
                curlv=0
            end 
            local nextRow = TableReader:TableRowByID("master_treasure_PowerUp",curlv+1)
            if nextRow ==nil then nextRow = TableReader:TableRowByID("master_treasure_PowerUp",curlv) end 
			local maxpower = nextRow.lv
			self["progress" .. i].text=self.baowu_list[i].power .. "/" .. maxpower
			self["Slider" .. i].value =self.baowu_list[i].power/maxpower
			self.progressLabel.text =TextMap.GetValue("Text_1_1046")
			self.tip.text=TextMap.GetValue("Text_1_1047")
		end
        self ["Item" .. i]:SetActive(true)
	end
	for i=#self.baowu_list+1,4 do 
		self ["Item" .. i]:SetActive(false)
	end
end

function enhanced_master:updateTreasure()
    local char_id = self.char.id
    local treasure = Player.Treasure
    local treasureSlot = Player.Chars[char_id].treasure --self.char.treasure
    local list = {}
    local treasure_equipPos = {}
    self.treasureArg = {}


    for i=1,2 do
        if i > treasureSlot.Count then
            list[i] = { empty = true, charIndex = self.index, equipIndex = i - 1, char = self.char ,subtype = "treasure"}
            treasure_equipPos[i] = false
            --self.treasureArg[i] = {name = "",value = 0}
        else

            local key = treasureSlot[i-1]
            if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
                if treasure[key] ~= nil then

                    local ts = Treasure:new(treasure[key].id, key)
                    ts.hasWear = 1
                    ts.equipIndex = i - 1
                    ts.charIndex = index
                    ts.char = self.char
                    ts.subtype = "treasure"
                    list[i] = ts
                    treasure_equipPos[i] = true
                end
            else
                treasure_equipPos[i] = false
                list[i] = { empty = true, charIndex = self.index, equipIndex = i - 1, char = self.char ,subtype = "treasure"}
            end
        end
    end

    self.treasure_equipPos = treasure_equipPos
    self.baowu_list={}
    for i = 1, #list do
        if treasure_equipPos[i]==true then 
        	table.insert(self.baowu_list, list[i])
        end
    end
end

function enhanced_master:zhuangbeiContent()
	self:updateGhost()
	for i = 1, #self.zhuangbei_list do
		self ["Item" .. i]:SetActive(true)
        if self["itemAll" .. i] ==nil then 
            self["itemAll" .. i] = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self ["Pic" .. i].gameObject)
        end 
        self["itemAll" .. i]:CallUpdate({ "char", self.zhuangbei_list[i], self ["Pic" .. i].width, self ["Pic" .. i].height })
        self ["Pic" .. i].enabled=false
		local name =self.zhuangbei_list[i]:getDisplayName()
		name =self.zhuangbei_list[i]:getItemColorName(self.zhuangbei_list[i].star,name)
		self ["Name" .. i].text=name
		if self.dashiType == "zhuangbeiqianghua" then 
			local curlv=self.dashilist[0]
            if curlv ==nil or curlv<0 then 
                curlv=0
            end 
            local nextRow = TableReader:TableRowByID("master_ghost_lvUp",curlv+1)
            if nextRow==nil then nextRow=TableReader:TableRowByID("master_ghost_lvUp",curlv) end 
            local maxLv = nextRow.lv
			self["progress" .. i].text=self.zhuangbei_list[i].lv .. "/" .. maxLv
			self["Slider" .. i].value =self.zhuangbei_list[i].lv/maxLv
			self.progressLabel.text =TextMap.GetValue("Text_1_1044")
			self.tip.text=TextMap.GetValue("Text_1_1048")
		elseif self.dashiType == "zhuangbeijinglian" then 
            local curlv=self.dashilist[1]
            if curlv ==nil or curlv<0 then 
                curlv=0
            end 
            local nextRow = TableReader:TableRowByID("master_ghost_PowerUp",curlv+1)
            if nextRow==nil then nextRow = TableReader:TableRowByID("master_ghost_PowerUp",curlv) end
			local maxpower = nextRow.lv
			self["progress" .. i].text=self.zhuangbei_list[i].power .. "/" .. maxpower
			self["Slider" .. i].value =self.zhuangbei_list[i].power/maxpower
			self.progressLabel.text =TextMap.GetValue("Text_1_1046")
			self.tip.text=TextMap.GetValue("Text_1_1049")
		end
	end
	for i=#self.zhuangbei_list+1,4 do 
		self ["Item" .. i]:SetActive(false)
	end
end

function enhanced_master:updateGhost()
    local index = self.index
    local ghostSlot = Player.ghostSlot
    local ghost = Player.Ghost
    local slot = ghostSlot[index]
    local postion = slot.postion
    local list = {}
    local len = postion.Count
    local equipPos = {}
    self.ghostArg = {}
    self.gostAttrName = {}
    for i = 1, 4 do
        if i > len then
            list[i] = { empty = true,charIndex = self.index, equipIndex = i - 1, char = self.char }
            equipPos[i] = false
            self.ghostArg[i] = 0
        else
            local key = postion[i - 1]
            if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
                local g = ghost[key].id
                if g == 0 then
                    equipPos[i] = false
                    self.ghostArg[i] = 0
                    list[i] = { empty = true,charIndex = self.index, equipIndex = i - 1, char = self.char }
                else
                    local gh = Ghost:new(g, key)
                    gh.hasWear = 1
                    gh.equipIndex = i - 1
                    gh.charIndex = index
                    gh.char = self.char
                    list[i] = gh
                    equipPos[i] = true
                    self.ghostArg[i] = gh:getMainArg()
                    self.gostAttrName[i] = gh:getMainAttrName()
                end

            else
                equipPos[i] = false
                list[i] = { empty = true, charIndex = self.index, equipIndex = i - 1, char = self.char }
                self.ghostArg[i] = 0
            end
        end
    end
    self.equipPos = equipPos
    self.zhuangbei_list={}
    for i = 1, #list do
    	if self.equipPos[i]==true then 
    		table.insert(self.zhuangbei_list, list[i])
    	end 
    end
end

function enhanced_master:changeBtnState()
    local check = 1
	if self.dashiType == "zhuangbeiqianghua" then 
        check=1
	elseif self.dashiType == "zhuangbeijinglian" then 
		check=2
	elseif self.dashiType == "baowuqianghua" then 
		check=3
	elseif self.dashiType == "baowujinglian" then 
		check=4
	end
    for i=1,4 do
        if i==check then 
            self.check[i]:SetActive(true)
        else 
            self.check[i]:SetActive(false)
        end 
    end
    iscanClick=true
end 


return enhanced_master
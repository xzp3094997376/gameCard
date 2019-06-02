local m = {}

--[[
{ pid: 'YukOR',
       name: TextMap.GetValue("Text_1_309"),
       level: 80,
       vip: 12,
       power: 423734,
       gongxun: 7780,
       dmg: 1966191,
       t: 1436607757222,
       type: 'daxu' },
]]

function m:update(data)
    self.data = data
    self.txt_item_name.text = Char:getItemColorName(data.quality, data.name)
    if data.gongxun then
        self.txt_desc.text = "[FFFF96FF]"..TextMap.GetValue("Text816").."[-]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(data.gongxun)))--data.gongxun
    elseif data.dmg then
        self.txt_desc.text = "[FFFF96FF]"..TextMap.GetValue("Text817").."[-]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(data.dmg)))--data.dmg
    end
    self.txt_slider.text = "[FFFF96FF]"..TextMap.GetValue("Text408").."[-]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(data.power)))--data.power
    self.txt_lv.text = TextMap.GetValue("Text_1_310")..data.level
	--
	if data.dictid ~= nil then
		local  char = Char:new(data.dictid)
		local ima = char:getHeadSpriteName()
		self.icon:setImage(ima, packTool:getIconByName(ima))
		self.img_icon.spriteName = char:getFrame()
		self.beijing.spriteName = char:getFrameBG()
	end
	--
    -- if data.rank <= 3 then
    --     self.binding:Show("sp_rank")
    --     self.binding:Hide("txt_rank")
    --     self.sp_rank.spriteName = "rank_" .. data.rank
    -- else
        self.binding:Hide("sp_rank")
        self.binding:Show("txt_rank")
        self.txt_rank.text =string.gsub(TextMap.GetValue("LocalKey_808"),"{0}",data.rank)
    -- end
end

function m:showDetailInfo(pid)
    Api:showGxDetailInfo(pid, function(result)
        local temp = {}
        temp.data = result.info.defenceTeam
        temp.show = false

        local datas = {}
        datas["info"] = result.info
        datas.rank = self.data.rank
        temp.peopleVO = datas
        temp.pid = pid
        temp.title = TextMap.GetValue("Text818")
        temp.tp = "normal"
        datas = nil
        UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/arena_enemy_info", temp)
        temp = nil
        result = nil
    end)
end

function m:onClick(go, name)
    m:showDetailInfo(self.data.pid)
end

function m:Start()
end

return m
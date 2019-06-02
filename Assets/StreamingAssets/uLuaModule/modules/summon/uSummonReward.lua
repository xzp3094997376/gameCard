local RewardChar = require("uLuaModule/modules/summon/uRewardChar.lua")

local Reward = {}
local DrawId = {
    NorOneFree = 4,
    NorOne = 1,
    NorTen = 6,
    SpOneFree = 5,
    SpOne = 2,
    SpTen = 3
}

local GOLD_DRAW_LOOP = 10
local GOLD_DRAW_LOOP_CHENG = 10

--金币抽卡循环

local MONEY_DRAW_LOOP = 10
local MONEY_DRAW_LOOP_CHENG = 10


--关闭奖励显示
function Reward:destory()
    --    SendBatching.DestroyGameOject(self.binding.gameObject)
    UIMrg:pop()
end

--确定
function Reward:onOk()
    if self.delegate then
        self.delegate:activeEvent(false)
    end
    self:destory()
end

--再抽一次
function Reward:onSummon(go)
    --    self:destory()
    self.cbAgin(go, self)
end

function Reward:Next()
    --    self.ItemIcon:Play("ani", "reward_effect", funcs.handler(self, self.play))
    --self.ItemIcon:PlayTween("ani", 0.3, funcs.handler(self, self.play))
end



function Reward:play()
    self.zhaohuan_door:SetActive(false)
    self.effectZhaokai:SetActive(false)
    self.ItemIcon:SetActive(false)
    self.index  = self.index + 1
    local list = self.rewardList
    local index = self.index
    local count = table.getn(list)
    local item = list[index]
    if item.star ~= nil and item.star > 3 then
        local time = 1
        if item.star > 4 then
            time = 3.5
        end
        local soundInfo = TableReader:TableRowByID("avter", item.dictid)
        if soundInfo.jianjie_audio ~= nil and soundInfo.jianjie_audio ~= "" and soundInfo.jianjie_audio > 0 then
            self.binding:CallAfterTime(time, function()
                 MusicManager.playByID(soundInfo.jianjie_audio)
           end)
        end
    end
    local tp = item:getType()
    if tp == "char" then
        if item.star >= 5 then
            self.bg_black:SetActive(true)
            self.zhaohuan_door:SetActive(true)
            MusicManager.playByID(24)
            self.binding:CallAfterTime(2.5, function()
                self.zhaohuan_door:SetActive(false)
                self.effectZhaokai:SetActive(true)
                self.binding:CallAfterTime(0.2, function()
                    self.binding:CallAfterTime(0.8, function()
                        self.effectZhaokai:SetActive(false)
                        end)
                    if (tp == "charPieceSplit") then
                        MusicManager.playByID(23)
                    else
                        MusicManager.playByID(23)
                    end
                    ------------------------------------------------------------------- fix at 2015年5月6日 去掉星星,加名字颜色------------------------------------------------------------------------------
                    local na = item.name
                    if tp == "charPiece" or tp == "charPieceSplit" then
                        na = na .. " x" .. item.rwCount
                    end
                    self.txt_name.text = Tool.getNameColor(item.star) .. na .. "[-]"
                    self.ItemIcon:SetActive(true)
                    self.ChoukaItemIcon:CallUpdate(item)
                    self.ani_show_button.enabled = true
                    self.bg_black:SetActive(false)
                end)
            end)
        else
            self.bg_black:SetActive(false)
            if (item:getType() == "charPieceSplit") then
                MusicManager.playByID(23)
            else
                MusicManager.playByID(23)
            end
            self.effectZhaokai:SetActive(true)
        ------------------------------------------------------------------- fix at 2015年5月6日 去掉星星,加名字颜色------------------------------------------------------------------------------
            self.txt_name.text = Tool.getNameColor(item.star) .. item.name .. "[-]"
            local that = self
          
            self.binding:CallAfterTime(0.2, function()
                self.binding:CallAfterTime(0.8, function()
                    self.effectZhaokai:SetActive(false)
                    end)
                self.ItemIcon:SetActive(true)
                self.ChoukaItemIcon:CallUpdate(item)
                self.ani_show_button.enabled = true
                end)
        end
    else

        MusicManager.playByID(23)
        self.ItemIcon:SetActive(true)
        self.ChoukaItemIcon:CallUpdate(item)
        self.ani_show_button.enabled = true
        self.binding:CallManyFrame(function()
            self:Next()
        end, 1)
    end
end


function Reward:showInfo()
    local char = self.rewardList[1]
    if char == nil then return end
    Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", char)
end

function Reward:onClick(go, name)
    if name == "btn_queding" then
        self:onOk()
    elseif name == "hero_info" then
        self:showInfo()
    elseif name == "btn_zaichouyici" then
        self:onSummon()
    end
end

function Reward:update(luaTable)
    self.result = luaTable.result
    self.cbAgin = luaTable.cbAgin
    self.txt_cost.text = luaTable.cost .. ""
    if luaTable.consume.consume_type=="gold" or luaTable.consume.consume_type=="money" then 
        local ziyuan=Tool.getCountByType(luaTable.consume.consume_type)
        local ziyuanTxt=toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan)))
        if luaTable.cost<=ziyuan then 
            if luaTable.consume.consume_type=="gold" then 
                self.txt_cost.text ="[ffff96]" .. ziyuanTxt .. "/" .. luaTable.cost .."[-]"
            else 
                self.txt_cost.text ="[ffffff]" .. ziyuanTxt .. "/" .. luaTable.cost .."[-]"
            end
        else 
            self.txt_cost.text ="[ff0000]" .. ziyuanTxt .. "/" .. luaTable.cost .."[-]"
        end
    elseif luaTable.consume.consume_type=="item" then 
        local ziyuan=Player.ItemBagIndex[luaTable.consume.consume_arg].count
        if luaTable.cost<=ziyuan then 
            self.txt_cost.text ="[ffffff]" .. ziyuan .. "/" .. luaTable.cost .."[-]"
        else 
            self.txt_cost.text ="[ff0000]" .. ziyuan .. "/" .. luaTable.cost .."[-]"
        end
    end

    --self.icon.spriteName = Tool.getResIcon(luaTable.cost_type)
    self.delegate = luaTable.delegate
	
    local darw_id = luaTable.darw_id
	if darw_id == 2 then 
		self.tips.text = TextMap.GetValue("Text_1_2789")
	elseif darw_id == 1 then 
		self.tips.text = TextMap.GetValue("Text_1_2790")
	end
    if self.ItemIcon ~=nil then
        self.ItemIcon:SetActive(false)
    end
    self.icon.Url = UrlManager.GetImagesPath("itemImage/" .. luaTable.cost_icon .. ".png")

   if darw_id == 1 or darw_id==4 or darw_id ==6 then
        local count = Player.Times.totalMdraw  + 1
        local num = count % MONEY_DRAW_LOOP
        if num == MONEY_DRAW_LOOP_CHENG then
         --必得橙卡
            self.msg.text = TextMap.GetValue("Text_1_2791")
        elseif num == 0 and count > 0 then
            self.msg.text = TextMap.GetValue("Text_1_2792")
        else
          --多少次后得橙卡
            if num == 0 then num = 1 end
            self.msg.text = TextMap.GetValue("Text_1_2793") .. GOLD_DRAW_LOOP_CHENG - num .. TextMap.GetValue("Text_1_2794")
        end
       -- self.icon.spriteName="icon_jinbi"
    else 
        local count = Player.Times.totalGdraw + 1
        local num = count % GOLD_DRAW_LOOP
        if num == GOLD_DRAW_LOOP_CHENG then
            --必得橙卡
            self.msg.text = TextMap.GetValue("Text_1_2795")
        elseif num == 0 and count > 0 then
            self.msg.text = TextMap.GetValue("Text_1_2795")
        else
           --多少次后得橙卡
           if num == 0 then num = 1 end
           self.msg.text = TextMap.GetValue("Text_1_2793") .. GOLD_DRAW_LOOP_CHENG - num .. TextMap.GetValue("Text_1_2796")
        end
        --self.icon.spriteName="icon_zuanshi"
    end
	
    local list = RewardMrg.getList(self.result)
    self.ani_show_button:ResetToBeginning()

    self.rewardList = list
    self.index = 0
    --    self:play()
    local that = self
	self.color.gameObject:SetActive(false)
    that:play()
end

function Reward:Start()
    self.bg_black:SetActive(false)
    local row = TableReader:TableRowByID("drawSetting", 7)
    if row then
        FREE_TIMES_COUNT = row.arg2
    end
    row = TableReader:TableRowByID("drawSetting", 2)
    if row then
        GOLD_DRAW_LOOP = row.arg1
    end

    row = TableReader:TableRowByID("drawSetting", 4)
    if row then
        GOLD_DRAW_LOOP_CHENG = row.arg1
    end
     row = TableReader:TableRowByID("drawSetting", 1)
    if row then
        MONEY_DRAW_LOOP = row.arg1
    end

    row = TableReader:TableRowByID("drawSetting", 9)
    if row then
        MONEY_DRAW_LOOP_CHENG = row.arg1
    end
end

--初始化
function Reward:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

--显示
function Reward:show(luaTable)
    --    local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/choukaModule/RewardItem", GlobalVar.Center)
    --    local luaTable = { result = result, cbAgin = cbAgin, darw_id = darw_id }
    --    if luaTable ~= nil then
    --        binding:CallUpdate(luaTable)
    --    end
     Tool.push("RewardItem", "Prefabs/moduleFabs/choukaModule/RewardItem", luaTable)
end


return Reward

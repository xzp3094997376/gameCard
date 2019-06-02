local arenaDes = {}
local rankingDesc
local obj = {}
local awardObj = nil

function arenaDes:setdata(time)
    if awardObj == nil then
        self.txt_shuijing.text = 0
        self.txt_gold.text = 0
        self.txt_lingzi.text = 0
    else
        local drop = awardObj.drop
        if drop.Count == 0 then
            self.txt_shuijing.text = 0
            self.txt_gold.text = 0
            self.txt_lingzi.text = 0
        else
            self.txt_shuijing.text = awardObj.drop[0].arg
            self.txt_gold.text = awardObj.drop[1].arg
            self.txt_lingzi.text = awardObj.drop[2].arg
        end
    end

    UluaModuleFuncs.Instance.uTimer:removeFrameTime("sureArenaDesc")
end

--设置信息
function arenaDes:update(data)
    self.type = data.tp
    self.delegate = data.delegate

    local tb_id = 3 --默认为普通竞技场
    local info = Player.VSBattle
    if self.type == 2 then --跨服竞技场
        tb_id = 11
        info = Player.crossArena
    end
    obj = TableReader:TableRowByID("moduleExplain", tb_id)
    self.txt_rule.text = string.gsub(obj.desc, '\\n', '\n')

    local _now_rank = info.now_rank
    if info.best_rank > _now_rank then
        self.txt_paiMing.text = _now_rank
    else
        self.txt_paiMing.text = info.best_rank
    end

    if self.type == 2 then
        self.normal:SetActive(false)
        self.kuafu:SetActive(true)
        self.txt_faFang:SetActive(false)
        self.txt_keep.text = ""
        self.txt_kuafu_keep.text =string.gsub(TextMap.GetValue("LocalKey_661"),"{0}",_now_rank)
        if self.delegate ~= nil then
            self.txt_count.text = self.delegate.speed..TextMap.GetValue("Text463")
        end
        local tb = TableReader:TableRowByID("MultiVsArgs", "honor_limit"..Player.Info.vip)
        self.txt_max.text = tb.arg
    else 
        self.normal:SetActive(true)
        self.kuafu:SetActive(false)
        self.txt_faFang :SetActive(true)

        local ishaveValue = false
        TableReader:ForEachLuaTable("dailyPrize",
            function(index, item)
                if item.rank_tag == _now_rank then
                    awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", item.rank_tag)
                    rankingDesc = item.desc
                    if item.desc == 0 then
                        self.txt_keep.text = string.gsub(TextMap.GetValue("LocalKey_661"),"{0}",_now_rank)
                    else
                        local msg = string.gsub(TextMap.GetValue("LocalKey_683"),"{0}",_now_rank)
                        self.txt_keep.text =string.gsub(msg,"{1}",_now_rank .. rankingDesc)
                    end
                    ishaveValue = true
                elseif item.rank_tag > _now_rank then
                    if ishaveValue == false then
                        awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", rankingDesc)
                        rankingDesc = awardObj.rank_tag .. awardObj.desc
                        local msg = string.gsub(TextMap.GetValue("LocalKey_683"),"{0}",_now_rank)
                        self.txt_keep.text =string.gsub(msg,"{1}",rankingDesc)
                        ishaveValue = true
                    end
                end
                if ishaveValue == false then
                    rankingDesc = item.rank_tag
                end
                return false
            end)
        UluaModuleFuncs.Instance.uTimer:frameTime("sureArenaDesc", 1, 1, self.setdata, self)
    end
end

function arenaDes:onClick(go, name)
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("sureArenaDesc")
    UIMrg:popWindow()
end

--初始化
function arenaDes:Start()
    -- self:update()
    local name = Tool.getResIcon("Multi_honor")
    local assets = packTool:getIconByName(name)
    self.icon_1:setImage(name, assets)
    self.icon_2:setImage(name,assets)
end

return arenaDes
--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/18
-- Time: 11:15
-- To change this template use File | Settings | File Templates.
--
TextMap = {}

function TextMap.GetValue( str )
    return Localization.Get(str)
end
TextMap = {
    TXT_TOP_STAR = TextMap.GetValue("Text7"),
    TXT_NO_CHAR_PIECE = TextMap.GetValue("Text8"),
    TXT_NEED_CHAR_LEVEL = TextMap.GetValue("Text9"),
    TXT_STAR_UP_NEED_MONEY = TextMap.GetValue("Text10"),
    TXT_TOP_POWER_UP = TextMap.GetValue("Text11"),
    TXT_IS_POWER_CHAR = TextMap.GetValue("Text12"),
    TXT_UNLOCK_SKILL = TextMap.GetValue("Text13"),
    TXT_PLAYER_LEVEL_EQUALS = TextMap.GetValue("Text14"),
    FIGHT_TIMES = TextMap.GetValue("Text15"),
    TIMES_OUT = TextMap.GetValue("Text16"),
    CD = TextMap.GetValue("Text17"),
    TXT_OPEN_MODULE_BY_LEVEL = TextMap.GetValue("Text18"),
    TXT_OPEN_MODULE_BY_CHAR_LEVEL = TextMap.GetValue("Text1806"),
    TXT_OPEN_MODULE_BY_CHAPTER = TextMap.GetValue("Text19"),
    TXT_LING_LUO_LEVEL = TextMap.GetValue("Text20"),
    TXT_SUMMON_CHAR_NEED_COST_MONEY = TextMap.GetValue("Text21"),
    TXT_CHAR_TO_PIECE_COUNT = TextMap.GetValue("Text22"),
    GET_BP = TextMap.GetValue("Text23"),
    GET_MONEY = TextMap.GetValue("Text24"),
    GET_SKILL_POINT = TextMap.GetValue("Text25"),
    TITLE_BP = TextMap.GetValue("Text26"),
    TITLE_BP_NUM = TextMap.GetValue("Text27"),
    TITLE_MONEY = TextMap.GetValue("Text28"),
    TITLE_MONEY_NUM = TextMap.GetValue("Text29"),
    TITLE_SKILL_POINT = TextMap.GetValue("Text30"),
    TITLE_SKILL_POINT_NUM = TextMap.GetValue("Text27"),
    TIMES_OUT = TextMap.GetValue("Text31"),
    BUY_SUCC = TextMap.GetValue("Text32"),
    VIP_LEVEL_OPEN = TextMap.GetValue("Text33"),
    BUY_SKILL_POINT = TextMap.GetValue("Text34"),
    FROM = TextMap.GetValue("Text35"),
    REFRESH_OFFER_OR_CHALLENGE = TextMap.GetValue("Text36"),
    REFRESH_TIMES_OUT = TextMap.GetValue("Text37"),
    NEED_VIP_LEVEL = TextMap.GetValue("Text38"),
    MAX_SOLT_OPEN = TextMap.GetValue("Text39"),
    money = TextMap.GetValue("Text40"),
    gold = TextMap.GetValue("Text41"),
    honor = TextMap.GetValue("Text42"), --竞技场
    credit = TextMap.GetValue("Text43"), --虚夜宫
    donate = TextMap.GetValue("Text44"), --协会
    soul = TextMap.GetValue("Text45"),
    bp = TextMap.GetValue("Text46"),
    char = TextMap.GetValue("Text47"),
    charPiece = TextMap.GetValue("Text48"),
    equip = TextMap.GetValue("Text49"),
    equipPiece = TextMap.GetValue("Text48"),
    item = TextMap.GetValue("Text50"),
    reel = TextMap.GetValue("Text51"),
    reelPiece = TextMap.GetValue("Text52"),
    exp = TextMap.GetValue("Text53"),
    TODAY = TextMap.GetValue("Text54"),
    TOMORROW = TextMap.GetValue("Text55"),
    COST_TYPE = TextMap.GetValue("Text56"),
    BUY_SKILL_DESC = TextMap.GetValue("Text57"),
    BUY_BP_VIP_COUNT = TextMap.GetValue("Text58"),
    TXT_GOLD_NONE = TextMap.GetValue("Text59"),
    TXT_GO_TO_SHOP_BUY_ITEM = TextMap.GetValue("Text60"),
    VIP_REFRESH_SHOP = TextMap.GetValue("Text61"),
    UNLOCK_XI_LIAN = TextMap.GetValue("Text62"),
    TXT_GO_TO_CHPTER = TextMap.GetValue("Text63"),
    TXT_MUST_ALL_EQUIP = TextMap.GetValue("Text64"),
    TXT_TOTAL = TextMap.GetValue("Text65"),
    TXT_BEFOR = TextMap.GetValue("Text66"),
    TXT_TODAY_BUY_TIMES = TextMap.GetValue("Text67"),
    TXT_CHONG_ZHI = TextMap.GetValue("Text68"),
    TXT_CHONG_ZHI_VIP = TextMap.GetValue("Text69"),
    TIPS = TextMap.GetValue("Text70"),
    TXT_HAS_ENTER_BATTLE = TextMap.GetValue("Text71"),
    TXT_TEAM_POWER = TextMap.GetValue("Text72"),
    TXT_FORMATION_POS = TextMap.GetValue("Text73"),
    TXT_UNLOCK_DAILY = TextMap.GetValue("Text74"),
    UNLOCK_SKILL = TextMap.GetValue("Text75"),
    SKILL_OPEN = TextMap.GetValue("Text76"),
    PlsSelectMaterial = TextMap.GetValue("Text77"),
    MaterialHasSelected = TextMap.GetValue("Text78"),
    TXT_NEED_EXP_FULL = TextMap.GetValue("Text79"),
    TXT_CTN_FIGHT = TextMap.GetValue("Text80"),
    TXT_XI_BIE_TOP = TextMap.GetValue("Text81"),
    TXT_XI_BIE_UP = TextMap.GetValue("Text82"),
    PLS_SET_FORMATION = TextMap.GetValue("Text83"),
    Slogout = TextMap.GetValue("Text84"),
    TXT_JJC_CAN_FIGHT_TIME = TextMap.GetValue("Text85"),
    TXT_JJC_BUY_COST = TextMap.GetValue("Text86"),
    TXT_CUR_SKILL = TextMap.GetValue("Text87"),
    NEED_TRANSFORM_LEVEL = TextMap.GetValue("Text88"),
    TXT_GOTO_POWER_UP = TextMap.GetValue("Text89"),
    TXT_XIULIAN = TextMap.GetValue("Text90"),
    TXT_XIULIAN_LEVEL = TextMap.GetValue("Text91"),
    TXT_HECHENG = TextMap.GetValue("Text92"),
    TXT_GET = TextMap.GetValue("Text93"),
    TXT_JINHUA = TextMap.GetValue("Text94"),
    TXT_POWER_TO_SIX = TextMap.GetValue("Text95"),
    TXT_NORMAL_XILIAN = TextMap.GetValue("Text96"),
    TXT_ZHUAN_JIA_XILIAN = TextMap.GetValue("Text97"),
    TXT_DA_SHI_XILIAN = TextMap.GetValue("Text98"),
    TXT_LOGIN_OUT = TextMap.GetValue("Text99"),
    MY_RANK = TextMap.GetValue("Text100"),
    RANK = TextMap.GetValue("Text101"),
    TXT_NOT_ITEM = TextMap.GetValue("Text102"),
    TXT_GO_TO_BUY_MONEY = TextMap.GetValue("Text103"),
    ITEM_GU_LING_WAN = TextMap.GetValue("Text104"),
    ITEM_LING_HUA_XIAO_ZI = TextMap.GetValue("Text105"),
    po = TextMap.GetValue("Text106"),
    hui = TextMap.GetValue("Text107"),
    fu = TextMap.GetValue("Text108"),
    jie = TextMap.GetValue("Text109"),
    TXT_POWER_UP_GHOST_NEED_MONEY = TextMap.GetValue("Text110"),
    TXT_UNLOCK_FORMATION = TextMap.GetValue("Text111"),
    TXT_NO_CHAR_PIECE = TextMap.GetValue("Text112"),
    HAS_NO_GOHST = TextMap.GetValue("Text113"),
    TXT_NEW_FORMATION = TextMap.GetValue("Text114"),
    TXT_UNLOCK_LV = TextMap.GetValue("Text115"),
    TXT_UNLOCK_DELEGATE = TextMap.GetValue("Text116"),
    TXT_NEXT_REWARD_TIME = TextMap.GetValue("Text117"),
    Finder = TextMap.GetValue("Text118"),
    FindDaXu = TextMap.GetValue("Text119"),
    RunTime = TextMap.GetValue("Text120"),
    TXT_DA_XU_DESC = TextMap.GetValue("Text121"),
    TXT_FOUND_DA_XU_DESC = TextMap.GetValue("Text122"),
    TXT_DA_XU_DESC1 = TextMap.GetValue("Text123"),
    TXT_DA_XU_DESC2 = TextMap.GetValue("Text124"),
    TXT_RESET_DAXU_REWARD = TextMap.GetValue("Text125"),
    TXT_DAXU_REWAD_NEED = TextMap.GetValue("Text126"),
    TXT_DAXU_RANK1 = TextMap.GetValue("Text127"),
    TXT_DAXU_RANK2 = TextMap.GetValue("Text128"),
    TXT_TASK_JIFEN = TextMap.GetValue("Text129"),
    TXT_WORLD_BOSS_DMG = TextMap.GetValue("Text130"),
    TXT_WORLD_BOSS_COST_MONEY = TextMap.GetValue("Text131"),
    TXT_WORLD_BOSS_COST_GOLD = TextMap.GetValue("Text132"),
    TXT_WORLD_BOSS_OPEN_TIME = TextMap.GetValue("Text133"),
    TXT_ADD_BUFF_FAIL = TextMap.GetValue("Text134"),
    TXT_ADD_BUFF_SUCC = TextMap.GetValue("Text135"),
    TXT_ADD_DMG = TextMap.GetValue("Text136"),
    TXT_WORLD_BOSS_CUR_DPS = TextMap.GetValue("Text137"),
    TXT_WORLD_BOSS_OPEN = TextMap.GetValue("Text138"),
    TXT_SHARE_DAXU = TextMap.GetValue("Text139"),
    Multi_honor = TextMap.GetValue("Text140"),
    quiz_point = TextMap.GetValue("Text1657"),
}

function TextMap.getText(name, params)
      -- print("name "..name )
    local obj = TableReader:TableRowByUnique("clientErrCode", "name", name)
    local des = ""
    local isFind = false
    if obj == nil then
        --         for key, value in pairs(TextMap) do
        --            if name == key then
        --                isFind = true
        --                des = value
        --            end
        --         end
        if TextMap[name] then
            isFind = true
            des = TextMap[name]
        end
    else
        des = obj.des
        isFind = true
    end
    if isFind then
        if params then
            table.foreachi(params, function(key, value)
                des = string.gsub(des, "{" .. (key - 1) .. "}", value)
            end)
        end
        return des
    else
        MessageMrg.show(TextMap.GetValue("Text141"))
        return
    end
end

function TextMap.GetValue( str )
    if str ~= nil then
        return Localization.Get(str)
    end
    return ""
end

function TextMap.GetSplitValue(str, ...)
	local lstr = nil
    if str ~= nil then
        lstr = Localization.Get(str)
    end
	local arg = { ... } 
	if #arg > 0 then 
		for k,v in ipairs({...}) do
			lstr = string.gsub(lstr, "{" .. (k-1) .. "}", v)
		end
	end 

    return lstr
end

return TextMap
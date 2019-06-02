--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/2/4
-- Time: 15:45
-- To change this template use File | Settings | File Templates.
-- 解锁配置

local unlockMap = {
    --超链接表id
    -- 精炼
    [239] = {
         icon = { "task_007" },
         guide = "jinglian",
         desc = TextMap.GetValue("Text_1_769"),
         line=1
    },

    --夺宝
    [803] = {
        icon = { "task_012" },
        guide = "duobao",
        desc = TextMap.GetValue("Text_1_770"),
        line=1
    },

    -- 神乐
    [13] = {
         icon = { "task_017" },
         guide = "shenle",
         desc = TextMap.GetValue("Text_1_771"),
         line=1
    },

    --竞技场
    [11] = {
        icon = { "task_022" },
        guide = "jjc",
        desc = TextMap.GetValue("Text1044"),
        line=1
    },

    --鬼道
    [241] = {
        icon = { "task_007" },
        guide = "guidao",
        desc = TextMap.GetValue("Text1049"),
        line=1
    },

    
    
    
    --技能
    --[[[14] = {
        icon = { "Zhujiemian_btn_yingxiong" },
        guide = "skill",
        desc = TextMap.GetValue("Text1041"),
        -- type = "skill"
    },]]

    --对决
    --[[[5] = {
        icon = { "zhujiemian_jingyingguanqia" },
        guide = "du_jie",
        desc = TextMap.GetValue("Text1042")
    },
    --日常
    [219] = {
        icon = { "Zhujiemian_btn_richang" },
        guide = "ri_chang",
        desc = TextMap.GetValue("Text1043")
    },
    --竞技场
    [11] = {
        icon = { "zhujiemian_jingjichang" },
        guide = "jjc",
        desc = TextMap.GetValue("Text1044")
    },
    --15级解锁悬赏
    [10] = {
        icon = { "zhujiemian_xuanshang" },
        guide = "xuan_shang",
        desc = TextMap.GetValue("Text1045")
    },

    --黑店
    [233] = {
        icon = { "zhujiemian_heidian" },
        guide = "hei_dian",
        desc = TextMap.GetValue("Text1046")
    },
    --灵王塔
    [226] = {
        icon = { "zhujiemian_qiancengta" },
        guide = "ling_huang_ta",
        desc = TextMap.GetValue("Text1047")
    },
    [240] = {
        icon = { "diff_select" },
        guide = "diff_section",
        desc = TextMap.GetValue("Text1048")
    },

    --鬼道
    [241] = {
        icon = { "Zhujiemian_btn_guidao" },
        guide = "guidao",
        desc = TextMap.GetValue("Text1049"),
        -- effect = true,
        -- type = "guidao"
    },
    --32级解锁灵络
    [229] = {
        icon = { "Zhujiemian_btn_yingxiong" },
        guide = "lin_luo",
        desc = TextMap.GetValue("Text1050"),
        -- type = "linluo"
    },
    --35级解锁洗练
    -- [230] = {
    --     icon = { "zhujiemian_xilian1" },
    --     guide = "xi_lian",
    --     desc = "灵器洗练,获得强力属性",
    --     -- type = "xilian"
    -- },

    [72] = {
        icon = { "Zhujiemian_btn_yingxiong" },
        guide = "blood",
        desc = TextMap.GetValue("Text1051"),
        -- type = "blood"
    },

    --变身技能
    changeSkill = {
        icon = { "btn_change" },
        guide = "change_skill",
        desc = TextMap.GetValue("Text1052")
    }]]
}

return unlockMap

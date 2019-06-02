local uMemberSelect = require("uLuaModule/modules/selectPlayer/uMemberList.lua")
local localchesEnemy = {}
local selectPanel = {}

--回调战斗函数
function localchesEnemy:fightIng(arr)
    Api:XuYeGongFight(self.currentIndex, arr, function(result)
        local fightData = {}
        fightData["battle"] = result
        UIMrg:pushObject(GameObject())
        fightData["mdouleName"] = "xuyegong"
        fightData["id"] = 4
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
    end)
end

function localchesEnemy:onFiter(char)
    if char == nil then return false end
    return char.lv >= TableReader:TableRowByID("xuYeGongArgs", "limitlv").value
end


function localchesEnemy:onClick(go, name)
    if name == "btn_challenge" then
        --localchesEnemy:fightIng(LuaMain:getTeamByIndex(4))
    elseif name == "btn_close" or name == "close" then
        UIMrg:popWindow()
    elseif name == "myteam" then
        self.fightTeamIndex = 4
        UIMrg:popWindow()
        selectPanel = uMemberSelect:showChapter(self)
    end
end

function localchesEnemy:update(tableData)
    self.currentIndex = tableData.currentIndex
    self.simpleImage:setImage(Player.XuYeGong.enemyArr[self.currentIndex].head, "headImage")
    self.txt_name.text = Player.XuYeGong.enemyArr[self.currentIndex].nickname
    self.txt_lv.text = Player.XuYeGong.enemyArr[self.currentIndex].level
    self.txt_union.text = ""
    self.myteam.gameObject:SetActive(true)
    if self.currentIndex <= Player.XuYeGong.jindu then
        self.myteam.gameObject:SetActive(false)
    end
    self.txt_ly.text = Player.XuYeGong.enemyArr[self.currentIndex].power
    self.txt_index.text = "[00ff0c]" .. self.currentIndex .. "[-]/15"
    self.progress.value = self.currentIndex / 15
    for i = 0, 5 do
        local enemychar
        if Player.XuYeGong.enemyArr[self.currentIndex].team[i].id ~= 0 then
            enemychar = Char:new(Player.XuYeGong.enemyArr[self.currentIndex].team[i].id)
            enemychar.star_level = Player.XuYeGong.enemyArr[self.currentIndex].team[i].star
            enemychar.lv = Player.XuYeGong.enemyArr[self.currentIndex].team[i].level
            enemychar.stage = Player.XuYeGong.enemyArr[self.currentIndex].team[i].stage
            enemychar.hp = Player.XuYeGong.enemyArr[self.currentIndex].team[i].hp
            enemychar.anger = Player.XuYeGong.enemyArr[self.currentIndex].team[i].anger
            enemychar.head = Player.XuYeGong.enemyArr[self.currentIndex].team[i].head
            enemychar.dead = Player.XuYeGong.enemyArr[self.currentIndex].team[i].dead
            print(enemychar.dead)
            if enemychar.dead then
                enemychar.hp = 0
            end
            if self.currentIndex <= Player.XuYeGong.jindu then
                enemychar.hp = 0
            end
            enemychar.maxhp = math.ceil(Player.XuYeGong.enemyArr[self.currentIndex].team[i].max_hp)
            enemychar.showState = true
        end
        local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/xuyegongModule/enemy", self.contentGrid.gameObject)
        infobinding:CallUpdate(enemychar)
        enemychar = nil
    end
end

function localchesEnemy:create()
    return self
end

return localchesEnemy
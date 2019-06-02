--背包类公共方法
packTool = packTool or {}

function packTool.getNumByID(types, id)
    local count = 0
    if types == "item" then
        count = Player.ItemBagIndex[id].count
    elseif types == "char" then 
      local chars = Player.Chars:getLuaTable() --获取所有英雄
        --遍历所有角色
        for k, v in pairs(chars) do
          local char = Char:new(k, v)
          if tonumber(char.dictid)==tonumber(id) then 
            count=count+1
          end 
        end
    elseif types == "pet" then 
      local chars = Player.Pets:getLuaTable() 
        for k, v in pairs(chars) do
          local char = Pet:new(k, v)
          if tonumber(char.dictid)==tonumber(id) then 
            count=count+1
          end 
        end
    elseif types == "ghost" then 
      local chars = Player.Ghost:getLuaTable() 
        for k, v in pairs(chars) do
          local char = Ghost:new(v.id, k)
          if tonumber(char.id)==tonumber(id) then 
            count=count+1
          end 
        end
    elseif types == "treasure" then 
      local chars = Player.Treasure:getLuaTable() 
        for k, v in pairs(chars) do
          local char = Treasure:new(v.id, k)
          if tonumber(char.id)==tonumber(id) then 
            count=count+1
          end 
        end
    elseif types == "charPiece" then
        count = Player.CharPieceBagIndex[id].count
    elseif types == "equipPiece" then
        count = Player.EquipmentPieceBagIndex[id].count
    elseif types == "equip" then
        count = Player.EquipmentBagIndex[id].count
    end
    if count == nil then
        count = 0
    end
    return count
end

function packTool.checkBoxOpen()
    local chapterData = TableReader:TableRowByUniqueKey("chapter", 2, "commonChapter")
    --小关宝箱
    local ta = TableReader:TableRowByUniqueKey("commonChapter", 2, 3)
    local  box = ta["box"]
    if box.Count > 0 then
        local boxState = false
        if Player.Chapter.status[ta.id] ~= nil then
            boxState = Player.Chapter.status[ta.id].bGotBox
        end
        if boxState ~= nil and boxState == true then
            print("boxState")
            return true
        end
    end
    return false
end

function packTool.checkGhostAndGhostLv()
    local charid=Player.Team[0].chars[0]
    local char =Char:new(charid)
    local ghostSlot = Player.ghostSlot
    local ghost = Player.Ghost
    local slot = ghostSlot[0]
    local postion = slot.postion
    local key = postion[0]
    if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
        local g = ghost[key].id
        if g ~= 0 then
            local gh = Ghost:new(g, key)
            local ghostLevelUpCost = TableReader:TableRowByUnique("ghostLevelUpCost", "level", gh.lv + 1)
            local ret=true 
            if ghostLevelUpCost~=nil then 
                local money = ghostLevelUpCost[gh.kind .. gh.star]
                local ret = money < Player.Resource.money
            end
            if ret == true then
                ret = gh:curMaxLv()
            end
            return ret
        end 
    end
    return true
end

function packTool.checkLv(id, ret)
    
    if Tool.getUnlockLevel(id) <= Player.Info.level then
        local unlock = unlockMap[id]
        if unlock then
            local step = unlock.guide
            if step=="guidao" then 
                if packTool.checkBoxOpen()==false then 
                    ret =false
                else 
                    if packTool.checkGhostAndGhostLv()==false then
                        ret =false
                    end
                end 
                local _id = Player.guide[step]
                print ("_id =" .. _id)
                if _id < 2 then
                    if ret then
                        Tool.checkLevelUnLock(id)
                        return true
                    end
                end
            end
        end
    end
    return false
end

function packTool.InitUnLock()
    local ret = false
    table.foreach(unlockMap, function(i, v)
        if ret ==false then 
            if v.effect == true then
                ret = packTool.checkLv(i)
            else
                ret = packTool.checkLv(i, true)
            end
        end
        if ret == true then return end
    end)
end


function packTool:showChar(list, cb)
    if #list == 0 then
        cb()
        return
    end
    local char = list[#list]
    table.remove(list)
    if char.Table.show_special==0 then 
        packTool:showChar(list, cb)
        return
    end
    local luaTable = {
        char = char,
        auto = true,
        cb = function()
            UIMrg:pop()
            packTool:showChar(list, cb)
        end
    }
    Tool.push("RewardChar", "Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
end

function packTool:showRewardBox(_list, statIndex, go, _cb)
    local Baoxiang_prefab = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/Baoxiang_prefab", go or UIMrg.top)
    Baoxiang_prefab:CallUpdate({_list = _list, statIndex = statIndex, cb = _cb})
   --  if _list == nil then return end
   --  if #_list==0 then return end 
   --  local list = {}
   --  if #_list>12*(statIndex+1) then 
   --      for i=1+(12*statIndex),12*(statIndex+1) do
   --          table.insert( list, _list[i])
   --      end
   --      cb=function ()
   --          packTool:showRewardBox(_list,statIndex+1,go, _cb)
   --      end
   --  else 
   --      for i=1+(12*statIndex),#_list do
   --          table.insert( list, _list[i])
   --      end
   --      cb=_cb
   --  end 
   --  go = go or UIMrg.top
   --  MusicManager.playByID(43)
   --  local Baoxiang_prefab = ClientTool.load("Prefabs/publicPrefabs/Baoxiang_prefab", go)
   --  --local node = Baoxiang_prefab.transform:FindChild("node").gameObject
   --  local grid = Baoxiang_prefab.transform:FindChild("Grid"):GetComponent(UIGrid)
   --  local mParent = grid.transform
   --  local next=Baoxiang_prefab.transform:FindChild("Next").gameObject
   --  next:SetActive(false)
   --  local goodsManager = Baoxiang_prefab.transform:FindChild("Sprite"):GetComponent(DestroyObject)
   --  if cb then
   --      goodsManager:setCallBack(function ()
   --          Messenger.Broadcast("RewardSucc")--新手引导的监听
   --          cb()
   --          if Player.Info.level<9 then 
   --              local _id = Player.guide["guidao"]
   --              if _id <2 then 
   --                  local ret = true
   --                  if packTool.checkBoxOpen()==false then 
   --                      ret =false
   --                  else 
   --                      if packTool.checkGhostAndGhostLv()==false then
   --                          ret =false
   --                      end
   --                  end 
   --                  if ret then
   --                      table.foreach(unlockMap, function(i, v)
   --                          if unlockMap[i].guide =="guidao" then 
   --                              Tool.checkLevelUnLock(i)
   --                          end 
   --                          end)
   --                  end     
   --              end
   --          end 
   --      end)
   --  end
   --  local gos = {}
   --  local effects = {}
   --  local items = {}
   --  local charList = {}
   --  local findIndex = 0
   --  local itemIndex = 0
   --  for i = 1, #list do
   --      local it = list[i]
   --      if it:getType() == "char" then
   --          table.insert(charList, it)
   --          if findIndex == 0 then
   --              findIndex = i
   --          end
   --      elseif itemIndex == 0 then
   --          itemIndex = i
   --      end
   --  end
   --  if findIndex == 1 and itemIndex > 1 then
   --      list[findIndex], list[itemIndex] = list[itemIndex], list[findIndex]
   --  end
   --  if #list<=6 then 
   --      grid.transform.localPosition=Vector3((6-#list)*75,-208,0)
   --  else 
   --      grid.transform.localPosition=Vector3(0,-66,0)
   --  end 
   --  LuaTimer.Add(10, function()
   --      print("10")
   --      for i = 1, #list do
   --          local temp = grid.transform:FindChild("node".. i).gameObject
   --          local mTran = temp.transform
   --          local item = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", Baoxiang_prefab)
   --          local effect = temp.transform:GetChild(0)
   --          local lab = mTran:Find("tx_name")
   --          lab.parent = item.transform
			-- --lab.fontSize = 22
   --          lab.localPosition = Vector3(0, -75, 0)
   --          --lab.localScale = Vector3(1.4, 1.4, 1.4)
   --          lab = lab:GetComponent(UILabel)
   --          lab.text = list[i]:getDisplayColorName()
   --          effect.parent = item.transform
   --          effect.localPosition = Vector3(0, 0, 0)
   --          effect.localScale = Vector3(1.4, 1.4, 1.4)
   --          table.insert(effects, effect.gameObject)
   --          item.gameObject:SetActive(false)
			
   --          item:CallUpdate({ "char", list[i], 100, 100 })
   --          item.transform.localPosition = Vector3(0, -120, -500);
   --          table.insert(gos, mTran)
   --          table.insert(items, item.gameObject)
   --      end
   --  end)
   --  LuaTimer.Add(200, function()
   --      print("200")
   --      local index = 1
   --      local function show()
   --          Baoxiang_prefab:SetActive(true)
   --          local len = #items
   --          if len < index then
   --              goodsManager.isClick = true
   --              next:SetActive(true)
   --              --LuaTimer.Add(500, function()
   --              --    GameObject.Destroy(Baoxiang_prefab.gameObject)
   --              --    end)
   --              return
   --          end
   --          local tempItem = items[index]
   --          local item = items[index]
   --          item:SetActive(true)
   --          item.transform.parent = gos[index]
   --          local ts = TweenPosition.Begin(item, 0.4, Vector3.zero)
   --          effects[index]:SetActive(true)
   --          local rot = Quaternion(0, 0, 0, -1)
   --          local r = item:AddComponent(TweenRotation)

   --          r.duration = 0.4
   --          r.to = Vector3(0, 0, 360)
   --          if list[index]:getType() == "char" and list[index].Table.show_special==1 then
   --              ts:SetOnFinished(function()
   --                  LuaTimer.Add(200, function()
   --                      print("200-2")
   --                      --packTool:showChar({ list[index] }, show)
   --                      local luaTable = {
   --                          char = list[index],
   --                          auto = true,
   --                          cb = function()
   --                              UIMrg:popWindow()
   --                              show()
   --                          end
   --                      }
   --                      print("显示第" .. index .. TextMap.GetValue("Text_1_920"))
   --                      UIMrg:pushWindow("Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
   --                      LuaTimer.Add(100, function()
   --                          print("200-3")
   --                          Baoxiang_prefab:SetActive(false)
   --                      end)
   --                      index = index + 1
   --                  end)
   --              end)
   --          else
   --              ts:SetOnFinished(function()
   --                  index = index + 1
   --                  show()
   --              end)
   --          end
   --      end

   --      if #charList > 0 then
   --          show()
   --          --LuaTimer.Add(100, function()
   --          --    eff:SetActive(false)
   --          --end)
   --      else
   --          local len = #items
   --          for i = 1, len do
   --              local item = items[i]
   --              item:SetActive(true);
   --              item.transform.parent = gos[i]
   --              local ts = TweenPosition.Begin(item, 0.4, Vector3.zero)
   --              effects[i]:SetActive(true)
   --              local rot = Quaternion(0, 0, 0, -1)
   --              local r = item:AddComponent(TweenRotation)
   --              if i == len then
   --                  ts:SetOnFinished(function()
   --                      goodsManager.isClick = true
   --                      next:SetActive(true)
   --                      --LuaTimer.Add(500, function()
   --                      --    GameObject.Destroy(Baoxiang_prefab.gameObject)
   --                       --   end )
   --                      return
   --                  end)
   --              end
   --              r.duration = 0.4
   --              r.to = Vector3(0, 0, 360)
   --          end
   --      end
   --  end)
end

function packTool:showMsg(result, go, _type, cb)
    local list = RewardMrg.getList(result)
    if #list == 0 then return end
    if table.getn(list) == 0 then return end
    local itemList ={}
    local isContainBox =false
    table.foreach(list, function(i, v)
        if v:getType() == "item" and v.Table.aotu_use == 1 then 
            isContainBox=true 
            Api:useItem("item", v.Table.id .. "", v.rwCount,function(result)
                Events.Brocast('pack_itemChange')
                local rewardlist = RewardMrg.getList(result)
                table.foreach(rewardlist, function(k, g)
                    table.insert(itemList, g)
                    end)
                packTool:showRewardMrg(go, _type, cb, itemList)
                end, v.Table.id)
        else 
            table.insert(itemList, v)
        end
        end)
    if isContainBox==false then 
        packTool:showRewardMrg(go, _type, cb, itemList)
    end 

end
function packTool:showRewardMrg(go, _type, cb, list)
    if _type == 0 or _type == nil then
        local ms = {}
        local charList = {}
        table.foreach(list, function(i, v)
            local isContain=false
            for i=1,#ms do
                if ms[i].type==v:getType() and ms[i].icon==v:getHeadSpriteName() and ms[i].goodsname==v.name and ms[i].frame==v:getFrame() then 
                   isContain=true 
                   ms[i].text = ms[i].text + v.rwCount 
                end 
            end
            if isContain==false then 
                local g = {}
                g.type = v:getType()
                g.icon = v:getHeadSpriteName()
                g.text = v.rwCount
                g.goodsname = v.name
                g.frame = v:getFrame()
                g.atlasName = packTool:getIconByName(g.icon)
                table.insert(ms, g)
                g = nil
            end 
            if v:getType() == "char" then
                table.insert(charList, v)
            end
        end)
        if #charList > 0 then
            packTool:showChar(charList, function()
                list = nil
                OperateAlert.getInstance:showGetGoods(ms, go or UIMrg.top, _type, function()
                    DialogMrg.levelUp()
                    if cb then cb() end
                end)
                ms = nil
                go = nil
            end)
            return
        end
        list = nil
        OperateAlert.getInstance:showGetGoods(ms, go or UIMrg.top, _type, function()
            DialogMrg.levelUp()
            if cb then cb() end
        end)
        ms = nil
        go = nil
    else
        packTool:showRewardBox(list,0, go, function()
            DialogMrg.levelUp()
            if cb then cb() end
        end)
    end
        
end

local dirTable = {
    ghostIcon_atlas = "ghost_icon",
    treasureIcon_atlas = "treasure_icon",
    equipIcon_atlas = "equipImage",
    headIcon_atlas = "headImage",
    ItemIcon1_atlas = "itemImage",
    ItemIcon_atlas = "itemImage",
    ghost_icon = "ghost_icon",
    equipImage = "equipImage",
    headImage = "headImage",
    itemImage = "itemImage",
    heroIcon1 = "headImage"
}

dirTable["activityModule/ItemIcon1_atlas"] = "itemImage"
dirTable["activityModule/ItemIcon2_atlas"] = "itemImage"
dirTable["activityModule/heroIcon1"] = "headImage"

--根据icon的名字拿到对应的图集
local iconAtlas
function packTool:getIconByName(iconName)
    if iconAtlas == nil then
        iconAtlas = {}
        TableReader:ForEachLuaTable("iconAtlas",
            function(index, item)
                iconAtlas[item.id] = item.atlasName
                return false
            end)
    end
    local p = "ItemIcon_atlas"
    if iconAtlas[iconName] ~= nil then
        p = iconAtlas[iconName]
    end
    p = dirTable[p] or p
    return p
end

return packTool

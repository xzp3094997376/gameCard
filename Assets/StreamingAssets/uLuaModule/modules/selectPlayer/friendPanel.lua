--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/7/6
-- Time: 16:42
-- To change this template use File | Settings | File Templates.
--

local m = {}

function m:update(lua)
    if lua == nil then return end
    self.delegate = lua.delegate
    self.powerList = {}
    self.cout = 0
    TableReader:ForEachLuaTable("buddyPower_config", function(index, item)
        self.powerList[index + 1] = item
        self.cout = self.cout + 1
        return false
    end)
    self:updateFriend()
end

--点击事件
function m:onClick(go, name)
    if name == "btn_close" then
        self.friendPanel:SetActive(false)
    elseif name =="up" then 
        self.scrollview:Scroll(-1)
    elseif name =="down" then 
        self.scrollview:Scroll(1)
    end
end

--更新小伙伴面板信息
function m:updateFriend()
    if self.delegate == nil then return end
    --更新小伙伴列表
    local infos = self.delegate:getXiaoHuoBan()
    for i = 1, 8 do
        local char = infos[i].char
        if char ~= nil then
            self["icon" .. i].gameObject:SetActive(true)
            local data = {}
            local line = TableReader:TableRowByID("avter",Tool.getDictId(char.id))
            data.name = line.name
            data.path = char:getImage()
            data.path = string.gsub(data.path, "cardImage", "smallCardImg")
            data.star = char.star
            data.power = char.power
            data.dictid=char.dictid
            data.modelid=char.modelid
            self["icon" .. i]:CallTargetFunction("updateIcon", data)
        else
            self["icon" .. i].gameObject:SetActive(false)
        end
    end
    self.grid.repositionNow = true
    self.scrollview:ResetPosition()
    --更新战力进度条
    local chars = Player.Team[12].chars
    --更新属性加成信息
    if chars~=nil and chars.Count>0 then 
        for i=1,4 do
            local text_left=""
            local text_right=""
            local id = self.powerList[1]._magic_effect[i-1].id
            local p_id=self.powerList[2]._magic_effect[i-1].id
            local txtAdd = 0
            for j=1,chars.Count do 
                local char = Player.Chars[chars[j-1]]
                if char~=nil and char.propertys[id] ~=nil then
                    txtAdd=txtAdd+math.ceil(char.propertys[id]*(1+char.propertys[p_id]/1000))
                end
            end
            local line = TableReader:TableRowByID("magics", id)
            if line ~= nil then
                text_left = string.gsub(line.format, "{0}", "+" .. txtAdd)
                text_right = string.gsub(line.format, "{0}", "+" .. math.ceil(txtAdd/5))
            end
            self["txt_right" .. i].text=text_right
            self["txt_left" .. i].text=text_left
        end
    else 
        print ("<<<<<<<<<<")
         self.friendPanel:SetActive(false)
    end
    
    --[[if power >= self.powerList[self.cout].need then --小伙伴总战力大于配表中最大总战力
    self.left_info:SetActive(true)
    self.right_info:SetActive(false)
    self.right_info.transform.localPosition = Vector3(0, -120, 0)
    self.txt_progress.text = "[00ff00]" .. power .. "[-]" .. "/" .. self.powerList[self.cout].need
    self.txt_allPower.text = TextMap.GetValue("Text1391") .. "[00ff00]" .. self.powerList[self.cout].need .. "[-]"
    self.slider.value = 1
    return
    end]]
    --战力总和小于最大值
    --self.left_info:SetActive(true)
    --self.right_info:SetActive(true)
    --self.left_info.transform.localPosition = Vector3(-143, -120, 0)
    --self.right_info.transform.localPosition = Vector3(143, -120, 0)
    --[[for i = 1, self.cout do
        if self.powerList[i] ~= nil then
            --if power < self.powerList[i].need then --大于最小值,小于最大值
            -- print("i==================="..i)
            if self.powerList[i - 1] ~= nil then
                --设置当前战力加成信息
                if self.powerList[i - 1].magic ~= nil then
                    for j = 0, 4 do
                        local text = ""
                        local id = self.powerList[i - 1].magic[j].magic_effect
                        local txtAdd = "+" .. self.powerList[i - 1].magic[j].magic_arg1
                        local line = TableReader:TableRowByID("magics", id)
                        if line ~= nil then
                            text = text .. string.gsub(line.format, "{0}", txtAdd)
                        end
                        if j ~= 4 then
                            text = text .. "\n"
                        end
                        self["txt_right" .. (i+1)].text=text
                    end
                    --self.txt_left.text = text
                end
                --设置下一级战力加成信息
                if self.powerList[i].magic ~= nil then
                    local text = ""
                    for j = 0, 4 do
                        local id = self.powerList[i].magic[j].magic_effect
                        local txtAdd = "+" .. self.powerList[i].magic[j].magic_arg1
                        local line = TableReader:TableRowByID("magics", id)
                        if line ~= nil then
                            text = text .. string.gsub(line.format, "{0}", txtAdd)
                        end
                        if j ~= 4 then
                            text = text .. "\n"
                        end
                    end
                    self.txt_right.text = text
                end
                -- self.slider.value = math.floor(power/self.powerList[i].need)
            else --当前战力小于配表最小值
            if self.powerList[i].magic ~= nil then
                local text1 = TextMap.GetValue("Text1392")
                self.txt_left.text = text1
                local text = ""
                for j = 0, 4 do
                    local id = self.powerList[i].magic[j].magic_effect
                    local txtAdd = "+" .. self.powerList[i].magic[j].magic_arg1
                    local line = TableReader:TableRowByID("magics", id)
                    if line ~= nil then
                        text = text .. string.gsub(line.format, "{0}", txtAdd)
                    end
                    if j ~= 4 then
                        text = text .. "\n"
                    end
                end
                self.txt_right.text = text
            end
            end
            if power <= self.powerList[i].need then
                self.slider.value = power / self.powerList[i].need
            else
                self.slider.value = 1
            end
            -- print("power==========="..power.."======need=========="..self.powerList[i].need)
            self.txt_progress.text = "[00ff00]" .. power .. "[-]" .. "/" .. self.powerList[i].need
            self.txt_allPower.text = TextMap.GetValue("Text1391") .. "[00ff00]" .. self.powerList[i].need .. "[-]"
            return
            end
        end
    end]]
end

function m:getOneMagicNum(id)
    local num = 0
    for i=1,self.cout do 
        if self.powerList[i]~= nil then
            for j = 0, 4 do
                local _id = self.powerList[i]._magic_effect[j].id
                if _id== id then 
                    print (self.powerList[i])
                    num =num +self.powerList[i - 1]._magic_effect[j]
                end
            end
        end
    end
    return num
end

return m
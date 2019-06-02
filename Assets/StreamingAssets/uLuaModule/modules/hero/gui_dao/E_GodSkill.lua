local m = {} 

function m:update(data)
	self.ScrollView.gameObject:SetActive(false)
	self.Label_cur2.gameObject:SetActive(false)
	local godskillList = {}
    local godSkillMenu = Tool:getGodSkillListInfo()
    if godSkillMenu ~= nil then
        for i = 1, #godSkillMenu do
            local name = ""
            local desc = ""
            local item = godSkillMenu[i]
            if item ~= nil and item.name == data.data.name then
                for j = 0, item._skillid.Count do
                    if item._skillid[j] ~= nil then
                        local skillId = item._skillid[j].id
                         local name = "[9a4c1e]【"..item._skillid[j].name.."】"
                         local desc = "[9a4c1e]"..item._skillid[j].desc.."（"..string.gsub(TextMap.GetValue("Text1812"), "{0}", item.unlock[j]).."）[-]"
                        if data.data.info.skill ~= nil then
                            for i = 0, data.data.info.skill.Count - 1 do
                                if data.data.info.skill[i] == skillId then
                                   name = string.gsub(name,"9a4c1e","FF0000")
                                   desc = string.gsub(desc,"9a4c1e","FF0000")
                                   break
                                end
                            end                        
                        end
                        table.insert(godskillList, {skillId = skillId, name = name, desc = desc}) 
                    end
                end
            end
        end
    end
    if #godskillList > 0 then
		self.Label_cur2.gameObject:SetActive(true)
    	self.Label_cur2.text =string.gsub(TextMap.GetValue("LocalKey_841"),"{0}", data.power)
		self.ScrollView.gameObject:SetActive(true)
    	self.Grid:refresh(Item, godskillList)
    end
end


function m:onClick(go, name)
	if name == "Close" then
		UIMrg:popWindow()
	end
end
return m
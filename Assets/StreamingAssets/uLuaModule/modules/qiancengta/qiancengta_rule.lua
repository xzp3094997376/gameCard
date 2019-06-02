local qctDes = {}


function qctDes:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

function qctDes:update(id)
    local obj = nil
    if id[1]~=nil then 
        obj=TableReader:TableRowByID("moduleExplain", id[1])
    end
    if obj ~= nil then
        self.txt_rule.text = string.gsub(obj.desc, '\\n', '\n')
        self.title.text = obj.type
    end
    --大转盘规则说明
    -- if id[1] == nil then
    	if id.title ~= nil then
 		self.title.text = id["title"]
    	end
    	if id.rule ~= nil then
    		self.txt_rule.text = id.rule
    	end
    -- end
end


--function qctDes:Start()
--
--end

return qctDes
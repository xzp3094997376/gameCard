local item = {}

--为了评审
function item:updateForUc(data, index, delegate)
    self.delegate = data.delegate
    self.data = data
    
    self.txt_number.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",self.data.number)
    self.txt_name.text = self.data.name
    self.txt_player.text = (self.data.pid or "") .. "(" .. self.data.lv .. ")"
  
end

function item:update(data)
    if SERVER_LIST_FOR_UC then
        --为了评审。。暂时屏蔽
        item:updateForUc(data)
        return
    end
end

function item:onClick(go, name)
    if self.oneLine == false then
        --有多线的情况下弹出选线
        UIMrg:pushWindow("Prefabs/moduleFabs/loginModule/ChannelServer", self.server)
        return
    end
    -- UIMrg:popWindow()
    Events.Brocast('select_server', self.data)
end

return item
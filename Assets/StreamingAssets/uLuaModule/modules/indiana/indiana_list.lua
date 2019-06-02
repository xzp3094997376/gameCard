--宝物掠夺列表界面
local m = {}

function m:Start(...)
    self.topMenu = LuaMain:ShowTopMenu()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_922"))
    local cd_time = TableReader:TableRowByID("trsRobConfig", "refresh_list_cdtime").value 
    self.max_vp = TableReader:TableRowByID("trsRobConfig", "max_vp").value 
    self.cd_time = string.gsub(cd_time, "s", "")
    self.cd_time = tonumber(self.cd_time)
    self:refreshVp()
end

function m:refreshVp()
    self.txt_cost.text = TableReader:TableRowByID("trsRobConfig", "rob_vp").value
    self.cur_jingli.text = Player.Resource.vp
    if self.topMenu~=nil then 
        self.topMenu.gameObject:SetActive(true)
        self.topMenu:CallTargetFunction("onUpdate",true)
    end 
end

function m:update(lua)
    --刷新对手列表
    self.treasure_id = lua.treasure_id
    self:refreshList()
end

--刷新宝物碎片列表
function m:refreshList()
    if self.treasure_id ~= nil then
        local that = self
        Api:getRobList(self.treasure_id,function (result)
                local data = json.decode(result:toString())
                that.showList = data.showRet
                that.scrollview:refresh(that.showList, that,false,0)
                if GuideMrg:isPlaying() then 
                    Messenger.Broadcast('IndianaDrag')--新手引导的监听
                end
        end)
    end
    self:refreshVP()
end

function m:refreshVP()
  --  local vp = Player.Resource.vp
 --   self.txt_now.text = "[00ff00]"..vp.."[-]/"..self.max_vp
end

function m:onCD(time)
    if self.cd_time == nil then return end
    self.binding:CallAfterTime(1,function ()
        time =time -1
        if time~=0 then 
            self.timeLabel.text=Tool.FormatTime(time)
            m:onCD(time)
        else 
            self.timeLabel.text =TextMap.GetValue("Text_1_923")
            self.btn_next.isEnabled = true
        end
    end)
end


function m:onClick(go, name)
    if name == "btn_next" then --换一批
        self:refreshList()
        self.btn_next.isEnabled = false
        self:onCD(self.cd_time)
    elseif name == "btn_close" then
        UIMrg:pop()
    end
end

return m
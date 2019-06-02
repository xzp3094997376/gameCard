local checkin = {}
local monthData = {}
local totleIndex = 0
local currentIndex = 0

function checkin:destory()
    UIMrg:popWindow()
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("setCheckinData")
end

function checkin:setCheckinData()
    if currentIndex == totleIndex then
        return
    end
    local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/signModule/reward", self.grid.gameObject)
    binding:CallUpdate(monthData[currentIndex])
    binding.gameObject.name = "reward" .. currentIndex
    binding = nil
    currentIndex = currentIndex + 1
    self.grid.repositionNow = true
end

--签到主界面
function checkin:setData()
    TableReader:ForEachLuaTable("checkinReward",
        function(index, item)
            if item.month == Player.Checkin.month then
                local datas = {}
                datas.obj = item
                datas.label = self.txt_times
                monthData[totleIndex] = datas
                datas = nil
                totleIndex = totleIndex + 1
            end
            return false
        end)
    self.txt_times.text =string.gsub(TextMap.GetValue("LocalKey_690"),"{0}",Player.Checkin.times)
    self.txt_title.text = Player.Checkin.month .. TextMap.GetValue("Text575")
    UluaModuleFuncs.Instance.uTimer:frameTime("setCheckinData", 1, 31, self.setCheckinData, self)
end

function checkin:onClick(go, name)
    if name == "closeBtn" then
        checkin:destory()
    else
        local temp = {}
        temp.type = "checkdesc"
        UIMrg:pushWindow("Prefabs/moduleFabs/signModule/sign_des", temp)
    end
end

--初始化界面
function checkin:Start()
    Api:checkRefresh(function(result)
        checkin:setData()
    end)
end

--初始化
function checkin:create(binding)
    self.binding = binding
    return self
end

return checkin
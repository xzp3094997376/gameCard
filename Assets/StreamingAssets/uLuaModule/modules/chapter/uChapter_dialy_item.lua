--章节cell
local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
local m = {}
local islock = false
local islockTip = ""

local objs = nil
local totaltimes = -1 --可挑战的次数-1
--关闭界面
function m:destory()
    SendBatching.DestroyGameOject(self.binding.gameObject)
    Events.RemoveListener('select_nandu')
end

local tipsShowStr = ""

function m:onClick(go, name)
    if m:isLock(self.data.id) == false then
        local arg = self.data.unlock[0].unlock_arg
        tipsShowStr = string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",arg)
        MessageMrg.show(tipsShowStr)
        return 
    end
    Events.Brocast('select_nandu')
    m:isSelect(true)
    self.delegate:updateSection(self.data.id, self.index, self)
end

function m:isSelect(ret)
    self.binding:CallManyFrame(function()
        self.select:SetActive(ret)
    end
    )
    if ret == true then
        self.delegate.sectionIndex = self.index
    end
end

--false 未解锁  true 已解锁
function m:isLock(id)
    local arg = self.data.unlock[0].unlock_arg
    if arg > Player.Info.level then
        self.islock = false
    else
        self.islock = true
    end
	return self.islock
end

--打开界面，设置值
function m:setData()
    objs = self.data

    m:isSelect(self.delegate.sectionIndex == self.index)

    --local totelTimes = Player.NBChapter.status[capterEasyID].fight + Player.NBChapter.status[capterNorID].fight + Player.NBChapter.status[capterDiffID].fight
    --local totelTimes = m:getTotaltimes()
    self.imgIcon.spriteName = "icon_nandu_" .. self.index
    --if totelTimes > 0 then
        --self.times.text = "可免费挑战"
    --end
    if m:isLock(self.data.id) == false then
		local arg = self.data.unlock[0].unlock_arg
		self.txtHint.text = string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",arg)
        self.txtHint.gameObject:SetActive(true)
		self.imgIcon.color = Color(0.5, 0.5, 0.5)
    else
	    self.txtHint.gameObject:SetActive(false)
		self.imgIcon.color = Color(255, 255, 255)
	end
end

function m:update(lua)
	self.data = lua.data
	self.index = lua.index
    self.delegate = lua.delegate
    m:setData()
end

function m:Start()
    Events.AddListener("select_nandu", function()
        m:isSelect(false)
    end)
end
--初始化
function m:create(binding)
    self.binding = binding
    return self
end

-- lzh 2015.05.07
-- 获取可挑战的次数
function m:getTotaltimes()
    if totaltimes == -1 then
        local row = TableReader:TableRowByID("heroChapter_config", "max_time")
        if row.args1 ~= nil and tonumber(row.args1) ~= nil then
            totaltimes = row.args1
        else
            totaltimes = 0
        end
    end
    local lefttimes = totaltimes + Player.NBChapter.resettimes - Player.NBChapter.totaltimes
    return lefttimes;
end


return m
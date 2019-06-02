local m = {}
local currentChapter = 1 --当前关卡
local totelChapter = 3 --总的关卡
local bindingArr = {}
local bindingArrLength = 0
local currentSection = 0
local totaltimes = -1 --总的可挑战的次数-1
local isInit = false
function m:sortAnalogData()
    if peopleDatas ~= nil then
        table.sort(peopleDatas, function(a, b)
            return a.char_num < b.char_num
        end)
    end
end

local selectHero
function m:selectCallBack(bind)
    if selectHero ~= nil then
        selectHero.open:SetActive(false)
        selectHero.normal.transform.rotation = Quaternion.identity
        selectHero.normal:SetActive(true)
    end
    selectHero = bind
end

--之所以这个方法里面这么多注释，这么乱，是因为策划需求改变，请勿删除注释代码
local peopleDatas = {}
local peopleCounts = 0
local currentHero = nil 

function m:setData()
    self.txt_count.text = m:getTotaltimes()

    TableReader:ForEachLuaTable("heroChapterIndex",
        function(index, item)
            peopleDatas[index] = item
            peopleCounts = peopleCounts + 1
            return false
        end)
    m:sortAnalogData()
	local list = m:getData(peopleDatas)
	self.hero_list:refresh(list, self, false, 0)
	currentHero = peopleDatas[self.sIndex - 1]
	local diffList = self:getAllDiffChapter(currentHero)
	
	local col = math.floor((#diffList + 2) / 3)

	self.itemContent:Reset(col, 3, #diffList)
	for i = 1, #diffList do
		self.itemContent.items[i - 1]:GetComponent(UluaBinding):CallUpdate({index = i, data = diffList[i]})
	end
	local data = TableReader:TableRowByID("avter", currentHero.chars[0]._easy.model)
	local imageUrl = UrlManager.GetImagesPath("cardImage/" .. data.full_img_d .. ".png")
    self.img_hero.Url = imageUrl
end

function m:getAllDiffChapter(peopleItem)
	local list = {}
	list[1] = peopleItem.chars[0]._easy
	list[2] = peopleItem.chars[0]._normal	
	list[3] = peopleItem.chars[0]._diffcult	
	return list
end

function m:Start()
	self.sIndex = 1
    m:setData()
end

function m:getData(data)
    local list = {}
    for i = 1, table.getn(data), 1 do
        local d = data[i - 1]
        d.realIndex = i
		d.delegate = self
		table.insert(list, d)
    end

    return list
end

function m:onEnter()
    peopleDatas = {}
    peopleCounts = 0
    --m:setData()
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

function m:onClick(go, name)
    if name == "btn_add" then
        DialogMrg:BuyBpAOrSoul("djq", "", toolFun.handler(self, self.updateForBuyBpAOrSoul),
            toolFun.handler(self, self.BuyBpAOrSoul_Change))
    end
end

function m:BuyBpAOrSoul_Change()
    self:updateForBuyBpAOrSoul()
end

function m:updateForBuyBpAOrSoul()
    self.txt_count.text = m:getTotaltimes()
end

return m
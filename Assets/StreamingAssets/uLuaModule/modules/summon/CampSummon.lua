local CampSummon = {} 
local radius = 550
local itemPreSize = 1
local objList={}
local rot_x =0
local timeid = 0
--初始化
function CampSummon:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end
function CampSummon:update(lua)
	self.data=lua
	local itemCount=#self.data
    local angle = 360/itemCount
    local _angle =angle/ 180* math.pi
    rot_x = -self.gameObject.transform.localEulerAngles.x
    objList={}
	self.itemPre.transform.localPosition =Vector3(radius * math.sin(0), radius * math.cos(0), 0);
    self.itemPre.transform.localScale = Vector3.one * itemPreSize;
    self.itemPre.transform.localEulerAngles =Vector3(rot_x, 0, 0);
    self.itemPre.name = "obj0"
    local uluabinding1=self.itemPre:GetComponent(UluaBinding)
    uluabinding1:CallUpdate({data=self.data[1]})
    for i = 1,itemCount-1 do
        local obj= ClientTool.AddChild(self.itemPre,self.gameObject)
        local pos_cur = Vector3(radius * math.sin(i*_angle), radius * math.cos(i * _angle), 0)
        obj.transform.localPosition = pos_cur
        obj.transform.localScale = Vector3.one * itemPreSize
        obj.transform.localEulerAngles =Vector3(rot_x, 0, 0)
        obj.name = "obj" .. i
        local uluabinding=obj :GetComponent(UluaBinding)
        uluabinding:CallUpdate({data=self.data[i+1]})
        objList[i+1]=obj
        if i==1 or i==itemCount-1 then 
        	obj:SetActive(false)
        end 
    end
    objList[1]=self.itemPre
    self.angle=angle
    self.itemCount=itemCount
    self.itemPre:SetActive(false)
end
local clickNum=0
function CampSummon:RotateEulerAngles(lua)
	if self.ain==nil then return end 
	self.ain.enabled=true
	self.ain:ResetToBeginning()
 	if lua.angle<=self.angle then 
 		self.ain.from=Vector3(-rot_x,0,-lua.angle*clickNum)
 		self.ain.to=Vector3(-rot_x,0,-lua.angle*(clickNum+1))
 		self.ain.duration=lua.time
 		self.binding:CallAfterTime(lua.time, function()
 			clickNum=clickNum+1
 			clickNum=clickNum%self.itemCount
 			self:updateItemPos(clickNum)
 		end)
 	else 
 		local totalNum = math.floor(lua.angle/self.angle)
 		clickNum=0
 		self.ain.from=Vector3(-rot_x,0,-lua.angle*clickNum)
 		self.ain.to=Vector3(-rot_x,0,-lua.angle*(clickNum+1))
 		self.ain.duration=lua.time
 		LuaTimer.Delete(timeid)
 		local onetime =math.floor(lua.time*1000/totalNum)
    	timeid = LuaTimer.Add(0,onetime, function(id)
    		clickNum=clickNum+1
    		self:updateItemPos(clickNum)
    		end)
 		self.binding:CallAfterTime(lua.time, function()
            self:updateItemPos(0)
 			LuaTimer.Delete(timeid)
 			end)
 	end 
 end 

 function CampSummon:OnDestroy()
    LuaTimer.Delete(timeid)
end

 function CampSummon:updateItemPos(clickNum)
	local pos1 = 1
 	local pos2 = 1
 	local pos3 = 1
 	if clickNum==0 then
 		pos1=#self.data
 		pos2=1
 		pos3=2
 	elseif clickNum==1 then 
 		pos1=#self.data-clickNum
 		pos2=#self.data
 		pos3=1
 	else 
 		pos1=#self.data-clickNum
 		pos2=#self.data-clickNum+1
 		pos3=#self.data-clickNum+2
 	end
 	for k, v in pairs(objList) do
 		if k==pos1 or k==pos2 or k==pos3 then
 			v:SetActive(false)
            v:GetComponent(UluaBinding):CallTargetFunction("ResetAni")
 		else 
 			v:SetActive(true)
            v:GetComponent(UluaBinding):CallTargetFunction("ResetAni")
 		end 
 	end 
end

 function CampSummon:playEffect()
 	for k, v in pairs(objList) do
 		v:GetComponent(UluaBinding):CallTargetFunction("playEffect")
 	end 
 end


return CampSummon
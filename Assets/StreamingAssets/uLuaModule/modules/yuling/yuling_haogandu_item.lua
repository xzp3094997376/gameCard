local m = {}

function m:update(data)
    ClientTool.UpdateGrid("",self.Grid,data[1])
    if #data[1]>4 then 
    	local num = math.ceil(#data[1]/4)-1
    	self.bg.height=250+190*num
    end 
end

return m
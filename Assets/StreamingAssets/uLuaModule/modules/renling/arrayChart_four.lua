local m = {} 

function m:update(item)
	self.item=item[1]
	local cur_star=0--当前升星数
	local magicList = {}
	local maxStar = TableReader:TableRowByID("renling_config",6).value2
	for i=1,tonumber(maxStar)-1 do
		local magic = {}
		magic.star=i
		magic._magic={}
		magic.cur_star=0
		if Player.renling[self.item.group]~=nil and Player.renling[self.item.group][self.item.id]~=nil and Player.renling[self.item.group][self.item.id].level~=nil then 
			magic.cur_star=tonumber(Player.renling[self.item.group][self.item.id].level)-1
		end 
		for j=0,self.item.magic.Count-1 do
			local row = self.item.magic[j]
			if row~=nil then 
				local tb =split(row._magic_effect.format, "{0}")
				local denominator=row._magic_effect.denominator or 1
				tb[2]=tb[2] or ""
				local des = ""
				des="[ffff96]" .. tb[1] .. "[-][ffffff]" .. (row.magic_arg1+row.magic_arg2*i)/denominator .. tb[2] .. "[-]"
				table.insert(magic._magic,des)
			end 
		end
		table.insert(magicList,magic)
	end
	ClientTool.UpdateGrid("", self.Content, magicList)
end 

function m:onClick(go, name)
	if name == "btnClose" or name == "closeBtn" or name == "btn_quxiao" then
		UIMrg:popWindow()
	elseif name == "active_btn" then
		UIMrg:popWindow()     
	end 
end 

return m
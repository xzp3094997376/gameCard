
local m = {}

-- 星星的spriteName
-- hero_null_star
-- hero_star
-- 参数 isShow 
function m:update(data)
	if data.isShow then 
		self.star.spriteName = "xingxing_1"
	else
		self.star.spriteName = "xingxing_2"
	end
end

------------------------------------------------------------------------------------------------------------------------

----------------------------------------------- 创建----------------------------------------------------------------------
function m:create(binding)
    self.binding = binding
    return self
end

-----------------------------------------------------------------------------------------------------------------------
return m

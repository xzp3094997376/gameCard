-- 登录后重新配置
local m = m or {}
m.enable = false

function m:reConfig()
	if not m.enable then return end 
	LuaGlobal.isGuide = true
	MyDebug.isDebug = true
end
m:reConfig()

return m
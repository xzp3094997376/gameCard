module("SettingConfig", package.seeall)
LuaGlobal = require("uLuaModule/config/config_global")
	
function parse(config)
    if config == nil then return end
    GlobalVar.isLJSDK = config.isLJSDK
    MyDebug.isDebug = config.isDebug
    GlobalVar.sdkPlatform = config.sdkPlatform
    GlobalVar.language = config.language
    GlobalVar.isPush = config.isPush
    GlobalVar.dataEyeChannelID = config.dataEyeChannelID	
    GlobalVar.subChannelID = config.subChannelID
    GlobalVar.gameName = config.gameName or nil
    GlobalVar.iosLoginUrl = config.IOS_loginURL or nil
    GlobalVar.dataEyeAppID = config.dataEyeAppID --add by lihui 17-2-24
    GlobalVar.isNeedUpdate = config.update or false
    GlobalVar.isChgeAcc = false --这里设置是否开启切换账号功能
	LuaGlobal.isGuide = config.isGuide
	GlobalVar.iosVerfy = config.iosVerfy or false
    print("serali 888888888888 GlobalVar.iosVerfy:"..tostring(GlobalVar.iosVerfy))
    GlobalVar.isChannel = config.isChannel or false
    GlobalVar.channelName = config.channelName or "ccydmx_test123"
    if ClientTool.Platform == "pc" then
        __Network.SERVER_IP = config.localIP
        __Network.SERVER_PORT = config.localPort
    else
        __Network.SERVER_IP = config.platformIP
        __Network.SERVER_PORT = config.platformPort
    end
end

function getLastVersion(config)
    local groupVersions = config.groupVersions or {}
    local version = nil
    table.foreach(groupVersions, function(i, v)
        local num = tonumber(v)
        if version and num > version then
            version = num
        elseif version == nil then
            version = num
        end
    end)
    return version
end

function isGuideOpen() 
	--return false
    --if ClientTool.Platform == "pc" then
    --    return PlayerPrefs.GetInt("IsOpenGuide", 0) == 1 ----保留这一行，其他行添加注释，手机上就没新手指引
    --end
	return LuaGlobal.isGuide
end

function getVersion()
    -- local fileUtils = FileUtils.getInstance()
    -- local path = fileUtils:getFullPath("project.manifest")
    -- local str = fileUtils:getString(path)
    local str = getFileContext("project.manifest")
    if str ~= "" then
        local config = json.decode(str)
        if config == nil then return
        error(TextMap.GetValue("Text1489"))
        end
        local v = getLastVersion(config)
        if v ~= nil then
            GlobalVar.mainVersion = tostring(v) or "0"
            return GlobalVar.mainVersion
        else
            GlobalVar.mainVersion = tostring(config.version) or "0"
            return GlobalVar.mainVersion
        end
    else
        print("找不到配置文件project.manifest")
    end
    return 0
end

function getFileContext(fileName)
    local fileUtils = FileUtils.getInstance()
    local path = fileUtils:getFullPath(fileName)
    local str = fileUtils:getString(path)
    return str
end

function getDataEyeChannel()
    local str = getFileContext("setting.json")
    if str ~= "" then
        local config = json.decode(str)
        return config["dataEyeChannelID"]
    end
    return 0
end

function getSubChannel()
    local str = getFileContext("setting.json")
    if str ~= "" then
        local config = json.decode(str)
        return config["subChannelID"]
    end
    return 0
end

function getIOSLoginURL()
    local str = getFileContext("setting.json")
    if str ~= "" then
        local config = json.decode(str)
        return config["IOS_loginURL"]
    end
    return 0
end

function getIOSVerfy()
	local str = getFileContext("setting.json")
	if str ~= "" then
		local config = json.decode(str)
		return config["iosVerfy"]
	end
	return false
end

function getShareSDKConfig(channelName,gameName)
    local str = getFileContext("shareSDKConfig.json")
    if str ~="" then
        local config = json.decode(str)
        return config[gameName][channelName]
    end
    return 0
end

function Init()
    local fileUtils = FileUtils.getInstance()
    local path = fileUtils:getFullPath("setting.json")
    local str = fileUtils:getString(path)
    if str ~= "" then
        local config = json.decode(str)
        parse(config)
    else
        print("找不到配置文件setting.json")
    end
end
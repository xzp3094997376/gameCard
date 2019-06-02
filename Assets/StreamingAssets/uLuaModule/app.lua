App = {}

function App.loadScript()
    require "uLuaModule/autoLoad"
    require "uLuaModule/tool/class"
    require "uLuaModule/tool/function"
    require "uLuaModule/GameManager"
    GameManager.OnInitOK()
    App.InitNetwrok()
end

--初始化网络
function App.InitNetwrok()
    Network.onCallbackForDataEye = function(api, jo)
        Messenger.BroadcastObject(api, api)
        api = string.gsub(api, "%.", "_")
        if Player.Info.level == 0 then return end
        DataEye:res(api, jo)
    end
    Network.onNetworkSlow = {
        "+=", function()
            ApiLoading:show(15, nil)
        end
    }
    Network.onNetworkFast = {
        "+=", function()
            ApiLoading:hide()
        end
    }

    Network.onNetworkError = {
        "+=", function(nRet, oRet, ignore)
            ApiLoading:hide()
            GameManager.ShowErrorCode(nRet, oRet)
        end
    }

    Network.onNetworkReconnet = {
        "+=", function()
            ApiLoading:hide()
            GameManager.HideDialog()
        end
    }
end

function App.Start()
    Localization.loadFunction = function(path)
        local p = FileUtils.getInstance():getFullPath("lan/Localization.csv")
		if p == "" then 
			p = FileUtils.getInstance():getFullPath("Localization.csv")
		end
		print("path = " .. p)
        return FileUtils.getInstance():getBytes(p)
    end
 --    if GlobalVar.language==nil then 
 --        GlobalVar.language="CN"
 --    end 
	-- Localization.language = GlobalVar.language
    Localization.language = "CN"
    TextMap = require("uLuaModule/TextMap")
    
    
    reload_files "uLuaModule/versionUpdate/updateAssets"
    reload_files "uLuaModule/versionUpdate/updateLogic"
    reload_files "uLuaModule/versionUpdate/setting"
    reload_files("uLuaModule/uLuaFramework/logic/json")
    reload_files("uLuaModule/dialog/DialogMrg")

    cjson = json
end

CHANNEL_ID = ""
versionNumber = 150000
DataEyeChannelID = ""


function App.StartDataEye()
    DataEyeTool.APP_ID = GlobalVar.dataEyeAppID
    CHANNEL_ID = GlobalVar.sdkPlatform
    DataEyeTool.CHANNEL_ID = GlobalVar.dataEyeChannelID
    DataEyeChannelID = GlobalVar.dataEyeChannelID
    local num = tonumber(GlobalVar.mainVersion)
    versionNumber = num - num % 1000
    print(versionNumber)
    DataEyeTool.OnStart()
end
local function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end
function decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end
function App.log()
    if ClientTool.Platform == "pc" then 
        return
    end
    local pf = GlobalVar.sdkPlatform
    if pf == "android" then 
        pf = GlobalVar.dataEyeChannelID
    end
    local network = "none"
    local _state = Application.internetReachability
    if _state == 2 then 
        network = "wifi"
    elseif _state == 1 then
        network = "other"
    end
    local map = {
        deviceModel or "" ,--型号
        Screen.currentResolution.width .."x"..Screen.currentResolution.height,
        SystemInfo.operatingSystem,
        deviceUniqueIdentifier or "", --设备号
        network,
        GlobalVar.dataEyeChannelID,
        -- GlobalVar.dataEyeAppID
    }


    local url = 'http://182.254.132.91/admin/log/collect.do?data='
    local gameId = "1"
    if "EA7D0701220EF0E4ACA26BC41B7C2AF9" ~= GlobalVar.dataEyeAppID then 
    	gameId = "3"
    end
    table.insert(map,1,{"1002","1","0",gameId})
    local str = json.encode(map)
    str = encodeURI(str)
    url = url..str
    local c=coroutine.create(function()
        local www = WWW(url)
        Yield(www)
        --if Slua.IsNull(www.error) then 
            -- local data = json.decode(www.text)
            -- print(www.text)
            -- NGUIDebug.Log(www.text)
        --else
            --NGUIDebug.Log(www.error)
        --end
    end)
    coroutine.resume(c)
end

function App.Run()
    updateLogic.update()
    App.log()
end



--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/12
-- Time: 13:43
-- To change this template use File | Settings | File Templates.
-- 登陆
mysdk = require("uLuaModule/SdkLua/MySdk")
require("uLuaModule/dialog/MessageMrg")
local m = {}
local mIsHaveClick = false
local tryTime = 0

function m:onLogin(go)
	print("点击了onLogin")
    tryTime = 0
    if isSdk ~= 1 then
        self.uid = self.input_user.value

        if self.uid == "" then MessageMrg.show("帐号不能为空啊~亲") return end
    end
    local that = self
    Network:initAuthServerWithLua(function()
        -- if that.uid == "sdk" then isSdk  = 1 end
		print("initAuthServerWithLua——————————————————————————")
        m:onSdkLogin(that.uid)
    end)
end

function m:loginSuccess(uid, token, channelCode, subchannelid,channeluid, platform, username, customparams, productcode,and_uuid, ios_uuid,idfv)
    local that = self
    require "uLuaModule/autoLoad_login"
    Api:checkLogin(uid, token, channelCode, subchannelid, channeluid, platform, username, customparams, productcode,and_uuid,ios_uuid, idfv, GlobalVar.dataEyeAppID,
        function(res1)
            self._res1 = res1
            self._uid = uid
            self.channelCode = channelCode
            local skey = res1["skey"]
			if GlobalVar.sdkPlatform == "san" then
				mysdk:getDataExtend(tostring(res1["channeluid"]))
			end
			
            --PlayerPrefs.SetString("uid", uid)
            PlayerPrefs.SetString("skey", skey)
            --edit by ben
            if GlobalVar.isLJSDK and ClientTool.Platform == "ios" and GlobalVar.isChgeAcc then
                local isHasAc = false
                local num = 0
                local curName = PlayerPrefs.GetString("uid")
                for i = 1, 10 do
                    local str = PlayerPrefs.GetString("uid"..i)
                    if string.len(str) <= 0 then
                        num = i
                    end
                    if str == curName then
                        isHasAc = true
                        break
                    end
                end
                if isHasAc == false then
                    PlayerPrefs.SetString("uid"..num, curName)
                    PlayerPrefs.SetString("uid"..num.."weuid", uid)
                    PlayerPrefs.SetString("uid"..num.."token", token)
                end
            else
                PlayerPrefs.SetString("uid", uid)
            end
            --
            DataEye.login(uid)
            UmengAnalytics.Event("login_1", "Login")
            UmengAnalytics.Event("login_4", "Login didn't uninstall")
            if res1:ContainsKey("notice") and res1["notice"] ~= nil and res1["notice"] ~= "" then
                local argObj = {}
                toolFun = require("uLuaModule/someFuncs")
                argObj.fun = toolFun.handler(that, that.callBack)
                argObj.msg = res1["notice"]
                if self.notice == nil then 
					self.notice = UIMrg:pushWindow("Prefabs/moduleFabs/noticeModule/xiTongGongGao", argObj) --打开通知界面
				else 
					self.notice:CallUpdate(argObj)
				end
				argObj = nil
            else
                m:callBack()
            end
        end,
        function(result)
            mIsHaveClick = false --登陆失败，可以再次点击
            --  self.button.gameObject:SetActive(true)
            return false
        end)
end

function m:callBack()
    -- local select_server = Tool.replace("SelectServer", "Prefabs/moduleFabs/loginModule/startgame")
    if self.select_server == nil then
        UIMrg:popWindow()
        self.select_server = UIMrg:pushWindow("Prefabs/moduleFabs/loginModule/startgame")
    end

    self.select_server:CallUpdateWithArgs(self._uid, self._res1["skey"], self._res1["server_list"]:toString(), self._res1["lastServer"], self._res1,self.channelCode)
    self._res1 = nil
end


function m:onSdkLogin(tuid)
    if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
        local that = self
        print("enter mysdk")
        if tryTime > 5 then
            DialogMrg.ShowDialog(TextMap.GetValue("Text1315"), function(...)
            end)
            return
        end
        mysdk:login(function(uid, token, channelCode, subchannelid,channeluid, username, customparams, productcode,and_uuid,ios_uuid, idfv)
            Debug.Log(uid)
            Debug.Log(token)
            Debug.Log(channelCode)
            Debug.Log(channeluid)
            Debug.Log(username)
            Debug.Log(customparams)
            Debug.Log(productcode)
            --  ljsdk:init()
            if (uid == nil) then
                uid = "0"
            end
            if (token == nil) then
                token = "0"
            end
            if (channelCode == nil) then
                channelCode = "0"
            end
            if (username == nil) then
                username = "0"
            end
            if (customparams == nil) then
                customparams = "0"
            end
            if (productcode == nil) then
                productcode = "0"
            end
			if subchannelid == nil then
				subchannelid = "0"
			end
			if ClientTool.Platform == "ios" then
				and_uuid = ""
				if ios_uuid == nil or ios_uuid == "" then
					ios_uuid = deviceUniqueIdentifier or "0"
				end
				if idfv == nil or idfv == "" then
					idfv = mysdk:getDeviceIDFV() or "0"
				end
				
			elseif ClientTool.Platform == "android" then
				if and_uuid == nil or and_uuid == "" then
					and_uuid = deviceUniqueIdentifier or "0"
				end				
				ios_uuid = ""
				idfv = ""
			end           
			Debug.Log("serali ios_uuid="..ios_uuid..",and_uuid"..and_uuid..",idfv="..idfv)
            that:loginSuccess(uid, token, channelCode, subchannelid,channeluid, GlobalVar.sdkPlatform, username, customparams, productcode,and_uuid,ios_uuid,idfv)
        end, function(msg)
            mIsHaveClick = false
            self:onSdkLogin(that.uid)
            tryTime = tryTime + 1
            return true
        end)
    else
        print(GlobalVar.channelName)
        if GlobalVar.isChannel==nil or GlobalVar.isChannel==false then 
            GlobalVar.channelName ="ccydmx_test123"
        end 
        self:loginSuccess(tuid, "token_test", GlobalVar.channelName, "ccydmx_test123","normal", tuid, "test", "test_code","0","0","0")
    end
end

function m:onClick(go, name)
    if name == "forgetpassword" then

    elseif name == "txt_register" then

    elseif name == "button" then

        if GlobalVar.dataEyeChannelID == "ios" then
            mysdk:init(function()
                self:onLogin()
            end)
            return nil
        end



        --   if mIsHaveClick == false then
        self:onLogin()
        --    self.button.gameObject:SetActive(false)
        --     mIsHaveClick =true
        -- end
    end
end

function m:Start()
    local str = PlayerPrefs.GetString("music")
	if GlobalVar.notice ~= nil then 
		GlobalVar.notice.transform.localPosition = Vector3(0, self.binding.height / 2.5, 0)
	end 
    --PlayerPrefs.SetString("Language", "EN ");
    --Localization.language="EN "
    local login_new = GameObject.Find("Login_new");
    if login_new ~= nil then
        -- local eff_load = login_new.transform:Find("eff_main_loading")
        -- if (eff_load ~= nil) then
        --     eff_load.gameObject:SetActive(true);
        -- end

        -- eff_load = login_new.transform:Find("Camera/eff_saoguang")
        -- if (eff_load ~= nil) then
        --     eff_load.gameObject:SetActive(true);
        -- end

    end

    self.login:SetActive(true)
    self.button.gameObject:SetActive(true)
    --读取是否接入棱镜，如果接入则不用自己帐号输入框
    local uid = PlayerPrefs.GetString("uid")
    self.uid = uid

    if GlobalVar.isLJSDK then
        self.login:SetActive(false)
        isSdk = 1
        if string.len(self.uid) > 0 and ClientTool.Platform == "ios" and GlobalVar.isChgeAcc then
            UIMrg:pushWindow("Prefabs/moduleFabs/loginModule/ChangeAccount",{
                name = self.uid, delegate = self})
        else
            mysdk:init(function()
                self:onLogin()
            end)
        end
    else
        self.input_user.value = self.uid
    end
    if GlobalVar.isPush then
        local xgpush = require("uLuaModule/modules/jpush/xgpush.lua")
        xgpush:init()
    end

    -- if GlobalVar.isLJSDK then
    --     self.login:SetActive(false)
    --     isSdk = 1
    --     mysdk:init(function()
    --         self:onLogin()
    --     end)
    --     -- mIsHaveClick =true
    -- else
    --     self.input_user.value = self.uid
    -- end
    -- if GlobalVar.isPush then
    --     local xgpush = require("uLuaModule/modules/jpush/xgpush.lua")
    --     xgpush:init()
    -- end
end

function m:choiseACuLogin(index, uid, isRegist)
    if isRegist then
        self.uid = ""
        PlayerPrefs.SetString("uid", "")
        PlayerPrefs.SetString("weuid", "")
    else
        PlayerPrefs.SetString("uid", uid)
        PlayerPrefs.SetString("weuid", PlayerPrefs.GetString("uid"..index.."weuid"))
        PlayerPrefs.SetString("wetoken", PlayerPrefs.GetString("uid"..index.."token"))
        self.uid = PlayerPrefs.GetString("uid")
    end
    mysdk:init(function()
        self:onLogin()
    end)
end

function m:create()
    return self
end

return m

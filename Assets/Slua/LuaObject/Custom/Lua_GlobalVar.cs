using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_GlobalVar : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			GlobalVar o;
			o=new GlobalVar();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_currentScene(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.currentScene);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_currentScene(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.currentScene=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_UI(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.UI);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_UI(IntPtr l) {
		try {
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			GlobalVar.UI=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Root(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.Root);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Root(IntPtr l) {
		try {
			UIRoot v;
			checkType(l,2,out v);
			GlobalVar.Root=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_camera(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.camera);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_camera(IntPtr l) {
		try {
			UnityEngine.Camera v;
			checkType(l,2,out v);
			GlobalVar.camera=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_RootPanel(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.RootPanel);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_RootPanel(IntPtr l) {
		try {
			UIPanel v;
			checkType(l,2,out v);
			GlobalVar.RootPanel=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_loading(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.loading);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_loading(IntPtr l) {
		try {
			ApiLoading v;
			checkType(l,2,out v);
			GlobalVar.loading=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_center(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.center);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_center(IntPtr l) {
		try {
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			GlobalVar.center=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_notice(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.notice);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_notice(IntPtr l) {
		try {
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			GlobalVar.notice=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_FightData(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.FightData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_FightData(IntPtr l) {
		try {
			SLua.LuaTable v;
			checkType(l,2,out v);
			GlobalVar.FightData=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_MainUI(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.MainUI);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_MainUI(IntPtr l) {
		try {
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			GlobalVar.MainUI=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_altasDic(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.altasDic);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_altasDic(IntPtr l) {
		try {
			System.Collections.Generic.Dictionary<System.String,UIAtlas> v;
			checkType(l,2,out v);
			GlobalVar.altasDic=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_gameName(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.gameName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_gameName(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.gameName=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isLJSDK(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.isLJSDK);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isLJSDK(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			GlobalVar.isLJSDK=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isChgeAcc(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.isChgeAcc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isChgeAcc(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			GlobalVar.isChgeAcc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_updateURL(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.updateURL);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_updateURL(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.updateURL=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mainVersion(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.mainVersion);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mainVersion(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.mainVersion=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_sdkPlatform(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.sdkPlatform);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_sdkPlatform(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.sdkPlatform=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_language(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.language);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_language(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.language=v;
			Debug.Log(v);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isPush(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.isPush);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isPush(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			GlobalVar.isPush=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_iosVerfy(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.iosVerfy);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_iosVerfy(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			GlobalVar.iosVerfy=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isChannel(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.isChannel);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isChannel(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			GlobalVar.isChannel=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_channelName(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.channelName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_channelName(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.channelName=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isNeedUpdate(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.isNeedUpdate);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isNeedUpdate(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			GlobalVar.isNeedUpdate=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_dataEyeChannelID(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.dataEyeChannelID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_dataEyeChannelID(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.dataEyeChannelID=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_dataEyeAppID(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.dataEyeAppID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_iosLoginUrl(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GlobalVar.iosLoginUrl);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_dataEyeAppID(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.dataEyeAppID=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_iosLoginUrl(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			GlobalVar.iosLoginUrl=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int get_subChanenelID(IntPtr l)
    {
        try
        {
            pushValue(l, true);
            pushValue(l, GlobalVar.subChannelID);
            return 2;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int set_subChanenelID(IntPtr l)
    {
        try
        {
            System.String v;
            checkType(l, 2, out v);
            GlobalVar.subChannelID = v;
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
	static public void reg(IntPtr l) {
		getTypeTable(l,"GlobalVar");
		addMember(l,"currentScene",get_currentScene,set_currentScene,false);
		addMember(l,"UI",get_UI,set_UI,false);
		addMember(l,"Root",get_Root,set_Root,false);
		addMember(l,"camera",get_camera,set_camera,false);
		addMember(l,"RootPanel",get_RootPanel,set_RootPanel,false);
		addMember(l,"loading",get_loading,set_loading,false);
		addMember(l,"center",get_center,set_center,false);
		addMember(l,"notice",get_notice,set_notice,false);
		addMember(l,"FightData",get_FightData,set_FightData,false);
		addMember(l,"MainUI",get_MainUI,set_MainUI,false);
		addMember(l,"altasDic",get_altasDic,set_altasDic,false);
		addMember(l,"gameName",get_gameName,set_gameName,false);
		addMember(l,"isLJSDK",get_isLJSDK,set_isLJSDK,false);
		addMember(l,"isChgeAcc",get_isChgeAcc,set_isChgeAcc,false);
		addMember(l,"updateURL",get_updateURL,set_updateURL,false);
		addMember(l,"mainVersion",get_mainVersion,set_mainVersion,false);
		addMember(l,"sdkPlatform",get_sdkPlatform,set_sdkPlatform,false);
		addMember(l,"language",get_language,set_language,false);
		addMember(l,"isPush",get_isPush,set_isPush,false);
		addMember(l,"isNeedUpdate",get_isNeedUpdate,set_isNeedUpdate,false);
		addMember(l,"dataEyeChannelID",get_dataEyeChannelID,set_dataEyeChannelID,false);
		addMember(l,"dataEyeAppID",get_dataEyeAppID,set_dataEyeAppID,false);
        addMember(l, "subChannelID", get_subChanenelID, set_subChanenelID, false);
		addMember(l, "iosLoginUrl", get_iosLoginUrl, set_iosLoginUrl, false);
		addMember(l, "iosVerfy", get_iosVerfy, set_iosVerfy, false);
		addMember(l, "isChannel", get_isChannel, set_isChannel, false);
		addMember(l,"channelName",get_channelName,set_channelName,false);
		createTypeMetatable(l,constructor, typeof(GlobalVar));
	}
}

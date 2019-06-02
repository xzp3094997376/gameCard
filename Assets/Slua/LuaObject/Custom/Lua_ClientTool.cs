using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_ClientTool : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Log_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				System.Object a1;
				checkType(l,1,out a1);
				ClientTool.Log(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==2){
				System.Object a1;
				checkType(l,1,out a1);
				UnityEngine.Object a2;
				checkType(l,2,out a2);
				ClientTool.Log(a1,a2);
				pushValue(l,true);
				return 1;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LogError_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				System.Object a1;
				checkType(l,1,out a1);
				ClientTool.LogError(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==2){
				System.Object a1;
				checkType(l,1,out a1);
				UnityEngine.Object a2;
				checkType(l,2,out a2);
				ClientTool.LogError(a1,a2);
				pushValue(l,true);
				return 1;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int endsWith_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=ClientTool.endsWith(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetNumbersFromString_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=ClientTool.GetNumbersFromString(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int load_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				System.String a1;
				checkType(l,1,out a1);
				var ret=ClientTool.load(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(string),typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				var ret=ClientTool.load(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(string),typeof(UnityEngine.GameObject))){
				System.String a1;
				checkType(l,1,out a1);
				UnityEngine.GameObject a2;
				checkType(l,2,out a2);
				var ret=ClientTool.load(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Pureload_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=ClientTool.Pureload(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int loadAndGetLuaBinding_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UnityEngine.GameObject a2;
			checkType(l,2,out a2);
			var ret=ClientTool.loadAndGetLuaBinding(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int loadAssets_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			UnityEngine.GameObject a3;
			checkType(l,3,out a3);
			System.Action<UnityEngine.Object> a4;
			LuaDelegation.checkDelegate(l,4,out a4);
			ClientTool.loadAssets(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int loadAndGetLuaBindingFromPool_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UnityEngine.GameObject a2;
			checkType(l,2,out a2);
			var ret=ClientTool.loadAndGetLuaBindingFromPool(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetLuaBinding_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			var ret=ClientTool.GetLuaBinding(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SendMessageFromLua_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			ClientTool.SendMessageFromLua(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UpdateGrid_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				System.String a1;
				checkType(l,1,out a1);
				UIGrid a2;
				checkType(l,2,out a2);
				SLua.LuaTable a3;
				checkType(l,3,out a3);
				var ret=ClientTool.UpdateGrid(a1,a2,a3);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==4){
				System.String a1;
				checkType(l,1,out a1);
				UIGrid a2;
				checkType(l,2,out a2);
				SLua.LuaTable a3;
				checkType(l,3,out a3);
				SLua.LuaTable a4;
				checkType(l,4,out a4);
				var ret=ClientTool.UpdateGrid(a1,a2,a3,a4);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UpdateMyTable_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				System.String a1;
				checkType(l,1,out a1);
				MyTable a2;
				checkType(l,2,out a2);
				SLua.LuaTable a3;
				checkType(l,3,out a3);
				var ret=ClientTool.UpdateMyTable(a1,a2,a3);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==4){
				System.String a1;
				checkType(l,1,out a1);
				MyTable a2;
				checkType(l,2,out a2);
				SLua.LuaTable a3;
				checkType(l,3,out a3);
				SLua.LuaTable a4;
				checkType(l,4,out a4);
				var ret=ClientTool.UpdateMyTable(a1,a2,a3,a4);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddClick_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(UnityEngine.Component),typeof(SLua.LuaFunction))){
				UnityEngine.Component a1;
				checkType(l,1,out a1);
				SLua.LuaFunction a2;
				checkType(l,2,out a2);
				ClientTool.AddClick(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.GameObject),typeof(SLua.LuaFunction))){
				UnityEngine.GameObject a1;
				checkType(l,1,out a1);
				SLua.LuaFunction a2;
				checkType(l,2,out a2);
				ClientTool.AddClick(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.Transform),typeof(SLua.LuaFunction))){
				UnityEngine.Transform a1;
				checkType(l,1,out a1);
				SLua.LuaFunction a2;
				checkType(l,2,out a2);
				ClientTool.AddClick(a1,a2);
				pushValue(l,true);
				return 1;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetNowTime_s(IntPtr l) {
		try {
			System.Double a1;
			checkType(l,1,out a1);
			var ret=ClientTool.GetNowTime(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AlignToObject_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UnityEngine.GameObject a1;
				checkType(l,1,out a1);
				UnityEngine.GameObject a2;
				checkType(l,2,out a2);
				ClientTool.AlignToObject(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				UnityEngine.GameObject a1;
				checkType(l,1,out a1);
				UnityEngine.GameObject a2;
				checkType(l,2,out a2);
				System.Int32 a3;
				checkType(l,3,out a3);
				ClientTool.AlignToObject(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int quitGame_s(IntPtr l) {
		try {
			ClientTool.quitGame();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onQuit_s(IntPtr l) {
		try {
			ClientTool.onQuit();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int beginLoadScene_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			SLua.LuaFunction a2;
			checkType(l,2,out a2);
			ClientTool.beginLoadScene(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadLevel_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			SLua.LuaFunction a2;
			checkType(l,2,out a2);
			ClientTool.LoadLevel(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int DestoryScene_s(IntPtr l)
    {
        try
        {
            ClientTool.DestoryScene(); 
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showLoading_s(IntPtr l) {
		try {
			ClientTool.showLoading();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int hideLoading_s(IntPtr l) {
		try {
			ClientTool.hideLoading();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ResetAnimation_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			ClientTool.ResetAnimation(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PlayAnimation_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			SLua.LuaFunction a3;
			checkType(l,3,out a3);
			System.Boolean a4;
			checkType(l,4,out a4);
			ClientTool.PlayAnimation(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int resetTransform_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			ClientTool.resetTransform(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AdjustDepth_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			ClientTool.AdjustDepth(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LuaTableToCSharp_s(IntPtr l) {
		try {
			SLua.LuaTable a1;
			checkType(l,1,out a1);
			var ret=ClientTool.LuaTableToCSharp(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int HideAllChildren_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			ClientTool.HideAllChildren(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetLayerByNane_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			ClientTool.SetLayerByNane(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int release_s(IntPtr l) {
		try {
			ClientTool.release();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int gcCollect_s(IntPtr l)
    {
        try
        {
            ClientTool.gcCollect();
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int IsLow_s(IntPtr l)
    {
        try
        {
            var ret = ClientTool.IsLow();
            pushValue(l, true);
            pushValue(l, ret);
            return 2;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int freeList_s(IntPtr l) {
		try {
			System.Collections.IList a1;
			checkType(l,1,out a1);
			ClientTool.freeList(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PlayTweenPostion_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			UnityEngine.GameObject a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			SLua.LuaFunction a4;
			checkType(l,4,out a4);
			ClientTool.PlayTweenPostion(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddChild_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			UnityEngine.GameObject a2;
			checkType(l,2,out a2);
			var ret=ClientTool.AddChild(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ForEachJsonObject_s(IntPtr l) {
		try {
			SimpleJson.JsonObject a1;
			checkType(l,1,out a1);
			SLua.LuaFunction a2;
			checkType(l,2,out a2);
			ClientTool.ForEachJsonObject(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ResetTweener_s(IntPtr l) {
		try {
			UnityEngine.GameObject a1;
			checkType(l,1,out a1);
			ClientTool.ResetTweener(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Platform(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,ClientTool.Platform);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Platform(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			ClientTool.Platform=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"ClientTool");
		addMember(l,Log_s);
		addMember(l,LogError_s);
		addMember(l,endsWith_s);
		addMember(l,GetNumbersFromString_s);
		addMember(l,load_s);
		addMember(l,Pureload_s);
		addMember(l,loadAndGetLuaBinding_s);
		addMember(l,loadAssets_s);
		addMember(l,loadAndGetLuaBindingFromPool_s);
		addMember(l,GetLuaBinding_s);
		addMember(l,SendMessageFromLua_s);
		addMember(l,UpdateGrid_s);
		addMember(l,UpdateMyTable_s);
		addMember(l,AddClick_s);
		addMember(l,GetNowTime_s);
		addMember(l,AlignToObject_s);
		addMember(l,quitGame_s);
		addMember(l,onQuit_s);
		addMember(l,beginLoadScene_s);
		addMember(l,LoadLevel_s);
        addMember(l,DestoryScene_s);
		addMember(l,showLoading_s);
		addMember(l,hideLoading_s);
		addMember(l,ResetAnimation_s);
		addMember(l,PlayAnimation_s);
		addMember(l,resetTransform_s);
		addMember(l,AdjustDepth_s);
		addMember(l,LuaTableToCSharp_s);
		addMember(l,HideAllChildren_s);
		addMember(l,SetLayerByNane_s);
		addMember(l,release_s);
        addMember(l, gcCollect_s);
        addMember(l, IsLow_s);
		addMember(l,freeList_s);
		addMember(l,PlayTweenPostion_s);
		addMember(l,AddChild_s);
		addMember(l,ForEachJsonObject_s);
		addMember(l,ResetTweener_s);
		addMember(l,"Platform",get_Platform,set_Platform,false);
		createTypeMetatable(l,null, typeof(ClientTool));
	}
}

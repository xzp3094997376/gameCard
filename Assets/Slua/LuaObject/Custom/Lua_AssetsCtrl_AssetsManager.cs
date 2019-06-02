using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_AssetsCtrl_AssetsManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager o;
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			AssetsCtrl.AssetsManager.EventAssetsManager a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			o=new AssetsCtrl.AssetsManager(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int checkUpdate(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager self=(AssetsCtrl.AssetsManager)checkSelf(l);
			self.checkUpdate();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int update(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager self=(AssetsCtrl.AssetsManager)checkSelf(l);
			self.update();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int downloadFailedAssets(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager self=(AssetsCtrl.AssetsManager)checkSelf(l);
			self.downloadFailedAssets();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getState(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager self=(AssetsCtrl.AssetsManager)checkSelf(l);
			var ret=self.getState();
			pushValue(l,true);
			pushEnum(l,(int)ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getStoragePath(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager self=(AssetsCtrl.AssetsManager)checkSelf(l);
			var ret=self.getStoragePath();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getLocalManifest(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager self=(AssetsCtrl.AssetsManager)checkSelf(l);
			var ret=self.getLocalManifest();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getRemoteManifest(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager self=(AssetsCtrl.AssetsManager)checkSelf(l);
			var ret=self.getRemoteManifest();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Log_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			AssetsCtrl.AssetsManager.Log(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LogError_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			AssetsCtrl.AssetsManager.LogError(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_VERSION_FILENAME(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AssetsCtrl.AssetsManager.VERSION_FILENAME);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_TEMP_MANIFEST_FILENAME(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AssetsCtrl.AssetsManager.TEMP_MANIFEST_FILENAME);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_MANIFEST_FILENAME(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AssetsCtrl.AssetsManager.MANIFEST_FILENAME);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_VERSION_ID(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AssetsCtrl.AssetsManager.VERSION_ID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_MANIFEST_ID(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AssetsCtrl.AssetsManager.MANIFEST_ID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_BATCH_UPDATE_ID(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AssetsCtrl.AssetsManager.BATCH_UPDATE_ID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onCallBack(IntPtr l) {
		try {
			AssetsCtrl.AssetsManager self=(AssetsCtrl.AssetsManager)checkSelf(l);
			AssetsCtrl.AssetsManager.EventAssetsManager v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onCallBack=v;
			else if(op==1) self.onCallBack+=v;
			else if(op==2) self.onCallBack-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"AssetsCtrl.AssetsManager");
		addMember(l,checkUpdate);
		addMember(l,update);
		addMember(l,downloadFailedAssets);
		addMember(l,getState);
		addMember(l,getStoragePath);
		addMember(l,getLocalManifest);
		addMember(l,getRemoteManifest);
		addMember(l,Log_s);
		addMember(l,LogError_s);
		addMember(l,"VERSION_FILENAME",get_VERSION_FILENAME,null,false);
		addMember(l,"TEMP_MANIFEST_FILENAME",get_TEMP_MANIFEST_FILENAME,null,false);
		addMember(l,"MANIFEST_FILENAME",get_MANIFEST_FILENAME,null,false);
		addMember(l,"VERSION_ID",get_VERSION_ID,null,false);
		addMember(l,"MANIFEST_ID",get_MANIFEST_ID,null,false);
		addMember(l,"BATCH_UPDATE_ID",get_BATCH_UPDATE_ID,null,false);
		addMember(l,"onCallBack",null,set_onCallBack,true);
		createTypeMetatable(l,constructor, typeof(AssetsCtrl.AssetsManager));
	}
}

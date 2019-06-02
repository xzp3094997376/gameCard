using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_AssetsCtrl_Downloader : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			AssetsCtrl.Downloader o;
			o=new AssetsCtrl.Downloader();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setConnectionTimeout(IntPtr l) {
		try {
			AssetsCtrl.Downloader self=(AssetsCtrl.Downloader)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.setConnectionTimeout(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int downloadAsync(IntPtr l) {
		try {
			AssetsCtrl.Downloader self=(AssetsCtrl.Downloader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			self.downloadAsync(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int batchDownloadAsync(IntPtr l) {
		try {
			AssetsCtrl.Downloader self=(AssetsCtrl.Downloader)checkSelf(l);
			System.Collections.Generic.Dictionary<System.String,AssetsCtrl.Downloader.DownloadUnit> a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			self.batchDownloadAsync(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get__connectionTimeout(IntPtr l) {
		try {
			AssetsCtrl.Downloader self=(AssetsCtrl.Downloader)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self._connectionTimeout);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__connectionTimeout(IntPtr l) {
		try {
			AssetsCtrl.Downloader self=(AssetsCtrl.Downloader)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self._connectionTimeout=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__onError(IntPtr l) {
		try {
			AssetsCtrl.Downloader self=(AssetsCtrl.Downloader)checkSelf(l);
			AssetsCtrl.Downloader.ErrorCallback v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self._onError=v;
			else if(op==1) self._onError+=v;
			else if(op==2) self._onError-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__onProgress(IntPtr l) {
		try {
			AssetsCtrl.Downloader self=(AssetsCtrl.Downloader)checkSelf(l);
			AssetsCtrl.Downloader.ProgressCallback v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self._onProgress=v;
			else if(op==1) self._onProgress+=v;
			else if(op==2) self._onProgress-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__onSuccess(IntPtr l) {
		try {
			AssetsCtrl.Downloader self=(AssetsCtrl.Downloader)checkSelf(l);
			AssetsCtrl.Downloader.SuccessCallback v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self._onSuccess=v;
			else if(op==1) self._onSuccess+=v;
			else if(op==2) self._onSuccess-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"AssetsCtrl.Downloader");
		addMember(l,setConnectionTimeout);
		addMember(l,downloadAsync);
		addMember(l,batchDownloadAsync);
		addMember(l,"_connectionTimeout",get__connectionTimeout,set__connectionTimeout,true);
		addMember(l,"_onError",null,set__onError,true);
		addMember(l,"_onProgress",null,set__onProgress,true);
		addMember(l,"_onSuccess",null,set__onSuccess,true);
		createTypeMetatable(l,constructor, typeof(AssetsCtrl.Downloader));
	}
}

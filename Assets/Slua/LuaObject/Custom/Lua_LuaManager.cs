using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_LuaManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int start(IntPtr l) {
		try {
			LuaManager self=(LuaManager)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.start(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int init(IntPtr l) {
		try {
			LuaManager self=(LuaManager)checkSelf(l);
			System.Action<System.Int32> a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			System.Action a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			System.Boolean a3;
			checkType(l,4,out a3);
			self.init(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DoString(IntPtr l) {
		try {
			LuaManager self=(LuaManager)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.DoString(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DoBuffer(IntPtr l) {
		try {
			LuaManager self=(LuaManager)checkSelf(l);
			System.Byte[] a1;
			checkType(l,2,out a1);
			var ret=self.DoBuffer(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DoFile(IntPtr l) {
		try {
			LuaManager self=(LuaManager)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.DoFile(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Destroy(IntPtr l) {
		try {
			LuaManager self=(LuaManager)checkSelf(l);
			self.Destroy();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallLuaFunction(IntPtr l) {
		try {
			LuaManager self=(LuaManager)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object[] a2;
			checkParams(l,3,out a2);
			var ret=self.CallLuaFunction(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getInstance_s(IntPtr l) {
		try {
			var ret=LuaManager.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int reloadAllScript_s(IntPtr l) {
		try {
			LuaManager.reloadAllScript();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_luaState(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,LuaManager.luaState);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"LuaManager");
		addMember(l,start);
		addMember(l,init);
		addMember(l,DoString);
		addMember(l,DoBuffer);
		addMember(l,DoFile);
		addMember(l,Destroy);
		addMember(l,CallLuaFunction);
		addMember(l,getInstance_s);
		addMember(l,reloadAllScript_s);
		addMember(l,"luaState",get_luaState,null,false);
		createTypeMetatable(l,null, typeof(LuaManager));
	}
}

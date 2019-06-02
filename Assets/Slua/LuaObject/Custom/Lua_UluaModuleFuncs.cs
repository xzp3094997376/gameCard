using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UluaModuleFuncs : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int times(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			self.times();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int luaBatchCommands(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			self.luaBatchCommands(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int luaCommands(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			self.luaCommands(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int executeInstruct(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			self.executeInstruct(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_uOtherFuns(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.uOtherFuns);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_uOtherFuns(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			UotherPublicFuncs v;
			checkType(l,2,out v);
			self.uOtherFuns=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_uTimer(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.uTimer);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_uTimer(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			UluaTimer v;
			checkType(l,2,out v);
			self.uTimer=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_uCommandList(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.uCommandList);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_uCommandList(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			System.Collections.Generic.List<SLua.LuaTable> v;
			checkType(l,2,out v);
			self.uCommandList=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isHaveTimer(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isHaveTimer);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isHaveTimer(IntPtr l) {
		try {
			UluaModuleFuncs self=(UluaModuleFuncs)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isHaveTimer=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaModuleFuncs.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UluaModuleFuncs");
		addMember(l,times);
		addMember(l,luaBatchCommands);
		addMember(l,luaCommands);
		addMember(l,executeInstruct);
		addMember(l,"uOtherFuns",get_uOtherFuns,set_uOtherFuns,true);
		addMember(l,"uTimer",get_uTimer,set_uTimer,true);
		addMember(l,"uCommandList",get_uCommandList,set_uCommandList,true);
		addMember(l,"isHaveTimer",get_isHaveTimer,set_isHaveTimer,true);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,null, typeof(UluaModuleFuncs));
	}
}

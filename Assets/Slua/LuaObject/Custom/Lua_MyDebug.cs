using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_MyDebug : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			MyDebug o;
			o=new MyDebug();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Log_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				System.Object a1;
				checkType(l,1,out a1);
				MyDebug.Log(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==2){
				System.Object a1;
				checkType(l,1,out a1);
				UnityEngine.Object a2;
				checkType(l,2,out a2);
				MyDebug.Log(a1,a2);
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
				MyDebug.LogError(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==2){
				System.Object a1;
				checkType(l,1,out a1);
				UnityEngine.Object a2;
				checkType(l,2,out a2);
				MyDebug.LogError(a1,a2);
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
	static public int LogWarning_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				System.Object a1;
				checkType(l,1,out a1);
				MyDebug.LogWarning(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==2){
				System.Object a1;
				checkType(l,1,out a1);
				UnityEngine.Object a2;
				checkType(l,2,out a2);
				MyDebug.LogWarning(a1,a2);
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
	static public int get_isDebug(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,MyDebug.isDebug);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isDebug(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			MyDebug.isDebug=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"MyDebug");
		addMember(l,Log_s);
		addMember(l,LogError_s);
		addMember(l,LogWarning_s);
		addMember(l,"isDebug",get_isDebug,set_isDebug,false);
		createTypeMetatable(l,constructor, typeof(MyDebug));
	}
}

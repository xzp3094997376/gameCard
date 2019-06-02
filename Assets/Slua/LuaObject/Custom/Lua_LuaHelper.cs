using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_LuaHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Clear_s(IntPtr l) {
		try {
			LuaHelper.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DoFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=LuaHelper.DoFile(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getTableFunction_s(IntPtr l) {
		try {
			SLua.LuaTable a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=LuaHelper.getTableFunction(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallLuaFunction_s(IntPtr l) {
		try {
			SLua.LuaTable a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Object[] a3;
			checkParams(l,3,out a3);
			var ret=LuaHelper.CallLuaFunction(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int readFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=LuaHelper.readFile(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int writeFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Object a2;
			checkType(l,2,out a2);
			LuaHelper.writeFile(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int deleteFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			LuaHelper.deleteFile(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"LuaHelper");
		addMember(l,Clear_s);
		addMember(l,DoFile_s);
		addMember(l,getTableFunction_s);
		addMember(l,CallLuaFunction_s);
		addMember(l,readFile_s);
		addMember(l,writeFile_s);
		addMember(l,deleteFile_s);
		createTypeMetatable(l,null, typeof(LuaHelper));
	}
}

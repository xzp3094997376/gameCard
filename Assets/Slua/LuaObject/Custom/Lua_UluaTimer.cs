using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UluaTimer : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int frameTime(IntPtr l) {
		try {
			UluaTimer self=(UluaTimer)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Double a2;
			checkType(l,3,out a2);
			System.Double a3;
			checkType(l,4,out a3);
			SLua.LuaFunction a4;
			checkType(l,5,out a4);
			SLua.LuaTable a5;
			checkType(l,6,out a5);
			self.frameTime(a1,a2,a3,a4,a5);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeFrameTime(IntPtr l) {
		try {
			UluaTimer self=(UluaTimer)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.removeFrameTime(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int secondTime(IntPtr l) {
		try {
			UluaTimer self=(UluaTimer)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Double a2;
			checkType(l,3,out a2);
			System.Double a3;
			checkType(l,4,out a3);
			SLua.LuaFunction a4;
			checkType(l,5,out a4);
			SLua.LuaTable a5;
			checkType(l,6,out a5);
			self.secondTime(a1,a2,a3,a4,a5);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeSecondTime(IntPtr l) {
		try {
			UluaTimer self=(UluaTimer)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.removeSecondTime(a1);
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
			pushValue(l,UluaTimer.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UluaTimer");
		addMember(l,frameTime);
		addMember(l,removeFrameTime);
		addMember(l,secondTime);
		addMember(l,removeSecondTime);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,null, typeof(UluaTimer));
	}
}

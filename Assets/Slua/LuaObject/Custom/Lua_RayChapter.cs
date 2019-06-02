using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_RayChapter : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onSetLuaTable(IntPtr l) {
		try {
			RayChapter self=(RayChapter)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			SLua.LuaTable a3;
			checkType(l,4,out a3);
			self.onSetLuaTable(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onClick(IntPtr l) {
		try {
			RayChapter self=(RayChapter)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.onClick(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnDestroy(IntPtr l) {
		try {
			RayChapter self=(RayChapter)checkSelf(l);
			self.OnDestroy();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_allNeedTest(IntPtr l) {
		try {
			RayChapter self=(RayChapter)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.allNeedTest);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_allNeedTest(IntPtr l) {
		try {
			RayChapter self=(RayChapter)checkSelf(l);
			UITexture[] v;
			checkType(l,2,out v);
			self.allNeedTest=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mTargets(IntPtr l) {
		try {
			RayChapter self=(RayChapter)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mTargets);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mTargets(IntPtr l) {
		try {
			RayChapter self=(RayChapter)checkSelf(l);
			SLua.LuaTable[] v;
			checkType(l,2,out v);
			self.mTargets=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"RayChapter");
		addMember(l,onSetLuaTable);
		addMember(l,onClick);
		addMember(l,OnDestroy);
		addMember(l,"allNeedTest",get_allNeedTest,set_allNeedTest,true);
		addMember(l,"mTargets",get_mTargets,set_mTargets,true);
		createTypeMetatable(l,null, typeof(RayChapter),typeof(UnityEngine.MonoBehaviour));
	}
}

using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_StarAnimate : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetViews(IntPtr l) {
		try {
			StarAnimate self=(StarAnimate)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.SetViews(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DelayShow(IntPtr l) {
		try {
			StarAnimate self=(StarAnimate)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			SLua.LuaFunction a2;
			checkType(l,3,out a2);
			SLua.LuaFunction a3;
			checkType(l,4,out a3);
			self.DelayShow(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_anis(IntPtr l) {
		try {
			StarAnimate self=(StarAnimate)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.anis);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_anis(IntPtr l) {
		try {
			StarAnimate self=(StarAnimate)checkSelf(l);
			UnityEngine.Animation[] v;
			checkType(l,2,out v);
			self.anis=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_Ani(IntPtr l) {
		try {
			StarAnimate self=(StarAnimate)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_Ani);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_Ani(IntPtr l) {
		try {
			StarAnimate self=(StarAnimate)checkSelf(l);
			UnityEngine.Animator v;
			checkType(l,2,out v);
			self.m_Ani=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"StarAnimate");
		addMember(l,SetViews);
		addMember(l,DelayShow);
		addMember(l,"anis",get_anis,set_anis,true);
		addMember(l,"m_Ani",get_m_Ani,set_m_Ani,true);
		createTypeMetatable(l,null, typeof(StarAnimate),typeof(UnityEngine.MonoBehaviour));
	}
}

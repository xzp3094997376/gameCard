using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_BuildCtrlTarget : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showEffect(IntPtr l) {
		try {
			BuildCtrlTarget self=(BuildCtrlTarget)checkSelf(l);
			self.showEffect();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_AngleY(IntPtr l) {
		try {
			BuildCtrlTarget self=(BuildCtrlTarget)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_AngleY);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_AngleY(IntPtr l) {
		try {
			BuildCtrlTarget self=(BuildCtrlTarget)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.m_AngleY=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"BuildCtrlTarget");
		addMember(l,showEffect);
		addMember(l,"m_AngleY",get_m_AngleY,set_m_AngleY,true);
		createTypeMetatable(l,null, typeof(BuildCtrlTarget),typeof(UnityEngine.MonoBehaviour));
	}
}

using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_SetTooltip : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int show(IntPtr l) {
		try {
			SetTooltip self=(SetTooltip)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.show(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_fixPosition(IntPtr l) {
		try {
			SetTooltip self=(SetTooltip)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.fixPosition);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_fixPosition(IntPtr l) {
		try {
			SetTooltip self=(SetTooltip)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.fixPosition=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mDir(IntPtr l) {
		try {
			SetTooltip self=(SetTooltip)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.mDir);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mDir(IntPtr l) {
		try {
			SetTooltip self=(SetTooltip)checkSelf(l);
			Tips.FixPosition v;
			checkEnum(l,2,out v);
			self.mDir=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onTooltip(IntPtr l) {
		try {
			SetTooltip self=(SetTooltip)checkSelf(l);
			System.Func<System.String> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onTooltip=v;
			else if(op==1) self.onTooltip+=v;
			else if(op==2) self.onTooltip-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"SetTooltip");
		addMember(l,show);
		addMember(l,"fixPosition",get_fixPosition,set_fixPosition,true);
		addMember(l,"mDir",get_mDir,set_mDir,true);
		addMember(l,"onTooltip",null,set_onTooltip,true);
		createTypeMetatable(l,null, typeof(SetTooltip),typeof(UnityEngine.MonoBehaviour));
	}
}

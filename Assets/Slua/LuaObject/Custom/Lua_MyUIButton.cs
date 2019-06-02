using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_MyUIButton : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			MyUIButton o;
			o=new MyUIButton();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetState(IntPtr l) {
		try {
			MyUIButton self=(MyUIButton)checkSelf(l);
			UIButtonColor.State a1;
			checkEnum(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.SetState(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isEnabled(IntPtr l) {
		try {
			MyUIButton self=(MyUIButton)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isEnabled);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isEnabled(IntPtr l) {
		try {
			MyUIButton self=(MyUIButton)checkSelf(l);
			bool v;
			checkType(l,2,out v);
			self.isEnabled=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"MyUIButton");
		addMember(l,SetState);
		addMember(l,"isEnabled",get_isEnabled,set_isEnabled,true);
		createTypeMetatable(l,constructor, typeof(MyUIButton),typeof(UIButton));
	}
}

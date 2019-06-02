using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_DestroyObject : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setCallBack(IntPtr l) {
		try {
			DestroyObject self=(DestroyObject)checkSelf(l);
			System.Action a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			self.setCallBack(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isClick(IntPtr l) {
		try {
			DestroyObject self=(DestroyObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isClick);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isClick(IntPtr l) {
		try {
			DestroyObject self=(DestroyObject)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isClick=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isPopWindow(IntPtr l) {
		try {
			DestroyObject self=(DestroyObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isPopWindow);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isPopWindow(IntPtr l) {
		try {
			DestroyObject self=(DestroyObject)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isPopWindow=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"DestroyObject");
		addMember(l,setCallBack);
		addMember(l,"isClick",get_isClick,set_isClick,true);
		addMember(l,"isPopWindow",get_isPopWindow,set_isPopWindow,true);
		createTypeMetatable(l,null, typeof(DestroyObject),typeof(UnityEngine.MonoBehaviour));
	}
}

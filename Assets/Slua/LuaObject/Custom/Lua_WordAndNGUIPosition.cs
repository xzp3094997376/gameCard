using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_WordAndNGUIPosition : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_trans(IntPtr l) {
		try {
			WordAndNGUIPosition self=(WordAndNGUIPosition)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.trans);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_trans(IntPtr l) {
		try {
			WordAndNGUIPosition self=(WordAndNGUIPosition)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.trans=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_beginGetPosition(IntPtr l) {
		try {
			WordAndNGUIPosition self=(WordAndNGUIPosition)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.beginGetPosition);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"WordAndNGUIPosition");
		addMember(l,"trans",get_trans,set_trans,true);
		addMember(l,"beginGetPosition",get_beginGetPosition,null,true);
		createTypeMetatable(l,null, typeof(WordAndNGUIPosition),typeof(UnityEngine.MonoBehaviour));
	}
}

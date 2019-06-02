using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_FontMrg : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			FontMrg o;
			o=new FontMrg();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getFont(IntPtr l) {
		try {
			FontMrg self=(FontMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getFont(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeUnusedFont(IntPtr l) {
		try {
			FontMrg self=(FontMrg)checkSelf(l);
			self.removeUnusedFont();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int addFont(IntPtr l) {
		try {
			FontMrg self=(FontMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.addFont(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getInstance_s(IntPtr l) {
		try {
			var ret=FontMrg.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"FontMrg");
		addMember(l,getFont);
		addMember(l,removeUnusedFont);
		addMember(l,addFont);
		addMember(l,getInstance_s);
		createTypeMetatable(l,constructor, typeof(FontMrg));
	}
}

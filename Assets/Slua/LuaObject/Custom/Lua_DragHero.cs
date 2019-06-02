using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_DragHero : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			DragHero o;
			o=new DragHero();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StartDragging(IntPtr l) {
		try {
			DragHero self=(DragHero)checkSelf(l);
			self.StartDragging();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int reset(IntPtr l) {
		try {
			DragHero self=(DragHero)checkSelf(l);
			self.reset();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_binding(IntPtr l) {
		try {
			DragHero self=(DragHero)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.binding);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_binding(IntPtr l) {
		try {
			DragHero self=(DragHero)checkSelf(l);
			UluaBinding v;
			checkType(l,2,out v);
			self.binding=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"DragHero");
		addMember(l,StartDragging);
		addMember(l,reset);
		addMember(l,"binding",get_binding,set_binding,true);
		createTypeMetatable(l,constructor, typeof(DragHero),typeof(UIDragDropItem));
	}
}

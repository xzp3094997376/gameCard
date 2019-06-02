using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_LZItemCell : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Init(IntPtr l) {
		try {
			LZItemCell self=(LZItemCell)checkSelf(l);
			System.Object a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			System.Boolean a3;
			checkType(l,4,out a3);
			self.Init(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Dispose(IntPtr l) {
		try {
			LZItemCell self=(LZItemCell)checkSelf(l);
			self.Dispose();
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
			LZItemCell self=(LZItemCell)checkSelf(l);
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
			LZItemCell self=(LZItemCell)checkSelf(l);
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
		getTypeTable(l,"LZItemCell");
		addMember(l,Init);
		addMember(l,Dispose);
		addMember(l,"binding",get_binding,set_binding,true);
		createTypeMetatable(l,null, typeof(LZItemCell),typeof(UnityEngine.MonoBehaviour));
	}
}

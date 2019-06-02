using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_DataModel_MPlayer2 : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			DataModel.MPlayer2 o;
			System.String a1;
			checkType(l,2,out a1);
			o=new DataModel.MPlayer2(a1);
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int init(IntPtr l) {
		try {
			DataModel.MPlayer2 self=(DataModel.MPlayer2)checkSelf(l);
			self.init();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,DataModel.MPlayer2.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Instance(IntPtr l) {
		try {
			DataModel.MRoot v;
			checkType(l,2,out v);
			DataModel.MPlayer2.Instance=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"DataModel.MPlayer2");
		addMember(l,init);
		addMember(l,"Instance",get_Instance,set_Instance,false);
		createTypeMetatable(l,constructor, typeof(DataModel.MPlayer2),typeof(DataModel.MRoot),true);
	}
}

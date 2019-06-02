using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Follow3DObject : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Follow3DObject o;
			o=new Follow3DObject();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_autoHide(IntPtr l) {
		try {
			Follow3DObject self=(Follow3DObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.autoHide);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_autoHide(IntPtr l) {
		try {
			Follow3DObject self=(Follow3DObject)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.autoHide=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Follow3DObject");
		addMember(l,"autoHide",get_autoHide,set_autoHide,true);
		createTypeMetatable(l,constructor, typeof(Follow3DObject),typeof(UIFollowTargetCtrl));
	}
}

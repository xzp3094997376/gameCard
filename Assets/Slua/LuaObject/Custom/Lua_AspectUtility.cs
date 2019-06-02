using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_AspectUtility : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UpdateLayout(IntPtr l) {
		try {
			AspectUtility self=(AspectUtility)checkSelf(l);
			self.UpdateLayout();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetCamera_s(IntPtr l) {
		try {
			AspectUtility.SetCamera();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_maxAspectRatio(IntPtr l) {
		try {
			AspectUtility self=(AspectUtility)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.maxAspectRatio);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_maxAspectRatio(IntPtr l) {
		try {
			AspectUtility self=(AspectUtility)checkSelf(l);
			UnityEngine.Vector2 v;
			checkType(l,2,out v);
			self.maxAspectRatio=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_minAspectRatio(IntPtr l) {
		try {
			AspectUtility self=(AspectUtility)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.minAspectRatio);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_minAspectRatio(IntPtr l) {
		try {
			AspectUtility self=(AspectUtility)checkSelf(l);
			UnityEngine.Vector2 v;
			checkType(l,2,out v);
			self.minAspectRatio=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_landscapeModeOnly(IntPtr l) {
		try {
			AspectUtility self=(AspectUtility)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.landscapeModeOnly);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_landscapeModeOnly(IntPtr l) {
		try {
			AspectUtility self=(AspectUtility)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.landscapeModeOnly=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get__landscapeModeOnly(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility._landscapeModeOnly);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__landscapeModeOnly(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			AspectUtility._landscapeModeOnly=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_screenHeight(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility.screenHeight);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_screenWidth(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility.screenWidth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_xOffset(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility.xOffset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_yOffset(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility.yOffset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_screenRect(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility.screenRect);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mousePosition(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility.mousePosition);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_guiMousePosition(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AspectUtility.guiMousePosition);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"AspectUtility");
		addMember(l,UpdateLayout);
		addMember(l,SetCamera_s);
		addMember(l,"maxAspectRatio",get_maxAspectRatio,set_maxAspectRatio,true);
		addMember(l,"minAspectRatio",get_minAspectRatio,set_minAspectRatio,true);
		addMember(l,"landscapeModeOnly",get_landscapeModeOnly,set_landscapeModeOnly,true);
		addMember(l,"_landscapeModeOnly",get__landscapeModeOnly,set__landscapeModeOnly,false);
		addMember(l,"instance",get_instance,null,false);
		addMember(l,"screenHeight",get_screenHeight,null,false);
		addMember(l,"screenWidth",get_screenWidth,null,false);
		addMember(l,"xOffset",get_xOffset,null,false);
		addMember(l,"yOffset",get_yOffset,null,false);
		addMember(l,"screenRect",get_screenRect,null,false);
		addMember(l,"mousePosition",get_mousePosition,null,false);
		addMember(l,"guiMousePosition",get_guiMousePosition,null,false);
		createTypeMetatable(l,null, typeof(AspectUtility),typeof(UnityEngine.MonoBehaviour));
	}
}

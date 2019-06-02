using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UIFollowTargetCtrl : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_target(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.target);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_target(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.target=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_gameCamera(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.gameCamera);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_gameCamera(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			UnityEngine.Camera v;
			checkType(l,2,out v);
			self.gameCamera=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_uiCamera(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.uiCamera);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_uiCamera(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			UnityEngine.Camera v;
			checkType(l,2,out v);
			self.uiCamera=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_disableIfInvisible(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.disableIfInvisible);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_disableIfInvisible(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.disableIfInvisible=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mOffset(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mOffset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mOffset(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.mOffset=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mNeedUpdateDepth(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mNeedUpdateDepth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mNeedUpdateDepth(IntPtr l) {
		try {
			UIFollowTargetCtrl self=(UIFollowTargetCtrl)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.mNeedUpdateDepth=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UIFollowTargetCtrl");
		addMember(l,"target",get_target,set_target,true);
		addMember(l,"gameCamera",get_gameCamera,set_gameCamera,true);
		addMember(l,"uiCamera",get_uiCamera,set_uiCamera,true);
		addMember(l,"disableIfInvisible",get_disableIfInvisible,set_disableIfInvisible,true);
		addMember(l,"mOffset",get_mOffset,set_mOffset,true);
		addMember(l,"mNeedUpdateDepth",get_mNeedUpdateDepth,set_mNeedUpdateDepth,true);
		createTypeMetatable(l,null, typeof(UIFollowTargetCtrl),typeof(UnityEngine.MonoBehaviour));
	}
}

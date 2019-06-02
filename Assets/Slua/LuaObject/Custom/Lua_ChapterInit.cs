using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_ChapterInit : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setInit(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Boolean a3;
			checkType(l,4,out a3);
			self.setInit(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setCallFun(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			self.setCallFun(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setCallBackMessage(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			self.setCallBackMessage(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_dragPage(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.dragPage);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_dragPage(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			DragPageComponent v;
			checkType(l,2,out v);
			self.dragPage=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_callBackFun(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.callBackFun);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_callBackFun(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.callBackFun=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_errorMessage(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.errorMessage);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_errorMessage(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.errorMessage=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mTarget(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mTarget);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mTarget(IntPtr l) {
		try {
			ChapterInit self=(ChapterInit)checkSelf(l);
			SLua.LuaTable v;
			checkType(l,2,out v);
			self.mTarget=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"ChapterInit");
		addMember(l,setInit);
		addMember(l,setCallFun);
		addMember(l,setCallBackMessage);
		addMember(l,"dragPage",get_dragPage,set_dragPage,true);
		addMember(l,"callBackFun",get_callBackFun,set_callBackFun,true);
		addMember(l,"errorMessage",get_errorMessage,set_errorMessage,true);
		addMember(l,"mTarget",get_mTarget,set_mTarget,true);
		createTypeMetatable(l,null, typeof(ChapterInit),typeof(UnityEngine.MonoBehaviour));
	}
}

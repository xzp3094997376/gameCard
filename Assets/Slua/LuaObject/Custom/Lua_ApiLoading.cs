using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_ApiLoading : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallManyFrameLua(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				ApiLoading self=(ApiLoading)checkSelf(l);
				SLua.LuaFunction a1;
				checkType(l,2,out a1);
				self.CallManyFrameLua(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				ApiLoading self=(ApiLoading)checkSelf(l);
				SLua.LuaFunction a1;
				checkType(l,2,out a1);
				System.Int32 a2;
				checkType(l,3,out a2);
				self.CallManyFrameLua(a1,a2);
				pushValue(l,true);
				return 1;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallManyFrame(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			System.Action a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			self.CallManyFrame(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isModelGuide(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.isModelGuide(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isModel(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.isModel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int show(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			Callback a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			self.show(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int hide(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			self.hide();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int stopEffect(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			self.stopEffect();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showTouchEffect(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			UnityEngine.Vector3 a1;
			checkType(l,2,out a1);
			self.showTouchEffect(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showLoading_s(IntPtr l) {
		try {
			System.Single a1;
			checkType(l,1,out a1);
			Callback a2;
			LuaDelegation.checkDelegate(l,2,out a2);
			ApiLoading.showLoading(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int hideLoading_s(IntPtr l) {
		try {
			ApiLoading.hideLoading();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getInstance_s(IntPtr l) {
		try {
			var ret=ApiLoading.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_install(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,ApiLoading.install);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_install(IntPtr l) {
		try {
			ApiLoading v;
			checkType(l,2,out v);
			ApiLoading.install=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_loading(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.loading);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_loading(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.loading=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_touchEffect(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.touchEffect);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_touchEffect(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.touchEffect=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mCamera(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mCamera);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mCamera(IntPtr l) {
		try {
			ApiLoading self=(ApiLoading)checkSelf(l);
			UnityEngine.Camera v;
			checkType(l,2,out v);
			self.mCamera=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"ApiLoading");
		addMember(l,CallManyFrameLua);
		addMember(l,CallManyFrame);
		addMember(l,isModelGuide);
		addMember(l,isModel);
		addMember(l,show);
		addMember(l,hide);
		addMember(l,stopEffect);
		addMember(l,showTouchEffect);
		addMember(l,showLoading_s);
		addMember(l,hideLoading_s);
		addMember(l,getInstance_s);
		addMember(l,"install",get_install,set_install,false);
		addMember(l,"loading",get_loading,set_loading,true);
		addMember(l,"touchEffect",get_touchEffect,set_touchEffect,true);
		addMember(l,"mCamera",get_mCamera,set_mCamera,true);
		createTypeMetatable(l,null, typeof(ApiLoading),typeof(UnityEngine.MonoBehaviour));
	}
}

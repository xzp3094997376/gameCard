using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UIModule : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			UIModule o;
			if(argc==1){
				o=new UIModule();
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(UluaBinding))){
				UluaBinding a1;
				checkType(l,2,out a1);
				o=new UIModule(a1);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(UnityEngine.GameObject))){
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				o=new UIModule(a1);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string))){
				System.String a1;
				checkType(l,2,out a1);
				o=new UIModule(a1);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			return error(l,"New object failed.");
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Find(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.Find(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int destroy(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			self.destroy();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetActive(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetActive(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int update(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				UIModule self=(UIModule)checkSelf(l);
				self.update();
				pushValue(l,true);
				return 1;
			}
			else if(argc==2){
				UIModule self=(UIModule)checkSelf(l);
				System.Object a1;
				checkType(l,2,out a1);
				self.update(a1);
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
	static public int onEnter(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.onEnter(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onExit(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			self.onExit();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int pushWindow(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(string))){
				UIModule self=(UIModule)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.pushWindow(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(UnityEngine.GameObject))){
				UIModule self=(UIModule)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				self.pushWindow(a1);
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
	static public int popWindow(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			self.popWindow();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int clearWindow(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			self.clearWindow();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showTopMenu(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			System.Object a1;
			checkType(l,2,out a1);
			self.showTopMenu(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int resetTopMenu(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			self.resetTopMenu();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_panelDepth(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UIModule.panelDepth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_panelDepth(IntPtr l) {
		try {
			System.Int32 v;
			checkType(l,2,out v);
			UIModule.panelDepth=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_gameObject(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.gameObject);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_gameObject(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.gameObject=v;
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
			UIModule self=(UIModule)checkSelf(l);
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
			UIModule self=(UIModule)checkSelf(l);
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
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_name(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.name);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_name(IntPtr l) {
		try {
			UIModule self=(UIModule)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.name=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UIModule");
		addMember(l,Find);
		addMember(l,destroy);
		addMember(l,SetActive);
		addMember(l,update);
		addMember(l,onEnter);
		addMember(l,onExit);
		addMember(l,pushWindow);
		addMember(l,popWindow);
		addMember(l,clearWindow);
		addMember(l,showTopMenu);
		addMember(l,resetTopMenu);
		addMember(l,"panelDepth",get_panelDepth,set_panelDepth,false);
		addMember(l,"gameObject",get_gameObject,set_gameObject,true);
		addMember(l,"binding",get_binding,set_binding,true);
		addMember(l,"name",get_name,set_name,true);
		createTypeMetatable(l,constructor, typeof(UIModule));
	}
}

using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UIMrg : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			UIMrg o;
			o=new UIMrg();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallRunnigModuleFunction(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object a2;
			checkType(l,3,out a2);
			var ret=self.CallRunnigModuleFunction(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallRunnigModuleFunctionWithArgs(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object[] a2;
			checkParams(l,3,out a2);
			var ret=self.CallRunnigModuleFunctionWithArgs(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int resume(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			self.resume();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetRunningModuleName(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			var ret=self.GetRunningModuleName();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int GetModuleCount(IntPtr l)
    {
        try
        {
            UIMrg self = (UIMrg)checkSelf(l);
            var ret = self.GetModuleCount();
            pushValue(l, true);
            pushValue(l, ret);
            return 2;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetRunningModule(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			var ret=self.GetRunningModule();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setTopMenu(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			UluaBinding a1;
			checkType(l,2,out a1);
			self.setTopMenu(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int setTopTitle(IntPtr l)
    {
        try
        {
            UIMrg self = (UIMrg)checkSelf(l);
            UluaBinding a1;
            checkType(l, 2, out a1);
            self.setTopTitle(a1);
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getTopMenu(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			var ret=self.getTopMenu();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int replaceModule(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			UIModule a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.replaceModule(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int replaceObject(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UIMrg self=(UIMrg)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				self.replaceObject(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Boolean a2;
				checkType(l,3,out a2);
				self.replaceObject(a1,a2);
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
	static public int replaceObjectWithName(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				self.replaceObjectWithName(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				System.Boolean a3;
				checkType(l,4,out a3);
				self.replaceObjectWithName(a1,a2,a3);
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
	static public int replace(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			System.Object[] a1;
			checkParams(l,2,out a1);
			var ret=self.replace(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int pushModule(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			UIModule a1;
			checkType(l,2,out a1);
			self.pushModule(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int pushObject(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			self.pushObject(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int pushObjectWithName(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			UnityEngine.GameObject a2;
			checkType(l,3,out a2);
			self.pushObjectWithName(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int pushWithPath(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.pushWithPath(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Object a2;
				checkType(l,3,out a2);
				var ret=self.pushWithPath(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
	static public int push(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				var ret=self.push(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==4){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Object a3;
				checkType(l,4,out a3);
				var ret=self.push(a1,a2,a3);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
	static public int replaceModuleToModule(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			UIModule a2;
			checkType(l,3,out a2);
			self.replaceModuleToModule(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int replaceModuleToLevel(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			UIModule a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			self.replaceModuleToLevel(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int replaceToLevel(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==4){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Int32 a3;
				checkType(l,4,out a3);
				var ret=self.replaceToLevel(a1,a2,a3);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==5){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Int32 a3;
				checkType(l,4,out a3);
				System.Object a4;
				checkType(l,5,out a4);
				var ret=self.replaceToLevel(a1,a2,a3,a4);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
	static public int replaceObjectToModule(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				self.replaceObjectToModule(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				UnityEngine.GameObject a3;
				checkType(l,4,out a3);
				self.replaceObjectToModule(a1,a2,a3);
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
	static public int popToRoot(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			self.popToRoot();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int logout(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			self.logout();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int popToModule(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.popToModule(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Object a2;
				checkType(l,3,out a2);
				var ret=self.popToModule(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
	static public int pop(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			self.pop();
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
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.pushWindow(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(UnityEngine.GameObject))){
				UIMrg self=(UIMrg)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				self.pushWindow(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Object a2;
				checkType(l,3,out a2);
				var ret=self.pushWindow(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				UIMrg self=(UIMrg)checkSelf(l);
				self.popWindow();
				pushValue(l,true);
				return 1;
			}
			else if(argc==2){
				UIMrg self=(UIMrg)checkSelf(l);
				System.Boolean a1;
				checkType(l,2,out a1);
				self.popWindow(a1);
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
	static public int popMessage(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			self.popMessage();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int pushMessage(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.pushMessage(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Object a2;
				checkType(l,3,out a2);
				var ret=self.pushMessage(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
	static public int pushNotice(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.pushNotice(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				UIMrg self=(UIMrg)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Object a2;
				checkType(l,3,out a2);
				var ret=self.pushNotice(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
	static public int get__Ins(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UIMrg._Ins);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__Ins(IntPtr l) {
		try {
			UIMrg v;
			checkType(l,2,out v);
			UIMrg._Ins=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_top(IntPtr l) {
		try {
			UIMrg self=(UIMrg)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.top);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Ins(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UIMrg.Ins);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UIMrg");
		addMember(l,CallRunnigModuleFunction);
		addMember(l,CallRunnigModuleFunctionWithArgs);
		addMember(l,resume);
		addMember(l,GetRunningModuleName);
        addMember(l,GetModuleCount);
		addMember(l,GetRunningModule);
		addMember(l,setTopMenu);
        addMember(l,setTopTitle);
		addMember(l,getTopMenu);
		addMember(l,replaceModule);
		addMember(l,replaceObject);
		addMember(l,replaceObjectWithName);
		addMember(l,replace);
		addMember(l,pushModule);
		addMember(l,pushObject);
		addMember(l,pushObjectWithName);
		addMember(l,pushWithPath);
		addMember(l,push);
		addMember(l,replaceModuleToModule);
		addMember(l,replaceModuleToLevel);
		addMember(l,replaceToLevel);
		addMember(l,replaceObjectToModule);
		addMember(l,popToRoot);
		addMember(l,logout);
		addMember(l,popToModule);
		addMember(l,pop);
		addMember(l,pushWindow);
		addMember(l,popWindow);
		addMember(l,popMessage);
		addMember(l,pushMessage);
		addMember(l,pushNotice);
		addMember(l,"_Ins",get__Ins,set__Ins,false);
		addMember(l,"top",get_top,null,true);
		addMember(l,"Ins",get_Ins,null,false);
		createTypeMetatable(l,constructor, typeof(UIMrg));
	}
}

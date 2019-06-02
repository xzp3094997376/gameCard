using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UotherPublicFuncs : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			UotherPublicFuncs o;
			o=new UotherPublicFuncs();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int instantiateGmeObject(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
				SLua.LuaTable a1;
				checkType(l,2,out a1);
				self.instantiateGmeObject(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				self.instantiateGmeObject(a1,a2);
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
	static public int instantiateGmeObjectAndCallBack(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			var ret=self.instantiateGmeObjectAndCallBack(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int itwwenGo(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			SLua.LuaFunction a3;
			checkType(l,4,out a3);
			self.itwwenGo(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int instantiateCommands(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			SLua.LuaFunction a2;
			checkType(l,3,out a2);
			self.instantiateCommands(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int openOrCloseWindow(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			SLua.LuaTable a3;
			checkType(l,4,out a3);
			SLua.LuaFunction a4;
			checkType(l,5,out a4);
			self.openOrCloseWindow(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DestroyGameOject(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			self.DestroyGameOject(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DestroyGameOjectByName(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			self.DestroyGameOjectByName(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int callBackFightFromScrip(IntPtr l)
    {
        try
        {
            UotherPublicFuncs self = (UotherPublicFuncs)checkSelf(l);
            SLua.LuaTable a1;
            checkType(l, 2, out a1);
            self.callBackFightFromScrip(a1);
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int callBackFight(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			self.callBackFight(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int fillString(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			var ret=self.fillString(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DivisionStr(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			var ret=self.DivisionStr(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_SceneName(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_SceneName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_SceneName(IntPtr l) {
		try {
			UotherPublicFuncs self=(UotherPublicFuncs)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.m_SceneName=v;
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
			pushValue(l,UotherPublicFuncs.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UotherPublicFuncs");
		addMember(l,instantiateGmeObject);
		addMember(l,instantiateGmeObjectAndCallBack);
		addMember(l,itwwenGo);
		addMember(l,instantiateCommands);
		addMember(l,openOrCloseWindow);
		addMember(l,DestroyGameOject);
		addMember(l,DestroyGameOjectByName);
        addMember(l, callBackFightFromScrip);
        addMember(l,callBackFight);
		addMember(l,fillString);
		addMember(l,DivisionStr);
		addMember(l,"m_SceneName",get_m_SceneName,set_m_SceneName,true);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,constructor, typeof(UotherPublicFuncs));
	}
}

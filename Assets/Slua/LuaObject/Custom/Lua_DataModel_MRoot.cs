using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_DataModel_MRoot : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			DataModel.MRoot o;
			System.String a1;
			checkType(l,2,out a1);
			o=new DataModel.MRoot(a1);
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int update(IntPtr l) {
		try {
			DataModel.MRoot self=(DataModel.MRoot)checkSelf(l);
			SimpleJson.JsonObject a1;
			checkType(l,2,out a1);
			self.update(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int addListener(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(string),typeof(string),typeof(SLua.LuaFunction))){
				DataModel.MRoot self=(DataModel.MRoot)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				self.addListener(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(DataModel.MStruct),typeof(string))){
				DataModel.MRoot self=(DataModel.MRoot)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				DataModel.MStruct a2;
				checkType(l,3,out a2);
				System.String a3;
				checkType(l,4,out a3);
				self.addListener(a1,a2,a3);
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
	static public int removeListener(IntPtr l) {
		try {
			DataModel.MRoot self=(DataModel.MRoot)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.removeListener(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int create_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=DataModel.MRoot.create(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"DataModel.MRoot");
		addMember(l,update);
		addMember(l,addListener);
		addMember(l,removeListener);
		addMember(l,create_s);
		createTypeMetatable(l,constructor, typeof(DataModel.MRoot),typeof(DataModel.MStruct),true);
	}
}

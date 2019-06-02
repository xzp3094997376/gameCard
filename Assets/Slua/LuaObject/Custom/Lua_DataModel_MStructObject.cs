using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_DataModel_MStructObject : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int existsKey(IntPtr l) {
		try {
			DataModel.MStructObject self=(DataModel.MStructObject)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.existsKey(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getDefaultItem(IntPtr l) {
		try {
			DataModel.MStructObject self=(DataModel.MStructObject)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getDefaultItem(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int update(IntPtr l) {
		try {
			DataModel.MStructObject self=(DataModel.MStructObject)checkSelf(l);
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
	static public int get_Keys(IntPtr l) {
		try {
			DataModel.MStructObject self=(DataModel.MStructObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Keys);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_AttributeKeys(IntPtr l) {
		try {
			DataModel.MStructObject self=(DataModel.MStructObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.AttributeKeys);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"DataModel.MStructObject");
		addMember(l,existsKey);
		addMember(l,getDefaultItem);
		addMember(l,update);
		addMember(l,"Keys",get_Keys,null,true);
		addMember(l,"AttributeKeys",get_AttributeKeys,null,true);
		createTypeMetatable(l,null, typeof(DataModel.MStructObject),typeof(DataModel.MStruct),true);
	}
}

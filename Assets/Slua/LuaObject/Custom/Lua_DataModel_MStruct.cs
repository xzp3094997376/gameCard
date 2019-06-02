using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_DataModel_MStruct : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int update(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
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
	static public int getCount(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			var ret=self.getCount();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getLuaTable(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			var ret=self.getLuaTable();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getStruct(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getStruct(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getStructObject(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getStructObject(a1);
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
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
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
	static public int getString(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getString(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getNumber(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getNumber(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getLong(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getLong(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getTimestamp(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getTimestamp(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getInt(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getInt(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getBoolean(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getBoolean(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getStringEnum(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getStringEnum(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int addListener(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
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
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int clear(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			self.clear();
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
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Keys);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getItem(IntPtr l) {
		try {
			DataModel.MStruct self=(DataModel.MStruct)checkSelf(l);
			string v;
			checkType(l,2,out v);
			var ret = self[v];
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"DataModel.MStruct");
		addMember(l,update);
		addMember(l,getCount);
		addMember(l,getLuaTable);
		addMember(l,getStruct);
		addMember(l,getStructObject);
		addMember(l,getDefaultItem);
		addMember(l,getString);
		addMember(l,getNumber);
		addMember(l,getLong);
		addMember(l,getTimestamp);
		addMember(l,getInt);
		addMember(l,getBoolean);
		addMember(l,getStringEnum);
		addMember(l,addListener);
		addMember(l,clear);
		addMember(l,getItem);
		addMember(l,"Keys",get_Keys,null,true);
		createTypeMetatable(l,null, typeof(DataModel.MStruct),null,true);
	}
}

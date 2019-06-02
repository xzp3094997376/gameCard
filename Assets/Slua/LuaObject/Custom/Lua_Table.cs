using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Table : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Table o;
			SimpleJson.JsonObject a1;
			checkType(l,2,out a1);
			o=new Table(a1);
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RowByUnique(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object a2;
			checkType(l,3,out a2);
			var ret=self.RowByUnique(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RowByID(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			System.Object a1;
			checkType(l,2,out a1);
			var ret=self.RowByID(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ValueByUnique(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Object a3;
			checkType(l,4,out a3);
			var ret=self.ValueByUnique(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RowByUniqueKey(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			System.Object[] a1;
			checkParams(l,2,out a1);
			var ret=self.RowByUniqueKey(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ForEach(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			System.Func<System.Int32,SimpleJson.JsonObject,System.Boolean> a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			self.ForEach(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int returnTableLength(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			var ret=self.returnTableLength();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_rowCount(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.rowCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_rowCount(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.rowCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_TableName(IntPtr l) {
		try {
			Table self=(Table)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.TableName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Table");
		addMember(l,RowByUnique);
		addMember(l,RowByID);
		addMember(l,ValueByUnique);
		addMember(l,RowByUniqueKey);
		addMember(l,ForEach);
		addMember(l,returnTableLength);
		addMember(l,"rowCount",get_rowCount,set_rowCount,true);
		addMember(l,"TableName",get_TableName,null,true);
		createTypeMetatable(l,constructor, typeof(Table));
	}
}

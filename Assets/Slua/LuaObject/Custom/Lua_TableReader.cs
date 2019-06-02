using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_TableReader : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Load(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String[] a1;
			checkType(l,2,out a1);
			System.String[] a2;
			checkType(l,3,out a2);
			self.Load(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetTable(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.GetTable(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int LoadTable(IntPtr l)
    {
        try
        {
            TableReader self = (TableReader)checkSelf(l);
            System.String a1;
            checkType(l, 2, out a1);
            self.LoadTable(a1);
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int TableRowByUnique(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Object a3;
			checkType(l,4,out a3);
			var ret=self.TableRowByUnique(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int TableRowByID(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object a2;
			checkType(l,3,out a2);
			var ret=self.TableRowByID(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int TableRowByUniqueKey(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object[] a2;
			checkParams(l,3,out a2);
			var ret=self.TableRowByUniqueKey(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int TableValueByUnique(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			System.Object a4;
			checkType(l,5,out a4);
			var ret=self.TableValueByUnique(a1,a2,a3,a4);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ForEachTable(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Func<System.Int32,SimpleJson.JsonObject,System.Boolean> a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			self.ForEachTable(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getTableLengthByTableName(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getTableLengthByTableName(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ForEachLuaTable(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Func<System.Int32,SimpleJson.JsonObject,System.Boolean> a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			self.ForEachLuaTable(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getTableRowCount(IntPtr l) {
		try {
			TableReader self=(TableReader)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getTableRowCount(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Destroy_s(IntPtr l) {
		try {
			TableReader.Destroy();
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
			pushValue(l,TableReader.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"TableReader");
		addMember(l,Load);
		addMember(l,GetTable);
        addMember(l, LoadTable);
        addMember(l,TableRowByUnique);
		addMember(l,TableRowByID);
		addMember(l,TableRowByUniqueKey);
		addMember(l,TableValueByUnique);
		addMember(l,ForEachTable);
		addMember(l,getTableLengthByTableName);
		addMember(l,ForEachLuaTable);
		addMember(l,getTableRowCount);
		addMember(l,Destroy_s);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,null, typeof(TableReader));
	}
}

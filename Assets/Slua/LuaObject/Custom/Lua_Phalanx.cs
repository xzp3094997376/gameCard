using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Phalanx : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Get(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			var ret=self.Get(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Reset(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			System.Int32 a3;
			checkType(l,4,out a3);
			self.Reset(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RefreshComponent(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			self.RefreshComponent();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_maxItemCount(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.maxItemCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_maxItemCount(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.maxItemCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_maxRows(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.maxRows);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_maxRows(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.maxRows=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_maxColumns(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.maxColumns);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_maxColumns(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.maxColumns=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isRowFirst(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isRowFirst);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isRowFirst(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isRowFirst=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_template(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.template);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_template(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.template=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_spacing(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.spacing);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_spacing(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			UnityEngine.Vector2 v;
			checkType(l,2,out v);
			self.spacing=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_items(IntPtr l) {
		try {
			Phalanx self=(Phalanx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.items);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Phalanx");
		addMember(l,Get);
		addMember(l,Reset);
		addMember(l,RefreshComponent);
		addMember(l,"maxItemCount",get_maxItemCount,set_maxItemCount,true);
		addMember(l,"maxRows",get_maxRows,set_maxRows,true);
		addMember(l,"maxColumns",get_maxColumns,set_maxColumns,true);
		addMember(l,"isRowFirst",get_isRowFirst,set_isRowFirst,true);
		addMember(l,"template",get_template,set_template,true);
		addMember(l,"spacing",get_spacing,set_spacing,true);
		addMember(l,"items",get_items,null,true);
		createTypeMetatable(l,null, typeof(Phalanx),typeof(UnityEngine.MonoBehaviour));
	}
}

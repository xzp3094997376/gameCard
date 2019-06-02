using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_MyTable : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			MyTable o;
			o=new MyTable();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Reposition(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			self.Reposition();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddChild(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			var ret=self.AddChild(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int rePositionParent(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			self.rePositionParent();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadList(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			SLua.LuaTable a3;
			checkType(l,4,out a3);
			var ret=self.LoadList(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int refresh(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				MyTable self=(MyTable)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				self.refresh(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				MyTable self=(MyTable)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				SLua.LuaTable a3;
				checkType(l,4,out a3);
				self.refresh(a1,a2,a3);
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
	static public int GetNumberInt_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=MyTable.GetNumberInt(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mParentTable(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mParentTable);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mParentTable(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			UITable v;
			checkType(l,2,out v);
			self.mParentTable=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_width(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.width);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_width(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.width=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_height(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.height);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_height(IntPtr l) {
		try {
			MyTable self=(MyTable)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.height=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"MyTable");
		addMember(l,Reposition);
		addMember(l,AddChild);
		addMember(l,rePositionParent);
		addMember(l,LoadList);
		addMember(l,refresh);
		addMember(l,GetNumberInt_s);
		addMember(l,"mParentTable",get_mParentTable,set_mParentTable,true);
		addMember(l,"width",get_width,set_width,true);
		addMember(l,"height",get_height,set_height,true);
		createTypeMetatable(l,constructor, typeof(MyTable),typeof(UITable));
	}
}

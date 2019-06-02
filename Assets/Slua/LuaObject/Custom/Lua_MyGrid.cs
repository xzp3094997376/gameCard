using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_MyGrid : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			MyGrid o;
			o=new MyGrid();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int rePositionParent(IntPtr l) {
		try {
			MyGrid self=(MyGrid)checkSelf(l);
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
			MyGrid self=(MyGrid)checkSelf(l);
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
				MyGrid self=(MyGrid)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				self.refresh(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				MyGrid self=(MyGrid)checkSelf(l);
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
			else if(argc==5){
				MyGrid self=(MyGrid)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				SLua.LuaTable a3;
				checkType(l,4,out a3);
				System.Int32 a4;
				checkType(l,5,out a4);
				self.refresh(a1,a2,a3,a4);
				pushValue(l,true);
				return 1;
			}
			else if(argc==6){
				MyGrid self=(MyGrid)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				SLua.LuaTable a3;
				checkType(l,4,out a3);
				System.Int32 a4;
				checkType(l,5,out a4);
				System.Boolean a5;
				checkType(l,6,out a5);
				self.refresh(a1,a2,a3,a4,a5);
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
	static public int setParentTable(IntPtr l) {
		try {
			MyGrid self=(MyGrid)checkSelf(l);
			UITable a1;
			checkType(l,2,out a1);
			self.setParentTable(a1);
			pushValue(l,true);
			return 1;
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
			var ret=MyGrid.GetNumberInt(a1);
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
			MyGrid self=(MyGrid)checkSelf(l);
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
			MyGrid self=(MyGrid)checkSelf(l);
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
	static public int get__copyObj(IntPtr l) {
		try {
			MyGrid self=(MyGrid)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self._copyObj);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__copyObj(IntPtr l) {
		try {
			MyGrid self=(MyGrid)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self._copyObj=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"MyGrid");
		addMember(l,rePositionParent);
		addMember(l,LoadList);
		addMember(l,refresh);
		addMember(l,setParentTable);
		addMember(l,GetNumberInt_s);
		addMember(l,"mParentTable",get_mParentTable,set_mParentTable,true);
		addMember(l,"_copyObj",get__copyObj,set__copyObj,true);
		createTypeMetatable(l,constructor, typeof(MyGrid),typeof(UIGrid));
	}
}

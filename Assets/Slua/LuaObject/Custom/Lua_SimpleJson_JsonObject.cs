using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_SimpleJson_JsonObject : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			SimpleJson.JsonObject o;
			if(argc==1){
				o=new SimpleJson.JsonObject();
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(argc==2){
				System.Collections.Generic.IEqualityComparer<System.String> a1;
				checkType(l,2,out a1);
				o=new SimpleJson.JsonObject(a1);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			return error(l,"New object failed.");
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int link(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.link(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int str(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.str(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int num(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.num(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Add(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
				System.Collections.Generic.KeyValuePair<System.String,System.Object> a1;
				checkValueType(l,2,out a1);
				self.Add(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Object a2;
				checkType(l,3,out a2);
				self.Add(a1,a2);
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
	static public int ContainsKey(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.ContainsKey(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Remove(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(KeyValuePair<System.String,object>))){
				SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
				System.Collections.Generic.KeyValuePair<System.String,System.Object> a1;
				checkValueType(l,2,out a1);
				var ret=self.Remove(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string))){
				SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.Remove(a1);
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
	static public int TryGetValue(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object a2;
			var ret=self.TryGetValue(a1,out a2);
			pushValue(l,true);
			pushValue(l,ret);
			pushValue(l,a2);
			return 3;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Clear(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			self.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Contains(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			System.Collections.Generic.KeyValuePair<System.String,System.Object> a1;
			checkValueType(l,2,out a1);
			var ret=self.Contains(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Keys(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Keys);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Values(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Values);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Count(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Count);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_IsReadOnly(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.IsReadOnly);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getItem(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			LuaTypes t = LuaDLL.lua_type(l, 2);
			if(matchType(l,2,t,typeof(System.Int32))){
				int v;
				checkType(l,2,out v);
				var ret = self[v];
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,2,t,typeof(System.String))){
				string v;
				checkType(l,2,out v);
				var ret = self[v];
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
	static public int setItem(IntPtr l) {
		try {
			SimpleJson.JsonObject self=(SimpleJson.JsonObject)checkSelf(l);
			string v;
			checkType(l,2,out v);
			System.Object c;
			checkType(l,3,out c);
			self[v]=c;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"SimpleJson.JsonObject");
		addMember(l,link);
		addMember(l,str);
		addMember(l,num);
		addMember(l,Add);
		addMember(l,ContainsKey);
		addMember(l,Remove);
		addMember(l,TryGetValue);
		addMember(l,Clear);
		addMember(l,Contains);
		addMember(l,getItem);
		addMember(l,setItem);
		addMember(l,SimpleJson.JsonObject.toString,true);
		addMember(l,"Keys",get_Keys,null,true);
		addMember(l,"Values",get_Values,null,true);
		addMember(l,"Count",get_Count,null,true);
		addMember(l,"IsReadOnly",get_IsReadOnly,null,true);
		createTypeMetatable(l,constructor, typeof(SimpleJson.JsonObject),null,true);
	}
}

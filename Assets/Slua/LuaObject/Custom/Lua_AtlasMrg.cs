using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_AtlasMrg : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			AtlasMrg o;
			o=new AtlasMrg();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getAtlas(IntPtr l) {
		try {
			AtlasMrg self=(AtlasMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getAtlas(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeUnusedAtlas(IntPtr l) {
		try {
			AtlasMrg self=(AtlasMrg)checkSelf(l);
			self.removeUnusedAtlas();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int addAtlas(IntPtr l) {
		try {
			AtlasMrg self=(AtlasMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.addAtlas(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int addAtlasAsync(IntPtr l) {
		try {
			AtlasMrg self=(AtlasMrg)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Action<AtlasItem> a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			var ret=self.addAtlasAsync(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getInstance_s(IntPtr l) {
		try {
			var ret=AtlasMrg.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"AtlasMrg");
		addMember(l,getAtlas);
		addMember(l,removeUnusedAtlas);
		addMember(l,addAtlas);
		addMember(l,addAtlasAsync);
		addMember(l,getInstance_s);
		createTypeMetatable(l,constructor, typeof(AtlasMrg));
	}
}

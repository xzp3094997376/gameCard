using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_ConfigManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			ConfigManager o;
			o=new ConfigManager();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int readTableFileList(IntPtr l) {
		try {
			ConfigManager self=(ConfigManager)checkSelf(l);
			self.readTableFileList();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int loadTable(IntPtr l) {
		try {
			ConfigManager self=(ConfigManager)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.loadTable(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getTableJson(IntPtr l) {
		try {
			ConfigManager self=(ConfigManager)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getTableJson(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onLoadComplete(IntPtr l) {
		try {
			ConfigManager self=(ConfigManager)checkSelf(l);
			self.onLoadComplete();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int moduleOpen_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkType(l,1,out a1);
			var ret=ConfigManager.moduleOpen(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ecodeLuaFile_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkType(l,1,out a1);
			var ret=ConfigManager.ecodeLuaFile(a1);
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
			var ret=ConfigManager.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_inited(IntPtr l) {
		try {
			ConfigManager self=(ConfigManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.inited);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_inited(IntPtr l) {
		try {
			ConfigManager self=(ConfigManager)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.inited=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"ConfigManager");
		addMember(l,readTableFileList);
		addMember(l,loadTable);
		addMember(l,getTableJson);
		addMember(l,onLoadComplete);
		addMember(l,moduleOpen_s);
		addMember(l,ecodeLuaFile_s);
		addMember(l,getInstance_s);
		addMember(l,"inited",get_inited,set_inited,true);
		createTypeMetatable(l,constructor, typeof(ConfigManager));
	}
}

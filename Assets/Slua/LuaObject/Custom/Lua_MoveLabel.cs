using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_MoveLabel : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int beginMove(IntPtr l) {
		try {
			MoveLabel self=(MoveLabel)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			self.beginMove(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int analysisUrlEncry(IntPtr l) {
		try {
			MoveLabel self=(MoveLabel)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.analysisUrlEncry(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_tvLab(IntPtr l) {
		try {
			MoveLabel self=(MoveLabel)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.tvLab);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_tvLab(IntPtr l) {
		try {
			MoveLabel self=(MoveLabel)checkSelf(l);
			UILabel v;
			checkType(l,2,out v);
			self.tvLab=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"MoveLabel");
		addMember(l,beginMove);
		addMember(l,analysisUrlEncry);
		addMember(l,"tvLab",get_tvLab,set_tvLab,true);
		createTypeMetatable(l,null, typeof(MoveLabel),typeof(UnityEngine.MonoBehaviour));
	}
}

using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_StarPrefabs : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setStar(IntPtr l) {
		try {
			StarPrefabs self=(StarPrefabs)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.setStar(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setLight(IntPtr l) {
		try {
			StarPrefabs self=(StarPrefabs)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			self.setLight(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_uCommandList(IntPtr l) {
		try {
			StarPrefabs self=(StarPrefabs)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.uCommandList);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_uCommandList(IntPtr l) {
		try {
			StarPrefabs self=(StarPrefabs)checkSelf(l);
			System.Collections.Generic.List<UISprite> v;
			checkType(l,2,out v);
			self.uCommandList=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"StarPrefabs");
		addMember(l,setStar);
		addMember(l,setLight);
		addMember(l,"uCommandList",get_uCommandList,set_uCommandList,true);
		createTypeMetatable(l,null, typeof(StarPrefabs),typeof(UnityEngine.MonoBehaviour));
	}
}

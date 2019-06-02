using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_LZDragComponent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DragPanel(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			UnityEngine.Vector2 a2;
			checkType(l,3,out a2);
			self.DragPanel(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PressCollider(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.PressCollider(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DragFinished(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			self.DragFinished();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onDispose(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			self.onDispose();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_scrollview(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.scrollview);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_scrollview(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			LZScrollView v;
			checkType(l,2,out v);
			self.scrollview=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_dragCollider(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.dragCollider);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_dragCollider(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.dragCollider=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_movePanel(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.movePanel);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_movePanel(IntPtr l) {
		try {
			LZDragComponent self=(LZDragComponent)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.movePanel=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"LZDragComponent");
		addMember(l,DragPanel);
		addMember(l,PressCollider);
		addMember(l,DragFinished);
		addMember(l,onDispose);
		addMember(l,"scrollview",get_scrollview,set_scrollview,true);
		addMember(l,"dragCollider",get_dragCollider,set_dragCollider,true);
		addMember(l,"movePanel",get_movePanel,set_movePanel,true);
		createTypeMetatable(l,null, typeof(LZDragComponent),typeof(UnityEngine.MonoBehaviour));
	}
}

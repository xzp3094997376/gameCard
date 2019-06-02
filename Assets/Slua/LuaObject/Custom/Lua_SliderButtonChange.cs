using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_SliderButtonChange : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_slider(IntPtr l) {
		try {
			SliderButtonChange self=(SliderButtonChange)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.slider);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_slider(IntPtr l) {
		try {
			SliderButtonChange self=(SliderButtonChange)checkSelf(l);
			UISlider v;
			checkType(l,2,out v);
			self.slider=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ButtonOne(IntPtr l) {
		try {
			SliderButtonChange self=(SliderButtonChange)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.ButtonOne);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_ButtonOne(IntPtr l) {
		try {
			SliderButtonChange self=(SliderButtonChange)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.ButtonOne=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ButtonTwo(IntPtr l) {
		try {
			SliderButtonChange self=(SliderButtonChange)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.ButtonTwo);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_ButtonTwo(IntPtr l) {
		try {
			SliderButtonChange self=(SliderButtonChange)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.ButtonTwo=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_value(IntPtr l) {
		try {
			SliderButtonChange self=(SliderButtonChange)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.value=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"SliderButtonChange");
		addMember(l,"slider",get_slider,set_slider,true);
		addMember(l,"ButtonOne",get_ButtonOne,set_ButtonOne,true);
		addMember(l,"ButtonTwo",get_ButtonTwo,set_ButtonTwo,true);
		addMember(l,"value",null,set_value,true);
		createTypeMetatable(l,null, typeof(SliderButtonChange),typeof(UnityEngine.MonoBehaviour));
	}
}

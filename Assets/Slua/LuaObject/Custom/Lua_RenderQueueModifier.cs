using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_RenderQueueModifier : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_runOnece(IntPtr l) {
		try {
			RenderQueueModifier self=(RenderQueueModifier)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.runOnece);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_runOnece(IntPtr l) {
		try {
			RenderQueueModifier self=(RenderQueueModifier)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.runOnece=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_target(IntPtr l) {
		try {
			RenderQueueModifier self=(RenderQueueModifier)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_target);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_target(IntPtr l) {
		try {
			RenderQueueModifier self=(RenderQueueModifier)checkSelf(l);
			UIWidget v;
			checkType(l,2,out v);
			self.m_target=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_type(IntPtr l) {
		try {
			RenderQueueModifier self=(RenderQueueModifier)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.m_type);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_type(IntPtr l) {
		try {
			RenderQueueModifier self=(RenderQueueModifier)checkSelf(l);
			RenderQueueModifier.RenderType v;
			checkEnum(l,2,out v);
			self.m_type=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"RenderQueueModifier");
		addMember(l,"runOnece",get_runOnece,set_runOnece,true);
		addMember(l,"m_target",get_m_target,set_m_target,true);
		addMember(l,"m_type",get_m_type,set_m_type,true);
		createTypeMetatable(l,null, typeof(RenderQueueModifier),typeof(UnityEngine.MonoBehaviour));
	}
}

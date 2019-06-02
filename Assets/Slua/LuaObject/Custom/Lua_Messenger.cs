using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Messenger : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int MarkAsPermanent_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Messenger.MarkAsPermanent(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Cleanup_s(IntPtr l) {
		try {
			Messenger.Cleanup();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PrintEventTable_s(IntPtr l) {
		try {
			Messenger.PrintEventTable();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnListenerAdding_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Delegate a2;
			checkType(l,2,out a2);
			Messenger.OnListenerAdding(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnListenerRemoving_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Delegate a2;
			checkType(l,2,out a2);
			Messenger.OnListenerRemoving(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnListenerRemoved_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Messenger.OnListenerRemoved(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnBroadcasting_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Messenger.OnBroadcasting(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreateBroadcastSignatureException_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Messenger.CreateBroadcastSignatureException(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddListener_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Callback a2;
			LuaDelegation.checkDelegate(l,2,out a2);
			Messenger.AddListener(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddListenerObject_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Callback<System.Object> a2;
			LuaDelegation.checkDelegate(l,2,out a2);
			Messenger.AddListenerObject(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveListener_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Callback a2;
			LuaDelegation.checkDelegate(l,2,out a2);
			Messenger.RemoveListener(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveListenerObject_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Messenger.RemoveListenerObject(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Broadcast_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Messenger.Broadcast(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int BroadcastObject_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Object a2;
			checkType(l,2,out a2);
			Messenger.BroadcastObject(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_eventTable(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Messenger.eventTable);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_eventTable(IntPtr l) {
		try {
			System.Collections.Generic.Dictionary<System.String,System.Delegate> v;
			checkType(l,2,out v);
			Messenger.eventTable=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_permanentMessages(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Messenger.permanentMessages);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_permanentMessages(IntPtr l) {
		try {
			System.Collections.Generic.List<System.String> v;
			checkType(l,2,out v);
			Messenger.permanentMessages=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Messenger");
		addMember(l,MarkAsPermanent_s);
		addMember(l,Cleanup_s);
		addMember(l,PrintEventTable_s);
		addMember(l,OnListenerAdding_s);
		addMember(l,OnListenerRemoving_s);
		addMember(l,OnListenerRemoved_s);
		addMember(l,OnBroadcasting_s);
		addMember(l,CreateBroadcastSignatureException_s);
		addMember(l,AddListener_s);
		addMember(l,AddListenerObject_s);
		addMember(l,RemoveListener_s);
		addMember(l,RemoveListenerObject_s);
		addMember(l,Broadcast_s);
		addMember(l,BroadcastObject_s);
		addMember(l,"eventTable",get_eventTable,set_eventTable,false);
		addMember(l,"permanentMessages",get_permanentMessages,set_permanentMessages,false);
		createTypeMetatable(l,null, typeof(Messenger));
	}
}

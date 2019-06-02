using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Network : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int initAuthServerWithLua(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			self.initAuthServerWithLua(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int initAuthServer(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.Action a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			self.initAuthServer(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int jsonWithKV(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.Object[] a1;
			checkParams(l,2,out a1);
			var ret=self.jsonWithKV(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int buildCallback(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.Object a1;
			checkType(l,2,out a1);
			System.Action<SimpleJson.JsonObject,System.Object> a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			System.Func<System.Int32,SimpleJson.JsonObject,System.Object,System.Boolean> a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			var ret=self.buildCallback(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int serverToClientTime(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.Int64 a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			var ret=self.serverToClientTime(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onUpdateServerTime(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Int64 a2;
			checkType(l,3,out a2);
			System.Double a3;
			checkType(l,4,out a3);
			self.onUpdateServerTime(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int updateServer(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Int32 a3;
			checkType(l,4,out a3);
			System.Boolean a4;
			checkType(l,5,out a4);
			self.updateServer(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int registerMsg(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Action<System.String,SimpleJson.JsonObject> a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			self.registerMsg(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int registerMsgByLua(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			SLua.LuaFunction a3;
			checkType(l,4,out a3);
			self.registerMsgByLua(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int disconnectAll(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			self.disconnectAll();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int sendRequest(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			SimpleJson.JsonObject a4;
			checkType(l,5,out a4);
			System.Action<SimpleJson.JsonObject> a5;
			LuaDelegation.checkDelegate(l,6,out a5);
			self.sendRequest(a1,a2,a3,a4,a5);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int sendRequestWithLua(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==7){
				Network self=(Network)checkSelf(l);
				System.Boolean a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.String a3;
				checkType(l,4,out a3);
				SLua.LuaTable a4;
				checkType(l,5,out a4);
				SLua.LuaFunction a5;
				checkType(l,6,out a5);
				SLua.LuaFunction a6;
				checkType(l,7,out a6);
				self.sendRequestWithLua(a1,a2,a3,a4,a5,a6);
				pushValue(l,true);
				return 1;
			}
			else if(argc==8){
				Network self=(Network)checkSelf(l);
				System.Boolean a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.String a3;
				checkType(l,4,out a3);
				SLua.LuaTable a4;
				checkType(l,5,out a4);
				SLua.LuaFunction a5;
				checkType(l,6,out a5);
				SLua.LuaFunction a6;
				checkType(l,7,out a6);
				SLua.LuaTable a7;
				checkType(l,8,out a7);
				self.sendRequestWithLua(a1,a2,a3,a4,a5,a6,a7);
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
	static public int createDataModel(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.createDataModel(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Destroy_s(IntPtr l) {
		try {
			Network.Destroy();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_SERVER_IP(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Network.SERVER_IP);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_SERVER_IP(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			Network.SERVER_IP=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_SERVER_PORT(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Network.SERVER_PORT);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_SERVER_PORT(IntPtr l) {
		try {
			System.Int32 v;
			checkType(l,2,out v);
			Network.SERVER_PORT=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onNetworkSlow(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			Network.networkSlowEventHandler v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onNetworkSlow=v;
			else if(op==1) self.onNetworkSlow+=v;
			else if(op==2) self.onNetworkSlow-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onNetworkFast(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			Network.networkFastEventHandler v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onNetworkFast=v;
			else if(op==1) self.onNetworkFast+=v;
			else if(op==2) self.onNetworkFast-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onNetworkReconnet(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			Network.networkReconnetEventHandler v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onNetworkReconnet=v;
			else if(op==1) self.onNetworkReconnet+=v;
			else if(op==2) self.onNetworkReconnet-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onNetworkSuccess(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			Network.networkSuccessEventHandler v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onNetworkSuccess=v;
			else if(op==1) self.onNetworkSuccess+=v;
			else if(op==2) self.onNetworkSuccess-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onNetworkError(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			Network.networkErrorEventHandler v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onNetworkError=v;
			else if(op==1) self.onNetworkError+=v;
			else if(op==2) self.onNetworkError-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onCallbackForDataEye(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.Action<System.String,SimpleJson.JsonObject> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onCallbackForDataEye=v;
			else if(op==1) self.onCallbackForDataEye+=v;
			else if(op==2) self.onCallbackForDataEye-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onNetworkConnected(IntPtr l) {
		try {
			Network self=(Network)checkSelf(l);
			System.Action<System.String> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onNetworkConnected=v;
			else if(op==1) self.onNetworkConnected+=v;
			else if(op==2) self.onNetworkConnected-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Network.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Network");
		addMember(l,initAuthServerWithLua);
		addMember(l,initAuthServer);
		addMember(l,jsonWithKV);
		addMember(l,buildCallback);
		addMember(l,serverToClientTime);
		addMember(l,onUpdateServerTime);
		addMember(l,updateServer);
		addMember(l,registerMsg);
		addMember(l,registerMsgByLua);
		addMember(l,disconnectAll);
		addMember(l,sendRequest);
		addMember(l,sendRequestWithLua);
		addMember(l,createDataModel);
		addMember(l,Destroy_s);
		addMember(l,"SERVER_IP",get_SERVER_IP,set_SERVER_IP,false);
		addMember(l,"SERVER_PORT",get_SERVER_PORT,set_SERVER_PORT,false);
		addMember(l,"onNetworkSlow",null,set_onNetworkSlow,true);
		addMember(l,"onNetworkFast",null,set_onNetworkFast,true);
		addMember(l,"onNetworkReconnet",null,set_onNetworkReconnet,true);
		addMember(l,"onNetworkSuccess",null,set_onNetworkSuccess,true);
		addMember(l,"onNetworkError",null,set_onNetworkError,true);
		addMember(l,"onCallbackForDataEye",null,set_onCallbackForDataEye,true);
		addMember(l,"onNetworkConnected",null,set_onNetworkConnected,true);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,null, typeof(Network));
	}
}

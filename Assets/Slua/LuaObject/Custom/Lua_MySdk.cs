using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_MySdk : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int initSDK(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			self.initSDK(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Login(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.Login(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int userCenter(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.userCenter(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setLoginDelegate(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			self.setLoginDelegate(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setLogoutDelegate(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			self.setLogoutDelegate(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setPayDelegate(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			SLua.LuaFunction a2;
			checkType(l,3,out a2);
			self.setPayDelegate(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setExitCallback(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			SLua.LuaFunction a2;
			checkType(l,3,out a2);
			self.setExitCallback(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onInitFinished(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			self.onInitFinished();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int pay(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			System.String a4;
			checkType(l,5,out a4);
			System.String a5;
			checkType(l,6,out a5);
			System.String a6;
			checkType(l,7,out a6);
			System.String a7;
			checkType(l,8,out a7);
			System.String a8;
			checkType(l,9,out a8);
			System.String a9;
			checkType(l,10,out a9);
			System.String a10;
			checkType(l,11,out a10);
			System.String a11;
			checkType(l,12,out a11);
            System.String a12;
            checkType(l, 13, out a12);
            System.String a13;
            checkType(l, 14, out a13);
			System.String a14;
			checkType(l, 15, out a14);
			self.pay(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int joinQQGroup(IntPtr l)
    {
        try
        {
            MySdk self = (MySdk)checkSelf(l);
            System.String a1;
            checkType(l, 2, out a1);
            self.joinQQGroup(a1);
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Logout(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.Logout(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getDataExtend(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.getDataExtend(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setEvent(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.setEvent(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getDeviceID(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			self.getDeviceID();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getDeviceIDFV(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			self.getDeviceIDFV();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int exit(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			self.exit();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setExtData(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			System.Int32 a4;
			checkType(l,5,out a4);
			System.Int32 a5;
			checkType(l,6,out a5);
			System.String a6;
			checkType(l,7,out a6);
			System.Int32 a7;
			checkType(l,8,out a7);
			System.Int32 a8;
			checkType(l,9,out a8);
			System.String a9;
			checkType(l,10,out a9);
			self.setExtData(a1,a2,a3,a4,a5,a6,a7,a8,a9);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int releaseResource(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			self.releaseResource();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onLogout(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.onLogout(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int checkLogin(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			System.String a4;
			checkType(l,5,out a4);
			System.String a5;
			checkType(l,6,out a5);
			System.String a6;
			checkType(l,7,out a6);
			System.String a7;
			checkType(l,8,out a7);
            System.String a8;
            checkType(l, 9, out a8);
			System.String a9;
			checkType(l,10,out a9);
			System.String a10;
			checkType(l, 11, out a10);
			System.String a11;
			checkType(l, 12, out a11);
			self.checkLogin(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showAndroidToast(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.showAndroidToast(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onLoginSuccess(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			System.String a4;
			checkType(l,5,out a4);
			System.String a5;
			checkType(l,6,out a5);
			System.String a6;
			checkType(l,7,out a6);
			System.String a7;
			checkType(l,8,out a7);
			System.String a8;
			checkType(l,9,out a8);
			self.onLoginSuccess(a1,a2,a3,a4,a5,a6,a7,a8);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onLoginFailed(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.onLoginFailed(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onExit_SDK(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.onExit_SDK(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onExit(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.onExit(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int chargeonSuccess(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.chargeonSuccess(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int chargeonFail(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.chargeonFail(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int payonSuccess(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.payonSuccess(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int payonFail(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.payonFail(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int FinishDeal(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.FinishDeal(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get__instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,MySdk._instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__instance(IntPtr l) {
		try {
			MySdk v;
			checkType(l,2,out v);
			MySdk._instance=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Idfa(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,MySdk.Idfa);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Idfa(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			MySdk.Idfa=v;
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
			pushValue(l,MySdk.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int sendSdkEvent(IntPtr l) {
		try {
			MySdk self=(MySdk)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			self.sendSdkEvent(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	static public void reg(IntPtr l) {
		getTypeTable(l,"MySdk");
		addMember(l,initSDK);
		addMember(l,Login);
		addMember(l,userCenter);
		addMember(l,setLoginDelegate);
		addMember(l,setLogoutDelegate);
		addMember(l,setPayDelegate);
		addMember(l,setExitCallback);
		addMember(l,onInitFinished);
		addMember(l,pay);
        addMember(l, joinQQGroup);        
        addMember(l,Logout);
		addMember(l,setEvent);
		addMember(l,getDataExtend);
		addMember(l,getDeviceID);
		addMember(l,getDeviceIDFV);
		addMember(l,exit);
		addMember(l,setExtData);
		addMember(l,releaseResource);
		addMember(l,onLogout);
		addMember(l,checkLogin);
		addMember(l,showAndroidToast);
		addMember(l,onLoginSuccess);
		addMember(l,onLoginFailed);
		addMember(l,onExit_SDK);
		addMember(l,onExit);
		addMember(l,chargeonSuccess);
		addMember(l,chargeonFail);
		addMember(l,payonSuccess);
		addMember(l,payonFail);
		addMember(l,FinishDeal);
		addMember(l,sendSdkEvent);
		addMember(l,"_instance",get__instance,set__instance,false);
		addMember(l,"Idfa",get_Idfa,set_Idfa,false);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,null, typeof(MySdk),typeof(UnityEngine.MonoBehaviour));
	}
}

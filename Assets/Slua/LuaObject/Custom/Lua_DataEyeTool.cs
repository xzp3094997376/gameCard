using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_DataEyeTool : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnStart_s(IntPtr l) {
		try {
			DataEyeTool.OnStart();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Init_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			DataEyeTool.Init(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int FBEvent_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			DataEyeTool.FBEvent(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AFEvent_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			DataEyeTool.AFEvent(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnPause_s(IntPtr l) {
		try {
			System.Boolean a1;
			checkType(l,1,out a1);
			DataEyeTool.OnPause(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Login_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			DataEyeTool.Login(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Logout_s(IntPtr l) {
		try {
			DataEyeTool.Logout();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetAccountType_s(IntPtr l) {
		try {
			DCAccountType a1;
			checkEnum(l,1,out a1);
			DataEyeTool.SetAccountType(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetLevel_s(IntPtr l) {
		try {
			System.Int32 a1;
			checkType(l,1,out a1);
			DataEyeTool.SetLevel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetGameServer_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			DataEyeTool.SetGameServer(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetGender_s(IntPtr l) {
		try {
			DCGender a1;
			checkEnum(l,1,out a1);
			DataEyeTool.SetGender(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetAge_s(IntPtr l) {
		try {
			System.Int32 a1;
			checkType(l,1,out a1);
			DataEyeTool.SetAge(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onEvent_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			SLua.LuaTable a2;
			checkType(l,2,out a2);
			DataEyeTool.onEvent(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Quit_s(IntPtr l) {
		try {
			DataEyeTool.Quit();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DcLevelsBegin_s(IntPtr l) {
		try {
			System.Int32 a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			DataEyeTool.DcLevelsBegin(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DcLevelsComplete_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			DataEyeTool.DcLevelsComplete(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DcLevelsFail_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			DataEyeTool.DcLevelsFail(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DcItemBuy_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Int32 a3;
			checkType(l,3,out a3);
			System.Int64 a4;
			checkType(l,4,out a4);
			System.String a5;
			checkType(l,5,out a5);
			System.String a6;
			checkType(l,6,out a6);
			DataEyeTool.DcItemBuy(a1,a2,a3,a4,a5,a6);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DcItemConsume_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Int32 a3;
			checkType(l,3,out a3);
			System.String a4;
			checkType(l,4,out a4);
			DataEyeTool.DcItemConsume(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DcItemGet_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Int32 a3;
			checkType(l,3,out a3);
			System.String a4;
			checkType(l,4,out a4);
			DataEyeTool.DcItemGet(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DCCoinSetCoinNum_s(IntPtr l) {
		try {
			System.Int64 a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			DataEyeTool.DCCoinSetCoinNum(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DCCoinGain_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Int64 a3;
			checkType(l,3,out a3);
			System.Int64 a4;
			checkType(l,4,out a4);
			DataEyeTool.DCCoinGain(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DCCoinLost_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Int64 a3;
			checkType(l,3,out a3);
			System.Int64 a4;
			checkType(l,4,out a4);
			DataEyeTool.DCCoinLost(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int paymentSuccess_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Double a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			System.String a4;
			checkType(l,4,out a4);
			DataEyeTool.paymentSuccess(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_IsOpenDataEye(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,DataEyeTool.IsOpenDataEye);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_IsOpenDataEye(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			DataEyeTool.IsOpenDataEye=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_APP_ID(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,DataEyeTool.APP_ID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_APP_ID(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			DataEyeTool.APP_ID=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Testin_ID(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,DataEyeTool.Testin_ID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Testin_ID(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			DataEyeTool.Testin_ID=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_CHANNEL_ID(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,DataEyeTool.CHANNEL_ID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_CHANNEL_ID(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			DataEyeTool.CHANNEL_ID=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"DataEyeTool");
		addMember(l,OnStart_s);
		addMember(l,Init_s);
		addMember(l,FBEvent_s);
		addMember(l,AFEvent_s);
		addMember(l,OnPause_s);
		addMember(l,Login_s);
		addMember(l,Logout_s);
		addMember(l,SetAccountType_s);
		addMember(l,SetLevel_s);
		addMember(l,SetGameServer_s);
		addMember(l,SetGender_s);
		addMember(l,SetAge_s);
		addMember(l,onEvent_s);
		addMember(l,Quit_s);
		addMember(l,DcLevelsBegin_s);
		addMember(l,DcLevelsComplete_s);
		addMember(l,DcLevelsFail_s);
		addMember(l,DcItemBuy_s);
		addMember(l,DcItemConsume_s);
		addMember(l,DcItemGet_s);
		addMember(l,DCCoinSetCoinNum_s);
		addMember(l,DCCoinGain_s);
		addMember(l,DCCoinLost_s);
		addMember(l,paymentSuccess_s);
		addMember(l,"IsOpenDataEye",get_IsOpenDataEye,set_IsOpenDataEye,false);
		addMember(l,"APP_ID",get_APP_ID,set_APP_ID,false);
		addMember(l,"Testin_ID",get_Testin_ID,set_Testin_ID,false);
		addMember(l,"CHANNEL_ID",get_CHANNEL_ID,set_CHANNEL_ID,false);
		createTypeMetatable(l,null, typeof(DataEyeTool));
	}
}

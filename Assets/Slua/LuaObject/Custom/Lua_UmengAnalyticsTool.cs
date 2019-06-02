using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
//using Umeng;
public class Lua_UmengAnalyticsTool : LuaObject {

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnStart_s(IntPtr l) {
		try {
			UmengAnalyticsTool.OnStart();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Pay_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			UmengAnalyticsTool.Pay(a1, a2, a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PayButItem_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			System.String a4;
			checkType(l,4,out a4);
			System.String a5;
			checkType(l,5,out a5);
			UmengAnalyticsTool.PayButItem(a1, a2, a3, a4, a5);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Buy_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			UmengAnalyticsTool.Buy(a1, a2, a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Use_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			UmengAnalyticsTool.Use(a1, a2, a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StartLevel_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.StartLevel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int FinishLevel_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.FinishLevel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int FailLevel_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.FailLevel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ProfileSignIn_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.ProfileSignIn(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ProfileSignInPro_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			UmengAnalyticsTool.ProfileSignInPro(a1, a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ProfileSignOff_s(IntPtr l) {
		try {
			UmengAnalyticsTool.ProfileSignOff();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetUserLevel_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.SetUserLevel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int BonusCoin_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			UmengAnalyticsTool.BonusCoin(a1, a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int BonusItem_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			System.String a4;
			checkType(l,4,out a4);
			UmengAnalyticsTool.BonusItem(a1, a2, a3, a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Event_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			UmengAnalyticsTool.Event(a1, a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EventBegin_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.EventBegin(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EventEnd_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.EventEnd(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PageBegin_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.PageBegin(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PageEnd_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UmengAnalyticsTool.PageEnd(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetDeviveInfo_s(IntPtr l) {
		try {
			UmengAnalyticsTool.GetDeviveInfo();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	static public void reg(IntPtr l) {
		getTypeTable(l,"UmengAnalyticsTool");
		addMember(l,OnStart_s);
		addMember(l,Pay_s);
		addMember(l,PayButItem_s);
		addMember(l,Buy_s);
		addMember(l,Use_s);
		addMember(l,StartLevel_s);
		addMember(l,FinishLevel_s);
		addMember(l,FailLevel_s);
		addMember(l,ProfileSignIn_s);
		addMember(l,ProfileSignInPro_s);
		addMember(l,ProfileSignOff_s);
		addMember(l,SetUserLevel_s);
		addMember(l,BonusCoin_s);
		addMember(l,BonusItem_s);
		addMember(l,Event_s);
		addMember(l,EventBegin_s);
		addMember(l,EventEnd_s);
		addMember(l,PageBegin_s);
		addMember(l,PageEnd_s);
		addMember(l,GetDeviveInfo_s);
		createTypeMetatable(l,null, typeof(UmengAnalyticsTool));
	}
}

using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_RunUI : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetRound(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.SetRound(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnClickBTN(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			self.OnClickBTN();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnClickSpeed(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			self.OnClickSpeed();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UpdateBattleCount(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			self.UpdateBattleCount(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ModifyClickBtnLater(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.ModifyClickBtnLater(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallModifyClickBtn(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			self.CallModifyClickBtn();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ModifyClickBtn(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.ModifyClickBtn(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_TxtRound(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_TxtRound);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_TxtRound(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			UILabel v;
			checkType(l,2,out v);
			self.m_TxtRound=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_LifeBar(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_LifeBar);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_LifeBar(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			LifeBarCtrl v;
			checkType(l,2,out v);
			self.m_LifeBar=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_TextCount(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_TextCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_TextCount(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			UILabel v;
			checkType(l,2,out v);
			self.m_TextCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_TextTotal(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_TextTotal);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_TextTotal(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			UILabel v;
			checkType(l,2,out v);
			self.m_TextTotal=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_BtnSprite(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_BtnSprite);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_BtnSprite(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			UIButton v;
			checkType(l,2,out v);
			self.m_BtnSprite=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_Tips(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_Tips);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_Tips(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			UILabel v;
			checkType(l,2,out v);
			self.m_Tips=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_AniAlpha(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_AniAlpha);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_AniAlpha(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			TweenAlpha v;
			checkType(l,2,out v);
			self.m_AniAlpha=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_SpeedLevel(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_SpeedLevel);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_SpeedLevel(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.m_SpeedLevel=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_Speeds(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_Speeds);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_Speeds(IntPtr l) {
		try {
			RunUI self=(RunUI)checkSelf(l);
			System.Single[] v;
			checkType(l,2,out v);
			self.m_Speeds=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Ins(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,RunUI.Ins);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Ins(IntPtr l) {
		try {
			RunUI v;
			checkType(l,2,out v);
			RunUI.Ins=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"RunUI");
		addMember(l,SetRound);
		addMember(l,OnClickBTN);
		addMember(l,OnClickSpeed);
		addMember(l,UpdateBattleCount);
		addMember(l,ModifyClickBtnLater);
		addMember(l,CallModifyClickBtn);
		addMember(l,ModifyClickBtn);
		addMember(l,"m_TxtRound",get_m_TxtRound,set_m_TxtRound,true);
		addMember(l,"m_LifeBar",get_m_LifeBar,set_m_LifeBar,true);
		addMember(l,"m_TextCount",get_m_TextCount,set_m_TextCount,true);
		addMember(l,"m_TextTotal",get_m_TextTotal,set_m_TextTotal,true);
		addMember(l,"m_BtnSprite",get_m_BtnSprite,set_m_BtnSprite,true);
		addMember(l,"m_Tips",get_m_Tips,set_m_Tips,true);
		addMember(l,"m_AniAlpha",get_m_AniAlpha,set_m_AniAlpha,true);
		addMember(l,"m_SpeedLevel",get_m_SpeedLevel,set_m_SpeedLevel,true);
		addMember(l,"m_Speeds",get_m_Speeds,set_m_Speeds,true);
		addMember(l,"Ins",get_Ins,set_Ins,false);
		createTypeMetatable(l,null, typeof(RunUI),typeof(UnityEngine.MonoBehaviour));
	}
}

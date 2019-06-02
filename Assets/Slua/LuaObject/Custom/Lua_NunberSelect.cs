using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_NunberSelect : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int maxNumValue(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.maxNumValue(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setCallFun(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			self.setCallFun(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onAddMax(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			self.onAddMax();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onAddOne(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			self.onAddOne();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onAddTen(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			self.onAddTen();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onSubMax(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			self.onSubMax();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onSubOne(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			self.onSubOne();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onSubTen(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			self.onSubTen();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_addBtn(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.addBtn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_addBtn(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			UIButton v;
			checkType(l,2,out v);
			self.addBtn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_subBtn(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.subBtn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_subBtn(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			UIButton v;
			checkType(l,2,out v);
			self.subBtn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_add_ten(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.add_ten);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_add_ten(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			UIButton v;
			checkType(l,2,out v);
			self.add_ten=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_sub_ten(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.sub_ten);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_sub_ten(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			UIButton v;
			checkType(l,2,out v);
			self.sub_ten=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_txtNumLab(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.txtNumLab);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_txtNumLab(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			UILabel v;
			checkType(l,2,out v);
			self.txtNumLab=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_callBackFun(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.callBackFun);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_callBackFun(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.callBackFun=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mTarget(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mTarget);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mTarget(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			SLua.LuaTable v;
			checkType(l,2,out v);
			self.mTarget=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_selectNum(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.selectNum);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_selectNum(IntPtr l) {
		try {
			NunberSelect self=(NunberSelect)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.selectNum=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"NunberSelect");
		addMember(l,maxNumValue);
		addMember(l,setCallFun);
		addMember(l,onAddMax);
		addMember(l,onAddOne);
		addMember(l,onAddTen);
		addMember(l,onSubMax);
		addMember(l,onSubOne);
		addMember(l,onSubTen);
		addMember(l,"addBtn",get_addBtn,set_addBtn,true);
		addMember(l,"subBtn",get_subBtn,set_subBtn,true);
		addMember(l,"add_ten",get_add_ten,set_add_ten,true);
		addMember(l,"sub_ten",get_sub_ten,set_sub_ten,true);
		addMember(l,"txtNumLab",get_txtNumLab,set_txtNumLab,true);
		addMember(l,"callBackFun",get_callBackFun,set_callBackFun,true);
		addMember(l,"mTarget",get_mTarget,set_mTarget,true);
		addMember(l,"selectNum",get_selectNum,set_selectNum,true);
		createTypeMetatable(l,null, typeof(NunberSelect),typeof(UnityEngine.MonoBehaviour));
	}
}

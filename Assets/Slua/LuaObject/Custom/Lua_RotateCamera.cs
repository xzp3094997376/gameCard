using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_RotateCamera : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Show(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			self.Show();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Hide(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			self.Hide();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int MoveTo(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			System.Action a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			self.MoveTo(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onCompleteFinish(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			self.onCompleteFinish();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RotateOne(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				RotateCamera self=(RotateCamera)checkSelf(l);
				SLua.LuaFunction a1;
				checkType(l,2,out a1);
				self.RotateOne(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				RotateCamera self=(RotateCamera)checkSelf(l);
				SLua.LuaFunction a1;
				checkType(l,2,out a1);
				System.Int32 a2;
				checkType(l,3,out a2);
				self.RotateOne(a1,a2);
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
	static public int TouchBegin(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			var ret=self.TouchBegin();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int MoveToBuild_s(IntPtr l) {
		try {
			BuildCtrlTarget a1;
			checkType(l,1,out a1);
			System.Action a2;
			LuaDelegation.checkDelegate(l,2,out a2);
			RotateCamera.MoveToBuild(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mTran(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mTran);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mTran(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.mTran=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_dec(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.dec);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_dec(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.dec=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_speed(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.speed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_speed(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.speed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_slipRate(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.slipRate);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_slipRate(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.slipRate=v;
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
			pushValue(l,RotateCamera.Ins);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Ins(IntPtr l) {
		try {
			RotateCamera v;
			checkType(l,2,out v);
			RotateCamera.Ins=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_touchPostion(IntPtr l) {
		try {
			RotateCamera self=(RotateCamera)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.touchPostion);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_canMove(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,RotateCamera.canMove);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_canMove(IntPtr l) {
		try {
			bool v;
			checkType(l,2,out v);
			RotateCamera.canMove=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"RotateCamera");
		addMember(l,Show);
		addMember(l,Hide);
		addMember(l,MoveTo);
		addMember(l,onCompleteFinish);
		addMember(l,RotateOne);
		addMember(l,TouchBegin);
		addMember(l,MoveToBuild_s);
		addMember(l,"mTran",get_mTran,set_mTran,true);
		addMember(l,"dec",get_dec,set_dec,true);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"slipRate",get_slipRate,set_slipRate,true);
		addMember(l,"Ins",get_Ins,set_Ins,false);
		addMember(l,"touchPostion",get_touchPostion,null,true);
		addMember(l,"canMove",get_canMove,set_canMove,false);
		createTypeMetatable(l,null, typeof(RotateCamera),typeof(UnityEngine.MonoBehaviour));
	}
}

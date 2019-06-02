using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_DragPageComponent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetCurrPage(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			var ret=self.GetCurrPage();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetCurrPage(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.SetCurrPage(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetInit(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			System.Int32 a3;
			checkType(l,4,out a3);
			self.SetInit(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DragPanel(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			UnityEngine.Vector2 a2;
			checkType(l,3,out a2);
			self.DragPanel(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PressCollider(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.PressCollider(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int MoveToLeft(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			self.MoveToLeft();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int MoveToRight(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			self.MoveToRight();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int BackToIdentity(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			self.BackToIdentity();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int MoveFinished(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			self.MoveFinished();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int onDispose(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			self.onDispose();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_dragCollider(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.dragCollider);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_dragCollider(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.dragCollider=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_arrayItem(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.arrayItem);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_arrayItem(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			UnityEngine.GameObject[] v;
			checkType(l,2,out v);
			self.arrayItem=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_movePanel(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.movePanel);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_movePanel(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.movePanel=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_moveCount(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.moveCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_moveCount(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.moveCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_moveSpeed(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.moveSpeed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_moveSpeed(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.moveSpeed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_distance(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.distance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_distance(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.distance=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_deltaCount(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,DragPageComponent.deltaCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_deltaCount(IntPtr l) {
		try {
			System.Single v;
			checkType(l,2,out v);
			DragPageComponent.deltaCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isPress(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,DragPageComponent.isPress);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isPress(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			DragPageComponent.isPress=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isPlaying(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,DragPageComponent.isPlaying);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isPlaying(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			DragPageComponent.isPlaying=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_initTransInfo(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			DragPageComponent.InitTransInfo v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.initTransInfo=v;
			else if(op==1) self.initTransInfo+=v;
			else if(op==2) self.initTransInfo-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_changeTransInfo(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			DragPageComponent.ChangeTransInfo v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.changeTransInfo=v;
			else if(op==1) self.changeTransInfo+=v;
			else if(op==2) self.changeTransInfo-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_errorCallback(IntPtr l) {
		try {
			DragPageComponent self=(DragPageComponent)checkSelf(l);
			DragPageComponent.ErrorCallBack v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.errorCallback=v;
			else if(op==1) self.errorCallback+=v;
			else if(op==2) self.errorCallback-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"DragPageComponent");
		addMember(l,GetCurrPage);
		addMember(l,SetCurrPage);
		addMember(l,SetInit);
		addMember(l,DragPanel);
		addMember(l,PressCollider);
		addMember(l,MoveToLeft);
		addMember(l,MoveToRight);
		addMember(l,BackToIdentity);
		addMember(l,MoveFinished);
		addMember(l,onDispose);
		addMember(l,"dragCollider",get_dragCollider,set_dragCollider,true);
		addMember(l,"arrayItem",get_arrayItem,set_arrayItem,true);
		addMember(l,"movePanel",get_movePanel,set_movePanel,true);
		addMember(l,"moveCount",get_moveCount,set_moveCount,true);
		addMember(l,"moveSpeed",get_moveSpeed,set_moveSpeed,true);
		addMember(l,"distance",get_distance,set_distance,true);
		addMember(l,"deltaCount",get_deltaCount,set_deltaCount,false);
		addMember(l,"isPress",get_isPress,set_isPress,false);
		addMember(l,"isPlaying",get_isPlaying,set_isPlaying,false);
		addMember(l,"initTransInfo",null,set_initTransInfo,true);
		addMember(l,"changeTransInfo",null,set_changeTransInfo,true);
		addMember(l,"errorCallback",null,set_errorCallback,true);
		createTypeMetatable(l,null, typeof(DragPageComponent),typeof(UnityEngine.MonoBehaviour));
	}
}

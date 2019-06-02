using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_PageView : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetCurrPage(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
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
	static public int SetCallBack(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			self.SetCallBack(a1);
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
			PageView self=(PageView)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			self.SetInit(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int move(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.move(a1);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
			self.MoveToRight();
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
			PageView self=(PageView)checkSelf(l);
			self.MoveFinished();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DisableDrag(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.DisableDrag(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getCurPage(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			var ret=self.getCurPage();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getCurPageObject(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			var ret=self.getCurPageObject();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getCenter(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			var ret=self.getCenter();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_pageItemPrefab(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pageItemPrefab);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_pageItemPrefab(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.pageItemPrefab=v;
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
	static public int get_pageItemParent(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pageItemParent);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_pageItemParent(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.pageItemParent=v;
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
			PageView self=(PageView)checkSelf(l);
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
	static public int set_initTransInfo(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			PageView.InitTransInfo v;
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
			PageView self=(PageView)checkSelf(l);
			PageView.ChangeTransInfo v;
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
	static public int get_callBack(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.callBack);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_callBack(IntPtr l) {
		try {
			PageView self=(PageView)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.callBack=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"PageView");
		addMember(l,GetCurrPage);
		addMember(l,SetCallBack);
		addMember(l,SetInit);
		addMember(l,move);
		addMember(l,DragPanel);
		addMember(l,PressCollider);
		addMember(l,MoveToLeft);
		addMember(l,MoveToRight);
		addMember(l,MoveFinished);
		addMember(l,DisableDrag);
		addMember(l,getCurPage);
		addMember(l,getCurPageObject);
		addMember(l,getCenter);
		addMember(l,"pageItemPrefab",get_pageItemPrefab,set_pageItemPrefab,true);
		addMember(l,"dragCollider",get_dragCollider,set_dragCollider,true);
		addMember(l,"arrayItem",get_arrayItem,set_arrayItem,true);
		addMember(l,"movePanel",get_movePanel,set_movePanel,true);
		addMember(l,"pageItemParent",get_pageItemParent,set_pageItemParent,true);
		addMember(l,"moveCount",get_moveCount,set_moveCount,true);
		addMember(l,"moveSpeed",get_moveSpeed,set_moveSpeed,true);
		addMember(l,"distance",get_distance,set_distance,true);
		addMember(l,"initTransInfo",null,set_initTransInfo,true);
		addMember(l,"changeTransInfo",null,set_changeTransInfo,true);
		addMember(l,"callBack",get_callBack,set_callBack,true);
		createTypeMetatable(l,null, typeof(PageView),typeof(UnityEngine.MonoBehaviour));
	}
}

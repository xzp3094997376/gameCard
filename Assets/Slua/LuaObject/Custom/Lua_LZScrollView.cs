using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_LZScrollView : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int refresh(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			SLua.LuaTable a2;
			checkType(l,3,out a2);
			self.refresh(a1,a2);
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
			LZScrollView self=(LZScrollView)checkSelf(l);
			self.MoveFinished();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int plusItem(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			self.plusItem();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int minuItem(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			self.minuItem();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int assignPage(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.assignPage(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetStandardPosition(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			UnityEngine.Transform a1;
			checkType(l,2,out a1);
			var ret=self.GetStandardPosition(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int adjustingLocation(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			self.adjustingLocation();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_standardTrans(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.standardTrans);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_standardTrans(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.standardTrans=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_itemCell(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.itemCell);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_itemCell(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.itemCell=v;
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
			LZScrollView self=(LZScrollView)checkSelf(l);
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
			LZScrollView self=(LZScrollView)checkSelf(l);
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
	static public int get_lineCount(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.lineCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_lineCount(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.lineCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_itemWidthandheight(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.itemWidthandheight);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_itemWidthandheight(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			UnityEngine.Vector2 v;
			checkType(l,2,out v);
			self.itemWidthandheight=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_movement(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.movement);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_movement(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			LZMovement v;
			checkEnum(l,2,out v);
			self.movement=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_itemDic(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.itemDic);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_itemDic(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			System.Collections.Generic.Dictionary<System.Int32,UnityEngine.GameObject> v;
			checkType(l,2,out v);
			self.itemDic=v;
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
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isPlaying);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isPlaying(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			bool v;
			checkType(l,2,out v);
			self.isPlaying=v;
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
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isPress);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isPress(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			bool v;
			checkType(l,2,out v);
			self.isPress=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_targetPos(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.targetPos);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_targetPos(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.targetPos=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isOverRange(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isOverRange);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isOverRange(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			bool v;
			checkType(l,2,out v);
			self.isOverRange=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_getMinVernier(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.getMinVernier);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_getMaxVernier(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.getMaxVernier);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_getTopStandardValue(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.getTopStandardValue);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_getBottleStandardValue(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.getBottleStandardValue);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_getSourceData(IntPtr l) {
		try {
			LZScrollView self=(LZScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.getSourceData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"LZScrollView");
		addMember(l,refresh);
		addMember(l,MoveFinished);
		addMember(l,plusItem);
		addMember(l,minuItem);
		addMember(l,assignPage);
		addMember(l,GetStandardPosition);
		addMember(l,adjustingLocation);
		addMember(l,"standardTrans",get_standardTrans,set_standardTrans,true);
		addMember(l,"itemCell",get_itemCell,set_itemCell,true);
		addMember(l,"movePanel",get_movePanel,set_movePanel,true);
		addMember(l,"lineCount",get_lineCount,set_lineCount,true);
		addMember(l,"itemWidthandheight",get_itemWidthandheight,set_itemWidthandheight,true);
		addMember(l,"movement",get_movement,set_movement,true);
		addMember(l,"itemDic",get_itemDic,set_itemDic,true);
		addMember(l,"isPlaying",get_isPlaying,set_isPlaying,true);
		addMember(l,"isPress",get_isPress,set_isPress,true);
		addMember(l,"targetPos",get_targetPos,set_targetPos,true);
		addMember(l,"isOverRange",get_isOverRange,set_isOverRange,true);
		addMember(l,"getMinVernier",get_getMinVernier,null,true);
		addMember(l,"getMaxVernier",get_getMaxVernier,null,true);
		addMember(l,"getTopStandardValue",get_getTopStandardValue,null,true);
		addMember(l,"getBottleStandardValue",get_getBottleStandardValue,null,true);
		addMember(l,"getSourceData",get_getSourceData,null,true);
		createTypeMetatable(l,null, typeof(LZScrollView),typeof(UnityEngine.MonoBehaviour));
	}
}

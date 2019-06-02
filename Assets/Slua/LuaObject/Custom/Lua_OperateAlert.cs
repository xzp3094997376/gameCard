using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_OperateAlert : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			OperateAlert o;
			o=new OperateAlert();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int show(IntPtr l) {
		try {
			OperateAlert self=(OperateAlert)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.show(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int showMsgToGameObject(IntPtr l)
    {
        try
        {
            OperateAlert self = (OperateAlert)checkSelf(l);
            System.String a1;
            checkType(l, 2, out a1);
            UnityEngine.GameObject a2;
            checkType(l, 3, out a2);
            self.showMsgToGameObject(a1,a2);
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showToGameObject(IntPtr l) {
		try {
			OperateAlert self=(OperateAlert)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			UnityEngine.GameObject a2;
			checkType(l,3,out a2);
			self.showToGameObject(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int showToGameObjectQuick(IntPtr l)
    {
        try
        {
            OperateAlert self = (OperateAlert)checkSelf(l);
            System.String a1;
            checkType(l, 2, out a1);
            UnityEngine.GameObject a2;
            checkType(l, 3, out a2);
            self.showToGameObjectQuick(a1, a2);
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showList(IntPtr l) {
		try {
			OperateAlert self=(OperateAlert)checkSelf(l);
			System.Collections.Generic.List<System.Object> a1;
			checkType(l,2,out a1);
			UnityEngine.GameObject a2;
			checkType(l,3,out a2);
			self.showList(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showGetGoods(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				OperateAlert self=(OperateAlert)checkSelf(l);
				SLua.LuaTable a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				self.showGetGoods(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				OperateAlert self=(OperateAlert)checkSelf(l);
				SLua.LuaTable a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				System.Int32 a3;
				checkType(l,4,out a3);
				self.showGetGoods(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==5){
				OperateAlert self=(OperateAlert)checkSelf(l);
				SLua.LuaTable a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				System.Int32 a3;
				checkType(l,4,out a3);
				SLua.LuaFunction a4;
				checkType(l,5,out a4);
				self.showGetGoods(a1,a2,a3,a4);
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
	static public int showGetGoodsWithBox(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				OperateAlert self=(OperateAlert)checkSelf(l);
				System.Collections.Generic.List<System.Object> a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				self.showGetGoodsWithBox(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				OperateAlert self=(OperateAlert)checkSelf(l);
				System.Collections.Generic.List<System.Object> a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				self.showGetGoodsWithBox(a1,a2,a3);
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
	static public int get_getInstance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,OperateAlert.getInstance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"OperateAlert");
        addMember(l, show);
        addMember(l, showMsgToGameObject);
        addMember(l, showToGameObject);
        addMember(l, showToGameObjectQuick);
		addMember(l,showList);
		addMember(l,showGetGoods);
		addMember(l,showGetGoodsWithBox);
		addMember(l,"getInstance",get_getInstance,null,false);
		createTypeMetatable(l,constructor, typeof(OperateAlert));
	}
}

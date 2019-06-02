using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UI3DModel : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			UI3DModel o;
			o=new UI3DModel();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int canDrag(IntPtr l) {
		try {
			UI3DModel self=(UI3DModel)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.canDrag(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showBottom(IntPtr l) {
		try {
			UI3DModel self=(UI3DModel)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			self.showBottom(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadByModelId(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==4){
				UI3DModel self=(UI3DModel)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				self.LoadByModelId(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==5){
				UI3DModel self=(UI3DModel)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				System.Boolean a4;
				checkType(l,5,out a4);
				self.LoadByModelId(a1,a2,a3,a4);
				pushValue(l,true);
				return 1;
			}
			else if(argc==6){
				UI3DModel self=(UI3DModel)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				System.Boolean a4;
				checkType(l,5,out a4);
				System.Int32 a5;
				checkType(l,6,out a5);
				self.LoadByModelId(a1,a2,a3,a4,a5);
				pushValue(l,true);
				return 1;
			}
			else if(argc==7){
				UI3DModel self=(UI3DModel)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				System.Boolean a4;
				checkType(l,5,out a4);
				System.Int32 a5;
				checkType(l,6,out a5);
				System.Single a6;
				checkType(l,7,out a6);
				self.LoadByModelId(a1,a2,a3,a4,a5,a6);
				pushValue(l,true);
				return 1;
			}
            else if (argc == 8)
            {
                UI3DModel self = (UI3DModel)checkSelf(l);
                System.Int32 a1;
                checkType(l, 2, out a1);
                System.String a2;
                checkType(l, 3, out a2);
                SLua.LuaFunction a3;
                checkType(l, 4, out a3);
                System.Boolean a4;
                checkType(l, 5, out a4);
                System.Int32 a5;
                checkType(l, 6, out a5);
                System.Single a6;
                checkType(l, 7, out a6);
                System.Single a7;
                checkType(l, 8, out a7);
                self.LoadByModelId(a1, a2, a3, a4, a5, a6, a7);
                pushValue(l, true);
                return 1;
            }
            else if (argc == 9)
            {
                UI3DModel self = (UI3DModel)checkSelf(l);
                System.Int32 a1;
                checkType(l, 2, out a1);
                System.String a2;
                checkType(l, 3, out a2);
                SLua.LuaFunction a3;
                checkType(l, 4, out a3);
                System.Boolean a4;
                checkType(l, 5, out a4);
                System.Int32 a5;
                checkType(l, 6, out a5);
                System.Single a6;
                checkType(l, 7, out a6);
                System.Single a7;
                checkType(l, 8, out a7);
                System.Int32 a8;
                checkType(l, 9, out a8);
                self.LoadByModelId(a1, a2, a3, a4, a5, a6, a7, a8);
                pushValue(l, true);
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
	static public int LoadByCharId(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==4){
				UI3DModel self=(UI3DModel)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				self.LoadByCharId(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==5){
				UI3DModel self=(UI3DModel)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				System.Boolean a4;
				checkType(l,5,out a4);
				self.LoadByCharId(a1,a2,a3,a4);
				pushValue(l,true);
				return 1;
			}
			else if(argc==6){
				UI3DModel self=(UI3DModel)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				System.Boolean a4;
				checkType(l,5,out a4);
				System.Int32 a5;
				checkType(l,6,out a5);
				self.LoadByCharId(a1,a2,a3,a4,a5);
				pushValue(l,true);
				return 1;
			}
			else if(argc==7){
				UI3DModel self=(UI3DModel)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				SLua.LuaFunction a3;
				checkType(l,4,out a3);
				System.Boolean a4;
				checkType(l,5,out a4);
				System.Int32 a5;
				checkType(l,6,out a5);
				System.Single a6;
				checkType(l,7,out a6);
				self.LoadByCharId(a1,a2,a3,a4,a5,a6);
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
	static public int get_layer_index(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UI3DModel.layer_index);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_layer_index(IntPtr l) {
		try {
			System.Int32 v;
			checkType(l,2,out v);
			UI3DModel.layer_index=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_sunshine(IntPtr l) {
		try {
			UI3DModel self=(UI3DModel)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.sunshine);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_sunshine(IntPtr l) {
		try {
			UI3DModel self=(UI3DModel)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.sunshine=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Target(IntPtr l) {
		try {
			UI3DModel self=(UI3DModel)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Target);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isEnabled(IntPtr l) {
		try {
			UI3DModel self=(UI3DModel)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isEnabled);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isEnabled(IntPtr l) {
		try {
			UI3DModel self=(UI3DModel)checkSelf(l);
			bool v;
			checkType(l,2,out v);
			self.isEnabled=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UI3DModel");
		addMember(l,canDrag);
		addMember(l,showBottom);
		addMember(l,LoadByModelId);
		addMember(l,LoadByCharId);
		addMember(l,"layer_index",get_layer_index,set_layer_index,false);
		addMember(l,"sunshine",get_sunshine,set_sunshine,true);
		addMember(l,"Target",get_Target,null,true);
		addMember(l,"isEnabled",get_isEnabled,set_isEnabled,true);
		createTypeMetatable(l,constructor, typeof(UI3DModel),typeof(UIWidget));
	}
}

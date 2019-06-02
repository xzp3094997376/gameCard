using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UI3DModelII : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
            UI3DModelII o;
			o=new UI3DModelII();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
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
				UI3DModelII self=(UI3DModelII)checkSelf(l);
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
				UI3DModelII self=(UI3DModelII)checkSelf(l);
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
				UI3DModelII self=(UI3DModelII)checkSelf(l);
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
				UI3DModelII self=(UI3DModelII)checkSelf(l);
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
                UI3DModelII self = (UI3DModelII)checkSelf(l);
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
                UI3DModelII self = (UI3DModelII)checkSelf(l);
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
	static public void reg(IntPtr l) {
		getTypeTable(l,"UI3DModelII");
		addMember(l,LoadByModelId);
		createTypeMetatable(l,constructor, typeof(UI3DModelII),typeof(MonoBehaviour));
	}
}

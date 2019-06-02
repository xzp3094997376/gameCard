using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_ScrollView : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ResetPosition(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			self.ResetPosition();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int clearItems(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			self.clearItems();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static public int updateLocal(IntPtr l)
    {
        try
        {
            ScrollView self = (ScrollView)checkSelf(l);
            self.updateLocal();
            pushValue(l, true);
            return 1;
        }
        catch (Exception e)
        {
            return error(l, e);
        }
    }

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Remove(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.Remove(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Add(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Object a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			var ret=self.Add(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int goToIndex(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.goToIndex(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int updateScrollView(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				ScrollView self=(ScrollView)checkSelf(l);
				System.Collections.IList a1;
				checkType(l,2,out a1);
				self.updateScrollView(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				ScrollView self=(ScrollView)checkSelf(l);
				System.Collections.IList a1;
				checkType(l,2,out a1);
				System.Boolean a2;
				checkType(l,3,out a2);
				System.Boolean a3;
				checkType(l,4,out a3);
				self.updateScrollView(a1,a2,a3);
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
	static public int refresh(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				ScrollView self=(ScrollView)checkSelf(l);
				SLua.LuaTable a1;
				checkType(l,2,out a1);
				self.refresh(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				ScrollView self=(ScrollView)checkSelf(l);
				SLua.LuaTable a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				self.refresh(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				ScrollView self=(ScrollView)checkSelf(l);
				SLua.LuaTable a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				System.Boolean a3;
				checkType(l,4,out a3);
				self.refresh(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==5){
				ScrollView self=(ScrollView)checkSelf(l);
				SLua.LuaTable a1;
				checkType(l,2,out a1);
				SLua.LuaTable a2;
				checkType(l,3,out a2);
				System.Boolean a3;
				checkType(l,4,out a3);
				System.Int32 a4;
				checkType(l,5,out a4);
				self.refresh(a1,a2,a3,a4);
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
	static public int get_mScrollView(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mScrollView);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mScrollView(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			UIScrollView v;
			checkType(l,2,out v);
			self.mScrollView=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Content(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Content);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Content(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.Content=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_luaBinding(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.luaBinding);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_luaBinding(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			UluaBinding v;
			checkType(l,2,out v);
			self.luaBinding=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_resetContent(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.resetContent);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_resetContent(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.resetContent=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isCenterChild(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isCenterChild);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isCenterChild(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isCenterChild=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isCenterOnClick(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isCenterOnClick);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isCenterOnClick(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isCenterOnClick=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_spacing(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.spacing);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_spacing(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.spacing=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_itemCount(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.itemCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_itemCount(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.itemCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_viewItem(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.viewItem);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_viewItem(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.viewItem=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_DataSource(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.DataSource);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_DataSource(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			System.Collections.IList v;
			checkType(l,2,out v);
			self.DataSource=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ItemCount(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.ItemCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_ItemCount(IntPtr l) {
		try {
			ScrollView self=(ScrollView)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.ItemCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"ScrollView");
		addMember(l,ResetPosition);
        addMember(l, clearItems);
        addMember(l, updateLocal);
		addMember(l,Remove);
		addMember(l,Add);
		addMember(l,goToIndex);
		addMember(l,updateScrollView);
		addMember(l,refresh);
		addMember(l,"mScrollView",get_mScrollView,set_mScrollView,true);
		addMember(l,"Content",get_Content,set_Content,true);
		addMember(l,"luaBinding",get_luaBinding,set_luaBinding,true);
		addMember(l,"resetContent",get_resetContent,set_resetContent,true);
		addMember(l,"isCenterChild",get_isCenterChild,set_isCenterChild,true);
		addMember(l,"isCenterOnClick",get_isCenterOnClick,set_isCenterOnClick,true);
		addMember(l,"spacing",get_spacing,set_spacing,true);
		addMember(l,"itemCount",get_itemCount,set_itemCount,true);
		addMember(l,"viewItem",get_viewItem,set_viewItem,true);
		addMember(l,"DataSource",get_DataSource,set_DataSource,true);
		addMember(l,"ItemCount",get_ItemCount,set_ItemCount,true);
		createTypeMetatable(l,null, typeof(ScrollView),typeof(UnityEngine.MonoBehaviour));
	}
}

using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_GuideManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int posToView(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			UnityEngine.Transform a1;
			checkType(l,2,out a1);
			var ret=self.posToView(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showHand(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			UnityEngine.Transform a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.showHand(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int showNpc(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				GuideManager self=(GuideManager)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				self.showNpc(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				GuideManager self=(GuideManager)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				self.showNpc(a1,a2);
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
	static public int hideHand(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			self.hideHand();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ShowPlot(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			System.Object[] a1;
			checkParams(l,2,out a1);
			self.ShowPlot(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PlayDialog(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			System.Object[] a1;
			checkParams(l,2,out a1);
			self.PlayDialog(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ShowTalk(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			System.String a4;
			checkType(l,5,out a4);
			System.String a5;
			checkType(l,6,out a5);
			System.Boolean a6;
			checkType(l,7,out a6);
            System.String a7;
            checkType(l, 8, out a7);
            self.ShowTalk(a1,a2,a3,a4,a5,a6,a7);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int HidePlot(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			self.HidePlot();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PlayThePlot(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			self.PlayThePlot();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int End(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			self.End();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int stop(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			self.stop();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int hide(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			self.hide();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getInstance_s(IntPtr l) {
		try {
			var ret=GuideManager.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isModel_s(IntPtr l) {
		try {
			System.Boolean a1;
			checkType(l,1,out a1);
			GuideManager.isModel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mCamera(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mCamera);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mCamera(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			UICamera v;
			checkType(l,2,out v);
			self.mCamera=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mParent(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mParent);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mParent(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.mParent=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mHand(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mHand);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mHand(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.mHand=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_txtDesc(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.txtDesc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_txtDesc(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			UILabel v;
			checkType(l,2,out v);
			self.txtDesc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mNpc(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mNpc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mNpc(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.mNpc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_model(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.model);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_model(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.model=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_show_bg(IntPtr l) {
		try {
			GuideManager self=(GuideManager)checkSelf(l);
			bool v;
			checkType(l,2,out v);
			self.show_bg=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"GuideManager");
		addMember(l,posToView);
		addMember(l,showHand);
		addMember(l,showNpc);
		addMember(l,hideHand);
		addMember(l,ShowPlot);
		addMember(l,PlayDialog);
		addMember(l,ShowTalk);
		addMember(l,HidePlot);
		addMember(l,PlayThePlot);
		addMember(l,End);
		addMember(l,stop);
		addMember(l,hide);
		addMember(l,getInstance_s);
		addMember(l,isModel_s);
		addMember(l,"mCamera",get_mCamera,set_mCamera,true);
		addMember(l,"mParent",get_mParent,set_mParent,true);
		addMember(l,"mHand",get_mHand,set_mHand,true);
		addMember(l,"txtDesc",get_txtDesc,set_txtDesc,true);
		addMember(l,"mNpc",get_mNpc,set_mNpc,true);
		addMember(l,"model",get_model,set_model,true);
		addMember(l,"show_bg",null,set_show_bg,true);
		createTypeMetatable(l,null, typeof(GuideManager),typeof(UnityEngine.MonoBehaviour));
	}
}

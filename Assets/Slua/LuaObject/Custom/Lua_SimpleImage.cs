using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_SimpleImage : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isShowGray(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.isShowGray(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isShowSpecialGray(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.isShowSpecialGray(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int changeColor(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			self.changeColor(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setSize(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			self.setSize(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Unload(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			self.Unload();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mTexture(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mTexture);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mTexture(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			UITexture v;
			checkType(l,2,out v);
			self.mTexture=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_imageType(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.imageType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_imageType(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.imageType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_autoLoadImage(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.autoLoadImage);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_autoLoadImage(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.autoLoadImage=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mDepth(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mDepth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mDepth(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.mDepth=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mWidth(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mWidth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mWidth(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.mWidth=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mheight(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mheight);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mheight(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.mheight=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_scale(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.scale);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_scale(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.scale=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isGray(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isGray);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isGray(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isGray=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Url(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Url);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Url(IntPtr l) {
		try {
			SimpleImage self=(SimpleImage)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.Url=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"SimpleImage");
		addMember(l,isShowGray);
		addMember(l,isShowSpecialGray);
		addMember(l,changeColor);
		addMember(l,setSize);
		addMember(l,Unload);
		addMember(l,"mTexture",get_mTexture,set_mTexture,true);
		addMember(l,"imageType",get_imageType,set_imageType,true);
		addMember(l,"autoLoadImage",get_autoLoadImage,set_autoLoadImage,true);
		addMember(l,"mDepth",get_mDepth,set_mDepth,true);
		addMember(l,"mWidth",get_mWidth,set_mWidth,true);
		addMember(l,"mheight",get_mheight,set_mheight,true);
		addMember(l,"scale",get_scale,set_scale,true);
		addMember(l,"isGray",get_isGray,set_isGray,true);
		addMember(l,"Url",get_Url,set_Url,true);
		createTypeMetatable(l,null, typeof(SimpleImage),typeof(UnityEngine.MonoBehaviour));
	}
}

using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_CustomSprite : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isShowGray(IntPtr l) {
		try {
			CustomSprite self=(CustomSprite)checkSelf(l);
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
	static public int setImage(IntPtr l) {
		try {
			CustomSprite self=(CustomSprite)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			self.setImage(a1,a2);
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
			CustomSprite self=(CustomSprite)checkSelf(l);
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
			CustomSprite self=(CustomSprite)checkSelf(l);
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
	static public int get_mDepth(IntPtr l) {
		try {
			CustomSprite self=(CustomSprite)checkSelf(l);
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
			CustomSprite self=(CustomSprite)checkSelf(l);
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
			CustomSprite self=(CustomSprite)checkSelf(l);
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
			CustomSprite self=(CustomSprite)checkSelf(l);
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
			CustomSprite self=(CustomSprite)checkSelf(l);
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
			CustomSprite self=(CustomSprite)checkSelf(l);
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
	static public int get_isGray(IntPtr l) {
		try {
			CustomSprite self=(CustomSprite)checkSelf(l);
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
			CustomSprite self=(CustomSprite)checkSelf(l);
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
	static public int get_atlasName(IntPtr l) {
		try {
			CustomSprite self=(CustomSprite)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.atlasName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_atlasName(IntPtr l) {
		try {
			CustomSprite self=(CustomSprite)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.atlasName=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"CustomSprite");
		addMember(l,isShowGray);
		addMember(l,setImage);
		addMember(l,"mTexture",get_mTexture,set_mTexture,true);
		addMember(l,"mDepth",get_mDepth,set_mDepth,true);
		addMember(l,"mWidth",get_mWidth,set_mWidth,true);
		addMember(l,"mheight",get_mheight,set_mheight,true);
		addMember(l,"isGray",get_isGray,set_isGray,true);
		addMember(l,"atlasName",get_atlasName,set_atlasName,true);
		createTypeMetatable(l,null, typeof(CustomSprite),typeof(UnityEngine.MonoBehaviour));
	}
}

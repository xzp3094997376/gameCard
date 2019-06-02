using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_TextureCache : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			TextureCache o;
			o=new TextureCache();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int addImage(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				TextureCache self=(TextureCache)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.addImage(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				TextureCache self=(TextureCache)checkSelf(l);
				UnityEngine.Texture2D a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				var ret=self.addImage(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
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
	static public int addImageAsync(IntPtr l) {
		try {
			TextureCache self=(TextureCache)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			TextureCache.DelegateLoadImageCallBack a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			self.addImageAsync(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeAllTextures(IntPtr l) {
		try {
			TextureCache self=(TextureCache)checkSelf(l);
			self.removeAllTextures();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeUnusedTextures(IntPtr l) {
		try {
			TextureCache self=(TextureCache)checkSelf(l);
			self.removeUnusedTextures();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeTexture(IntPtr l) {
		try {
			TextureCache self=(TextureCache)checkSelf(l);
			UnityEngine.Texture2D a1;
			checkType(l,2,out a1);
			self.removeTexture(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeTextureForKey(IntPtr l) {
		try {
			TextureCache self=(TextureCache)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.removeTextureForKey(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getCachedTextureInfo(IntPtr l) {
		try {
			TextureCache self=(TextureCache)checkSelf(l);
			var ret=self.getCachedTextureInfo();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getInstance_s(IntPtr l) {
		try {
			var ret=TextureCache.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"TextureCache");
		addMember(l,addImage);
		addMember(l,addImageAsync);
		addMember(l,removeAllTextures);
		addMember(l,removeUnusedTextures);
		addMember(l,removeTexture);
		addMember(l,removeTextureForKey);
		addMember(l,getCachedTextureInfo);
		addMember(l,getInstance_s);
		createTypeMetatable(l,constructor, typeof(TextureCache));
	}
}

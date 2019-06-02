using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UISpriteII : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			UISpriteII o;
			o=new UISpriteII();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetAtlasSprite(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			var ret=self.GetAtlasSprite();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int MakePixelPerfect(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			self.MakePixelPerfect();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnFill(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			BetterList<UnityEngine.Vector3> a1;
			checkType(l,2,out a1);
			BetterList<UnityEngine.Vector2> a2;
			checkType(l,3,out a2);
			BetterList<UnityEngine.Color32> a3;
			checkType(l,4,out a3);
			self.OnFill(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_MyShader(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_MyShader);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_MyShader(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			UnityEngine.Shader v;
			checkType(l,2,out v);
			self.m_MyShader=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_IsAdd(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_IsAdd);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_IsAdd(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.m_IsAdd=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_material(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.material);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_MyShader(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.MyShader);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_MyShader(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			UnityEngine.Shader v;
			checkType(l,2,out v);
			self.MyShader=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_atlas(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.atlas);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_atlas(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			UIAtlas v;
			checkType(l,2,out v);
			self.atlas=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_spriteName(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.spriteName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_spriteName(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.spriteName=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isValid(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isValid);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_border(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.border);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_pixelSize(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pixelSize);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_minWidth(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.minWidth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_minHeight(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.minHeight);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_drawingDimensions(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.drawingDimensions);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_premultipliedAlpha(IntPtr l) {
		try {
			UISpriteII self=(UISpriteII)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.premultipliedAlpha);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UISpriteII");
		addMember(l,GetAtlasSprite);
		addMember(l,MakePixelPerfect);
		addMember(l,OnFill);
		addMember(l,"m_MyShader",get_m_MyShader,set_m_MyShader,true);
		addMember(l,"m_IsAdd",get_m_IsAdd,set_m_IsAdd,true);
		addMember(l,"material",get_material,null,true);
		addMember(l,"MyShader",get_MyShader,set_MyShader,true);
		addMember(l,"atlas",get_atlas,set_atlas,true);
		addMember(l,"spriteName",get_spriteName,set_spriteName,true);
		addMember(l,"isValid",get_isValid,null,true);
		addMember(l,"border",get_border,null,true);
		addMember(l,"pixelSize",get_pixelSize,null,true);
		addMember(l,"minWidth",get_minWidth,null,true);
		addMember(l,"minHeight",get_minHeight,null,true);
		addMember(l,"drawingDimensions",get_drawingDimensions,null,true);
		addMember(l,"premultipliedAlpha",get_premultipliedAlpha,null,true);
		createTypeMetatable(l,constructor, typeof(UISpriteII),typeof(UIBasicSprite));
	}
}

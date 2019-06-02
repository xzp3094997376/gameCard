using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_CustomLabel2 : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			CustomLabel2 o;
			o=new CustomLabel2();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UpdateMyNGUIText(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			self.UpdateMyNGUIText();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ApplyOffset(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			BetterList<UnityEngine.Transform> a1;
			checkType(l,2,out a1);
			self.ApplyOffset(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ParserSymbol(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.ParserSymbol(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SingleLineWrapText(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			System.String a3;
			System.Single a4;
			checkType(l,5,out a4);
			System.Int32 a5;
			System.Int32 a6;
			var ret=self.SingleLineWrapText(a1,out a2,out a3,a4,out a5,out a6);
			pushValue(l,true);
			pushValue(l,ret);
			pushValue(l,a2);
			pushValue(l,a3);
			pushValue(l,a5);
			pushValue(l,a6);
			return 6;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetGlyphWidth(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			UIFont a3;
			checkType(l,4,out a3);
			UnityEngine.Font a4;
			checkType(l,5,out a4);
			System.Int32 a5;
			checkType(l,6,out a5);
			UnityEngine.FontStyle a6;
			checkEnum(l,7,out a6);
			System.Single a7;
			checkType(l,8,out a7);
			System.Single a8;
			checkType(l,9,out a8);
			var ret=self.GetGlyphWidth(a1,a2,a3,a4,a5,a6,a7,a8);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_block(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.block);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_block(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			UIWidget v;
			checkType(l,2,out v);
			self.block=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_alignment(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.alignment);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_alignment(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			NGUIText.Alignment v;
			checkEnum(l,2,out v);
			self.alignment=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_minWidth(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.minWidth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_minWidth(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.minWidth=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_region(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.region);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_region(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			UISprite v;
			checkType(l,2,out v);
			self.region=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_heightAdjust(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.heightAdjust);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_heightAdjust(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.heightAdjust=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_lineSpace(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.lineSpace);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_lineSpace(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.lineSpace=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_paddingLeft(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.paddingLeft);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_paddingLeft(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.paddingLeft=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_paddingTop(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.paddingTop);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_paddingTop(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.paddingTop=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_paddingRight(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.paddingRight);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_paddingRight(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.paddingRight=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_paddingBottom(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.paddingBottom);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_paddingBottom(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.paddingBottom=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onArchor(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			System.Action v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onArchor=v;
			else if(op==1) self.onArchor+=v;
			else if(op==2) self.onArchor-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_symbolFont(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.symbolFont);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_symbolFont(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			UIFont v;
			checkType(l,2,out v);
			self.symbolFont=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_labelPrefab(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.labelPrefab);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_labelPrefab(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.labelPrefab=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_facePrefab(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.facePrefab);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_facePrefab(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.facePrefab=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_text(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.text);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_text(IntPtr l) {
		try {
			CustomLabel2 self=(CustomLabel2)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.text=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"CustomLabel2");
		addMember(l,UpdateMyNGUIText);
		addMember(l,ApplyOffset);
		addMember(l,ParserSymbol);
		addMember(l,SingleLineWrapText);
		addMember(l,GetGlyphWidth);
		addMember(l,"block",get_block,set_block,true);
		addMember(l,"alignment",get_alignment,set_alignment,true);
		addMember(l,"minWidth",get_minWidth,set_minWidth,true);
		addMember(l,"region",get_region,set_region,true);
		addMember(l,"heightAdjust",get_heightAdjust,set_heightAdjust,true);
		addMember(l,"lineSpace",get_lineSpace,set_lineSpace,true);
		addMember(l,"paddingLeft",get_paddingLeft,set_paddingLeft,true);
		addMember(l,"paddingTop",get_paddingTop,set_paddingTop,true);
		addMember(l,"paddingRight",get_paddingRight,set_paddingRight,true);
		addMember(l,"paddingBottom",get_paddingBottom,set_paddingBottom,true);
		addMember(l,"onArchor",null,set_onArchor,true);
		addMember(l,"symbolFont",get_symbolFont,set_symbolFont,true);
		addMember(l,"labelPrefab",get_labelPrefab,set_labelPrefab,true);
		addMember(l,"facePrefab",get_facePrefab,set_facePrefab,true);
		addMember(l,"text",get_text,set_text,true);
		createTypeMetatable(l,constructor, typeof(CustomLabel2),typeof(UIWidget));
	}
}

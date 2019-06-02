using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_RichTextContent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int fillCharacter(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			self.fillCharacter(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ParseValueURL(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.ParseValueURL(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ParseValue(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.ParseValue(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreatLabels(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.CreatLabels(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreateLinkLabel(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.CreateLinkLabel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreateLabel(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.CreateLabel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreateSprite(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.CreateSprite(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreateUrlImage(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.CreateUrlImage(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int clearContent(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			self.clearContent();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_contentGo(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.contentGo);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_contentGo(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.contentGo=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_bg(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.bg);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_bg(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			UIWidget v;
			checkType(l,2,out v);
			self.bg=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_defaultFontSize(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.defaultFontSize);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_defaultFontSize(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.defaultFontSize=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_labelTrans(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.labelTrans);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_labelTrans(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.labelTrans=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_spriteTrans(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.spriteTrans);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_spriteTrans(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.spriteTrans=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_imageTrans(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.imageTrans);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_imageTrans(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.imageTrans=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_currentLineThing(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.currentLineThing);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_currentLineThing(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.Collections.Generic.List<UnityEngine.Transform> v;
			checkType(l,2,out v);
			self.currentLineThing=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_currentContentMaxWidth(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.currentContentMaxWidth);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_currentContentMaxWidth(IntPtr l) {
		try {
			RichTextContent self=(RichTextContent)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.currentContentMaxWidth=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"RichTextContent");
		addMember(l,fillCharacter);
		addMember(l,ParseValueURL);
		addMember(l,ParseValue);
		addMember(l,CreatLabels);
		addMember(l,CreateLinkLabel);
		addMember(l,CreateLabel);
		addMember(l,CreateSprite);
		addMember(l,CreateUrlImage);
		addMember(l,clearContent);
		addMember(l,"contentGo",get_contentGo,set_contentGo,true);
		addMember(l,"bg",get_bg,set_bg,true);
		addMember(l,"defaultFontSize",get_defaultFontSize,set_defaultFontSize,true);
		addMember(l,"labelTrans",get_labelTrans,set_labelTrans,true);
		addMember(l,"spriteTrans",get_spriteTrans,set_spriteTrans,true);
		addMember(l,"imageTrans",get_imageTrans,set_imageTrans,true);
		addMember(l,"currentLineThing",get_currentLineThing,set_currentLineThing,true);
		addMember(l,"currentContentMaxWidth",get_currentContentMaxWidth,set_currentContentMaxWidth,true);
		createTypeMetatable(l,null, typeof(RichTextContent),typeof(UnityEngine.MonoBehaviour));
	}
}

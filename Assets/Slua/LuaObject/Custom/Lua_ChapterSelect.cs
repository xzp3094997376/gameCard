using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_ChapterSelect : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetChapterTitle(IntPtr l) {
		try {
			ChapterSelect self=(ChapterSelect)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			SLua.LuaFunction a3;
			checkType(l,4,out a3);
			self.SetChapterTitle(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_currentSelectChapter(IntPtr l) {
		try {
			ChapterSelect self=(ChapterSelect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.currentSelectChapter);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_currentSelectChapter(IntPtr l) {
		try {
			ChapterSelect self=(ChapterSelect)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.currentSelectChapter=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"ChapterSelect");
		addMember(l,SetChapterTitle);
		addMember(l,"currentSelectChapter",get_currentSelectChapter,set_currentSelectChapter,true);
		createTypeMetatable(l,null, typeof(ChapterSelect),typeof(UnityEngine.MonoBehaviour));
	}
}

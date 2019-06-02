using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_MusicManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			MusicManager o;
			o=new MusicManager();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int stopAllMusic_s(IntPtr l) {
		try {
			MusicManager.stopAllMusic();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setMuteLevel_s(IntPtr l) {
		try {
			System.Int32 a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			MusicManager.setMuteLevel(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int playByID_s(IntPtr l) {
		try {
			System.Int32 a1;
			checkType(l,1,out a1);
			MusicManager.playByID(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int play_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				MusicManager.play(a1);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(AudioVo))){
				AudioVo a1;
				checkType(l,1,out a1);
				MusicManager.play(a1);
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
	static public int getMusicAudioCamera_s(IntPtr l) {
		try {
			var ret=MusicManager.getMusicAudioCamera();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int muteMusicBG_s(IntPtr l) {
		try {
			System.Boolean a1;
			checkType(l,1,out a1);
			MusicManager.muteMusicBG(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int openMusicBG_s(IntPtr l) {
		try {
			MusicManager.openMusicBG();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_dic(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,MusicManager.dic);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_dic(IntPtr l) {
		try {
			System.Collections.Generic.Dictionary<System.String,AudioItem> v;
			checkType(l,2,out v);
			MusicManager.dic=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_soundDic(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,MusicManager.soundDic);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_soundDic(IntPtr l) {
		try {
			System.Collections.Generic.Dictionary<System.String,AudioItem> v;
			checkType(l,2,out v);
			MusicManager.soundDic=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_musicMuteBool(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,MusicManager.musicMuteBool);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_musicMuteBool(IntPtr l) {
		try {
			System.Collections.Generic.List<System.Boolean> v;
			checkType(l,2,out v);
			MusicManager.musicMuteBool=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_clearItem(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,MusicManager.clearItem);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_clearItem(IntPtr l) {
		try {
			AudioItem v;
			checkType(l,2,out v);
			MusicManager.clearItem=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"MusicManager");
		addMember(l,stopAllMusic_s);
		addMember(l,setMuteLevel_s);
		addMember(l,playByID_s);
		addMember(l,play_s);
		addMember(l,getMusicAudioCamera_s);
		addMember(l,muteMusicBG_s);
		addMember(l,openMusicBG_s);
		addMember(l,"dic",get_dic,set_dic,false);
		addMember(l,"soundDic",get_soundDic,set_soundDic,false);
		addMember(l,"musicMuteBool",get_musicMuteBool,set_musicMuteBool,false);
		addMember(l,"clearItem",get_clearItem,set_clearItem,false);
		createTypeMetatable(l,constructor, typeof(MusicManager));
	}
}

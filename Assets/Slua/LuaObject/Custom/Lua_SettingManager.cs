using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_SettingManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getLastState(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			self.getLastState();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int changeSprite(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			UnityEngine.GameObject a2;
			checkType(l,3,out a2);
			self.changeSprite(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setIsActive(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			UnityEngine.GameObject a2;
			checkType(l,3,out a2);
			System.Boolean a3;
			checkType(l,4,out a3);
			self.setIsActive(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int quitAndSaveState(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			self.quitAndSaveState();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_music(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.music);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_music(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.music=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_musicOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.musicOn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_musicOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.musicOn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_sound(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.sound);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_sound(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.sound=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_soundOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.soundOn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_soundOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.soundOn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_strength(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.strength);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_strength(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.strength=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_strengthOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.strengthOn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_strengthOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.strengthOn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_refreshStore(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.refreshStore);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_refreshStore(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.refreshStore=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_refreshStoreOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.refreshStoreOn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_refreshStoreOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.refreshStoreOn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_energyFull(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.energyFull);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_energyFull(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.energyFull=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_energyFullOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.energyFullOn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_energyFullOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.energyFullOn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_skillFull(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.skillFull);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_skillFull(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.skillFull=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_skillFullOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.skillFullOn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_skillFullOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.skillFullOn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_arena(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.arena);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_arena(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.arena=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_arenaOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.arenaOn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_arenaOn(IntPtr l) {
		try {
			SettingManager self=(SettingManager)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.arenaOn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"SettingManager");
		addMember(l,getLastState);
		addMember(l,changeSprite);
		addMember(l,setIsActive);
		addMember(l,quitAndSaveState);
		addMember(l,"music",get_music,set_music,true);
		addMember(l,"musicOn",get_musicOn,set_musicOn,true);
		addMember(l,"sound",get_sound,set_sound,true);
		addMember(l,"soundOn",get_soundOn,set_soundOn,true);
		addMember(l,"strength",get_strength,set_strength,true);
		addMember(l,"strengthOn",get_strengthOn,set_strengthOn,true);
		addMember(l,"refreshStore",get_refreshStore,set_refreshStore,true);
		addMember(l,"refreshStoreOn",get_refreshStoreOn,set_refreshStoreOn,true);
		addMember(l,"energyFull",get_energyFull,set_energyFull,true);
		addMember(l,"energyFullOn",get_energyFullOn,set_energyFullOn,true);
		addMember(l,"skillFull",get_skillFull,set_skillFull,true);
		addMember(l,"skillFullOn",get_skillFullOn,set_skillFullOn,true);
		addMember(l,"arena",get_arena,set_arena,true);
		addMember(l,"arenaOn",get_arenaOn,set_arenaOn,true);
		createTypeMetatable(l,null, typeof(SettingManager),typeof(UnityEngine.MonoBehaviour));
	}
}

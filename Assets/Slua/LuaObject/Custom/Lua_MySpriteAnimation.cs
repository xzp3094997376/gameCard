using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_MySpriteAnimation : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RebuildSpriteList(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			self.RebuildSpriteList();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Play(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			self.Play();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Pause(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			self.Pause();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Reset(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			self.Reset();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ResetToBeginning(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			self.ResetToBeginning();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_hideWhenFinish(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hideWhenFinish);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_hideWhenFinish(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.hideWhenFinish=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mFPS(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mFPS);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mFPS(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.mFPS=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mLoopTimeDelta(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mLoopTimeDelta);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mLoopTimeDelta(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.mLoopTimeDelta=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mPrefix(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mPrefix);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mPrefix(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.mPrefix=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mLoop(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mLoop);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mLoop(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.mLoop=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mSnap(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mSnap);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mSnap(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.mSnap=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_frames(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.frames);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_framesPerSecond(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.framesPerSecond);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_framesPerSecond(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.framesPerSecond=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_namePrefix(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.namePrefix);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_namePrefix(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.namePrefix=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_loop(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.loop);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_loop(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			bool v;
			checkType(l,2,out v);
			self.loop=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isPlaying(IntPtr l) {
		try {
			MySpriteAnimation self=(MySpriteAnimation)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isPlaying);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"MySpriteAnimation");
		addMember(l,RebuildSpriteList);
		addMember(l,Play);
		addMember(l,Pause);
		addMember(l,Reset);
		addMember(l,ResetToBeginning);
		addMember(l,"hideWhenFinish",get_hideWhenFinish,set_hideWhenFinish,true);
		addMember(l,"mFPS",get_mFPS,set_mFPS,true);
		addMember(l,"mLoopTimeDelta",get_mLoopTimeDelta,set_mLoopTimeDelta,true);
		addMember(l,"mPrefix",get_mPrefix,set_mPrefix,true);
		addMember(l,"mLoop",get_mLoop,set_mLoop,true);
		addMember(l,"mSnap",get_mSnap,set_mSnap,true);
		addMember(l,"frames",get_frames,null,true);
		addMember(l,"framesPerSecond",get_framesPerSecond,set_framesPerSecond,true);
		addMember(l,"namePrefix",get_namePrefix,set_namePrefix,true);
		addMember(l,"loop",get_loop,set_loop,true);
		addMember(l,"isPlaying",get_isPlaying,null,true);
		createTypeMetatable(l,null, typeof(MySpriteAnimation),typeof(UnityEngine.MonoBehaviour));
	}
}

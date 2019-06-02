using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UluaBinding : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Init(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			self.Init();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveClick(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.RemoveClick(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ClearClick(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			self.ClearClick();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getCallBack(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			var ret=self.getCallBack();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallOnEnter(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.CallOnEnter(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallOnExit(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			self.CallOnExit();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int playMusic(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			self.playMusic(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Show(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.Show(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Hide(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.Hide(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ChangeColor(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(string),typeof(UnityEngine.Color))){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				UnityEngine.Color a2;
				checkType(l,3,out a2);
				self.ChangeColor(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(string))){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				self.ChangeColor(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Int32 a3;
				checkType(l,4,out a3);
				self.ChangeColor(a1,a2,a3);
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
	static public int Play(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				self.Play(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Action a3;
				LuaDelegation.checkDelegate(l,4,out a3);
				self.Play(a1,a2,a3);
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
	static public int CallAfterTime(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Double a1;
			checkType(l,2,out a1);
			System.Action a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			self.CallAfterTime(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallFixedUpdate(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Action a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			self.CallFixedUpdate(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallManyFrame(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.Action a1;
				LuaDelegation.checkDelegate(l,2,out a1);
				self.CallManyFrame(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.Action a1;
				LuaDelegation.checkDelegate(l,2,out a1);
				System.Int32 a2;
				checkType(l,3,out a2);
				self.CallManyFrame(a1,a2);
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
	static public int CallEndOfFrame(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Action a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			self.CallEndOfFrame(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int WaitFixedUpdate(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Action a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			var ret=self.WaitFixedUpdate(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int WaitEndOfFrame(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Action a1;
			LuaDelegation.checkDelegate(l,2,out a1);
			var ret=self.WaitEndOfFrame(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Wait(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			System.Action a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			var ret=self.Wait(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadModel(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==5){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				System.String a3;
				checkType(l,4,out a3);
				SLua.LuaFunction a4;
				checkType(l,5,out a4);
				self.LoadModel(a1,a2,a3,a4);
				pushValue(l,true);
				return 1;
			}
			else if(argc==6){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				System.String a3;
				checkType(l,4,out a3);
				SLua.LuaFunction a4;
				checkType(l,5,out a4);
				System.Boolean a5;
				checkType(l,6,out a5);
				self.LoadModel(a1,a2,a3,a4,a5);
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
	static public int CallUpdateWithArgs(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Object[] a1;
			checkParams(l,2,out a1);
			self.CallUpdateWithArgs(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallUpdate(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Object a1;
			checkType(l,2,out a1);
			self.CallUpdate(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetLabelAlignment(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			UILabel a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Int32 a3;
			checkType(l,4,out a3);
			self.SetLabelAlignment(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallTargetFunction(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object[] a2;
			checkParams(l,3,out a2);
			var ret=self.CallTargetFunction(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CallTargetFunctionWithLuaTable(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Object a2;
			checkType(l,3,out a2);
			var ret=self.CallTargetFunctionWithLuaTable(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetTarget(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			var ret=self.GetTarget();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetCallBack(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			self.SetCallBack(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PlayTween(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				self.PlayTween(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				System.Action a3;
				LuaDelegation.checkDelegate(l,4,out a3);
				self.PlayTween(a1,a2,a3);
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
	static public int MoveToPos(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				UnityEngine.Vector3 a3;
				checkType(l,4,out a3);
				self.MoveToPos(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==5){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				UnityEngine.Vector3 a3;
				checkType(l,4,out a3);
				System.Action a4;
				LuaDelegation.checkDelegate(l,5,out a4);
				self.MoveToPos(a1,a2,a3,a4);
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
	static public int RotTo(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				UnityEngine.Quaternion a3;
				checkType(l,4,out a3);
				self.RotTo(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==5){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				UnityEngine.Quaternion a3;
				checkType(l,4,out a3);
				System.Action a4;
				LuaDelegation.checkDelegate(l,5,out a4);
				self.RotTo(a1,a2,a3,a4);
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
	static public int ScaleToGameObject(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				UnityEngine.Vector3 a3;
				checkType(l,4,out a3);
				self.ScaleToGameObject(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==5){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				UnityEngine.Vector3 a3;
				checkType(l,4,out a3);
				System.Action a4;
				LuaDelegation.checkDelegate(l,5,out a4);
				self.ScaleToGameObject(a1,a2,a3,a4);
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
	static public int ScalePage(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				System.Single a3;
				checkType(l,4,out a3);
				self.ScalePage(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==5){
				UluaBinding self=(UluaBinding)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				UnityEngine.GameObject a2;
				checkType(l,3,out a2);
				System.Single a3;
				checkType(l,4,out a3);
				System.Action a4;
				LuaDelegation.checkDelegate(l,5,out a4);
				self.ScalePage(a1,a2,a3,a4);
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
	static public int CheckRootUIWidgetCom(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			var ret=self.CheckRootUIWidgetCom();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DestroyObject(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				self.DestroyObject(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				self.DestroyObject(a1,a2);
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
	static public int fadeIn(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				self.fadeIn(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				System.Action a3;
				LuaDelegation.checkDelegate(l,4,out a3);
				self.fadeIn(a1,a2,a3);
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
	static public int fadeOut(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				self.fadeOut(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				System.Single a2;
				checkType(l,3,out a2);
				System.Action a3;
				LuaDelegation.checkDelegate(l,4,out a3);
				self.fadeOut(a1,a2,a3);
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
	static public int moveTo(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==5){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				UnityEngine.Vector3 a2;
				checkType(l,3,out a2);
				UnityEngine.Vector3 a3;
				checkType(l,4,out a3);
				System.Single a4;
				checkType(l,5,out a4);
				self.moveTo(a1,a2,a3,a4);
				pushValue(l,true);
				return 1;
			}
			else if(argc==6){
				UluaBinding self=(UluaBinding)checkSelf(l);
				UnityEngine.GameObject a1;
				checkType(l,2,out a1);
				UnityEngine.Vector3 a2;
				checkType(l,3,out a2);
				UnityEngine.Vector3 a3;
				checkType(l,4,out a3);
				System.Single a4;
				checkType(l,5,out a4);
				System.Boolean a5;
				checkType(l,6,out a5);
				self.moveTo(a1,a2,a3,a4,a5);
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
	static public int CallLuaFunction_s(IntPtr l) {
		try {
			SLua.LuaTable a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Object[] a3;
			checkParams(l,3,out a3);
			var ret=UluaBinding.CallLuaFunction(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnRecycle_s(IntPtr l) {
		try {
			UluaBinding.OnRecycle();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_START(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaBinding.START);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ON_DESTROY(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaBinding.ON_DESTROY);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ON_CLICK(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaBinding.ON_CLICK);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ON_PRESS(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaBinding.ON_PRESS);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_UPDATE(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaBinding.UPDATE);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_CREATE(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaBinding.CREATE);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ON_TOOLTIP(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaBinding.ON_TOOLTIP);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_mVariables(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.mVariables);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_mVariables(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			LuaVariable[] v;
			checkType(l,2,out v);
			self.mVariables=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_target(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.target);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_target(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			SLua.LuaTable v;
			checkType(l,2,out v);
			self.target=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_KeyMap(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.KeyMap);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_KeyMap(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			System.Collections.Generic.List<LuaKeyValue> v;
			checkType(l,2,out v);
			self.KeyMap=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_recordGuideStep(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,UluaBinding.recordGuideStep);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_recordGuideStep(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			UluaBinding.recordGuideStep=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Map(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Map);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_luaScriptPath(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.luaScriptPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_luaScriptPath(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.luaScriptPath=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_width(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.width);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_height(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.height);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ConstMap(IntPtr l) {
		try {
			UluaBinding self=(UluaBinding)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.ConstMap);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UluaBinding");
		addMember(l,Init);
		addMember(l,RemoveClick);
		addMember(l,ClearClick);
		addMember(l,getCallBack);
		addMember(l,CallOnEnter);
		addMember(l,CallOnExit);
		addMember(l,playMusic);
		addMember(l,Show);
		addMember(l,Hide);
		addMember(l,ChangeColor);
		addMember(l,Play);
		addMember(l,CallAfterTime);
		addMember(l,CallFixedUpdate);
		addMember(l,CallManyFrame);
		addMember(l,CallEndOfFrame);
		addMember(l,WaitFixedUpdate);
		addMember(l,WaitEndOfFrame);
		addMember(l,Wait);
		addMember(l,LoadModel);
		addMember(l,CallUpdateWithArgs);
		addMember(l,CallUpdate);
		addMember(l,SetLabelAlignment);
		addMember(l,CallTargetFunction);
		addMember(l,CallTargetFunctionWithLuaTable);
		addMember(l,GetTarget);
		addMember(l,SetCallBack);
		addMember(l,PlayTween);
		addMember(l,MoveToPos);
		addMember(l,RotTo);
		addMember(l,ScaleToGameObject);
		addMember(l,ScalePage);
		addMember(l,CheckRootUIWidgetCom);
		addMember(l,DestroyObject);
		addMember(l,fadeIn);
		addMember(l,fadeOut);
		addMember(l,moveTo);
		addMember(l,CallLuaFunction_s);
		addMember(l,OnRecycle_s);
		addMember(l,"START",get_START,null,false);
		addMember(l,"ON_DESTROY",get_ON_DESTROY,null,false);
		addMember(l,"ON_CLICK",get_ON_CLICK,null,false);
		addMember(l,"ON_PRESS",get_ON_PRESS,null,false);
		addMember(l,"UPDATE",get_UPDATE,null,false);
		addMember(l,"CREATE",get_CREATE,null,false);
		addMember(l,"ON_TOOLTIP",get_ON_TOOLTIP,null,false);
		addMember(l,"mVariables",get_mVariables,set_mVariables,true);
		addMember(l,"target",get_target,set_target,true);
		addMember(l,"KeyMap",get_KeyMap,set_KeyMap,true);
		addMember(l,"recordGuideStep",get_recordGuideStep,set_recordGuideStep,false);
		addMember(l,"Map",get_Map,null,true);
		addMember(l,"luaScriptPath",get_luaScriptPath,set_luaScriptPath,true);
		addMember(l,"width",get_width,null,true);
		addMember(l,"height",get_height,null,true);
		addMember(l,"ConstMap",get_ConstMap,null,true);
		createTypeMetatable(l,null, typeof(UluaBinding),typeof(UnityEngine.MonoBehaviour));
	}
}

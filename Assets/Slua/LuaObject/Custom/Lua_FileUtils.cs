using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_FileUtils : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			FileUtils o;
			o=new FileUtils();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ClearCache(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			self.ClearCache();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getSearchPaths(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			var ret=self.getSearchPaths();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setSearchPaths(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.Collections.Generic.List<System.String> a1;
			checkType(l,2,out a1);
			self.setSearchPaths(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int addSearchPath(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				self.addSearchPath(a1);
				pushValue(l,true);
				return 1;
			}
			else if(argc==3){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Boolean a2;
				checkType(l,3,out a2);
				self.addSearchPath(a1,a2);
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
	static public int GetMd5(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.GetMd5(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EqualsMd5(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			var ret=self.EqualsMd5(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getString(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.getString(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				var ret=self.getString(a1,a2);
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
	static public int getBytes(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.getBytes(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				var ret=self.getBytes(a1,a2);
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
	static public int isFileExist(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.isFileExist(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isDirectoryExist(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.isDirectoryExist(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int renameFile(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			var ret=self.renameFile(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int movePath(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			self.movePath(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeDirectory(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.removeDirectory(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int removeFile(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.removeFile(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getWritablePath(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			var ret=self.getWritablePath();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getFileDataFromZip(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			var ret=self.getFileDataFromZip(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int writeFileWithCode(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Text.Encoding a3;
			checkType(l,4,out a3);
			var ret=self.writeFileWithCode(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int writeFile(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(string),typeof(System.Byte[]))){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Byte[] a2;
				checkType(l,3,out a2);
				var ret=self.writeFile(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(string))){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				var ret=self.writeFile(a1,a2);
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
	static public int writeFileStream(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Collections.Generic.List<System.Byte[]> a2;
				checkType(l,3,out a2);
				var ret=self.writeFileStream(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==4){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Collections.Generic.List<System.Byte[]> a3;
				checkType(l,4,out a3);
				var ret=self.writeFileStream(a1,a2,a3);
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
	static public int createDirectory(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.createDirectory(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int clearPath(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.clearPath(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int unZip(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.unZip(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ForEachDirectory(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.Action<System.String> a2;
				LuaDelegation.checkDelegate(l,3,out a2);
				self.ForEachDirectory(a1,a2);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				FileUtils self=(FileUtils)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Action<System.String> a3;
				LuaDelegation.checkDelegate(l,4,out a3);
				self.ForEachDirectory(a1,a2,a3);
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
	static public int getAllFileInPath(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getAllFileInPath(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getAllFileInPathWithSearchPattern(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			var ret=self.getAllFileInPathWithSearchPattern(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getFullPath(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getFullPath(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getRuntimePlatform(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			var ret=self.getRuntimePlatform();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getAssetBundleFilePath(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getAssetBundleFilePath(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getAssetBundle(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getAssetBundle(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getAssetBundleFromMemory(IntPtr l) {
		try {
			FileUtils self=(FileUtils)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getAssetBundleFromMemory(a1);
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
			var ret=FileUtils.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int destroyInstance_s(IntPtr l) {
		try {
			FileUtils.destroyInstance();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getLinuxPath_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=FileUtils.getLinuxPath(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"FileUtils");
		addMember(l,ClearCache);
		addMember(l,getSearchPaths);
		addMember(l,setSearchPaths);
		addMember(l,addSearchPath);
		addMember(l,GetMd5);
		addMember(l,EqualsMd5);
		addMember(l,getString);
		addMember(l,getBytes);
		addMember(l,isFileExist);
		addMember(l,isDirectoryExist);
		addMember(l,renameFile);
		addMember(l,movePath);
		addMember(l,removeDirectory);
		addMember(l,removeFile);
		addMember(l,getWritablePath);
		addMember(l,getFileDataFromZip);
		addMember(l,writeFileWithCode);
		addMember(l,writeFile);
		addMember(l,writeFileStream);
		addMember(l,createDirectory);
		addMember(l,clearPath);
		addMember(l,unZip);
		addMember(l,ForEachDirectory);
		addMember(l,getAllFileInPath);
		addMember(l,getAllFileInPathWithSearchPattern);
		addMember(l,getFullPath);
		addMember(l,getRuntimePlatform);
		addMember(l,getAssetBundleFilePath);
		addMember(l,getAssetBundle);
		addMember(l,getAssetBundleFromMemory);
		addMember(l,getInstance_s);
		addMember(l,destroyInstance_s);
		addMember(l,getLinuxPath_s);
		createTypeMetatable(l,constructor, typeof(FileUtils));
	}
}

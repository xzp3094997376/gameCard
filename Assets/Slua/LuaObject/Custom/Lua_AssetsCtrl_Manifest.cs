using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_AssetsCtrl_Manifest : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			AssetsCtrl.Manifest o;
			System.String a1;
			checkType(l,2,out a1);
			o=new AssetsCtrl.Manifest(a1);
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int loadJson(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.loadJson(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int parseVersion(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.parseVersion(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int parse(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.parse(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int versionEquals(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			AssetsCtrl.Manifest a1;
			checkType(l,2,out a1);
			var ret=self.versionEquals(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int genDiff(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			AssetsCtrl.Manifest a1;
			checkType(l,2,out a1);
			var ret=self.genDiff(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int genResumeAssetsList(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			Dictionary<System.String,AssetsCtrl.Downloader.DownloadUnit> a1;
			checkType(l,2,out a1);
			self.genResumeAssetsList(ref a1);
			pushValue(l,true);
			pushValue(l,a1);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int prependSearchPaths(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			self.prependSearchPaths();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int loadVersion(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			TinyJSON.Node a1;
			checkType(l,2,out a1);
			self.loadVersion(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int loadManifest(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			TinyJSON.Node a1;
			checkType(l,2,out a1);
			self.loadManifest(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int saveToFile(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.saveToFile(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int parseAsset(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			TinyJSON.Node a2;
			checkType(l,3,out a2);
			var ret=self.parseAsset(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int clear(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			self.clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getGroups(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getGroups();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getGroupVerions(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getGroupVerions();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getGroupVersion(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.getGroupVersion(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getAssets(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getAssets();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int setAssetDownloadState(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			AssetsCtrl.Manifest.DownloadState a2;
			checkEnum(l,3,out a2);
			self.setAssetDownloadState(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isVersionLoaded(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.isVersionLoaded();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int isLoaded(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.isLoaded();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getPackageUrl(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getPackageUrl();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getManifestFileUrl(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getManifestFileUrl();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getVersionFileUrl(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getVersionFileUrl();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getVersion(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getVersion();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getEngineVersion(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getEngineVersion();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getSearchPaths(IntPtr l) {
		try {
			AssetsCtrl.Manifest self=(AssetsCtrl.Manifest)checkSelf(l);
			var ret=self.getSearchPaths();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"AssetsCtrl.Manifest");
		addMember(l,loadJson);
		addMember(l,parseVersion);
		addMember(l,parse);
		addMember(l,versionEquals);
		addMember(l,genDiff);
		addMember(l,genResumeAssetsList);
		addMember(l,prependSearchPaths);
		addMember(l,loadVersion);
		addMember(l,loadManifest);
		addMember(l,saveToFile);
		addMember(l,parseAsset);
		addMember(l,clear);
		addMember(l,getGroups);
		addMember(l,getGroupVerions);
		addMember(l,getGroupVersion);
		addMember(l,getAssets);
		addMember(l,setAssetDownloadState);
		addMember(l,isVersionLoaded);
		addMember(l,isLoaded);
		addMember(l,getPackageUrl);
		addMember(l,getManifestFileUrl);
		addMember(l,getVersionFileUrl);
		addMember(l,getVersion);
		addMember(l,getEngineVersion);
		addMember(l,getSearchPaths);
		createTypeMetatable(l,constructor, typeof(AssetsCtrl.Manifest));
	}
}

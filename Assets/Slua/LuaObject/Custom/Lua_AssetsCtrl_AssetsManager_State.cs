using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_AssetsCtrl_AssetsManager_State : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"AssetsCtrl.AssetsManager.State");
		addMember(l,0,"UNCHECKED");
		addMember(l,1,"PREDOWNLOAD_VERSION");
		addMember(l,2,"DOWNLOADING_VERSION");
		addMember(l,3,"VERSION_LOADED");
		addMember(l,4,"PREDOWNLOAD_MANIFEST");
		addMember(l,5,"DOWNLOADING_MANIFEST");
		addMember(l,6,"MANIFEST_LOADED");
		addMember(l,7,"NEED_UPDATE");
		addMember(l,8,"UPDATING");
		addMember(l,9,"UP_TO_DATE");
		addMember(l,10,"FAIL_TO_UPDATE");
		LuaDLL.lua_pop(l, 1);
	}
}

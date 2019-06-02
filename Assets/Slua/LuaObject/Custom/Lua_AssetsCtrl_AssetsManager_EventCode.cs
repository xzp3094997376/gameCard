using UnityEngine;
using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_AssetsCtrl_AssetsManager_EventCode : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"AssetsCtrl.AssetsManager.EventCode");
		addMember(l,0,"ERROR_NO_LOCAL_MANIFEST");
		addMember(l,1,"ERROR_DOWNLOAD_MANIFEST");
		addMember(l,2,"ERROR_PARSE_MANIFEST");
		addMember(l,3,"NEW_VERSION_FOUND");
		addMember(l,4,"ALREADY_UP_TO_DATE");
		addMember(l,5,"UPDATE_PROGRESSION");
		addMember(l,6,"ASSET_UPDATED");
		addMember(l,7,"ERROR_UPDATING");
		addMember(l,8,"UPDATE_FINISHED");
		addMember(l,9,"UPDATE_FAILED");
		addMember(l,10,"ERROR_DECOMPRESS");
		LuaDLL.lua_pop(l, 1);
	}
}

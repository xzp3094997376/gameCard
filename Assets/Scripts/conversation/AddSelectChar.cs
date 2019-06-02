using UnityEngine;
using System.Collections;
using SLua;
public class AddSelectChar : MonoBehaviour {

	// Use this for initialization
    void Start()
    {
        string file_name = "uLuaModule/modules/conversation/uTestAll.lua";
        //string text = LuaHelper.LoadString(file_name);
        //LuaState l = new LuaState();
        //object[] objs = l.DoString(text);
        var objs = LuaManager.getInstance().DoFile(file_name);
        TranslateScripts.Inst.TranslateString(objs as LuaTable);
    }

}

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class TestUIMain : MonoBehaviour {
    LuaManager luaMrg;
    // Use this for initialization
    void Awake() {
        var list = new List<string>();
#if UNITY_EDITOR
        list.Add(Application.dataPath + "/../");
        list.Add(Application.dataPath + "/");
#endif
        list.Add(Application.persistentDataPath);
        list.Add(Application.streamingAssetsPath);
        FileUtils.getInstance().ClearCache();
        FileUtils.getInstance().setSearchPaths(list);
        //luaMrg = LuaManager.getInstance();
        //yield return null;
        Init();
    }

    void Init()
    { 
        GlobalVar.UI = gameObject;
        GlobalVar.camera = GameObject.Find("GameManager/Camera").GetComponent<Camera>();
        GlobalVar.Root = GetComponent<UIRoot>();
        GlobalVar.RootPanel = GlobalVar.camera.GetComponent<UIPanel>();
        GlobalVar.center = GameObject.Find("GameManager/Camera/mainUI/center");
        GlobalVar.notice = GameObject.Find("GameManager/Camera/mainUI/notice");
        GlobalVar.undestroy = GameObject.Find("GameManager/Camera/mainUI/undestroy");
        GlobalVar.MainUI = GlobalVar.center.transform.parent.gameObject;
    }
	
	// Update is called once per frame
	void Update () {
        FrameTimerManager.frameHandle(); //启动定时器
    }
}

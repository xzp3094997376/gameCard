using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.IO;
using SimpleJson;

public class GameManager : MonoBehaviour
{
    public float f_UpdateInterval = 0.5F;
    private float f_LastInterval;
    private int i_Frames = 0;
    private float f_Fps;
    private float f_ms;
    private bool isPause = false;
    float m_CountTime = 0;
    float m_CountTimeRes = 0;
    LuaManager luaMrg;
    /// <summary>
    /// 初始化游戏管理器
    /// </summary>
    void Awake()
    {
		#if UNITY_ANDROID
			if (gameObject.GetComponent<sdkManager>() == null) 
				gameObject.AddComponent<sdkManager> ();
		#endif
        if (GlobalVar.UI)
        {
			#if UNITY_ANDROID
	            LuaManager.getInstance().Destroy();
	            Network.Destroy();
			#endif
			if (FightManager.Inst != null) FightManager.Inst.m_Data = null;
            TableReader.Destroy();
            GameObject.Destroy(GlobalVar.UI);
            GlobalVar.UI = null;
            GlobalVar.currentScene = "";
        }
    }
    IEnumerator Start()
    {
        var list = new List<string>();
#if UNITY_EDITOR
        list.Add(Application.dataPath + "/../");
        list.Add(Application.dataPath + "/");
#endif
        list.Add(Application.persistentDataPath);
        list.Add(Application.streamingAssetsPath);
        FileUtils.getInstance().setSearchPaths(list);
        luaMrg = LuaManager.getInstance();

        //gameObject.AddComponent<Scene>();
        yield return null;
        Init();
    }


    /// <summary>
    /// 初始化
    /// </summary>
    void Init()
    {
        DontDestroyOnLoad(gameObject);  //防止销毁自己
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = 30;

        GlobalVar.UI = gameObject;
        GlobalVar.camera = GameObject.Find("GameManager/Camera").GetComponent<Camera>();
        GlobalVar.Root = GetComponent<UIRoot>();
        GlobalVar.RootPanel = GlobalVar.camera.GetComponent<UIPanel>();
        GlobalVar.center = GameObject.Find("GameManager/Camera/mainUI/center");
        GlobalVar.undestroy = GameObject.Find("GameManager/Camera/mainUI/undestroy");
        GlobalVar.notice = GameObject.Find("GameManager/Camera/mainUI/notice");
        GlobalVar.MainUI = GlobalVar.center.transform.parent.gameObject;
        if (GlobalVar.loading == null)
            ClientTool.loadAssets("Prefabs/publicPrefabs/ui_waiting", true, null, go =>
            {
                GlobalVar.loading = ((GameObject)go).GetComponent<ApiLoading>();
            });
        var isDebug = false;
        luaMrg.init(tick, complete, isDebug);
		LoadPool();
    }
    void HideFighting()
    {
        ClientTool.hideFighting();
    }
    private void complete()
    {
        luaMrg.start("uLuaModule/main");
    }
    private void tick(int p)
    {
    }


    /// <summary>
    /// 执行Lua方法
    /// </summary>
    protected object CallMethod(string func, params object[] args)
    {
        return LuaManager.getInstance().CallLuaFunction("GameManager." + func, args);
    }



    void LoadPool()
    {
        GameObject go = GameObject.Find("PoolManager");
        if (!go)
        {
            ClientTool.loadAssets("Prefabs/publicPrefabs/PoolManager", true, null, obj =>
            {
                go = obj as GameObject;
                go.name = "PoolManager";
                ItemPoolManager.initPrefabs();
            });
        }
    }


    /// <summary>
    /// 析构函数
    /// </summary>
    void OnDestroy()
    {
        MyDebug.Log("~GameManager was destroyed");
    }


    private void Update()
    {
        try
        {
            if (isPause) return;

            if (Input.GetMouseButtonDown(0))
            {
                ApiLoading.getInstance().showTouchEffect(Input.mousePosition);
            }
            ++i_Frames;
            if (Time.realtimeSinceStartup > f_LastInterval + f_UpdateInterval)
            {
                f_Fps = i_Frames / (Time.realtimeSinceStartup - f_LastInterval);
                f_ms = 1000.0f / (float)Mathf.Max(f_Fps, 0.00001f);
                i_Frames = 0;
                f_LastInterval = Time.realtimeSinceStartup;
            }

            m_CountTime += Time.deltaTime;
            if (m_CountTime > 15 && QualityManager.IsLow())
            {
                m_CountTime = 0;
                TextureCache.getInstance().removeUnusedTextures();
                LoadManager.getInstance().RemoveUnusedModel(true);
                AssetBundles.AssetBundleLoader.removeUnusedAssetBundle();
                Resources.UnloadUnusedAssets();
            }
            m_CountTimeRes += Time.deltaTime;
            if (m_CountTimeRes > 90 && !QualityManager.IsLow())
            {
                m_CountTimeRes = 0;
                TextureCache.getInstance().removeUnusedTextures();
                LoadManager.getInstance().RemoveUnusedModel(true);
                AssetBundles.AssetBundleLoader.removeUnusedAssetBundle();
                Resources.UnloadUnusedAssets();
            }
            FrameTimerManager.frameHandle(); //启动定时器
            if ((Input.GetKeyDown(KeyCode.Escape) || Input.GetKeyDown(KeyCode.Home)))
            {
                ClientTool.quitGame();
            }
            else if (Input.GetKeyDown(KeyCode.G))// && Input.GetKeyDown(KeyCode.RightControl))
            {
                //if (DataModel.ProtoPlayer.Instance != null && DataModel.ProtoPlayer.Instance["gmlevel"] != null)
               // {
               //     ClientTool.popGMUI();
               // }
            }
            //else if (Input.GetKeyDown(KeyCode.D))// && Input.GetKeyDown(KeyCode.RightControl))
            //{
            //    Network.Instance.disconnectTemp();
            //}
        }
        catch (System.Exception error)
        {
            UnityEngine.Debug.Log(error);
        }
    }


    /// <summary>
    /// 安卓从后台切换。
    /// </summary>
    /// <param name="pauseStatus"></param>
    void OnApplicationPause(bool pauseStatus)
    {
        isPause = pauseStatus;
        if (luaMrg != null)
            CallMethod("OnApplicationPause", pauseStatus);
    }
    void OnApplicationFocus(bool focusStatus)
    {
        if (luaMrg != null)
            CallMethod("OnApplicationFocus", focusStatus);
    }
}

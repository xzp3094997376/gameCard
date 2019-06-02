using UnityEngine;
using System;
using System.Collections;
using SimpleJson;
using SLua;
using System.Reflection;
using ICSharpCode.SharpZipLib.Zip;
using System.Collections.Generic;
using System.IO;
[CustomLuaClass]
static public class ClientTool
{
    private static double clickTime;

#if UNITY_EDITOR
    public static string Platform = "pc";
#elif UNITY_IOS
	public static string Platform = "ios";
#elif UNITY_ANDROID
	public static string Platform = "android";
#endif
    #region Log
    static public void Log(object message)
    {
        MyDebug.Log(message);
    }

    static public void Log(object message, UnityEngine.Object context)
    {
        MyDebug.Log(message, context);
    }

    static public void LogError(object message)
    {
        MyDebug.LogError(message);
    }

    static public void LogError(object message, UnityEngine.Object context)
    {
        MyDebug.LogError(message, context);
    }
    #endregion

    #region 工具
    /// <summary>
    /// 检查字符是否以suffix结尾
    /// </summary>
    /// <param name="str"></param>
    /// <param name="suffix"></param>
    /// <returns></returns>
    static public bool endsWith(string str, string suffix)
    {
        int pos = str.Length - suffix.Length;
        if (pos < 0) return false;
        return str.IndexOf(suffix, pos) != -1;
    }

    static public string GetNumbersFromString(string p_str)
    {
        string strReturn = string.Empty;
        if (p_str == null || p_str.Trim() == "")
        {
            strReturn = "";
        }

        foreach (char chrTemp in p_str)
        {
            if (char.IsNumber(chrTemp))
            {
                strReturn += chrTemp.ToString();
            }
        }

        return strReturn;
    }

    #endregion

    #region 加载预设

    static public GameObject load(string prefabsPath)
    {
        GameObject gobj = Pureload(prefabsPath);
        GameObject go = null;
        if (gobj != null)
        {
            go = GameObject.Instantiate(gobj) as GameObject;
            go.name = go.name.Replace("(Clone)", "");
            AssetBundleRef.Add(go, prefabsPath.ToLower(), Path.GetFileNameWithoutExtension(prefabsPath));
            gobj = null;
        }
        return go;
    }

    

    /// <summary>
    /// 加载预设
    /// </summary>
    /// <param name="prefabsPath">预设的路径</param>
    /// <param name="parent">预设的父亲节点</param>
    /// <returns></returns>
    static public GameObject load(string prefabsPath, GameObject parent, bool resetlayer = true)
    {
        GameObject ret = load(prefabsPath);
        if (parent)
        {
            if (ret)
            {
                if (resetlayer)
                    NGUITools.SetLayer(ret, parent.layer);
                ret.transform.parent = parent.transform;
                ret.transform.localPosition = Vector3.zero;
                ret.transform.localScale = Vector3.one;
            }
        }
        else
        {
            ClientTool.LogError("the parent is Null!");
        }
        return ret;
    }

    static public GameObject load(string prefabsPath, string parentNodePath)
    {
        return load(prefabsPath, GameObject.Find(parentNodePath));
    }

    //获取预设，支持热更新的方式，先查找是否在
    static public GameObject Pureload(string prefabsPath)
    {
        GameObject ret = null;
        try
        {
#if UNITY_EDITOR
            if (PlayerPrefs.GetInt("isAssetsBundle", 0) == 0)
            {
                GameObject go = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>("Assets/UI/" + prefabsPath + ".prefab");
                if (go)
                    return go;
            }
#endif
            string path = prefabsPath;
            string lastName = Path.GetFileNameWithoutExtension(path);
            path = path.ToLower();
            var error = "";
            var asset = AssetBundles.AssetBundleLoader.GetLoadedAssetBundle(path, out error);
            if (asset != null)
            {
                var bundle = asset.m_AssetBundle;
                if (bundle)
                {
                    ret = bundle.LoadAsset<GameObject>(lastName);
                    ModelShowUtil.resetShader(ret.transform);
                    return ret;
                }
            }
            MyDebug.Log("load form resources " + prefabsPath);
            ret = Resources.Load(prefabsPath, typeof(GameObject)) as GameObject; //3 其他预设

            if (!ret)
            {
                ClientTool.LogError("can't find " + prefabsPath);
                return null;
            }
            return ret;
        }
        catch (Exception e)
        {
            MyDebug.LogError("Can't find Prefabs " + prefabsPath + "\n" + e.ToString());
        }
        return ret;
    }


    /// <summary>
    /// 通过预设路径加载预设并返回预设中所绑定的LuaBinding脚本。
    /// </summary>
    /// <param name="prefabsPath">预设路径</param>
    /// <param name="parent">父节点</param>
    /// <returns>UluaBinding</returns>
    static public UluaBinding loadAndGetLuaBinding(string prefabsPath, GameObject parent, bool resetlayer = true)
    {
        UluaBinding lua = null;
        var go = load(prefabsPath, parent, resetlayer);
        if (go) lua = go.GetComponent<UluaBinding>();
        if (!lua)
        {
            throw new System.Exception(prefabsPath + " Prefabs have not Binding a lua script! pls use [ClientTool.load]  instead of [ClientTool.loadAndGetLuaBinding] or attach [UluaBinding] script.");
        }
        if (resetlayer)
            NGUITools.SetLayer(lua.gameObject, parent.layer);

        return lua;
    }
    //-----------------------------------------------------------
    // Method        : UnZipBuf
    // Function Name : ClientTool.UnZipBuf
    // Access        : public static 
    // Argument      : byte [] buf
    // Return Type   : byte []
    // Description   : 
    //-----------------------------------------------------------
    static public byte [] UnZipBuf(string s)
    {
        byte[] buf = System.Text.Encoding.ASCII.GetBytes(s);
        System.IO.MemoryStream dest = new System.IO.MemoryStream();
        using (ZipOutputStream zipStream = new ZipOutputStream(dest))
        {

            //buf = System.Text.Encoding.ASCII.GetBytes(s);

            zipStream.Write(buf, 0, buf.Length);
        }
        return dest.ToArray();
    }

    static public void loadAssets(string path, bool isInit, GameObject parent, Action<UnityEngine.Object> cb)
    {
        //DownLoadManager.getInstance().StartCoroutine(_loadAssets(path, isInit, parent, cb));
        var go = load(path);
        if (isInit)
        {
            if (isInit && go)
            {
                if (parent)
                {
                    Transform mTran = ((GameObject)go).transform;
                    if (mTran)
                    {
                        mTran.parent = parent.transform;
                        mTran.localPosition = Vector3.zero;
                        mTran.localScale = Vector3.one;
                    }
                }
            }
            cb(go);
        }
    }

    static public UluaBinding loadAndGetLuaBindingFromPool(string prefabsPath, GameObject parent)
    {
        UluaBinding lua = null;
        Transform ret = ItemPoolManager.getItamAllFromPool(parent.transform);
        if (parent)
        {
            if (ret)
            {
                ret.transform.parent = parent.transform;
                ret.transform.localPosition = Vector3.zero;
                ret.transform.localScale = Vector3.one;
            }
        }
        else
        {
            ClientTool.LogError("the parent is Null!");
            return null;
        }
        lua = ret.GetComponent<UluaBinding>();
        if (!lua)
        {
            throw new System.Exception(prefabsPath + " Prefabs have not Binding a lua script! pls use [ClientTool.load]  instead of [ClientTool.loadAndGetLuaBinding] or attach [UluaBinding] script.");
        }
        return lua;
    }
    #endregion


    #region for lua
    /// <summary>
    /// 获得加载的预所绑定的UluaBinding的实例lua对象
    /// </summary>
    /// <param name="go"></param>
    /// <returns></returns>
    static public LuaTable GetLuaBinding(GameObject go)
    {
        var comp = go.GetComponent<UluaBinding>();
        if (comp) return comp.target;
        return null;
    }


    /// <summary>
    /// 给GameObject发消息
    /// </summary>
    /// <param name="go"></param>
    /// <param name="name"></param>
    static public void SendMessageFromLua(GameObject go, string name)
    {
        if (go != null)
            go.SendMessage(name, SendMessageOptions.DontRequireReceiver);
    }
    static public LuaTable UpdateGrid(string path, UIGrid grid, LuaTable dataes)
    {
        return UpdateGrid(path, grid, dataes, null);
    }
    static public LuaTable UpdateGrid(string path, UIGrid grid, LuaTable dataes, LuaTable target)
    {
        int num = 0;
        ArrayList list = new ArrayList();
        if (dataes != null)
        {
            foreach (var o in dataes)
            {
                list.Add(o.value);
            }
        }
        grid.animateSmoothly = false;
        dataes = null;
        num = list.Count;
        LuaTable lTb = new LuaTable(LuaManager.luaState);
        var mTrans = grid.transform;
        var find = grid.transform.parent.FindChild("__cacheObject__");
        GameObject obj = null;
        if (find)
        {
            obj = find.gameObject;
        }
        else if (mTrans.childCount > 0)
        {
            var child = mTrans.GetChild(0);
            if (child != null)
            {
                child.parent = grid.transform.parent;
                child.name = "__cacheObject__";
                obj = child.gameObject;
                obj.SetActive(false);
            }
        }
        int childCount = grid.transform.childCount;
        for (int i = 0; i < Math.Max(num, childCount); i++)
        {
            GameObject go = null;
            if (i >= childCount)
            {
                if (obj == null)
                {
                    obj = ClientTool.load(path, grid.transform.parent.gameObject);
                    obj.name = "__cacheObject__";
                    obj.SetActive(false);
                    go = NGUITools.AddChild(grid.gameObject, obj);
                    go.name = go.name.Replace("(Clone)", "");

                    grid.AddChild(go.transform);
                }
                else
                {
                    go = NGUITools.AddChild(grid.gameObject, obj);
                    go.name = go.name.Replace("(Clone)", "");

                    grid.AddChild(go.transform);
                }
                if (obj == null) return lTb;
                go.SetActive(true);

                //列表少于需要的数量，加入新的
                var comp = go.GetComponent<UluaBinding>();
                if (comp)
                {
                    comp.CallUpdateWithArgs(new object[] { list[i], i, grid, target });
                    lTb[i + 1] = comp;
                }
                go.name = "cell" + i;
            }
            else
            {
                var t = mTrans.GetChild(i);
                go = t.gameObject;
                if (i < num)
                {
                    go.SetActive(true);
                    var comp = go.GetComponent<UluaBinding>();
                    if (comp)
                    {
                        //comp.CallUpdateWithArgs(list[i], i, _myTable);
                        comp.CallUpdateWithArgs(new object[] { list[i], i, grid, target });
                        lTb[i + 1] = comp;
                    }
                    go.name = "cell" + i;
                }
                else
                {
                    go.SetActive(false);
                }

            }
        }
        target = null;
        grid.repositionNow = true;
        return lTb;
    }

    static public LuaTable UpdateMyTable(string path, MyTable _myTable, LuaTable dataes)
    {
        return UpdateMyTable(path, _myTable, dataes, null);
    }

    /// <summary>
    /// 快速创建一个列表
    /// </summary>
    /// <param name="path">预设的路径</param>
    /// <param name="_myTable">MyTable</param>
    /// <param name="dataes">数据源</param>
    /// <returns></returns>
    static public LuaTable UpdateMyTable(string path, MyTable _myTable, LuaTable dataes, LuaTable target)
    {
        int num = 0;
        ArrayList list = new ArrayList();
        if (dataes != null)
        {
            foreach (var o in dataes)
            {
                list.Add(o.value);
            }
        }
        dataes = null;
        num = list.Count;
        LuaTable lTb = new LuaTable(LuaManager.luaState);
        var mTrans = _myTable.transform;
        var find = _myTable.transform.parent.FindChild("__cacheObject__");
        GameObject obj = null;
        if (find)
        {
            obj = find.gameObject;
        }
        else if (mTrans.childCount > 0)
        {
            var child = mTrans.GetChild(0);
            if (child != null)
            {
                child.parent = _myTable.transform.parent;
                child.name = "__cacheObject__";
                obj = child.gameObject;
                obj.SetActive(false);
            }
        }
        int childCount = _myTable.transform.childCount;
        for (int i = 0; i < Math.Max(num, childCount); i++)
        {
            GameObject go = null;
            if (i >= childCount)
            {
                if (obj == null)
                {
                    obj = ClientTool.load(path, _myTable.transform.parent.gameObject);
                    obj.name = "__cacheObject__";
                    obj.SetActive(false);
                    go = go = _myTable.AddChild(obj);
                }
                else
                {
                    go = _myTable.AddChild(obj);
                }
                if (obj == null) return lTb;
                go.SetActive(true);
                //列表少于需要的数量，加入新的
                var comp = go.GetComponent<UluaBinding>();
                if (comp)
                {
                    comp.CallUpdateWithArgs(new object[] { list[i], i, _myTable, target });
                    lTb[i + 1] = comp;
                }
                go.name = "cell" + i;
            }
            else
            {
                var t = mTrans.GetChild(i);
                go = t.gameObject;
                if (i < num)
                {
                    go.SetActive(true);
                    var comp = go.GetComponent<UluaBinding>();
                    if (comp)
                    {
                        //comp.CallUpdateWithArgs(list[i], i, _myTable);
                        comp.CallUpdateWithArgs(new object[] { list[i], i, _myTable, target });
                        lTb[i + 1] = comp;
                    }
                    go.name = "cell" + i;
                }
                else
                {
                    go.SetActive(false);
                }

            }
        }
        target = null;
        _myTable.repositionNow = true;
        return lTb;
    }

    #endregion

    static public void AddClick(Transform tran, LuaFunction fn)
    {
        AddClick(tran.gameObject, fn);
    }
    static public void AddClick(GameObject go, LuaFunction fn)
    {
        if (fn == null) return;
        if (go.GetComponent<Collider>() == null) { go.AddComponent<BoxCollider>(); }
        UIEventListener.Get(go).onClick = (g) =>
        {
            double time = Time.realtimeSinceStartup;
            if (time - clickTime < 0.6f)
            {
                return;
            }
            clickTime = time;
            fn.call();
        };
    }
    static public void AddClick(Component com, LuaFunction fn)
    {
        AddClick(com.gameObject, fn);
    }
    static private long ToUnixTime(DateTime date)
    {
        var epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        return Convert.ToInt64((date.ToUniversalTime() - epoch).TotalMilliseconds);
    }
    static public long GetNowTime(double milliTime)
    {
        //long timeTricks = new DateTime(1970, 1, 1).Ticks + (long)milliTime * 10000 +
        //    TimeZone.CurrentTimeZone.GetUtcOffset(DateTime.Now).Hours * 3600 * (long)10000000;
        double time = ToUnixTime(DateTime.Now);
        //long time = Network.Instance.serverToClientTime();
        double deviationTime = milliTime - Network.Instance.serverToClientTime((long)time);
        //Debug.Log(time + "  ----->" + Network.Instance.serverToClientTime((long)time) + "  :" + deviationTime);
        return (long)(deviationTime / Math.Pow(10, 3));
    }

    private static readonly int UINT32TIME_YEARMASK = 0x7c000000;  // 5 0x1f
    private static readonly int UINT32TIME_YEARSHIFT = 26;
    private static readonly int UINT32TIME_MONTHMASK = 0x03c00000; // 4 0xf
    private static readonly int UINT32TIME_MONTHSHIFT = 22;
    private static readonly int UINT32TIME_DAYMASK = 0x003e0000;   // 5 0x1f
    private static readonly int UINT32TIME_DAYSHIFT = 17;
    private static readonly int UINT32TIME_HOURMASK = 0x0001f000;  // 5 0x1f
    private static readonly int UINT32TIME_HOURSHIFT = 12;
    private static readonly int UINT32TIME_MINUTEMASK = 0x00000fc0;    // 6 0x3f
    private static readonly int UINT32TIME_MINUTESHIFT = 6;
    private static readonly int UINT32TIME_SECONDMASK = 0x0000003f;	// 6 0x3f

    static public double GetU32Time(int dwUInt32Timer)
    {
        int y = ((dwUInt32Timer & UINT32TIME_YEARMASK) >> UINT32TIME_YEARSHIFT) + 2000 - 1900;
        int m = (dwUInt32Timer & UINT32TIME_MONTHMASK) >> UINT32TIME_MONTHSHIFT+1;
        int d = (dwUInt32Timer & UINT32TIME_DAYMASK) >> UINT32TIME_DAYSHIFT;
        int h = (dwUInt32Timer & UINT32TIME_HOURMASK) >> UINT32TIME_HOURSHIFT;
        int i = (dwUInt32Timer & UINT32TIME_MINUTEMASK) >> UINT32TIME_MINUTESHIFT;
        int s = (dwUInt32Timer & UINT32TIME_SECONDMASK);

        DateTime now = new DateTime(y, m, d,h,i,s);

        return GetNowTime(now.Ticks / 1000);
    }


    /// <summary>
    /// 对齐目标位置
    /// </summary>
    /// <param name="go">要修改的对象</param>
    /// <param name="tran">目标对象</param>
    /// <param name="dir">方向，0为x，3为全部对齐，2为y</param>
    static public void AlignToObject(GameObject go, GameObject tran, int dir)
    {
        var pos = tran.transform.position;
        var tempPos = go.transform.position;
        if (dir == 0)
        {
            tempPos.x = pos.x;
        }
        else if (dir == 2)
        {
            tempPos.y = pos.y;
        }
        else
        {
            tempPos = pos;
        }
        go.transform.position = tempPos;
    }

    static public void AlignToObject(GameObject go, GameObject tran)
    {
        AlignToObject(go, tran, 0);
    }

		static public void popGMUI()
    {
        LuaManager.getInstance().CallLuaFunction("GameManager.ShowGMUI");
    }

    #region 退出游戏
    static public void quitGame()
    {
        LuaManager.getInstance().CallLuaFunction("GameManager.QuitGame");
    }

    static public void onQuit()
    {
        DataEyeTool.Quit();
        Application.Quit();
    }
    #endregion

    #region 加载场景

    /// <summary>
    /// 加载场景,有进度条显示
    /// </summary>
    /// <param name="name">场景名</param>
    /// <param name="cb">回调</param>
    static public void beginLoadScene(string name, LuaFunction cb = null)
    {
    }

    /// <summary>
    /// 加载场景，无进度条
    /// </summary>
    /// <param name="name"></param>
    /// <param name="callBack"></param>
    static public void LoadLevel(string name, LuaFunction callBack = null)
    {
        if (name == "login")
        {
            UIMrg.Ins.logout();
            Application.LoadLevel(name);
        }
    }

    static public void DestoryScene() 
    {
    }
    #endregion

    /// <summary>
    /// 显示请求loading
    /// </summary>
    static public void showLoading()
    {
        ApiLoading.getInstance().show();
    }
    /// <summary>
    /// 隐藏请求loading
    /// </summary>
    static public void hideLoading()
    {
        ApiLoading.getInstance().hide();
    }

    static public void showFighting()
    {
        FightManager.Inst.show();
    }
    /// <summary>
    /// 隐藏请求loading
    /// </summary>
    static public void hideFighting()
    {
        FightManager.Inst.hide();
    }

    #region 动画

    /// <summary>
    /// 重置节点中的所有动画
    /// </summary>
    /// <param name="go"></param>
    /// <param name="mLastDirection"></param>
    static public void ResetAnimation(GameObject go, int mLastDirection = 0)
    {
        var mAnim = go.GetComponent<Animation>();
        if (mAnim == null) return;
        foreach (AnimationState state in mAnim)
        {
            if (mLastDirection == 1) state.time = state.length;
            else state.time = 0f;
        }
    }
    /// <summary>
    /// 播放动画
    /// </summary>
    /// <param name="go">有动画组件的对象，Animation或Animator</param>
    /// <param name="clipName">动画名</param>
    /// <param name="luaFunc">播放完成回调</param>
    /// <param name="forward">为true时向前播放，否则倒播</param>
    static public void PlayAnimation(GameObject go, string clipName, LuaFunction luaFunc = null, bool forward = true)
    {
        Animation ani = go.GetComponent<Animation>();
        ActiveAnimation activeAni = null;
        if (ani != null)
        {
            activeAni = ActiveAnimation.Play(ani, clipName, forward ? AnimationOrTween.Direction.Forward : AnimationOrTween.Direction.Reverse);
        }
        else
        {
            Animator animator = go.GetComponent<Animator>();
            if (animator == null) return;
            activeAni = ActiveAnimation.Play(animator, clipName, forward ? AnimationOrTween.Direction.Forward : AnimationOrTween.Direction.Reverse, AnimationOrTween.EnableCondition.DoNothing, AnimationOrTween.DisableCondition.DoNotDisable);
        }
        if (activeAni != null)
        {
            if (luaFunc != null)
            {
                EventDelegate.Add(activeAni.onFinished, () =>
                {
                    luaFunc.call();
                }, true);
            }
        }
    }
    #endregion

    /// <summary>
    /// 重置位置角度缩放。
    /// </summary>
    /// <param name="mTran"></param>
    static public void resetTransform(Transform mTran)
    {
        mTran.localEulerAngles = Vector3.zero;
        mTran.localPosition = Vector3.zero;
        mTran.localScale = Vector3.one;
    }

    /// <summary>
    /// ngui节点尝试修改
    /// </summary>
    /// <param name="go"></param>
    /// <param name="depth"></param>
    static public void AdjustDepth(GameObject go, int depth)
    {
        NGUITools.AdjustDepth(go, depth);
    }

    static public List<object> LuaTableToCSharp(LuaTable list)
    {
        List<object> li = new List<object>();
        foreach (var i in list)
        {
            li.Add(i.value);
        }
        return li;
    }
    static public void HideAllChildren(GameObject go)
    {
        var tran = go.transform;
        for (int i = 0; i < tran.childCount; i++)
        {
            tran.GetChild(i).gameObject.SetActive(false);
        }
    }

    static public void SetLayerByNane(GameObject go, string name)
    {
        LayerMask mask = LayerMask.NameToLayer(name);
        NGUITools.SetLayer(go, mask);
    }
    static public void release()
    {
        Resources.UnloadUnusedAssets();
        TextureCache.getInstance().removeUnusedTextures();
        System.GC.Collect();
    }

    static public void gcCollect()
    {
        System.GC.Collect();
    }

    static public bool IsLow()
    {
        return QualityManager.IsLow();
    }
    static public void freeList(IList list)
    {
        for (int i = 0; i < list.Count; i++)
        {
            list[i] = null;
        }
        list.Clear();
    }

    static public void PlayTweenPostion(GameObject go, GameObject form, float dur, LuaFunction fn = null)
    {
        Vector3 pos = go.transform.position;
        go.transform.position = form.transform.position;
        UITweener tween = TweenPosition.Begin(go, dur, pos, true);
        var com = go.GetComponents<UITweener>();
        for (int i = 0; i < com.Length; i++)
        {
            var t = com[i];
            t.ResetToBeginning();
            t.enabled = true;
        }

        if (tween && fn != null)
        {
            tween.onFinished.Clear();

            tween.SetOnFinished(() =>
            {
                fn.call();
                if (tween)
                {
                    tween.onFinished.Clear();
                }
                tween = null;
            });
        }
    }
    static public GameObject AddChild(GameObject go, GameObject parent)
    {
        go = NGUITools.AddChild(parent, go);
        go.name = go.name.Replace("(Clone)", "");
        return go;
    }
    public static void ForEachJsonObject(JsonObject jo, LuaFunction lua)
    {
        foreach (var item in jo)
        {
            lua.call(item.Key, item.Value);
        }
    }
    static public void ResetTweener(GameObject go)
    {
        UITweener[] com = go.GetComponents<UITweener>();
        for (int i = 0; i < com.Length; i++)
        {
            com[i].ResetToBeginning();
            com[i].enabled = true;
        }
    }
}

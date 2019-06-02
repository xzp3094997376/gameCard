/*************************************************************************************
 * 类 名 称：       uLuaBinding
 * 命名空间：       Assets.uCsharpFramework
 * 创建时间：       2014/8/30 21:28:35
 * 作    者：       Oliver shen
 * 说    明：       
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
using System;
using SimpleJson;

[ExecuteInEditMode]
public class UluaBinding : MonoBehaviour
{
    #region 常量，lua中的事件名
    /// <summary>
    /// lua事件，脚本初始化完毕调用
    /// </summary>
    public const string START = "Start";
    /// <summary>
    /// lua事件，脚本销毁时调用
    /// </summary>
    public const string ON_DESTROY = "OnDestroy";
    /// <summary>
    /// lua点击事件方法，通过判断第二个参数可分不同事件 
    /// 例：
    /// function Main:onClick(go,name) 
    ///     if name == "btn1" then 
    ///         --doSomething 
    ///     elseif name == "btn2" 
    ///         --doSomething 
    ///     end 
    /// end
    /// </summary>
    public const string ON_CLICK = "onClick";
    public const string ON_SCROLL = "OnScroll";
    public const string ON_PRESS = "onPress";
    public const string ON_DRAG = "OnDrag";
    private const string ON_ENABLE = "OnEnable";
    private const string ON_DISABLE = "OnDisable";
    /// <summary>
    /// 用于外部更新lua脚本对象的内容，例如在MyTable中
    /// 关联请看：
    ///  <see cref="ClientTool.CreateTableByNameAndNum"/>
    /// </summary>
    public const string UPDATE = "update";

    /// <summary>
    /// 每个挂在UluaBinding的lua脚本都要有一个create方法，用来初始化，确定对象作用域
    /// 方法要返回self
    /// 例：
    /// --参数binding就是UluaBinding的实例对象
    /// function Main:create(binding)
    ///     self.binding = binding
    ///     return self
    /// end
    /// </summary>
    public const string CREATE = "create";

    /// <summary>
    /// lua事件，判断触发按下事件显示Tip,方法要返回一个字符串用于tip显示
    /// 例：
    /// function Main:onTooltip(name) 
    ///     if name == "kill1" then
    ///         return "点击了技能1"
    ///     elseif name == "kill2" then
    ///         return "点击了技能2"
    ///    end
    /// end
    /// </summary>
    public const string ON_TOOLTIP = "onTooltip";

    #endregion

    #region 私有属性
    private bool isInited = false;
    [HideInInspector]
    [SerializeField]
    public LuaVariable[] mVariables;
    private LuaFunction _callBack;


    [HideInInspector]
    [SerializeField]
    string mPath = "";

    //private bool _isCallUpdate = false;
    //Action luaOnUpdate = null;
    Hashtable mLuaMap;
    LuaTable mConstMap;
    LuaTable _map;
    public LuaTable Map
    {
        get
        {
            if (_map == null)
            {
                _map = new LuaTable(LuaManager.luaState);
                foreach (DictionaryEntry i in mLuaMap)
                {
                    _map[i.Key.ToString()] = ((LuaVariable)i.Value).val;
                }
            }
            return _map;
        }
    }

    LuaFunction onEnter;
    LuaFunction onExit;
    LuaFunction _onDestroy;
    LuaFunction _onUpdate;
    LuaFunction _onClick;
    LuaFunction _onScroll;
    LuaFunction _onDrag;
    LuaFunction _onPress;
    LuaFunction _onEnable;
    LuaFunction _onDisable;

    List<Action> deltaCallFunction = new List<Action>();
    private Hashtable buttons = new Hashtable();
    #endregion

    /// <summary>
    /// 脚本的实例对象
    /// </summary>
    public LuaTable target;


    /// <summary>
    /// 脚本路径
    /// </summary>
    public string luaScriptPath
    {
        get { return mPath; }
        set { mPath = value; }
    }
    [HideInInspector]
    [SerializeField]
    public List<LuaKeyValue> KeyMap = new List<LuaKeyValue>();
    static private double clickTime = 0;

    public void RecallStart()
    {
        CallLuaFunction(target, START);
    }
    /// <summary>
    /// 开始运行
    /// </summary>
    void Start()
    {
        if (Application.isPlaying && !isInited)
        {
            if (string.IsNullOrEmpty(luaScriptPath)) return;
            //object o = LuaScriptMgr.Instance.doFile(luaScriptPath);
            //target = o as LuaTable;
            //LuaState state = TTLuaMain.Instance.luaState;
            object o = LuaManager.getInstance().DoFile(luaScriptPath);
            if (o == null)
            {
                MyDebug.LogError("lua 文件：" + luaScriptPath + " 没有返回值");
                target = null;
                return;
            }
            target = o as LuaTable;
            target["_keyMap"] = ConstMap;
            target["binding"] = this;
            target["gameObject"] = gameObject;
            Init();
        }

    }

    /// <summary>
    /// 初始化，加载lua脚本并绑定变量
    /// </summary>
    public void Init()
    {
        if (target != null)
        {
            //把变量附给lua对象
            if (mLuaMap == null)
            {
                mLuaMap = new Hashtable();
                for (int i = 0, iMax = mVariables.Length; i < iMax; i++)
                {
                    var val = mVariables[i];
                    mLuaMap.Add(val.name, val);
                    target[val.name] = val.val;
                }
            }
            isInited = true;
            var fn = LuaHelper.getTableFunction(target, CREATE);
            if (fn != null)
                fn.call(target, this);
            //fn.call(target, this);
            CallLuaFunction(target, START);
            _onUpdate = LuaHelper.getTableFunction(target, UPDATE);
            StartCoroutine(CallDeltaCallFunction());
            Invoke("_deltaInit", 0.2f);
        }
    }

    public void reStart() 
    {
        if (target == null) return;
        CallLuaFunction(target, START);
    }
    public float width
    {
        get
        {
            if (GlobalVar.Root)
            {
                float s = (float)GlobalVar.Root.activeHeight / Screen.height;
                int width = Mathf.CeilToInt(Screen.width * s);
                return width;
            }
            return Screen.width;
        }
    }
    public float height
    {
        get
        {
            if (GlobalVar.Root)
            {
                float s = (float)GlobalVar.Root.activeHeight / Screen.height;
                int height = Mathf.CeilToInt(Screen.height * s);
                return height;
            }
            return Screen.height;
        }
    }
    public void RemoveClick(string button)
    {
        object o = buttons[button];
        if (o == null) return;
        GameObject go = o as GameObject;
        UIEventListener listener = go.GetComponent<UIEventListener>();
        if (listener)
        {
            listener.onClick = null;
            listener.onPress = null;
        }
    }
    public void ClearClick()
    {
        foreach (DictionaryEntry de in buttons)
        {
            RemoveClick(de.Key.ToString());
        }
    }
    /// <summary>
    /// 销毁事件
    /// </summary>
    void OnDestroy()
    {
        try
        {
            if (Application.isPlaying)
            {
                if (_callBack != null)
                {
                    _callBack.call();
                }
                _callBack = null;
                if (_onDestroy != null) _onDestroy.call(target);

                ClearClick();

                buttons.Clear();

                buttons = null;
                int mVariablesCount = mVariables.Length;
                for (int i = 0; i < mVariablesCount; i++)
                {
                    mVariables[i].Dispose();
                    mVariables[i] = null;
                }
                mVariables = null;
                //mVariables.Clear();
                if (mLuaMap != null)
                {
                    //mLuaMap.Clear();
                    var key = mLuaMap.Keys;
                    List<string> li = new List<string>();
                    li.AddRange(li);
                    for (int i = 0; i < li.Count; i++)
                    {
                        mLuaMap[li[i]] = null;
                    }
                    mLuaMap.Clear();
                }
                mLuaMap = null;
                onEnter = null;
                onExit = null;
                _onDestroy = null;
                _onUpdate = null;
                _onClick = null;
                _onScroll = null;
                _onDrag = null;
                _onPress = null;
                _onEnable = null;
                _onDisable = null;
                int actionCount = deltaCallFunction.Count;
                for (int j = 0; j < actionCount; j++)
                {
                    deltaCallFunction[j] = null;
                }
                deltaCallFunction.Clear();
                deltaCallFunction = null;
                if (target != null)
                {
                    target["binding"] = null;
                    target = null;
                }
            }
        }
        catch (System.Exception error)
        {
            UnityEngine.Debug.Log(error);
        }

    }

    public LuaFunction getCallBack()
    {
        return _callBack;
    }
    public void CallOnEnter(bool isRoot = false)
    {
        try
        {
            if (onEnter != null)
            {
                if (isRoot)
                {
                    onEnter.call(target);
                }
                else
                {
                    StartCoroutine(WaitManyFrame(() =>
                    {
                        onEnter.call(target);
                    }, 2));
                }
            }
        }
        catch (System.Exception error)
        {
            UnityEngine.Debug.Log(error);
        }
    }
    public void CallOnExit()
    {
        try
        {
            if (onExit != null) onExit.call(target);
        }
        catch (System.Exception error)
        {
            UnityEngine.Debug.Log(error);
        }
    }
    /// <summary>
    /// 返回绑定的键值对
    /// </summary>

    public void playMusic(GameObject go)
    {
        try
        {
            AudoPlayType musicName = go.GetComponent<AudoPlayType>();
            if (musicName != null)
            {
                MusicManager.play(musicName.soundName);
            }
            else
            {
                MusicManager.playByID(16);
            }
        }
        catch (System.Exception error)
        {
            UnityEngine.Debug.Log(error);
        }
    }

    IEnumerator CallDeltaCallFunction()
    {
        for (int i = 0; i < deltaCallFunction.Count; i++)
        {
            try
            {

                deltaCallFunction[i]();
                deltaCallFunction[i] = null;
            }
            catch (System.Exception error)
            {
                UnityEngine.Debug.Log(error);
            }
            yield return null;
        }
        deltaCallFunction.Clear();

    }

    public LuaTable ConstMap
    {
        get
        {
            try
            {
                if (mConstMap == null)
                {
                    mConstMap = new LuaTable(LuaManager.luaState);
                    for (int i = 0; i < KeyMap.Count; i++)
                    {
                        var val = KeyMap[i];
                        mConstMap[val.Key] = val.value;
                    }
                }
                return mConstMap;
            }
            catch (System.Exception error)
            {
                UnityEngine.Debug.Log(error);
                return new LuaTable(LuaManager.luaState);
            }
        }
    }

    void OnEnable()
    {
        if (_onEnable != null)
        {
            _onEnable.call(target);
        }
    }

    void OnDisable()
    {
        if (_onDisable != null)
        {
            _onDisable.call(target);
        }
    }

    /// <summary>
    /// 延迟初始化。
    /// </summary>
    private void _deltaInit()
    {
        onEnter = LuaHelper.getTableFunction(target, "onEnter");
        onExit = LuaHelper.getTableFunction(target, "onExit");
        _onDestroy = LuaHelper.getTableFunction(target, ON_DESTROY);
        _onClick = LuaHelper.getTableFunction(target, ON_CLICK);
        _onScroll = LuaHelper.getTableFunction(target, ON_SCROLL);
        _onDrag = LuaHelper.getTableFunction(target, ON_DRAG);
        _onPress = LuaHelper.getTableFunction(target, ON_PRESS);
        _onEnable = LuaHelper.getTableFunction(target, ON_ENABLE);
        _onDisable = LuaHelper.getTableFunction(target, ON_DISABLE);
        for (int i = 0, iMax = mVariables.Length; i < iMax; i++)
        {
            var val = mVariables[i];
            if (val.type == "UIButton" || val.type == "MyUIButton")
            {

                if (_onClick != null)
                {
                    if (val.gameObject == null) Debug.LogError(val.name + ": gameObject is null");
                    UIEventListener.Get(val.gameObject).onClick += (GameObject go) =>
                    {
                        double time = Time.realtimeSinceStartup;
                        if (time - clickTime < 0.1f)
                        {
                            return;
                        }
                        clickTime = time;
                        playMusic(go);
                        if (target != null)
                        {
                            _onClick.call(target, val.val, val.name);
                        //GuideManager.CallNext(go);
                        Messenger.BroadcastObject("GuideNext", go);
#if UNITY_EDITOR
                            record(go);
#endif
                        }
                    };
                }
                if (_onScroll != null)
                {
                    if (val.gameObject == null) Debug.LogError(val.name + ": gameObject is null");
                    UIEventListener.Get(val.gameObject).onScroll += (GameObject go,float fDetal) =>
                    {                      
                        if (target != null)
                        {
                            _onScroll.call(target, val.val, val.name, fDetal);
                            //GuideManager.CallNext(go);
                            //Messenger.BroadcastObject("GuideNext", go);
#if UNITY_EDITOR
                            record(go);
#endif
                        }
                    };
                }
                if (_onDrag != null)
                {
                    if (val.gameObject == null) Debug.LogError(val.name + ": gameObject is null");
                    UIEventListener.Get(val.gameObject).onDrag += (GameObject go, Vector2 vDetal) =>
                    {
                        if (target != null)
                        {
                            _onDrag.call(target, val.val, val.name, vDetal);
                            //GuideManager.CallNext(go);
                            //Messenger.BroadcastObject("GuideNext", go);
#if UNITY_EDITOR
                            record(go);
#endif
                        }
                    };
                }
                if (_onPress != null)
                {
                    UIEventListener.Get(val.gameObject).onPress = (GameObject go, bool ret) =>
                    {
                        if (target != null)
                        {
                            _onPress.call(target, val.val, val.name, ret);
                        }
                    };
                }
                buttons.Add(val.name, val.gameObject);
            }
        }
    }
    public static bool recordGuideStep = true;

#if UNITY_EDITOR

    void record(GameObject go)
    {
        if (!recordGuideStep) return;
        if (go == null) return;
        string path = go.name;
        Transform parent = go.transform.parent;
        while (parent)
        {
            path = parent.name + "/" + path;
            parent = parent.parent;
        }
        path = "{ \"guide\", path = \"" + path + "\",say = \"\",pos = \"left\", event = \"GuideNext\" }\n";
        FileUtils.getInstance().writeFileStream(Application.dataPath + "/Z_Test/guideStep.txt", new List<byte[]> { System.Text.Encoding.UTF8.GetBytes(path) });
    }
#endif

    #region 反射调用,常用方法封装
    /// <summary>
    /// 查找字典里是否包括名称为key的变量
    /// </summary>
    /// <param name="key"></param>
    /// <returns></returns>
    private LuaVariable GetValueByKey(string key)
    {
        if (mLuaMap == null)
        {
            return null;
        }
        if (mLuaMap.ContainsKey(key))
        {
            return mLuaMap[key] as LuaVariable;
        }
        else
        {
            MyDebug.Log("没有这个变量：" + key);
        }
        return null;
    }


    public void Show(string key)
    {
        var lua = GetValueByKey(key);
        if (lua != null)
        {
            lua.Show();
        }
    }
    public void Hide(string key)
    {
        var lua = GetValueByKey(key);
        if (lua != null)
        {
            lua.Hide();
        }
    }
    public void ChangeColor(string key, string color)
    {
        ChangeColor(key, color, 0);
    }
    public void ChangeColor(string key, string color, int index)
    {
        var lua = GetValueByKey(key);
        if (lua != null)
        {
            lua.ChangeColor(color, index);
        }
    }
    public void ChangeColor(string key, Color color)
    {
        var lua = GetValueByKey(key);
        if (lua != null)
        {
            lua.ChangeColor(color);
        }
    }
    public void Play(string key, string aniName)
    {
        Play(key, aniName, null);
    }
    /// <summary>
    /// 播放节点中的动画
    /// </summary>
    /// <param name="key">节点key</param>
    /// <param name="aniName">动画名</param>
    /// <param name="cb">播放完成回调方法</param>
    public void Play(string key, string aniName, Action cb)
    {
        var lua = GetValueByKey(key);
        if (lua != null)
        {
            if (cb == null)
                lua.Play(aniName);
            else
            {
                lua.Play(aniName, () =>
                {
                    cb.Invoke();
                });
            }
        }
    }


    /// <summary>
    /// 延后time秒执行函数func
    /// </summary>
    /// <param name="time"></param>
    /// <param name="func"></param>
    public void CallAfterTime(double time, Action func)
    {
        if (func == null || !gameObject.activeInHierarchy) return;
        float fTime = (float)time;
        StartCoroutine(Wait(fTime, func));
    }

    public void CallFixedUpdate(Action func)
    {
        if (func == null || !gameObject.activeInHierarchy) return;
        StartCoroutine(WaitFixedUpdate(func));
    }
    public void CallManyFrame(Action func)
    {
        CallManyFrame(func, 1);
    }
    public void CallManyFrame(Action func, int frame)
    {
        if (func == null || !gameObject.activeInHierarchy) return;
        StartCoroutine(WaitManyFrame(func, frame));
    }

    private IEnumerator WaitManyFrame(Action cb, int frame)
    {
        int i = 0;
        while (i < frame)
        {
            yield return null;
            i++;
        }
        if (cb != null) cb();
    }
    public void CallEndOfFrame(Action func)
    {
        if (func == null || !gameObject.activeInHierarchy) return;
        StartCoroutine(WaitEndOfFrame(func));
    }

    public IEnumerator WaitFixedUpdate(Action cb)
    {
        yield return new WaitForFixedUpdate();
        if (cb != null) cb();
    }
    public IEnumerator WaitEndOfFrame(Action cb)
    {
        yield return new WaitForEndOfFrame();
        if (cb != null) cb();
    }

    public IEnumerator Wait(float time, Action cb)
    {
        yield return new WaitForSeconds(time);
        if (cb != null) cb();
    }

    public void LoadModel(int charId, GameObject parent, string aniName, LuaFunction cb)
    {
        LoadModel(charId, parent, aniName, cb, false);
    }
    /// <summary>
    ///  加载模型
    /// </summary>
    /// <param name="charId">角色id</param>
    /// <param name="parent">父节点</param>
    /// <param name="aniName">动画名</param>
    /// <param name="cb">回调</param>
    public void LoadModel(int charId, GameObject parent, string aniName, LuaFunction cb, bool isTranform)
    {
        if (string.IsNullOrEmpty(aniName)) aniName = "stand";
        JsonObject jo = TableReader.Instance.TableRowByID("char", charId);
        int _id = jo.num("model_id");
        string modelName = jo.str("name");
        Transform mTran = null;
        if (parent != null)
        {
            //检查是否模型已加载过。
            mTran = parent.transform;
            bool find = false;
            AvatarCtrl findAct = null;
            for (int i = 0; i < mTran.childCount; i++)
            {
                var go = mTran.GetChild(i).gameObject;
                if (go.name == modelName)
                {
                    go.SetActive(true);
                    find = true;
                    findAct = go.GetComponent<AvatarCtrl>();
                    findAct.PlayAnimation(aniName, true);
                }
                else
                {
                    go.SetActive(false);
                }
            }

            if (find)
            {
                if (cb != null)
                {
                    cb.call(target, findAct);
                }
                return;
            }
        }
        //未加载过，开始新的加载
        AvatarLoad.Instance.LoadAvatar(_id, (AvatarCtrl act) =>
        {
            act.PlayAnimation(aniName, true);
            if (mTran != null)
            {
                act.transform.parent = mTran;
                NGUITools.SetLayer(act.gameObject, mTran.gameObject.layer);
            }
            act.transform.localScale = Vector3.one;
            act.transform.eulerAngles = new Vector3(0, 180, 0);
            act.transform.localPosition = Vector3.zero;
            act.gameObject.name = jo.str("name");
            if (cb != null) cb.call(target, act);
        }, isTranform);
    }
    #endregion

    /// <summary>
    /// 快速调用lua对象中的方法
    /// </summary>
    /// <param name="luaTable">lua对象</param>
    /// <param name="functionName">方法名</param>
    /// <param name="args">参数</param>
    /// <returns></returns>
    static public object CallLuaFunction(LuaTable luaTable, string functionName, params object[] args)
    {
        return LuaHelper.CallLuaFunction(luaTable, functionName, args);
    }
    /// <summary>
    /// 调用lua的update方法
    /// </summary>
    /// <param name="p"></param>
    /// <param name="i"></param>
    /// <param name="_myTable"></param>
    public void CallUpdateWithArgs(params object[] args)
    {
        //_isCallUpdate = true;
        if (target != null)
        {
            int actionCount = deltaCallFunction.Count;
            for (int j = 0; j < actionCount; j++)
            {
                deltaCallFunction[j] = null;
            }
            deltaCallFunction.Clear();
            CallLuaFunction(target, UPDATE, args);
        }
        else
        {
            deltaCallFunction.Add(() =>
            {
                CallLuaFunction(target, UPDATE, args);
            });
            //luaOnUpdate = () =>
            //{
            //    CallLuaFunction(target, UPDATE, args);
            //};
        }
    }

    /// <summary>
    /// 通知调用lua的update方法
    /// </summary>
    /// <param name="args"></param>
    public void CallUpdate(object args)
    {
        //_isCallUpdate = true;
        if (target != null)
        {
            try
            {
                int actionCount = deltaCallFunction.Count;
                for (int j = 0; j < actionCount; j++)
                {
                    deltaCallFunction[j] = null;
                }
                deltaCallFunction.Clear();
                //CallLuaFunction(target, UPDATE, args);
                if (_onUpdate != null) _onUpdate.call(target, args);
            }
            catch (System.Exception error)
            {
                UnityEngine.Debug.Log(error);
            }

        }
        else
        {
            //luaOnUpdate = () =>
            //{
            //    CallLuaFunction(target, UPDATE, args);
            //};
            try
            {
                deltaCallFunction.Add(() =>
               {
               //CallLuaFunction(target, UPDATE, args);
               if (_onUpdate != null) _onUpdate.call(target, args);

               });
            }
            catch (System.Exception error)
            {
                UnityEngine.Debug.Log(error);
            }

        }
    }

    /// <summary>
    /// 字符对齐方式。
    /// </summary>
    /// <param name="lab"></param>
    /// <param name="str"></param>
    /// <param name="len">长度判断，如果str的长度大于len，左对齐，否则右对齐</param>
    public void SetLabelAlignment(UILabel lab, string str, int len)
    {
        int type = 2;
        if (str.Length > len) type = 1;
        lab.alignment = (NGUIText.Alignment)type;
    }

    public object CallTargetFunction(string name, params object[] lua)
    {
        if (target != null)
        {
            int actionCount = deltaCallFunction.Count;
            for (int j = 0; j < actionCount; j++)
            {
                deltaCallFunction[j] = null;
            }
            deltaCallFunction.Clear();
            return CallLuaFunction(target, name, lua);
        }            
        else
        {
            deltaCallFunction.Add(() =>
            {
                CallLuaFunction(target, name, lua);
            });
            return null;
        }
    }
    public object CallTargetFunctionWithLuaTable(string name, object lua)
    {
        if (target != null)
        {
            int actionCount = deltaCallFunction.Count;
            for (int j = 0; j < actionCount; j++)
            {
                deltaCallFunction[j] = null;
            }
            deltaCallFunction.Clear();
            return CallLuaFunction(target, name, lua);
        }
        else
        {
            deltaCallFunction.Add(() =>
            {
                CallLuaFunction(target, name, lua);
            });
            return null;
        }
    }
    /// <summary>
    /// 获得luaTable的self对象
    /// </summary>
    /// <returns></returns>
    public LuaTable GetTarget()
    {
        return target;
    }

    /// <summary>
    /// 关闭该组件时会触发fn方法
    /// </summary>
    /// <param name="fn"></param>
    public void SetCallBack(LuaFunction fn)
    {
        _callBack = fn;
    }
    public void PlayTween(string key, float dur)
    {
        PlayTween(key, dur, null);
    }
    public void PlayTween(string key, float dur, Action fn)
    {
        var lua = GetValueByKey(key);
        if (lua != null)
        {
            GameObject go = lua.gameObject;
            Vector3 pos = go.transform.position;
            UITweener tween = null;
            var com = go.GetComponents<UITweener>();
            for (int i = 0; i < com.Length; i++)
            {
                var t = com[i];
                t.ResetToBeginning();
                t.enabled = true;
                if (i == 0)
                {
                    tween = t;
                }
            }

            if (tween && fn != null)
            {
                //EventDelegate.Callback cb = delegate
                //{
                //    CallManyFrame(fn, 2);
                //};
                //tween.SetOnFinished(new EventDelegate(cb));
                CallAfterTime(dur, fn);

            }

        }
    }
    internal void OnRecyclePool()
    {
        //MyDebug.Log("回收内存池。。");
        //CallLuaFunction(target, "OnRecycle");
    }
    static public void OnRecycle()
    {
        //CallLuaFunction((LuaTable)TTLuaMain.Instance.luaState["LuaMain"], "collect");
    }                               

    public void MoveToPos(GameObject go, float durtime, Vector3 pos1)
    {
        MoveToPos(go, durtime, pos1, null);
    }
    /// <summary>
    /// move a gameObject to the position
    /// </summary>
    /// <param name="go">Go.</param>
    /// <param name="durtime">Durtime.</param>
    /// <param name="pos1">Pos1.</param>
    /// <param name="fn">Fn.</param>
    public void MoveToPos(GameObject go, float durtime, Vector3 pos1, Action fn)
    {
        if (go == null)
            return;
        UITweener tweenPos = null;

        tweenPos = TweenPosition.Begin(go, durtime, pos1);
        if (fn != null)
        {
            //EventDelegate.Callback cb = delegate
            //{
            //    CallManyFrame(fn, 2);
            //};
            //tweenPos.SetOnFinished(new EventDelegate(cb));
            CallAfterTime(durtime, fn);

        }
    }

    public void RotTo(GameObject go, float durtime, Quaternion rot)
    {
        RotTo(go, durtime, rot, null);
    }
    public void RotTo(GameObject go, float durtime, Quaternion rot, Action fn)
    {
        if (go == null)
            return;
        UITweener tweenRot = TweenRotation.Begin(go, durtime, rot);
        if (fn != null)
        {
            //EventDelegate.Callback cb = delegate
            //{
            //    CallManyFrame(fn, 2);
            //};
            //tweenRot.SetOnFinished(new EventDelegate(cb));
            CallAfterTime(durtime, fn);

        }
    }
    public void ScaleToGameObject(GameObject go, float durtime, Vector3 pos1)
    {
        ScaleToGameObject(go, durtime, pos1, null);
    }
    public void ScaleToGameObject(GameObject go, float durtime, Vector3 pos1, Action fn)
    {
        if (go == null)
            return;
        UITweener tweenScale = null;

        tweenScale = TweenScale.Begin(go, durtime, pos1);

        if (fn != null)
        {
            //tweenScale.onFinished.Clear();
            //EventDelegate.Callback cb = delegate{
            //    tweenScale.enabled = false;
            //    CallManyFrame(fn,2);
            //};
            //tweenScale.SetOnFinished(new EventDelegate(cb));
            CallAfterTime(durtime, fn);

        }
        else
        {
            //if (tweenScale)
            //{
            //    tweenScale.SetOnFinished(new EventDelegate());
            //}
            //tweenScale = null;

        }
    }
    public void ScalePage(int type, GameObject go, float durtime)
    {
        ScalePage(type, go, durtime, null);
    }
    /// <summary>
    /// Scales the page.
    /// </summary>
    /// <param name="type">Type. 1 = show  2 =  close </param>
    /// <param name="go">Go. show this go </param>
    /// <param name="durtime">Durtime</param>
    public void ScalePage(int type, GameObject go, float durtime, Action fn)
    {
        if (go == null)
            return;
        if (type == 1)
        {
            UIWidget com = CheckRootUIWidgetCom();
            if (com != null)
                com.alpha = 0;
        }
        UITweener tweenScale = null;

        if (type == 1)
        {
            StartCoroutine(WaitEndOfFrame(() =>
            {
                go.transform.localScale = new Vector3(0, go.transform.localScale.y, 1);
                TweenAlpha.Begin(this.gameObject, durtime, 1);
                tweenScale = TweenScale.Begin(go, durtime, Vector3.one);
                if (fn != null)
                {
                //EventDelegate.Callback cb = delegate
                //{
                //    tweenScale.enabled = false;
                //    CallManyFrame(fn, 2);
                //};
                //tweenScale.SetOnFinished(new EventDelegate(cb));
                CallAfterTime(durtime, fn);

                }
            }));
        }
        else
        {
            TweenAlpha.Begin(this.gameObject, durtime, 0);
            tweenScale = TweenScale.Begin(go, durtime, new Vector3(0, go.transform.localScale.y, 1));
            tweenScale.PlayForward();
            //			MyDebug.Log("SCALE"); 
            if (fn != null)
            {
                //EventDelegate.Callback cb = delegate
                //{
                //    tweenScale.enabled = false;
                //    CallManyFrame(fn, 2);
                //};
                //tweenScale.SetOnFinished(new EventDelegate(cb));
                CallAfterTime(durtime, fn);

            }
        }
    }
    public UIWidget CheckRootUIWidgetCom()
    {
        UIWidget com = this.gameObject.GetComponent<UIWidget>();
        if (com)
            return com;
        else
        {
            com = this.gameObject.AddComponent<UIWidget>();
            return com;
        }
    }
    public void DestroyObject(GameObject go)
    {
        DestroyObject(go, 0);
    }
    public void DestroyObject(GameObject go, float time)
    {
        if (go)
            GameObject.Destroy(go, time);
    }
    public void fadeIn(GameObject go, float time)
    {
        fadeIn(go, time, null);
    }
    public void fadeIn(GameObject go, float time, Action fn)
    {
        TweenAlpha alpha = TweenAlpha.Begin(go, time, 1);
        alpha.from = 0;
        if (fn != null)
        {
            //EventDelegate.Callback cb = delegate
            //{
            //    alpha.enabled = false;
            //    CallManyFrame(fn, 2);
            //};
            //alpha.SetOnFinished(new EventDelegate(cb));
            CallAfterTime(time, fn);

        }
        else
        {
            //alpha.onFinished.Clear();
        }
    }
    public void fadeOut(GameObject go, float time)
    {
        fadeOut(go, time, null);
    }
    public void fadeOut(GameObject go, float time, Action fn)
    {
        TweenAlpha alpha = TweenAlpha.Begin(go, time, 0);
        alpha.from = 1;
        if (fn != null)
        {
            //EventDelegate.Callback cb = delegate
            //{
            //    alpha.enabled = false;
            //    CallManyFrame(fn, 2);
            //};
            //alpha.SetOnFinished(new EventDelegate(cb));
            CallAfterTime(time, fn);
        }
        else
        {
            //alpha.onFinished.Clear();
        }
    }
    public void moveTo(GameObject go, Vector3 form, Vector3 to, float time)
    {
        moveTo(go, form, to, time, false);
    }
    public void moveTo(GameObject go, Vector3 form, Vector3 to, float time, bool isWord)
    {
        TweenPosition p = TweenPosition.Begin(go, time, to, isWord);
        p.from = form;
    }

}

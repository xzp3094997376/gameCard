/*************************************************************************************
 * 类 名 称：       UIMrg
 * 命名空间：       Assets.Scripts.manager
 * 创建时间：       2014/10/11 11:32:44
 * 作    者：       Oliver shen
 * 说    明：       
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using SLua;

public class UIModule
{
    static public int panelDepth = 6;
    static public Dictionary<string, GameObject> _dontDestroyUI = new Dictionary<string, GameObject>();
    public GameObject gameObject;
    public UluaBinding binding;
    public bool dontDestroy;
    public string gamePath;
    private UIPanel topPanel;
    private GameObject topLayer;
    private List<GameObject> _windowList;
    private UIPanel mPanel;
    private object topMenuData;
    private GameObject mParent;
    public UIModule()
    {
        init();
    }
    public string name
    {
        get;
        set;
    }
    public UIModule(UluaBinding bind)
    {
        init();
        binding = bind;
        gameObject = binding.gameObject;
        if (gameObject.GetComponent<DontDestroyUI>() != null && !QualityManager.IsLow())
        {
            dontDestroy = true;
        }
        else
        {
            dontDestroy = false;
        }
        SetActive(false);
        gameObject.transform.parent = mParent.transform;
        mParent.name = "Module_" + gameObject.name;
        CountModule(mParent.name);
    }
    public UIModule(GameObject go)
    {
        init();
        gameObject = go;
        if (gameObject.GetComponent<DontDestroyUI>() != null && !QualityManager.IsLow())
        {
            dontDestroy = true;
        }
        else
        {
            dontDestroy = false;
        }
        binding = go.GetComponent<UluaBinding>();
        SetActive(false);

        gameObject.transform.parent = mParent.transform;
        mParent.name = "Module_" + gameObject.name;
        CountModule(mParent.name);
    }
    public UIModule(string pabsPath)
    {
        gamePath = pabsPath;
        init();
        SetActive(false);
        gameObject = ClientTool.load(pabsPath, mParent);
        if (gameObject.GetComponent<DontDestroyUI>() != null && !QualityManager.IsLow())
        {
            dontDestroy = true;
        }
        else
        {
            dontDestroy = false;
        }
        binding = gameObject.GetComponent<UluaBinding>();
        mParent.name = "Module_" + gameObject.name;
        CountModule(mParent.name);
    }
    private void CountModule(string ctrlName)
    {
        //ctrlName = ctrlName.Replace("(Clone)", "");
        //ctrlName = ctrlName.Replace("Module_", "");
        //if (!string.IsNullOrEmpty(ctrlName))
        //    CacheAsset.Inst.CountCtrl(ctrlName);        
    }
    public Transform Find(string path)
    {
        path = path.Replace(mParent.name + "/", "");
        return mParent.transform.FindChild(path);
    }
    /// <summary>
    /// 初始化模块生成
    /// </summary>
    private void init()
    {
        //生成存放模块的panel
        _windowList = new List<GameObject>();
        mPanel = NGUITools.AddChild<UIPanel>(GlobalVar.center);
        mPanel.depth = 1;
        mParent = mPanel.gameObject;
        //mParent = NGUITools.AddChild(GlobalVar.center);
        //生成存放模块二次弹出窗口的panel
        topPanel = NGUITools.AddChild<UIPanel>(mParent);
        topPanel.depth = 6;
        topLayer = topPanel.gameObject;
        topLayer.name = "top_layer";
    }

    public void destroy()
    {
        //if (binding) binding.OnRecyclePool();
        clearWindow();
        if (mParent)
        {
            mParent.SetActive(false);
            GameObject.Destroy(mParent);
        }
        binding = null;
        //UluaBinding.OnRecycle();

        string ctrlName = name;
        if (mParent)
        {
            ctrlName = mParent.name;
        }
        //ctrlName = ctrlName.Replace("(Clone)", "");
        //ctrlName = ctrlName.Replace("Module_", "");
        //if (!string.IsNullOrEmpty(ctrlName))
        //    CacheAsset.Inst.ReleaseCtrl(ctrlName);
    }

    public void SetActive(bool ret)
    {
        if (mParent)
        {
            mParent.SetActive(ret);
        }
    }
    public void AddToDontDestroyList()
    {
        if (mParent)
        {
            mParent.transform.parent = GlobalVar.undestroy.transform;
            mParent.SetActive(false);
        }
    }

    public void AddToBackList()
    {
        if (mParent)
        {
            mParent.transform.parent = GlobalVar.center.transform;
            mParent.SetActive(true);
        }
    }
    public void update()
    {
        update(null);
    }
    //重新调用lua模块初始化方法
    public void update(object table)
    {
        if (table == null || binding == null) return;
        ApiLoading.getInstance().CallManyFrame(delegate
        {
            SetActive(true);
            if(binding != null)
                binding.CallUpdate(table);
        }, 1);
    }

    public void reStart()
    {
        if (binding == null) return;
        binding.reStart();
    }

    public void onEnter(bool isRoot = false)
    {
        if (binding == null) return;
        if (isRoot)
            binding.CallOnEnter(isRoot);
        else if (_windowList.Count == 0)
            binding.CallOnEnter(isRoot);

        foreach (var i in _windowList)
        {
            if (i)
                _onEnter(i);
        }
        //if (binding.GetTarget() != null)
        //{
        //    //UluaBinding.CallLuaFunction(binding.GetTarget(), "onEnter");
        //}
    }
    public void onExit()
    {
        if (binding == null) return;
        binding.CallOnExit();
        if (topMenuData != null) topMenuData = null;
        foreach (var i in _windowList)
        {
            if (i)
                _onExit(i);
        }
        //if (binding.GetTarget() != null)
        //{
        //    //UluaBinding.CallLuaFunction(binding.GetTarget(), "onExit");
        //}
    }

    private void AdjustPanelDepth(GameObject go) 
    {
        int depth = panelDepth;
        UIPanel[] panels = go.GetComponentsInChildren<UIPanel>(true);
        for (int i = 0; i < panels.Length; i++)
        {
            for (int j = i; j < panels.Length - 1; j++)
            {
                UIPanel temp;
                if (panels[i].depth >= panels[j + 1].depth)
                {
                    temp = panels[i];
                    panels[i] = panels[j + 1];
                    panels[j + 1] = temp;
                }
            }
        }
        for (int j = 0; j < panels.Length; j++) 
        {
            UIPanel panel = panels[j];
            setUIPanel sp = panel.gameObject.GetComponent<setUIPanel>();
            if (sp != null) UnityEngine.Object.Destroy(sp);
            panel.depth = ++depth;
        }
    }

    public void pushWindow(GameObject go)
    {
        _windowList.Add(go);
        go.SetActive(false);
        go.transform.parent = topLayer.transform;
        panelDepth += 10;
        UIPanel panel = go.GetComponent<UIPanel>();
        if (panel == null)
        {
            panel = go.AddComponent<UIPanel>();
        }
        setUIPanel sp = panel.gameObject.GetComponent<setUIPanel>();
        if (sp != null) UnityEngine.Object.Destroy(sp);
        panel.depth = 0;
        AdjustPanelDepth(go);
        //ApiLoading.getInstance().CallManyFrame(delegate
        //{
            if (go)
                go.SetActive(true);
        //}, 1);
    }

    //打开二级窗口，并返回lua数据
    public UluaBinding pushWindow(string pabsPath)
    {
        UluaBinding bind = null;
        if (_dontDestroyUI.ContainsKey(pabsPath))
        {
            bind = _dontDestroyUI[pabsPath].GetComponent<UluaBinding>();
        }
        else
        {
            bind = ClientTool.loadAndGetLuaBinding(pabsPath, topLayer);
            if (bind.gameObject.GetComponent<DontDestroyUI>() != null && !QualityManager.IsLow())
            {
                _dontDestroyUI[pabsPath] = bind.gameObject;
            }
        }
        
        pushWindow(bind.gameObject);
        return bind;
    }

    private void _onEnter(GameObject go)
    {
        UluaBinding bind = go.GetComponent<UluaBinding>();
        if (bind)
        {
            bind.CallOnEnter();
        }
    }
    private void _onExit(GameObject go)
    {
        UluaBinding bind = go.GetComponent<UluaBinding>();
        if (bind)
        {
            bind.CallOnExit();
        }
    }
    //关闭最外层二级窗口
    public void popWindow()
    {
        if (_windowList.Count > 0)
        {
            GameObject go = _windowList[_windowList.Count - 1];
            _windowList[_windowList.Count - 1] = null;
            _windowList.RemoveAt(_windowList.Count - 1);
            panelDepth -= 10;
            if (panelDepth < 6) panelDepth = 6;
            if (go)
            {
                if (_dontDestroyUI.ContainsValue(go))
                {
                    go.transform.parent = GlobalVar.undestroy.transform;
                    go.SetActive(false);
                }
                else
                {
                    GameObject.Destroy(go);
                }
                
            }
                
            if (_windowList.Count == 0)
            {
                onEnter();
            }
            else
            {
                go = _windowList[_windowList.Count - 1];
                if (go)
                    go.SetActive(true);
                _onEnter(_windowList[_windowList.Count - 1]);
            }
        }
    }
    public void clearWindow()
    {
        int len = _windowList.Count;
        for (int i = len - 1; i >= 0; i--)
        {
            GameObject go = _windowList[i];
            _windowList[i] = null;
            if (go)
            {
                if (_dontDestroyUI.ContainsValue(go))
                {
                    go.transform.parent = GlobalVar.undestroy.transform;
                    go.SetActive(false);
                }
                else
                {
                    GameObject.Destroy(go);
                }
            }
            panelDepth -= 10;
            if (panelDepth < 6) panelDepth = 6;
        }
        _windowList.Clear();
        //panelDepth = 6;
    }

    public void showTopMenu(object table)
    {
        topMenuData = table;
        resetTopMenu();
    }
    public void resetTopMenu()
    {
        if (topMenuData == null) return;
        UluaBinding bind = UIMrg.Ins.getTopMenu();
        if (bind)
        {
            //bind.transform.parent = mParent.transform;
            bind.gameObject.SetActive(true);
            //bind.transform.localPosition = Vector3.zero;

            bind.CallUpdate(topMenuData);
        }
    }
}
[CustomLuaClass]
public class UIMrg
{
    public static UIMrg _Ins;

    private List<UIModule> _stack;
    private List<UIModule> _removeList;
    private List<UIModule> _dontDestroy;
    private List<GameObject> _messageList;

    private UIModule runningModule = null;
    private UIModule _nextModule = null;
    private bool _sendCleanupToScene = false;
    private UluaBinding topMenu;
    private UluaBinding topTitle;
    private GameObject _top;
    public GameObject top
    {
        get
        {
            if (_top == null)
            {
                UIPanel topPanel = NGUITools.AddChild<UIPanel>(GlobalVar.loading.gameObject);
                topPanel.depth = 1000;
                _top = topPanel.gameObject;
            }
            return _top;
        }
    }
    public static UIMrg Ins
    {
        get
        {
            if (_Ins == null)
            {
                _Ins = new UIMrg();
            }
            return _Ins;
        }
    }
    public UIMrg()
    {
        this._removeList = new List<UIModule>();
        _messageList = new List<GameObject>();
        this._stack = new List<UIModule>();
        this._dontDestroy = new List<UIModule>();

    }
    public int GetModuleCount()
    {
        return _stack.Count;
    }

    public object CallRunnigModuleFunction(string fn, object lua)
    {
        if (runningModule != null && runningModule.binding != null)
            return runningModule.binding.CallTargetFunctionWithLuaTable(fn, lua);
        return null;
    }
    public object CallRunnigModuleFunctionWithArgs(string fn, params object[] lua)
    {
        if (runningModule != null && runningModule.binding != null)
            return runningModule.binding.CallTargetFunction(fn, lua);
        return null;
    }
    //从后台切回来调用
    public void resume()
    {
        if (runningModule != null)
        {
            callEnter(runningModule);
        }
    }

    public string GetRunningModuleName()
    {
        if (runningModule != null)
            return runningModule.name;
        return "";
    }

    public UIModule GetRunningModule()
    {
        return runningModule;
    }

    private void callEnter(UIModule module, bool isRoot = false)
    {
        module.onEnter(isRoot);
    }
    private void callExit(UIModule module)
    {
        module.onExit();
    }

    public void setTopTitle(UluaBinding topTitle)
    {
        this.topTitle = topTitle;
    }

    public void setTopMenu(UluaBinding go)
    {
        topMenu = go;
    }
    public UluaBinding getTopMenu()
    {
        return topMenu;
    }

    private void resetTopMenu()
    {
        if (topMenu)
        {
            topMenu.gameObject.SetActive(false);
            //topMenu.transform.parent = GlobalVar.MainUI.transform;
            //topMenu.transform.position = Vector3.one * 1000;
        }
    }
    private void draw()
    {
        resetTopMenu();
        UIModule g = null;
        if (this._sendCleanupToScene && this.runningModule != null)
        {
            if (this.runningModule.dontDestroy)
            {
                this.runningModule.AddToDontDestroyList();
                this._dontDestroy.Add(this.runningModule);
            }
            else
            {
                this._removeList.Add(this.runningModule);
            }
            
        }
        else if (this.runningModule != null)
        {
            g = this.runningModule;
            //ApiLoading.getInstance().CallManyFrame(delegate
            //{

            //}, 3);


        }
        this.runningModule = this._nextModule;
        //ApiLoading.getInstance().CallManyFrame(delegate
        //{
        this.runningModule.SetActive(true);

        if (g != null)
        {
            this.callExit(g);
            g.SetActive(false);
            g = null;
        }

        this.runningModule.resetTopMenu();
        this.callEnter(this.runningModule, _stack.Count == 1);
        //}, 0);


        int len = this._removeList.Count;
        while (len > 0)
        {
            UIModule go = this._removeList[len - 1];
            if (go != null)
            {
                this.callExit(go);
                go.destroy();
            }
            len--;
        }
        ClientTool.freeList(_removeList);
        //this._removeList.Clear();

    }

    public void replaceModule(UIModule go, bool ret)
    {
        if (go == null) throw new Exception("模块为空");
        this._removeList.Clear();

        if (ret)
        {
            int c = this._stack.Count;
            while (c > 1)
            {
                var current = this._stack[c - 1];
                if (current.dontDestroy)
                {
                    current.AddToDontDestroyList();
                    this._dontDestroy.Add(current);
                }
                else
                {
                    this._removeList.Add(current);
                }
                _stack[c - 1] = null;
                this._stack.RemoveAt(c - 1);
                c--;
            }
        }

        int i = this._stack.Count;
        if (i == 0)
        {
            this._sendCleanupToScene = true;
            this._stack.Add(go);
            this._nextModule = go;
        }
        else
        {
            this._sendCleanupToScene = true;
            this.runningModule = this._stack[i - 1];
            _stack[i - 1] = null;
            this._stack[i - 1] = go;
            this._nextModule = go;
        }
        this.draw();
    }
    public void replaceObject(GameObject go)
    {
        replaceObject(go, false);
    }
    public void replaceObject(GameObject go, bool ret)
    {
        replaceObjectWithName(go.name, go, ret);
    }
    public void replaceObjectWithName(string moduleName, GameObject go)
    {
        replaceObjectWithName(moduleName, go, false);
    }
    public void replaceObjectWithName(string moduleName, GameObject go, bool ret)
    {
        UIModule module = new UIModule(go);
        module.name = moduleName;
        replaceModule(module, ret);
    }

    public UluaBinding replace(params object[] args)
    {
        string moduleName = "";
        string pabsPath = "";
        object data = null;
        bool ret = false;
        int len = args.Length;
        object arg2, arg3;
        switch (len)
        {
            case 1:
                pabsPath = args[0].ToString();
                moduleName = System.IO.Path.GetFileNameWithoutExtension(pabsPath);
                break;
            case 2:
                arg2 = args[1];
                if (arg2 != null && arg2.GetType() == typeof(string))
                {
                    moduleName = args[0].ToString();
                    pabsPath = arg2.ToString();
                }
                else if (arg2 != null)
                {
                    pabsPath = args[0].ToString();
                    moduleName = System.IO.Path.GetFileNameWithoutExtension(pabsPath);
                    data = args[1];
                }
                break;
            case 3:
                arg2 = args[1];
                arg3 = args[2];

                if (arg2 != null && arg2.GetType() == typeof(string))
                {
                    moduleName = args[0].ToString();
                    pabsPath = arg2.ToString();
                    data = arg3;
                }
                else if (arg2 != null)
                {
                    pabsPath = args[0].ToString();
                    moduleName = System.IO.Path.GetFileNameWithoutExtension(pabsPath);
                    data = arg2;
                    ret = (bool)arg3;
                }
                break;
            case 4:
                moduleName = args[0].ToString();
                pabsPath = args[1].ToString();
                data = args[2];
                ret = (bool)args[3];
                break;
            default:
                return null;
        }
        UIModule module = getDontDestroyUI(pabsPath);
        if (module == null)
            module = new UIModule(pabsPath);
        module.name = moduleName;
        replaceModule(module, ret);
        module.update(data);
        return module.binding;
    }


    public void pushModule(UIModule go)
    {
        if (go == null) throw new Exception("模块为空");
        _sendCleanupToScene = false;
        _stack.Add(go);
        this._nextModule = go;
        this.draw();
    }
    public void pushObject(GameObject go)
    {
        pushObjectWithName(go.name, go);
    }
    public void pushObjectWithName(string moduleName, GameObject go)
    {
        UIModule module = new UIModule(go);
        module.name = moduleName;
        pushModule(module);
    }
    public UluaBinding pushWithPath(string pabsPath)
    {
        return pushWithPath(pabsPath, null);
    }

    /// <summary>
    /// 供C#调用打开窗口的API
    /// </summary>
    /// <param name="pabsPath"></param>
    /// <param name="data"></param>
    /// <returns></returns>
    public UluaBinding pushWithPath(string pabsPath, object data)
    {
        return push(pabsPath, pabsPath, data);
    }
    public UluaBinding push(string moduleName, string pabsPath)
    {
        return push(moduleName, pabsPath, null);
    }
    /// <summary>
    /// 供lua调用打开窗口的API
    /// </summary>
    /// <param name="moduleName">模块名</param>
    /// <param name="pabsPath">模块主预设路径</param>
    /// <param name="data">模块参数</param>
    /// <returns></returns>
    public UluaBinding push(string moduleName, string pabsPath, object data)
    {
        UIModule module = getDontDestroyUI(pabsPath);
        if (module == null)  module = new UIModule(pabsPath);
        else module.reStart();
        module.name = moduleName;
        pushModule(module);
        module.update(data);
        return module.binding;
    }


    public UIModule getDontDestroyUI(string pabsPath)
    {
        for (int i = 0; i < _dontDestroy.Count; i++)
        {
            if (_dontDestroy[i].gamePath == pabsPath)
            {
                UIModule temp = _dontDestroy[i];
                temp.AddToBackList();
                _dontDestroy.Remove(temp);
                return temp;
            }
        }
        return null;
    }
    #region 替换到模块
    /// <summary>
    /// 替换到某个模块，模块之后的模块会全部销毁
    /// </summary>
    /// <param name="moduleName">要替换到的模块名</param>
    /// <param name="new_module">新的模块</param>
    public void replaceModuleToModule(string moduleName, UIModule new_module)
    {
        this._removeList.Clear();
        bool find = false;
        int index = 0;
        int count = _stack.Count;
        for (int i = count - 1; i >= 0; i--)
        {
            var m = _stack[i];
            if (moduleName == m.name)
            {
                index = i;
                find = true;
                break;
            }
            if (m.dontDestroy)
            {
                m.AddToDontDestroyList();
                this._dontDestroy.Add(m);
            }
            else
            {
                _removeList.Add(m);
            }
        }
        if (find)
        {
            _stack.RemoveRange(index + 1, count - index - 1);
        }
        else
        {
            this._removeList.Clear();
        }
        int j = this._stack.Count;
        if (j == 0)
        {
            this._sendCleanupToScene = true;
            this._stack.Add(new_module);
            this._nextModule = new_module;
        }
        else
        {
            this._sendCleanupToScene = true;
            this.runningModule = this._stack[j - 1];
            _stack[j - 1] = null;
            this._stack[j - 1] = new_module;
            this._nextModule = new_module;
        }
        draw();
    }

    public void replaceModuleToLevel(UIModule new_module, int level)
    {
        this._removeList.Clear();
        //int index = 0;
        int count = _stack.Count;
        if (count < level)
        {
            pushModule(new_module);
            return;
        }
        for (int i = count - 1; i >= level - 1; i--)
        {
            var m = _stack[i];
            //index = i;
            if (m.dontDestroy)
            {
                m.AddToDontDestroyList();
                this._dontDestroy.Add(m);
            }
            else
            {
                _removeList.Add(m);
            }
        }
        if (_removeList.Count > 0)
        {
            //_stack.RemoveRange(index + 1, count - index - 1);
            _stack.RemoveRange(level, count - level);
        }

        //replace(new_module, false);
        this._sendCleanupToScene = true;
        count = _stack.Count;
        this.runningModule = this._stack[count - 1];
        _stack[count - 1] = null;
        this._stack[count - 1] = new_module;
        this._nextModule = new_module;
        draw();
    }

    public UluaBinding replaceToLevel(string moduleName, string pabsPath, int level)
    {
        return replaceToLevel(moduleName, pabsPath, level, null);
    }
    public UluaBinding replaceToLevel(string moduleName, string pabsPath, int level, object arg)
    {
        UIModule module = getDontDestroyUI(pabsPath);
        if (module == null)
            module = new UIModule(pabsPath);
        module.name = moduleName;
        module.update(arg);
        replaceModuleToLevel(module, level);
        return module.binding;
    }

    public void replaceObjectToModule(string name, GameObject go)
    {
        replaceObjectToModule(name, go.name, go);
    }
    public void replaceObjectToModule(string name, string moduleName, GameObject go)
    {
        UIModule m = new UIModule(go);
        m.name = moduleName;
        replaceModuleToModule(name, m);
    }
    #endregion
    public void popToRoot()
    {
        popWindow(true);
        if (_stack.Count == 1) return;
        this._stack[_stack.Count - 1] = null;
        _stack.RemoveAt(_stack.Count - 1);
        int c = this._stack.Count;
        while (c > 1)
        {
            var go = this._stack[c - 1];
            if (go.dontDestroy)
            {
                go.AddToDontDestroyList();
                this._dontDestroy.Add(go);
            }
            else
            {
                _removeList.Add(go);
            }
            this._stack[c - 1] = null;
            _stack.RemoveAt(c - 1);
            c--;
        }
        c = this._stack.Count;
        if (c > 0)
        {
            this._sendCleanupToScene = true;
            this._nextModule = this._stack[c - 1];
        }
        this.draw();
    }

    public void logout()
    {
        runningModule = null;
        _nextModule = null;
        topMenu = null;
        _top = null;
        _messageList.Clear();
        this._stack.Clear();
        this._dontDestroy.Clear();
        this._removeList.Clear();
        UIModule._dontDestroyUI.Clear();
    }
    public UluaBinding popToModule(string moduleName)
    {
        return popToModule(moduleName, null);
    }
    public UluaBinding popToModule(string moduleName, object table)
    {
        this._removeList.Clear();
        bool find = false;
        int index = 0;
        int count = _stack.Count;
        UIModule findModule = null;
        for (int i = count - 1; i >= 0; i--)
        {
            var m = _stack[i];
            if (moduleName == m.name)
            {
                index = i;
                find = true;
                findModule = m;
                break;
            }
            if (m.dontDestroy)
            {
                m.AddToDontDestroyList();
                this._dontDestroy.Add(m);
            }
            else
            {
                _removeList.Add(m);
            }
        }
        if (find)
        {
            for (int i = index + 1; i < _stack.Count && i < count - index; i++)
            {
                _stack[i] = null;
            }
            _stack.RemoveRange(index + 1, count - index - 1);
        }
        else
        {
            ClientTool.freeList(_removeList);
            //this._removeList.Clear();
            pop();
            return null;
        }
        UluaBinding bind = null;
        if (findModule != null)
        {
            this._sendCleanupToScene = false;
            this._nextModule = findModule;
            bind = findModule.binding;
            if (table != null && bind)
            {
                bind.CallUpdate(table);
            }
        }
        draw();

        return bind;
    }

    public void pop()
    {
        if (runningModule == null) throw new Exception("没有正在运行的模块");
        if (_stack.Count == 0) return;
        if (topTitle) topTitle.CallTargetFunctionWithLuaTable("modulePopEvent", runningModule.name);
        _stack[_stack.Count - 1] = null;
        _stack.RemoveAt(_stack.Count - 1);
        int c = this._stack.Count;
        if (c > 0)
        {
            this._sendCleanupToScene = true;
            this._nextModule = this._stack[c - 1];
        }
        this.draw();
    }

    public void pushWindow(GameObject go)
    {
        if (runningModule != null)
        {
            runningModule.pushWindow(go);
        }
    }
    public UluaBinding pushWindow(string pabsPath)
    {
        return pushWindow(pabsPath, null);
    }
    public UluaBinding pushWindow(string pabsPath, object data)
    {
        if (runningModule != null)
        {
            UluaBinding bind = runningModule.pushWindow(pabsPath);
            if (bind && data != null)
            {
                bind.CallUpdate(data);
            }
            return bind;
        }
        return null;
    }

    public void popWindow()
    {
        popWindow(false);
    }
    public void popWindow(bool ret)
    {
        if (runningModule != null)
        {
            if (ret)
                runningModule.clearWindow();
            else
                runningModule.popWindow();
        }
    }

    public void popMessage()
    {
        if (_messageList.Count > 0)
        {
            GameObject go = _messageList[_messageList.Count - 1];
            _messageList[_messageList.Count - 1] = null;
            _messageList.RemoveAt(_messageList.Count - 1);
            GameObject.Destroy(go);
        }
    }
    public UluaBinding pushMessage(string pabsPath)
    {
        return pushMessage(pabsPath);
    }
    public UluaBinding pushMessage(string pabsPath, object table)
    {
        UluaBinding binding = ClientTool.loadAndGetLuaBinding(pabsPath, top);
        NGUITools.SetLayer(binding.gameObject, top.layer);
        if (table != null) binding.CallUpdate(table);
        _messageList.Add(binding.gameObject);
        return binding;
    }

    public UluaBinding pushNotice(string pabsPath)
    {
        return pushNotice(pabsPath, null);
    }
    public UluaBinding pushNotice(string pabsPath, object table)
    {
        UluaBinding binding = ClientTool.loadAndGetLuaBinding(pabsPath, GlobalVar.notice);
        if (table != null) binding.CallUpdate(table);
        return binding;
    }
}

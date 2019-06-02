using UnityEngine;
using System.Collections.Generic;
using System;
using System.Collections;
//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class LoadManager
{
    public static LoadManager instance;
    /// <summary>
    /// 最大加载数量
    /// </summary>
    private const int MAX_LOAD_REQUEST = 10;
    /// <summary>
    /// 正在加载队列映射，url与LoadRequest
    /// </summary>
    private Dictionary<string, LoadRequest> loadMap = new Dictionary<string, LoadRequest>();
    /// <summary>
    /// 等待加载队列
    /// </summary>
    private Dictionary<string, LoadRequest> waitingLoad = new Dictionary<string, LoadRequest>();
    /// <summary>
    /// 已完成的加载的字段，url对应LoadParam
    /// </summary>
    public Dictionary<string, LoadParam> completeLoad = new Dictionary<string, LoadParam>();

    // 加载后无需释放的资源
    public Dictionary<string, LoadParam> completeLoadDontDestroy = new Dictionary<string, LoadParam>();
    /// <summary>
    /// 优先级队列，string为加载的url
    /// </summary>
    private List<string> priorityList = new List<string>();
    private bool isLoading = false; //是否是正在加载中......，不加载的时候，停止定时器
    private LoadRequest newLoadRequest;

    public int getunCompleteLoadCount()
    {
        return waitingLoad.Count + loadMap.Count;
    }
    public LoadManager()
    {
        FrameTimerManager.getInstance().add(2, 0, OnFrame);
    }

    public static LoadManager getInstance()
    {
        if (instance == null)
        {
            instance = new LoadManager();
        }
        return instance;
    }

    public bool HadLoadedUrl(string url)
    {
        url = url.Trim();
        if (url == "" || url == null)
            return false;
        if (completeLoadDontDestroy.ContainsKey(url))
        {
            return true;
        }
        // 1.已下载资源，直接调用回调函数
        if (completeLoad.ContainsKey(url))
        {
            return true;
        }
        return false;
    }
    public GameObject GetEffect(string name)
    {
        string url = UrlManager.ModelPath(name, "effect/prefab");
        if (url == "")
        {
            return null;
        }
        if (completeLoadDontDestroy.ContainsKey(url))
        {
            return completeLoadDontDestroy[url].mainGameObject;
        }
        // 1.已下载资源，直接调用回调函数
        if (completeLoad.ContainsKey(url))
        {
            return completeLoad[url].mainGameObject;
        }
        return null;

    }

    public GameObject GetAnimation(string name)
    {
        string url = UrlManager.ModelPath(name, "animation");
        if (url == "")
        {
            return null;
        }
        if (completeLoadDontDestroy.ContainsKey(url))
        {
            return completeLoadDontDestroy[url].mainGameObject;
        }
        // 1.已下载资源，直接调用回调函数
        if (completeLoad.ContainsKey(url))
        {
            return completeLoad[url].mainGameObject;
        }
        return null;
    }
    //加载通用资源等
    public void LoadSceneUnity3d(string url, string name, LoadRequest.DownCompleteDelegate completeFun, object customParam = null, bool dontdestroy = false)
    {
        Load(url, name, completeFun, customParam, null, null, LoadFileType.UNITY3D, 2, dontdestroy);
    }
    //模型资源
    public void LoadSceneModel(string url, string name, LoadRequest.DownCompleteDelegate completeFun, object customParam = null, bool dontdestroy = false)
    {
        Load(url, name, completeFun, customParam, null, null, LoadFileType.MODEL, 2, dontdestroy);
    }
    //动画
    public void LoadSceneAnimation(string name, LoadRequest.DownCompleteDelegate completeFun, object customParam = null, bool dontdestroy = false)
    {
        string url = UrlManager.ModelPath("hero", "animation");
        if (url == "")
        {
            return;
        }
        Load(url, name, completeFun, customParam, null, null, LoadFileType.ANIMATION, 2, dontdestroy);
    }
    //加载特效----不同的类型释放的方式不同
    public void LoadSceneEffect(string name, LoadRequest.DownCompleteDelegate completeFun, object customParam = null, bool dontdestroy = false)
    {
        string url = UrlManager.ModelPath(name, "effect/prefab");
        if (url == "")
        {
            return;
        }
        Load(url, name, completeFun, customParam, null, null, LoadFileType.EFFECT, 2, dontdestroy);
    }
    //加载脚本数据
    public void LoadSceneScriptableData(string url, string name, LoadRequest.DownCompleteDelegate completeFun, object customParam = null, bool dontdestroy = false)
    {
        Load(url, name, completeFun, customParam, null, null, LoadFileType.SCRIPTABLEDATA, 2, dontdestroy);
    }

    //加载音频文件
    public void LoadAudio(string url, LoadRequest.DownCompleteDelegate completeFun, object customParam = null, LoadRequest.ErrorDelegate errorFunc = null, LoadRequest.ProcessDelegate proFunc = null, int priority = 2)
    {
        Load(url, "", completeFun, customParam, errorFunc, proFunc, LoadFileType.AUDIO, priority);
    }

    public void Load(string url, string name, LoadRequest.DownCompleteDelegate completeFun, object customParam = null, LoadRequest.ErrorDelegate errorFunc = null, LoadRequest.ProcessDelegate proFunc = null, string fileType = "", int priority = 2, bool dontdestroy = false)
    {
        url = url.Trim();
        if (url == "" || url == null)
            return;
        if (completeLoadDontDestroy.ContainsKey(url))
        {
            CompleteCallBack(completeFun, completeLoadDontDestroy[url], customParam);
            return;
        }
        // 1.已下载资源，直接调用回调函数
        if (completeLoad.ContainsKey(url))
        {
            CompleteCallBack(completeFun, completeLoad[url], customParam);
            return;
        }
        // 2.已经提交相同请求，但是没有下载完成，正在加载中......
        if (loadMap.ContainsKey(url))
        {
            //写这一段是为了2个地方正在调用，两个地方等加载完以后，都回调comepleteFun;
            loadMap[url].completeFun += completeFun;
            loadMap[url].processFun += proFunc;
            loadMap[url].errorFun += errorFunc;
            loadMap[url].customParams.Add(customParam);
            return;
        }
        //3.已经提交相同请求，但是还没轮到加载
        if (waitingLoad.ContainsKey(url))
        {
            //写这一段是为了2个地方正在调用，两个地方等加载完以后，都回调comepleteFun;
            waitingLoad[url].completeFun += completeFun;
            waitingLoad[url].processFun += proFunc;
            waitingLoad[url].errorFun += errorFunc;
            waitingLoad[url].customParams.Add(customParam);
            return;
        }//返回，直接等待
        //4.未加载过的
        LoadRequest lr = null;
        if (canLoad())
        {
            if (!loadMap.ContainsKey(url))
            {
                isLoading = true; //开始加载
                lr = new LoadRequest(url, name, completeFun, errorFunc, proFunc, customParam, fileType, dontdestroy);
                loadMap.Add(url, lr);
            }
        }
        else
        {
            lr = new LoadRequest();
            lr.requestURl = url;
            lr.name = name;
            lr.dontdestroy = dontdestroy;
            lr.completeFun = completeFun;
            lr.customParams.Add(customParam);
            lr.errorFun = errorFunc;
            lr.processFun = proFunc;
            lr.fileType = fileType;
            lr.priority = priority;
            waitingLoad.Add(url, lr);
            priorityList.Add(url);//暂时没有进行优先级排序，以后添加
        }
    }
    //是否可以load，判断是否达到最大同步加载数量
    private bool canLoad()
    {
        return (loadMap.Count < MAX_LOAD_REQUEST);
    }
    //加载完成之后进行回调
    private void CompleteCallBack(LoadRequest.DownCompleteDelegate completeFun, LoadParam param, object customParam = null)
    {
        param.param = customParam;
        try
        {
            completeFun.Invoke(param);
        }
        catch (Exception ex)
        {
            MyDebug.Log(ex.ToString());
        }
    }

    private LoadParam addResourceToComplete(LoadRequest request)
    {
        LoadParam param = new LoadParam();
        param.url = request.requestURl;
        param.name = request.name;
        param.dontdestroy = request.dontdestroy;
        param.priority = request.priority;
        param.fileType = request.fileType;

        if (LoadFileType.MODEL == request.fileType || LoadFileType.EFFECT == request.fileType || LoadFileType.ANIMATION == request.fileType)
        {
            try
            {
                param.assetbundle = request.wwwObject.assetBundle;
                param.mainGameObject = param.assetbundle.LoadAsset(request.name, typeof(GameObject)) as GameObject;
                if (param.mainGameObject != null)
                    ModelShowUtil.CompleteRenderMaterialShader(param.mainGameObject);
            }
            catch (Exception ex)
            {
                MyDebug.LogWarning("read UNITY3D error :" + request.requestURl);
            }
        }
        else if (LoadFileType.UNITY3D == request.fileType)
        {
            try
            {
                param.assetbundle = request.wwwObject.assetBundle;
            }
            catch (Exception ex)
            {
                MyDebug.LogWarning("read UNITY3D error :" + request.requestURl);
            }
        }
        else if (LoadFileType.AUDIO == request.fileType)
        {
            try
            {
                UnityEngine.Object[] data = request.wwwObject.assetBundle.LoadAllAssets();
                param.assetbundle = request.wwwObject.assetBundle;
                int len = data.Length;
                for (int i = 0; i < len; i++)
                {
                    if (data[i] is AudioClip)
                    {
                        param.audioClip = data[i] as AudioClip;
                    }
                }
            }
            catch (Exception ex)
            {
                MyDebug.LogWarning("read audio error :" + request.requestURl);
            }
        }
        return param;
    }

    //进度回调
    private void ProcessCallBack(LoadRequest request)
    {
        if (request.processFun == null)
            return;
        int count = request.processFun.GetInvocationList().GetLength(0);
        LoadRequest.ProcessDelegate proFunc;
        for (int i = 0; i < count; i++)
        {
            proFunc = (LoadRequest.ProcessDelegate)request.processFun.GetInvocationList()[i];
            try
            {
                proFunc.Invoke(request.wwwObject.progress);
            }
            catch (Exception ex)
            {
            }
        }
    }

    private void CompletedCallBack(LoadRequest request, LoadParam param)
    {
        if (param.dontdestroy)
        {
            completeLoadDontDestroy.Add(request.requestURl, param);
        }
        else
        {
            completeLoad.Add(request.requestURl, param);
        }
        int count = request.completeFun.GetInvocationList().GetLength(0);
        for (int i = 0; i < count; i++)
        {
            CompleteCallBack(((LoadRequest.DownCompleteDelegate)request.completeFun.GetInvocationList()[i]), param, request.customParams[i]);
        }
        request.bHasDeal = true;
        loadMap.Remove(request.requestURl);
        //新增加载
        addNewLoadFromWaiting();
    }

    public void AddLoadAssetRefCount(string url)
    {
        if (completeLoad.ContainsKey(url))
        {
            completeLoad[url].refCount++;
        }
    }

    public void ReduceLoadAssetRefCount(string url)
    {
        if (completeLoad.ContainsKey(url))
        {
            completeLoad[url].refCount--;
        }
    }

    void OnFrame()
    {
        if (!isLoading)
        {
            return;
        }
        foreach (KeyValuePair<string, LoadRequest> wwwPair in loadMap)
        {
            LoadRequest request = wwwPair.Value;
            //处理加载错误的请求
            if (request.wwwObject.error != null && request.wwwObject.error != "")
            {
                if (request.errorFun != null)
                {
                    int errorCount = request.errorFun.GetInvocationList().GetLength(0);
                    LoadRequest.ErrorDelegate errorFunc;
                    for (int i = 0; i < errorCount; i++)
                    {
                        errorFunc = (LoadRequest.ErrorDelegate)request.errorFun.GetInvocationList()[i];
                        try
                        {
                            errorFunc.Invoke(request.requestURl);
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                }
                request.bHasDeal = true;
                loadMap.Remove(request.requestURl);
                MyDebug.LogWarning("loaded error:" + request.requestURl);
                addNewLoadFromWaiting();
                break;
            }

            //如果尚未调用回调，并且下载完成，则调用
            if (!request.bHasDeal)
            {
                ProcessCallBack(request);
                if (request.wwwObject.isDone)
                {
                    LoadParam param = addResourceToComplete(request);
                    CompletedCallBack(request, param);
                    break;
                }
            }
        }
        isLoading = (loadMap.Count > 0);
    }

    private void addNewLoadFromWaiting()
    {
        if (priorityList.Count > 0)
        {
            if (waitingLoad.ContainsKey(priorityList[0]))
            {
                newLoadRequest = waitingLoad[priorityList[0]];
                waitingLoad[priorityList[0]] = null;
                waitingLoad.Remove(priorityList[0]);
                priorityList.RemoveAt(0);
                Load(newLoadRequest.requestURl,newLoadRequest.name, newLoadRequest.completeFun, newLoadRequest.customParams[0], newLoadRequest.errorFun, newLoadRequest.processFun, newLoadRequest.fileType, newLoadRequest.priority, newLoadRequest.dontdestroy);
            }
        }
    }

    static int s_cacheModelNum = 15;
    public void RemoveUnusedModel(bool isAll = false)
    {
        int count = 0;
        List<string> destroyRef = new List<string>();
        foreach (KeyValuePair<string, LoadParam> o in completeLoad)
        {
            if (o.Value.refCount <= 0 && o.Value.fileType == LoadFileType.MODEL)
            {
                if (isAll || (!isAll && count > s_cacheModelNum))
                    destroyRef.Add(o.Key);
            }
        }

        for (int i = 0; i < destroyRef.Count; i++)
        {
            string url = destroyRef[i];
            AssetBundle bundle = completeLoad[url].assetbundle;
            AudioClip audios = completeLoad[url].audioClip;
            GameObject go = completeLoad[url].mainGameObject;
            if (go != null)
            {
                go = null;
            }
            if (bundle != null)
            {
                bundle.Unload(true);
                bundle = null;
            }
            if (audios != null)
            {
                audios = null;
            }
            completeLoad[url].param = null;
            completeLoad[url] = null; //先清空引用，再remove该项
            completeLoad.Remove(url);
        }
    }

    public void removeEffectResource()
    {
        List<string> destroyRef = new List<string>();
        foreach (KeyValuePair<string, LoadParam> o in completeLoad)
        {
            if (o.Value.refCount <= 0 && o.Value.fileType == LoadFileType.EFFECT)
            {
                destroyRef.Add(o.Key);
            }
        }

        for (int i = 0; i < destroyRef.Count; i++)
        {
            string url = destroyRef[i];
            AssetBundle bundle = completeLoad[url].assetbundle;
            AudioClip audios = completeLoad[url].audioClip;
            GameObject go = completeLoad[url].mainGameObject;
            if (go != null)
            {
                go = null;
            }
            if (bundle != null)
            {
                bundle.Unload(true);
                bundle = null;
            }
            if (audios != null)
            {
                audios = null;
            }
            completeLoad[url].param = null;
            completeLoad[url] = null; //先清空引用，再remove该项
            completeLoad.Remove(url);
        }
    }

    /// <summary>
    ///移除要谨慎，移除之前要把用到的资源卸载掉，释放资源内存，做不到就不要移除，不然下次会重新加载，内存会一直递增
    /// </summary>
    /// <param name="url"></param>
    public void removeResource(string url, bool isShiftDelete = false)
    {
        if (completeLoad.ContainsKey(url))
        {
            //去除内存未使用的引用
            AssetBundle bundle = completeLoad[url].assetbundle;
            AudioClip audios = completeLoad[url].audioClip;
            if (bundle != null)
            {
                bundle.Unload(isShiftDelete);
                bundle = null;
            }
            if (audios != null)
            {
                audios = null;
            }
            completeLoad[url].param = null;
            completeLoad[url] = null; //先清空引用，再remove该项
            completeLoad.Remove(url);
        }
    }
}


using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************


/// <summary>
/// 加载类，将加载要求封装成LoadManager所匹配的样子
/// </summary>
public class LoadRequest
{
    public delegate void DownCompleteDelegate(LoadParam param);
    public delegate void ErrorDelegate(string errorUrl);
    public delegate void ProcessDelegate(float processValue);

    public string requestURl;
    public string name;
    public bool dontdestroy;
    public DownCompleteDelegate completeFun;
    public ErrorDelegate errorFun;
    public ProcessDelegate processFun;
    public WWW wwwObject = null;
    public string fileType;
    public List<object> customParams = new List<object>();
    public bool bHasDeal = false;
    public int priority = LoadPriority.NORMAL;

    public LoadRequest()
    { }
    void Error(string errorUrl)
    {
        MyDebug.Log(errorUrl);
    }
    public LoadRequest(string url, string nameV, DownCompleteDelegate cFun, ErrorDelegate eFunc = null, ProcessDelegate pFunc = null, object customParam = null, string ft = "", bool dontdestroyV = false)
    {
        requestURl = (url);
        name = nameV;
        dontdestroy = dontdestroyV;
        completeFun = new DownCompleteDelegate(cFun);
        if (eFunc != null)
            errorFun = new ErrorDelegate(eFunc);
        else
            errorFun = new ErrorDelegate(Error);
        if (pFunc != null)
            processFun = new ProcessDelegate(pFunc);
        fileType = ft;
        string formUrl = formatUrl(url);
        //MyDebug.Log("formUrlformUrlformUrl  "+ formUrl);
        wwwObject = new WWW(formatUrl(url));
        customParams.Add(customParam);
    }
    static string formatUrl(string urlstr)
    {
        if (string.IsNullOrEmpty(urlstr)) return "";
        Uri url = new Uri(urlstr);

        return url.AbsoluteUri;
    }
}


using System;
using UnityEngine;
using System.Collections;
 
//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************
public class LoadParam
{
    public LoadParam()
    {

    }
    public string fileType;

    public object param;//自定义参数

    public Texture2D texture2d;//图片

    public string text;//文本

    public AssetBundle assetbundle;//unity3d格式文件，目前针对场景打包的unity3d格式文件

    public GameObject mainGameObject;

    public string jsonData;//json文件

    public byte[] byteArr;//二进制文件

    public AudioClip audioClip;//音频文件

    public UIAtlas uiatlas;//模块资源打包格式文件

    public UnityEngine.Object mainAsset;//fbx打包的文件对象

    public UIFont font;//font文件

    public string url;//加载的路径

    public string name;
    public bool dontdestroy;

    public int priority = LoadPriority.NORMAL;	//加载优先级;

    public int refCount = 0;

}


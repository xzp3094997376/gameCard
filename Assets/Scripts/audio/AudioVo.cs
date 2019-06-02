using UnityEngine;
using System.Collections;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

/// <summary>
/// 基本音频vo
/// </summary>
public class AudioVo
{
    public AudioVo()
    {
    }
    public string fileName="music"; //音频名称
    public int level=1; //音频等级，用于分级暂停，播放音乐
    public float volume=0.1f;//音量大小 0-1
    public int isloop=1;//是否循环播放 -1 为循环播放
    public bool isFade=false;//是否渐变打开或者关闭
    public string path = ""; //存放路径
}

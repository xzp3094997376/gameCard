using UnityEngine;
using System;
using System.Collections;
using Spine.Unity;
//*********************************************
//**author:zengjiadong                       **
//**copyright:乐云工作室                     **
//加入动画加载完成回调
//*****
public class AvatarCtrl : MonoBehaviour {
    public string model_path;
    private SkeletonAnimation m_skAni;
    void Awake() {
        m_skAni = gameObject.GetComponent<SkeletonAnimation>();
    }
    //播放名为aniName的动画，如果本地有则读取本地！没有就去加载
    public void PlayAnimation(string aniName, bool needLoop = true)
    {
        if (m_skAni == null)
        {
            Debug.LogError("hero obj export is error, must have SkeletonAnimation scrip");
            return;
        }
        if (m_skAni.state.FindAnimation(aniName))
        {
            m_skAni.state.SetAnimation(0, aniName, needLoop);
        }

    }

    public void SetPySkin(bool py)
    {
        if (m_skAni == null)
        { return; }
        foreach (var skin in m_skAni.skeleton.Data.Skins)
        {
            if (py)
            {
                if (skin.name == "py")
                {
                    m_skAni.initialSkinName = skin.name;
                    m_skAni.Initialize(true);
                    //m_skAni.skeleton.SetSkin(skin.name);
                    return;
                }
            }

            if (skin.name == "zc")
            {
                m_skAni.initialSkinName = skin.name;
                m_skAni.Initialize(true);
                //m_skAni.skeleton.SetSkin(skin.name);
            }
        }
    }

    public void SetAlpha(float a)
    {
        m_skAni.skeleton.A = a;
    }
}

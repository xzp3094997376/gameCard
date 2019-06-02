using UnityEngine;
using System;
using System.Collections;
using SLua;
using System.Reflection;
using System.Collections.Generic;
public class StarAnimate : MonoBehaviour
{
	public Animation[] anis = null;
    public Animator m_Ani = null;
    private LuaFunction callBack = null;
    private LuaFunction setView = null;
	private bool isPlaying;
	// Use this for initialization
	void Start () {
		//DelayShow(1);
	}
    public void SetViews(string strName, bool val)
    {
        m_Ani.SetBool(strName, val);
		isPlaying = true;
	}
	
	void Update()
	{
		if (isPlaying && callBack != null)
		{
			AnimatorStateInfo animatorInfo;
			animatorInfo = m_Ani.GetCurrentAnimatorStateInfo (0); 
			if(animatorInfo.normalizedTime > 1) 
			{
				callBack.call();
				isPlaying = false;
			}
		}
	}
	
	public void DelayShow(float time,LuaFunction luaFunc = null,LuaFunction luaFunc1 = null)
	{
		if (luaFunc != null)
			callBack = luaFunc;
		if (luaFunc1 != null)
			setView = luaFunc1;
//        Invoke("Show", time);
		Show ();
    }

    void Show()
    {
        m_Ani.gameObject.SetActive(true);
		if (setView!=null)
		{
			setView.call();
		}
//		Invoke("CallLuaFunc",2f);
    }
    void CallLuaFunc()
    {
        if (callBack!=null)
        {
			callBack.call();
		}
    }
}

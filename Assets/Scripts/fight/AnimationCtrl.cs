using UnityEngine;
using System.Collections;

/**
 * 说明：加载动画资源管理动画资源！
 * 
 * 
 * */
public class AnimationCtrl : MonoBehaviour {

	// Use this for initialization
    Hashtable m_Animations = new Hashtable();
    Animation m_AniPlayer = null;
    void Start () {
	    
	}

    public void SetAimation()
    {

    }
    public void PlayAnimation(string name, PlayMode mod = PlayMode.StopAll)
    {
        if (m_AniPlayer.GetClip(name) == null)
        {
            Animation obj = Resources.Load<Animation>("animation/" + name);
            string[] str = name.Split('@');
            if (obj == null || str.Length != 2)
            {
                MyDebug.Log("miss ani:" + name);
                return;
            }
            m_AniPlayer.AddClip(obj.GetClip(str[1]), name);

        }
        m_AniPlayer.Play(name, mod);
    }
	// Update is called once per frame
	void Update () {
	
	}
}

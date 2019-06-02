using UnityEngine;
using System.Collections;

public class HeroObject : MonoBehaviour
{
    private ActionPlayer m_SelfAction = null;
    private Animation m_Ani = null;
    public GameObject m_Hero = null;
    public GameObject m_BackUp = null;
    public bool m_IsTransform = false;
	// Use this for initialization
	void Start () {
        m_SelfAction = this.GetComponent<ActionPlayer>();
        if (m_SelfAction == null)
        {
            m_SelfAction = gameObject.AddComponent<ActionPlayer>();
        }
	}

    public void PlayAnimation(string name, PlayMode mod = PlayMode.StopAll)
    {
        if (m_Ani.GetClip(name) == null)
        {
            if (name != "great_hit")
                return;
            name = "normal_hit";
        }

        m_Ani.Stop();
        m_Ani.Play(name, mod);
    }

    public void BackNormal()
    {
        m_IsTransform = false;
        GameObject tmp = m_Hero;
        tmp.name = "backup";
        tmp.SetActive(false);
        m_Hero = m_BackUp;
        m_Hero.name = "hero";
        m_Hero.SetActive(true);
        m_BackUp = tmp;
        m_Ani = m_Hero.GetComponent<Animation>();
        //PlayAnimation("stadn");
        

        Invoke("CallNext", 1f);
    }
	// Update is called once per frame
	void Update () {
        if (m_Ani!=null && !m_Ani.isPlaying)
        {
            // MyDebug.Log("ending time :" + Time.time);
            PlayAnimation("stand");
        }
	}
}

using UnityEngine;
using System.Collections;

public class MoveAction : MonoBehaviour {

    public float m_AniTime = 0;
    public Vector3 m_TargetPos = new Vector3();
    public Vector3 m_StartPos = new Vector3();
    private bool m_IsMoving = false;
    private float m_UsedTime = 0.0f;
    //private Transform m_Transform = null;
    public GameObject m_Effect = null;
    public HeroCtrl m_HeroCtrl = null;
	// Use this for initialization
    public float m_TimeNeed = 0;
    public float m_TimeCount = 0;
    // Use this for Scale
    public float m_ScaTime = 0;
    public float m_TargetScale = 0;
    public float m_StartScale = 0;
    public float m_ScaleUsedTime = 0;
    public bool m_IsScaling = false;

void Start () {
       // m_Transform = this.transform;
        m_HeroCtrl = gameObject.GetComponent<HeroCtrl>();
	}
    public void Disappear(float ft = 1)
    {
        m_TimeCount = 0;
        m_TimeNeed = ft;
        if (ft <= 0)
            SetAlpha(0);
    }
    public void MoveTo(Vector3 Pos, float NeedTime)
    {
        //NeedTime += 3.0f;
        m_AniTime = NeedTime;
        m_TargetPos = Pos;

        if (NeedTime <= 0)
        {
            transform.position = Pos;
            return;
        }

        m_StartPos = this.transform.position;
        m_UsedTime = 0;
        m_IsMoving = true;
    }

    public void ScaleTo(float scale, float NeedTime)
    {
        m_ScaTime = NeedTime;
        m_TargetScale = scale;


        if (NeedTime <= 0)
        {
            transform.localScale = new Vector3(m_TargetScale, m_TargetScale, m_TargetScale);
            return;
        }
        m_StartScale = this.transform.localScale.x;
        m_ScaleUsedTime = 0;
        m_IsScaling = true;

    }

    void SetAlpha(float alpha)
    {
        if (m_HeroCtrl == null || m_HeroCtrl.m_Hero == null)
            return;
        Transform t = m_HeroCtrl.m_Hero.transform;

        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            if (t0.GetComponent<Renderer>() != null && t0.GetComponent<Renderer>().material != null)
            {
                if (!string.IsNullOrEmpty(t0.GetComponent<Renderer>().material.shader.name))
                {
                    t0.GetComponent<Renderer>().material.SetFloat("_Alpha", alpha);
                }
            }
        }
        if (alpha <= 0)
            gameObject.SetActive(false);
    }
	// Update is called once per frame
	void Update () {

        if (m_TimeNeed > 0 && m_TimeNeed >= m_TimeCount)
        {
            m_TimeCount += Time.deltaTime;
            m_TimeCount = Mathf.Min(m_TimeCount, m_TimeNeed);
            SetAlpha(1 - m_TimeCount / m_TimeNeed);

        }

        if (m_IsMoving)
        {
            m_UsedTime += Time.deltaTime;
            Vector3 pos = m_StartPos;
            m_UsedTime = Mathf.Min(m_UsedTime, m_AniTime);
            pos.x = pos.x + m_UsedTime * (m_TargetPos.x - pos.x) / m_AniTime;
            pos.y = pos.y + m_UsedTime * (m_TargetPos.y - pos.y) / m_AniTime;
            pos.z = pos.z + m_UsedTime * (m_TargetPos.z - pos.z) / m_AniTime;

            transform.position = pos;
            if (m_AniTime <= m_UsedTime)
            {
                m_IsMoving = false;
            }
        }

        if (m_IsScaling)
        {
            m_ScaleUsedTime += Time.deltaTime;
            float tmp = m_StartScale;
            m_ScaleUsedTime = Mathf.Min(m_ScaleUsedTime, m_ScaTime);
            tmp = tmp + m_ScaleUsedTime * (m_TargetScale - tmp) / m_ScaTime;

            transform.localScale = new Vector3(tmp, tmp, tmp);
            if (m_ScaTime <= m_ScaleUsedTime)
            {
                m_IsScaling = false;
            }
        }

    }
}

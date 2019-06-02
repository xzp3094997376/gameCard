using UnityEngine;
using System.Collections;

public class StartAni : MonoBehaviour {
    public static StartAni Inst;
    public GameObject bg1;
    public GameObject bg2;

    public bool m_IsMoving = false;

    public Vector3 m_StartPos1 = new Vector3();
    public Vector3 m_StartPos2 = new Vector3();
    public float m_UsedTime = 0.0f;
    public float m_TimeNeed = 0.0f;
    public Vector3 m_MoveSpeed1 = new Vector3(-9.0f, -0.0f, 0.0f);
    public Vector3 m_MoveSpeed2 = new Vector3(9.0f, 0.0f, 0.0f);
    
    void Awake()
    {
        Inst = this;
        m_StartPos1 = bg1.gameObject.transform.position;
        m_StartPos2 = bg2.gameObject.transform.position;
    }
    public void Begin()
    {
        m_IsMoving = true;
        m_UsedTime = 0.0f;
        bg1.gameObject.transform.position = m_StartPos1;
        bg2.gameObject.transform.position = m_StartPos2;
    }

    // Update is called once per frame
    void Update()
    {
        if (m_IsMoving)
        {
            m_UsedTime += Time.deltaTime;
            if (m_UsedTime >= m_TimeNeed)
            {
                bg1.gameObject.transform.position = m_StartPos1 + m_MoveSpeed1 * m_TimeNeed;
                bg2.gameObject.transform.position = m_StartPos2 + m_MoveSpeed2 * m_TimeNeed;


                m_IsMoving = false;
                FightManager.Inst.Next();
            }
            else
            {
                bg1.gameObject.transform.position = m_StartPos1 + m_MoveSpeed1 * m_UsedTime;
                bg2.gameObject.transform.position = m_StartPos2 + m_MoveSpeed2 * m_UsedTime;
            }
        }
    }
}

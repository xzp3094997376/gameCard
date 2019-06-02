using UnityEngine;
using System.Collections;

public class Shaking : MonoBehaviour {
    public float m_Delay = 0.5f;
    public float m_Cost = 2.0f;
    public float m_Value = 0.01f;
    public Vector3 m_CurPosition = new Vector3();
    public bool m_IsShaking = false;
    float m_CountTime = 0;

    public Transform m_SelfTransform = null;
    // Use this for initialization
    void Start () {
        m_SelfTransform = transform;
        Invoke("StartShake", m_Delay);
    }
	
	// Update is called once per frame
	void FixedUpdate () {
        
        if (m_IsShaking)
        {
            m_CountTime += Time.deltaTime;
            transform.position = new Vector3(m_CurPosition.x + Mathf.Sin(m_CountTime * 100) * m_Value, m_CurPosition.y + Mathf.Sin(m_CountTime * 1000) * m_Value, m_CurPosition.z);
        }
    }

    void StartShake()
    {
        m_CountTime = 0;
        m_CurPosition = transform.position;
        m_IsShaking = true;
        Invoke("CancelShake", m_Cost);
    }

    void CancelShake()
    {
        transform.position = m_CurPosition;
        m_IsShaking = false;
    }
}

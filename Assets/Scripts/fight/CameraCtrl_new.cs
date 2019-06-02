using UnityEngine;
using System.Collections;

/***
* 说明:用于控制摄像头的效果跟动作模式
* 
*/


public class CameraCtrl_new : MonoBehaviour
{
    public static CameraCtrl_new Inst = null;
    public Transform m_SelfTransform = null;
    public Camera mCamera;

    //shake
    public bool m_IsShaking = false;
    public Vector3 m_CurPosition = new Vector3();
    public float sizeR = 2.8125f;
    public float sizeS = 3.75f;
    public float sizeT = 5.0f;
    float m_Value = 0.8f;
    float m_CountTime = 0;

    public Animation m_Ani = null;

    void Start()
    {
        m_Ani = mCamera.gameObject.GetComponent<Animation>();
        Inst = this;
        m_SelfTransform = transform;
    }

    public void StartShake(float cost, float rate)
    {
        m_CountTime = 0;

        m_CurPosition = transform.position;
        m_Value = rate;
        m_IsShaking = true;
        Invoke("CancelShake", cost);
    }

    void CancelShake()
    {
        transform.position = m_CurPosition;
        m_IsShaking = false;
    }

    public void StartCameraAnimtion(string str, bool isAtk, float time)
    {
        if (m_Ani != null)
        {
            string ani = str;
            if (!isAtk)
            {
                ani += "_s";
            }
            if (m_Ani.GetClip(ani) != null)
            {
                m_Ani.Play(ani);
            }
        }
    }

    public void StartEnd(float last = 0.5f, float stren = 1)
    {
       
        Invoke("EndWhite", last);
    }
    void EndWhite()
    {
    }

    void Update()
    {
        if (m_IsShaking)
        {
            m_CountTime += Time.deltaTime;
            transform.position = new Vector3(m_CurPosition.x, m_CurPosition.y + Mathf.Sin(m_CountTime * 100) * m_Value * 2, m_CurPosition.z);
        }

        Vector2 screen = NGUITools.screenSize;
        float aspect = screen.x / screen.y;
        float initialAspect = 1.778f - aspect;
        if (initialAspect < 0.1f)
            initialAspect = 0;
        float size = sizeS + sizeR * initialAspect;
        if (size > sizeT)
        {
            size = sizeT;
        }
        if (size < sizeS)
        {
            size = sizeS;
        }
        mCamera.orthographicSize = size;
    }
}

using UnityEngine;
using System.Collections;
/**
 * 说明：此类用于调整GameObject对象，是对象朝向摄像头
 * 案例：
 * 战斗场景里的血条，使用方法直接添加到GameObject上
 * 
 * */

public class LookCamera : MonoBehaviour
{

    // Use this for initialization
    private Transform m_CameraTransform = null;
    private Vector3 localSize;
    public bool isNeedHideThing = false;
    public float HideThingFar = 80;
    void Start()
    {
        m_CameraTransform = Camera.main.transform;
        localSize = transform.localScale;
    }

    void Update()
    {
        if (isNeedHideThing)
        {
            if (Vector3.Distance(m_CameraTransform.position, transform.position) <= HideThingFar)
            {
                Vector3 rot = new Vector3();
                this.transform.localScale = localSize;
                rot.y = m_CameraTransform.eulerAngles.y;
                rot.x = m_CameraTransform.eulerAngles.x;
                this.transform.eulerAngles = rot;
            }
            else
            {
                this.transform.localScale = new Vector3(0.1f, 0, 0);
            }
        }
        else
        {
            Vector3 rotNormal = new Vector3();
            rotNormal.y = m_CameraTransform.eulerAngles.y;
            rotNormal.x = m_CameraTransform.eulerAngles.x;
            this.transform.eulerAngles = rotNormal;
        }
    }
}

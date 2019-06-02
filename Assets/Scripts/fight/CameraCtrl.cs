using UnityEngine;
using System.Collections;

/***
* 说明:用于控制摄像头的效果跟动作模式
* 
*/

//摄像头的模式 Lock 摄像头锁定不动 
public enum CarmeraFollowType
{
    Lock,
    Free,
    Follow,
    Auto,
    AutoRotate,
    FocusTarget,
    Move,
}

public class CameraCtrl : MonoBehaviour
{

    public Transform m_CameraPoint = null;
    public float m_ViewLen = 15f;
    public Vector3 m_AngleDes = new Vector3(27, 130, 0);
    public CarmeraFollowType m_State = CarmeraFollowType.AutoRotate;

    public bool m_IsShaking = false;
    public float m_LastRecord = 0;
    public Vector3 m_CurPosition = new Vector3();
    float m_Decay = 0.2f;
    float m_Value = 0.8f;
    float m_CountTime = 0;
    public Camera m_SonCarmera = null;
    // Use this for initialization

    public Vector4 m_StartDir;
    public Vector4 m_EndDir;
    public float m_Cur = 0;
    public float m_StartSecond = 1;
    public bool isStop = false;
    public Transform m_Parent = null;

    public static CameraCtrl Inst = null;
    public Transform m_SelfTransform = null;
    public int m_IsJump = 0;



    public float m_StartAnimateTime = 0;
    public float m_TotalNeedTime = 0;
    public float m_Changing = 0;
    public float m_RotateArgv = 0.0005f;
    private bool isRight = true;

    public float m_MaxRate = 1;
    public float m_MinRate = 1f;
    public HeroCtrl m_TargetHero = null;
    public Vector3 m_PointPos;
    public bool m_NeedFocus = false;
    public float m_NeedSpeed = 0.2f;

    private bool m_IsBoss = false;
    private float m_pointHigh = 1.5f;
    public Vector3 m_BossPos = new Vector3(-6.17f, 1.767f, 8.28f);
    public Vector3 m_BossRot = new Vector3(-3.2f, 140f, 0);
    public Vector3 m_BossStartPos;
    public Vector3 m_BossStartRot;
    public float m_BossCountTime = 0;
    public float m_BossTotalTime = 0.5f;
    public float m_cameraY = 0.24f;
    public float m_cameraX = 0.96f;
    public float m_cameraZ = -1.75f;

    private Camera mCamera;


    void Start()
    {
        m_cameraX = ConstData.FightCamerX;
        m_cameraY = ConstData.FightCamerY;
        m_cameraZ = ConstData.FightCamerZ;
        mCamera = GetComponent<Camera>();
        Inst = this;
        m_SelfTransform = transform;
        UpdateCamera(0);
    }

    public void StartFocus(HeroCtrl hc, float breakTime)
    {
        if (breakTime <= 0)
            breakTime = 0.2f;
        m_NeedFocus = true;
        m_PointPos = m_CameraPoint.transform.position;
        m_TargetHero = hc;
        m_State = CarmeraFollowType.FocusTarget;
        StartFieldAnimation(breakTime, 32);
    }
    public void EndFocus(float breakTime)
    {
        if (breakTime <= 0)
            breakTime = 0.2f;
        m_State = CarmeraFollowType.FocusTarget;

        StartFieldAnimation(breakTime, 55);

        m_NeedSpeed = Vector3.Distance(m_CameraPoint.position, m_PointPos);
        m_NeedSpeed = m_NeedSpeed / (breakTime * 30 + 5);
        EndTarget();
    }
    void EndTarget()
    {
        m_NeedFocus = false;
        m_State = CarmeraFollowType.FocusTarget;
    }

    public void StartFieldAnimation(float last, float val)
    {
        m_StartAnimateTime = 0;
        m_TotalNeedTime = last;
        if (last <= 0)
        {
            SetFieldView(val);
            return;
        }
        m_Changing = (val - mCamera.fieldOfView) / last;
    }

    public void ModifyBossCamera(bool isBoss)
    {
        m_IsBoss = isBoss;
    }
    /// <summary>
    /// 设置摄像头位置
    /// </summary>
    void UpdateCamera()
    {
        var pos = m_CameraPoint.localPosition;
        pos.x += m_cameraX;
        pos.y += m_cameraY;
        pos.z += m_cameraZ;
        m_SelfTransform.localPosition = pos;
        m_SelfTransform.localEulerAngles = m_AngleDes;
        m_SelfTransform.Translate(new Vector3(0, 0, -m_ViewLen));
    }
    void UpdateCamera(float rate)
    {

        if (m_IsBoss)
        {
            int flag = 1;
            float tmpAng = (m_BossRot.y - m_StartDir.y) / (m_EndDir.y - m_StartDir.y);
            tmpAng = m_Cur - tmpAng;
            if (tmpAng < 0)
                flag = -1;
            else if (tmpAng == 0)
            {
                if (m_BossCountTime == m_BossTotalTime)
                {
                    m_SelfTransform.localPosition = m_BossPos;
                    m_SelfTransform.localEulerAngles = m_BossRot;
                    return;
                }
                float fl = m_BossCountTime;

                m_BossCountTime += Time.deltaTime;

                m_BossCountTime = Mathf.Min(m_BossCountTime, m_BossTotalTime);

                m_SelfTransform.localPosition = m_BossStartPos + (m_BossPos - m_BossStartPos) * m_BossCountTime / m_BossTotalTime;
                m_SelfTransform.localEulerAngles = m_BossStartRot + (m_BossRot - m_BossStartRot) * (m_BossCountTime) / (m_BossTotalTime);
                return;
            }
            float tmp = Mathf.Abs(tmpAng);
            tmp = Mathf.Min(tmp, m_RotateArgv * 25 * 5);
            m_Cur += -flag * tmp;
            m_CameraPoint.transform.localPosition = new Vector3(0, (1 - m_Cur) * m_pointHigh, m_Cur);

            m_AngleDes = new Vector3(m_StartDir.x + m_Cur * (m_EndDir.x - m_StartDir.x), m_StartDir.y + m_Cur * (m_EndDir.y - m_StartDir.y), 0);
            m_ViewLen = m_StartDir.z + m_Cur * (m_EndDir.z - m_StartDir.z);
            SetFieldView(m_EndDir.w + (1 - m_Cur) * (m_StartDir.w - m_EndDir.w));//1 + (1 - m_Cur) * (1 - m_Cur) * 40;
            UpdateCamera();
            if (m_BossRot.y - m_SelfTransform.eulerAngles.y < 0.001)
            {
                m_BossStartPos = m_SelfTransform.localPosition;
                m_BossStartRot = m_SelfTransform.localEulerAngles;
            }
            return;
        }

        if (m_BossCountTime > 0)
        {
            m_BossCountTime -= Time.deltaTime;
            m_BossCountTime = Mathf.Max(0, m_BossCountTime);
            m_SelfTransform.localPosition = m_BossStartPos + (m_BossPos - m_BossStartPos) * m_BossCountTime / m_BossTotalTime;
            m_SelfTransform.localEulerAngles = m_BossStartRot + (m_BossRot - m_BossStartRot) * (m_BossCountTime) / (m_BossTotalTime);
            return;
        }
        rate /= 100;
        m_Cur += rate;
        m_Cur = Mathf.Clamp(m_Cur, m_MinRate, m_MaxRate);
        if (m_Cur < 0)
        {
            m_Cur = -m_Cur;
            m_CameraPoint.transform.localPosition = new Vector3(0, (1 - m_Cur) * m_pointHigh, -m_Cur);

            m_AngleDes = new Vector3(m_StartDir.x + m_Cur * (m_EndDir.x - m_StartDir.x), m_StartDir.y + -m_Cur * (m_EndDir.y - m_StartDir.y), 0);

            m_ViewLen = m_StartDir.z + m_Cur * (m_EndDir.z - m_StartDir.z);
            SetFieldView(m_EndDir.w + (1 - m_Cur) * (m_StartDir.w - m_EndDir.w));
            UpdateCamera();
            m_Cur = -m_Cur;
            return;
        }
        m_CameraPoint.transform.localPosition = new Vector3(0, (1 - m_Cur) * m_pointHigh, m_Cur);

        m_AngleDes = new Vector3(m_StartDir.x + m_Cur * (m_EndDir.x - m_StartDir.x), m_StartDir.y + m_Cur * (m_EndDir.y - m_StartDir.y), 0);
        m_ViewLen = m_StartDir.z + m_Cur * (m_EndDir.z - m_StartDir.z);
        SetFieldView(m_EndDir.w + (1 - m_Cur) * (m_StartDir.w - m_EndDir.w));//1 + (1 - m_Cur) * (1 - m_Cur) * 40;
        UpdateCamera();

    }
    public void AutoSetCamera(float t)
    {
        m_StartSecond = t;
        m_State = CarmeraFollowType.AutoRotate;
    }

    public void SetFieldView(float value)
    {
        mCamera.fieldOfView = value;
        if (m_SonCarmera != null && m_SonCarmera.enabled)
        {
            m_SonCarmera.fieldOfView = value;
        }
    }
    /// <summary>
    /// 开启白屏
    /// </summary>
    /// <param name="last"></param>
    public void StartEnd(float last = 0.5f, float stren = 1)
    {
        Invoke("EndWhite", last);
    }
    void EndWhite()
    {
    }
    /// <summary>
    /// 反色效果
    /// </summary>
    /// <param name="lastTime">持续多久</param>
    /// <param name="useTime">使用多久进入反色</param>
    public void StartInvert(float lastTime, float useTime = 0)
    {

        Invoke("CancelInvert", lastTime);
    }

    private void CheckSonCamera()
    {
       
    }

    /// <summary>
    /// 气消反色效果
    /// </summary>
    void CancelInvert()
    {
        DisableSonCamera();
    }

    private void DisableSonCamera()
    {
       
    }
    /// <summary>
    /// 开始模糊跟踪 模糊系数0-1区间  cost多少时间
    /// </summary>
    /// <param name="value"></param>
    /// <param name="cost"></param>
    public void StartMotionBlur(float value, float cost)
    {
        
        Invoke("CancelMotionBlur", cost);
    }
    void CancelMotionBlur()
    {
    }
    /// <summary>
    /// 开启场景模糊 
    /// </summary>
    /// <param name="cost">持续cost 秒</param>
    public void StartBlur(float cost)
    {
        Invoke("CancelBlur", cost);
    }
    void CancelBlur()
    {
      
    }
    /// <summary>
    /// 镜头抖动
    /// </summary>
    /// <param name="cost"></param>
    public void StartShake(float cost, float rate)
    {
        m_CurPosition = transform.position;
        m_Value = rate;
        m_IsShaking = true;
        Invoke("CancelShake", cost);
    }

    void CancelShake()
    {
        transform.position = m_CurPosition;
        if (m_State == CarmeraFollowType.Free)
        {
            UpdateCamera();
        }
        else if (m_State == CarmeraFollowType.Follow)
        {

            m_SelfTransform.localPosition = new Vector3(0, 0, 0);
            m_SelfTransform.localEulerAngles = new Vector3(0, 180, 0);
        }
        m_IsShaking = false;
    }

    void Update()
    {

        if (m_StartAnimateTime < m_TotalNeedTime)
        {
            float tmp = Time.deltaTime;
            m_StartAnimateTime += tmp;
            if (m_StartAnimateTime > m_TotalNeedTime)
            {
                tmp = tmp + m_TotalNeedTime - m_StartAnimateTime;
            }
            SetFieldView(mCamera.fieldOfView + tmp * m_Changing);
        }



        if (CarmeraFollowType.AutoRotate == m_State)
        {
            if (isRight)
            {
                float tmpRotate = m_Cur - m_RotateArgv;
                if (tmpRotate <= m_MinRate)
                {
                    tmpRotate = -m_RotateArgv + tmpRotate + m_MinRate;
                    isRight = false;
                }
                else tmpRotate = -m_RotateArgv;
                UpdateCamera(tmpRotate * 100);
            }
            else
            {

                float tmpRotate = m_Cur + m_RotateArgv;
                if (tmpRotate >= m_MaxRate)
                {
                    tmpRotate = m_RotateArgv - tmpRotate + m_MaxRate;
                    isRight = true;
                }
                else tmpRotate = m_RotateArgv;
                UpdateCamera(tmpRotate * 100);
            }
            Vector3 eulerAngles = transform.eulerAngles;
        }
        else if (m_State == CarmeraFollowType.FocusTarget)
        {
            if (m_NeedFocus == true)
            {
                float len = Vector3.Distance(m_TargetHero.transform.position, m_CameraPoint.transform.position);
                float tmp = Mathf.Min(0.1f, len);
                if (len <= 0)
                {

                    m_State = CarmeraFollowType.Lock;
                    //StartFieldAnimation(0.2f, 32);
                    return;
                }
                m_CameraPoint.transform.position += (tmp * (m_TargetHero.transform.position - m_CameraPoint.transform.position) / len);
                transform.LookAt(m_CameraPoint);
            }
            else
            {
                float len = Vector3.Distance(m_PointPos, m_CameraPoint.transform.position);
                float tmp = Mathf.Min(m_NeedSpeed, len);
                if (len <= 0)
                {

                    m_State = CarmeraFollowType.AutoRotate;
                    return;
                }
                m_CameraPoint.transform.position += (tmp * (m_PointPos - m_CameraPoint.transform.position) / len);
                transform.LookAt(m_CameraPoint);
            }
        }
        else if (CarmeraFollowType.Move == m_State)
        {
            float frameChange = Time.deltaTime / m_StartSecond;
            UpdateCamera(frameChange * 100);
        }
        else if (CarmeraFollowType.Auto == m_State)
        {
            float frameChange = Time.deltaTime / m_StartSecond;
            UpdateCamera(frameChange * 100);
            if (m_Cur >= 0.5f)
            {
                m_State = CarmeraFollowType.AutoRotate;
            }
        }

        m_LastRecord = 0;
        if (m_IsShaking)
        {
            if (CarmeraFollowType.Follow == m_State)
            {
                m_CountTime += Time.deltaTime;
                transform.position = m_Parent.transform.position + new Vector3(0, 0, Mathf.Sin(m_CountTime * 100) * m_Value * 2);
                return;
            }
            m_CountTime += Time.deltaTime;
            transform.position = new Vector3(m_CurPosition.x, m_CurPosition.y, m_CurPosition.z + Mathf.Sin(m_CountTime * 100) * m_Value * 2);
        }
    }
}

using UnityEngine;
using System.Collections;
using SLua;

public class RotateCamera : MonoBehaviour
{

    private bool m_IsMouseDown = false;
    public Transform mTran;
    public float dec = 0.5f;
    public float speed = 1.5f;
    public float slipRate = 0.2f;
    private Vector2 startPos = Vector2.zero;
    private Vector2 endPos = Vector2.zero;
    private bool isMouse = true;
    private float mouseDelta = 4f;
    private float touchDelta = 10f;
    private Camera mCamera;
    private bool fistTouch;
    private System.Action _moveCallBack;
    private UICamera ui_camera;
    private enum SingleModel
    {
        None,
        Single
    }
    private SingleModel singleMode
    {
        get;
        set;
    }
    private GameObject singleObject = null;
    static public RotateCamera Ins = null;
    bool isAutoRotate = false;

    private float slipSpeed = 0.0f;
    void Awake()
    {
        Ins = this;
        LuaManager.getInstance().CallLuaFunction("GameManager.OnInitScene", this);
    }

    void Start()
    {
        singleMode = SingleModel.None;
        mCamera = Camera.main;
        mCamera.cullingMask = 1 << 0;
        transform.parent = mTran;
        ui_camera = GlobalVar.camera.GetComponent<UICamera>();

#if UNITY_EDITOR
        Material mtl = RenderSettings.skybox;
        if (mtl != null)
        {
            mtl.shader = Shader.Find(mtl.shader.name);

        }
        GameObject mGobj = GameObject.Find("scene");
        if (mGobj != null)
        {
            ModelShowUtil.resetShader(mGobj.transform);
        }

#endif

        canMove = true;
        mTran.localPosition = new Vector3(32, mTran.localPosition.y, mTran.localPosition.z);
    }
   
    public void Show()
    {
        gameObject.SetActive(true);
    }
    public void Hide()
    {
        gameObject.SetActive(false);
    }
    public void MoveTo(float num, System.Action cb)
    {
        canMove = false;
        _moveCallBack = cb;
        iTween.Stop(mTran.gameObject);
        iTween.MoveTo(mTran.gameObject, iTween.Hash(new object[]
        {
             "x",
             num,
             "onComplete",
             "onCompleteFinish",
             "onCompleteTarget",
             gameObject,
             "time",
             0.3f
        }));
    }
    public void onCompleteFinish()
    {
        canMove = true;
        if (_moveCallBack != null)
        {
            _moveCallBack.Invoke();
            _moveCallBack = null;
        }

    }
    public void RotateOne(LuaFunction fn, int num)
    {
        canMove = true;
        GuideManager.isModel(true);
        m_IsMouseDown = false;
        isAutoRotate = true;
        MoveTo(num,()=> {
            if(fn != null)
            {
                m_IsMouseDown = false;
                isAutoRotate = false;
                fn.call();
            }
        });
    }
    public void RotateOne(LuaFunction fn)
    {
        RotateOne(fn, 16);
    }
    /// <summary>
    /// 获取点击的屏幕坐标
    /// </summary>
    public Vector3 touchPostion
    {
        get
        {
            if (Input.touchCount > 0)
            {
                isMouse = false;
                return Input.GetTouch(0).position;
            }
            else
            {
                return Input.mousePosition;
            }
        }
    }
    public bool TouchBegin()
    {
#if UNITY_EDITOR
        return Input.GetMouseButtonDown(0);
#else
        if (Input.touchCount == 2) fistTouch = false; 
        return (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began);
#endif
    }
    // Update is called once per frame
    void Update()
    {
        if (!canMove) return;
        if (isAutoRotate) return;
        if (TouchBegin())
        {
            if (UICamera.isOverUI)
            {
                m_IsMouseDown = false;
                return;
            }
            fistTouch = true;
            m_IsMouseDown = true;
            startPos = touchPostion;
        }


        if (m_IsMouseDown && Input.GetMouseButtonUp(0))
        {
            m_IsMouseDown = false;
            Vector2 delta = endPos - startPos;
            float _delta = isMouse ? mouseDelta : touchDelta;
            if (delta.sqrMagnitude < _delta)
            {
                onClickBuilding();
            }
        }
        if (m_IsMouseDown)
        {
            endPos = touchPostion;
            float vx = Input.GetAxis("Mouse X");
            if (fistTouch)
            {
                vx = 0;
                fistTouch = false;
            }
            slipSpeed = vx * slipRate;
            float xpos = mTran.localPosition.x + slipSpeed;
            if (xpos < 0.2f)
            {
                xpos = 0.2f;
                slipSpeed = 0.0f;
            }
            else if (xpos > 37.0f)
            {
                xpos = 37.0f;
                slipSpeed = 0.0f;
            }
            if (singleMode == SingleModel.None)
                mTran.localPosition = new Vector3(xpos, mTran.localPosition.y, mTran.localPosition.z);
        }
        else if (singleMode == SingleModel.None)
        {
            if (Mathf.Abs(slipSpeed) < 0.2f)
            {
                if (mTran.localPosition.x < 2.0f)
                {
                    float xpos = mTran.localPosition.x + 0.2f;
                    mTran.localPosition = new Vector3(xpos, mTran.localPosition.y, mTran.localPosition.z);
                }
                else if (mTran.localPosition.x > 35.5f)
                {
                    float xpos = mTran.localPosition.x - 0.2f;
                    mTran.localPosition = new Vector3(xpos, mTran.localPosition.y, mTran.localPosition.z);
                }
            }
            else
            {
                slipSpeed = Mathf.Sign(slipSpeed) * (Mathf.Abs(slipSpeed) - 0.1f);

                float xpos = mTran.localPosition.x + slipSpeed;
                if (xpos < 0.2f)
                {
                    xpos = 0.2f;
                    slipSpeed = 0.0f;
                }
                else if (xpos > 37.0f)
                {
                    xpos = 37.0f;
                    slipSpeed = 0.0f;
                }
                mTran.localPosition = new Vector3(xpos, mTran.localPosition.y, mTran.localPosition.z);

            }
        }

    }
    static public bool canMove
    {
        get;
        set;
    }

    private void onClickBuilding()
    {
        Ray ray = mCamera.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit))
        {
            BuildCtrlTarget sc = hit.transform.GetComponent<BuildCtrlTarget>();
            GameObject go = null;
            if (sc)
            {
                go = sc.gameObject;
                if (singleMode == SingleModel.Single && go != singleObject)
                {
                    return;
                }
                sc.GetComponent<Collider>().enabled = false;

                sc.onClick();
                sc.GetComponent<Collider>().enabled = true;
                singleMode = SingleModel.None;
            }
        }
    }

    public static void MoveToBuild(BuildCtrlTarget buid,System.Action cb)
    {
        if (Ins)
        {
            buid.showEffect();
            Ins.moveToBuild(buid, cb);
        }
    }
    private void moveToBuild(BuildCtrlTarget buid, System.Action cb)
    {
        singleObject = buid.gameObject;
        singleMode = SingleModel.Single;
        iTween.Stop(mTran.gameObject);
        MoveTo(buid.m_AngleY, cb);

    }
}

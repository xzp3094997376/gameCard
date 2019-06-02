/*************************************************************************************
 * 类 名 称：       UI3DModel
 * 命名空间：       Assets.Scripts.ui
 * 创建时间：       2014/10/9 10:36:43
 * 作    者：       Oliver shen
 * 说    明：       在ui中显示3d模型
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SimpleJson;

/// <summary>
/// 在ui中显示3d模型
/// </summary>
public class UI3DModel : UIWidget
{
    public static int layer_index = 0;
    /// <summary>
    /// 模型相机
    /// </summary>
    private GameObject mCameraObject;
    private Camera mCamera;

    /// <summary>
    /// 模型父节点
    /// </summary>
    private GameObject modelParent;

    /// <summary>
    /// 渲染贴图
    /// </summary>
    private UITexture mTexture;

    private RenderTexture mRenderTexture;

    private bool _enabled = true;
    private int _charId = 0;
    private int _modelId = 0;
    private Dictionary<int, AvatarCtrl> mDictAva;
    private UIRoot _mRoot;
    private SpinWithMouse spin;
    private LayerMask model_layer;
    //public GameObject eff_lv_up;
    //public GameObject eff_power_up_tip;
    public GameObject sunshine;
    ModelCamera modelCamera;
    private Transform mCharNode;
    private int m_modelId;
    private string m_aniName;
    private SLua.LuaFunction _callBack;
    private bool _isTransform = false;
    private bool _canDrag = false;
    private bool _isLoadModel = false;
    private int _effId = 0;
    private float _alpha = 255;

    private string model_path = "";

    [HideInInspector][SerializeField] protected ShowType _type = ShowType.UI;
    protected override void Awake()
    {
        base.Awake();
        //enabled = false;
    }
    protected override void OnStart()
    {
        if (Application.isPlaying)
        {
            layer_index++;
            layer_index %= 10000;
            model_layer = LayerMask.NameToLayer("model");

            //创建贴图，显示模型
            mTexture = NGUITools.AddChild<UITexture>(gameObject);
            mTexture.depth = depth;
            mTexture.width = width;
            mTexture.height = height;
            //mTexture.material = Resources.Load("meterial/talk_maskL", typeof(Material)) as Material;
            mTexture.shader = Shader.Find("Custom/Fix alpha");
            mTexture.gameObject.SetActive(false);
            var pos = Vector3.zero;

            switch (mPivot)
            {
                case Pivot.Bottom:
                    pos.y = height / 2;
                    break;
                case Pivot.BottomLeft:
                    pos.x = width / 2;
                    pos.y = height / 2;
                    break;
                case Pivot.BottomRight:
                    pos.x = -width / 2;
                    pos.y = height / 2;
                    break;
                case Pivot.Left:
                    pos.x = width / 2;
                    break;
                case Pivot.Right:
                    pos.x = -width / 2;
                    break;
                case Pivot.Top:
                    pos.y = -height / 2;
                    break;
                case Pivot.TopLeft:
                    pos.x = width / 2;
                    pos.y = -height / 2;
                    break;
                case Pivot.TopRight:
                    pos.x = -width / 2;
                    pos.y = -height / 2;
                    break;
                case Pivot.Center:
                default:
                    break;

            }

            mTexture.transform.localPosition = pos;
            mTexture.width = (int)(mTexture.width);
            mTexture.height = (int)(mTexture.height);
            //加载模型相片
            _mRoot = GlobalVar.Root;
            mDictAva = new Dictionary<int, AvatarCtrl>();
            mCameraObject = ClientTool.load("Prefabs/publicPrefabs/ModelCamera");
            NGUITools.SetLayer(mCameraObject, model_layer);
            modelCamera = mCameraObject.GetComponent<ModelCamera>();
            mCamera = modelCamera.GetComponent<Camera>();
            if (_type == ShowType.PoYi) 
            {
                //
            }
            else if (_type == ShowType.UI) {
                //
                mTexture.width = (int)(mTexture.width * 1.5);
                mTexture.height = (int)(mTexture.height * 1.5);
            } 
            
            mCameraObject.transform.parent = transform;
            mCamera.cullingMask = 1 << model_layer;
            float s = (1 / _mRoot.transform.localScale.x);
            mCameraObject.transform.localScale = Vector3.one * s;
            mCameraObject.transform.localPosition = new Vector3(layer_index * 10000 * (layer_index % 2), -layer_index * 10000 * ((layer_index + 1) % 2), layer_index * 10000 * ((layer_index + 1) % 3));
          
            //创建渲染贴图附给相片渲染
            if (QualityManager.IsLow())
                mRenderTexture = new RenderTexture((int)(mTexture.width * 1.5), (int)(mTexture.height * 1.5), 24);
            else
                mRenderTexture = new RenderTexture(mTexture.width, mTexture.height, 24);
            mCamera.targetTexture = mRenderTexture;
            mCamera.fieldOfView = 46;
            mTexture.mainTexture = mRenderTexture;

            //初始化
            modelParent = modelCamera.modelParent;
            mCharNode = new GameObject("charNode").transform;
            mCharNode.gameObject.layer = model_layer;
            mCharNode.parent = modelParent.transform;
            mCharNode.localEulerAngles = Vector3.zero;
            mCharNode.localPosition = Vector3.zero;
            mCharNode.localScale = Vector3.one;
            //eff_lv_up = modelCamera.eff_lv_up;
            //eff_power_up_tip = modelCamera.eff_power_up_tip;
            sunshine = modelCamera.sunshine;
        }
        base.OnStart();
        if (_isLoadModel)
        {
            LoadByModelId(m_modelId, m_aniName, _callBack, _isTransform, _effId, _scale);
        }
        if (_canDrag) canDrag(_canDrag);
    }
    /// <summary>
    /// 是否可以拖动
    /// </summary>
    /// <param name="ret"></param>
    public void canDrag(bool ret)
    {
        _canDrag = ret;
        if (!mStarted) return;
        if (ret)
        {
            if (spin == null)
            {
                spin = gameObject.AddComponent<SpinWithMouse>();
                spin.target = modelParent.transform;
                spin.speed = 5;
            }
            else
            {
                spin.enabled = true;
                spin.target = modelParent.transform;
                spin.speed = 5;
            }
        }
        else
        {
            if (spin != null)
            {
                spin.enabled = false;
            }
        }
    }


    public GameObject Target
    {
        get { return mCameraObject; }
    }


    private void HideOldModel()
    {
        if (mDictAva.ContainsKey(_modelId))
        {
            //mDictAva[_modelId].gameObject.SetActive(false);
            if (mDictAva[_modelId])
                GameObject.Destroy(mDictAva[_modelId].gameObject);
            mDictAva[_modelId] = null;
            mDictAva.Remove(_modelId);
        }
    }

    public void showBottom(GameObject go)
    {
        if (modelParent)
        {
            go.layer = modelParent.layer;
            go.transform.parent = modelParent.transform;
        }
    }
    float maxModelValueY = 0;
    private float _scale;
    public void LoadByModelId(int modelId, string aniName, SLua.LuaFunction callBack)
    {
        LoadByModelId(modelId, aniName, callBack, false);
    }
    public void LoadByModelId(int modelId, string aniName, SLua.LuaFunction callBack, bool isTransform)
    {
        LoadByModelId(modelId, aniName, callBack, isTransform, 0);
    }
    public void LoadByModelId(int modelId, string aniName, SLua.LuaFunction callBack, bool isTransform, int effId)
    {
        LoadByModelId(modelId, aniName, callBack, isTransform, effId, 1);
    }
    public void LoadByModelId(int modelId, string aniName, SLua.LuaFunction callBack, bool isTransform, int effId, float scale, float alpha = 255, int isSmall = 0)
    {
        enabled = true;
        if (!mStarted)
        {
            _isLoadModel = true;
            m_modelId = modelId;
            m_aniName = aniName;
            _callBack = callBack;
            _isTransform = isTransform;
            _effId = effId;
            _scale = scale;
            _alpha = alpha;
            return;
        }
        showEffectById(effId);
        if (modelId == _modelId) return;
        mTexture.gameObject.SetActive(false);
        HideOldModel();
        if (mDictAva.ContainsKey(modelId))
        {
            mTexture.gameObject.SetActive(true);
            AvatarCtrl ctrl = mDictAva[modelId];
            ctrl.gameObject.SetActive(true);
            ctrl.PlayAnimation(aniName, true);
            _modelId = modelId;
            callBack.call(ctrl);
            return;
        }
        _modelId = modelId;
        //var mTran = modelParent.transform;
        bool isPet = false;
        if (effId == 100)
            isPet = true;
        AvatarLoad.Instance.LoadAvatar(_modelId, (AvatarCtrl act) =>
        {
            mTexture.gameObject.SetActive(true);
            act.SetPySkin(isTransform);
            model_path = act.model_path;
            if (_alpha < 255) act.SetAlpha(_alpha);
            if (!string.IsNullOrEmpty(aniName))
                act.PlayAnimation(aniName, true);
            for (int i = mCharNode.childCount - 1; i >= 0; i--)
            {
                Object.Destroy(mCharNode.GetChild(i).gameObject);
            }
            if (mCharNode != null)
            {
                act.transform.parent = mCharNode;
            }
            if (isPet)
            {
                act.transform.localScale = new Vector3(0.4f, 0.4f, 0.4f);
            }
            else
            {
                act.transform.localScale = new Vector3(1.0f, 1.0f, 1.0f);
            }
            NGUITools.SetLayer(act.gameObject, model_layer);
            act.transform.localScale = act.transform.localScale * scale;
            act.transform.localPosition = Vector3.zero;
            mDictAva[_modelId] = act;
            mCamera.Render();
            callBack.call(act);
        }, isTransform, isSmall, isPet);
    }

    private void getModelValue(Transform t)
    {
        if (t == null) return;
        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            getModelValue(t0);
        }
        if (t.GetComponent<Renderer>() != null)
        {
            float tempy = t.GetComponent<Renderer>().bounds.size.y;
            if (tempy > maxModelValueY)
            {
                maxModelValueY = tempy;
            }
        }
    }
    /// <summary>
    /// 特效id
    /// </summary>
    /// <param name="effId">特效id,默认为0，角色特效，1为普通难度，2为困难，3为地狱</param>
    /// effid==-1,表示为不要任何特效
    private void showEffectById(int effId)
    {
        if (modelCamera == null) return;
        modelCamera.sunshine.SetActive(false);
        modelCamera.yuantai.SetActive(false);

        mTexture.shader = Shader.Find("Custom/Fix alpha");
        if (effId == 1)
        {
            modelCamera.sunshine.SetActive(true);
            var find = modelCamera.sunshine.transform.FindChild("ui_sunshine");
            if (find)
            {
                find.gameObject.SetActive(false);
            }
        }
        else if (effId == 2)
        {
            modelCamera.yuantai.SetActive(true);
        }
        else if (effId == 3)
        {
            mTexture.material = Resources.Load("meterial/talk_maskL", typeof(Material)) as Material;
        }
        else if (effId == 4)
        {
            mTexture.material = Resources.Load("meterial/talk_maskR", typeof(Material)) as Material;
        }
    }

    public void LoadByCharId(int charId, string aniName, SLua.LuaFunction callBack)
    {
        LoadByCharId(charId, aniName, callBack, false);
    }
    public void LoadByCharId(int charId, string aniName, SLua.LuaFunction callBack, bool isTransform)
    {
        LoadByCharId(charId, aniName, callBack, isTransform, 0);

    }
    public void LoadByCharId(int charId, string aniName, SLua.LuaFunction callBack, bool isTransform, int effId)
    {
        LoadByCharId(charId, aniName, callBack, isTransform, effId, 1);
    }

    /// <summary>
    /// 加载模型显示在ui中
    /// </summary>
    /// <param name="charId">角色id</param>
    /// <param name="aniName">动作名</param>
    /// <param name="callBack">回调</param>
    /// <param name="isTransform">是否变身</param>
    /// <param name="effId">特效id,默认为0，角色特效，1为普通难度，2为困难，3为地狱</param>
    public void LoadByCharId(int charId, string aniName, SLua.LuaFunction callBack, bool isTransform, int effId, float scale)
    {
        _charId = charId;
        JsonObject jo = TableReader.Instance.TableRowByID("char", _charId);
        int _id = jo.num("model_id");
        LoadByModelId(_id, aniName, callBack, isTransform, effId, scale);
    }
    public bool isEnabled
    {
        get { return _enabled; }
        set
        {
            if (_enabled == value) return;
            _enabled = value;
            //if (!_enabled)
            //{
            //    mTexture.shader = Shader.Find("Unlit/Transparent Grays");
            //}
            //else
            //{
            //    mTexture.shader = Shader.Find("Unlit/Transparent Colored");
            //}

        }
    }
    void OnDestroy()
    {
        if (!Application.isPlaying) return;
        this.gameObject.SetActive(false);
        if (mRenderTexture)
        {
            mRenderTexture.Release();
            Object.Destroy(mRenderTexture);
        }
    }
    public enum ShowType
    {
        PoYi,
        UI
    }
}

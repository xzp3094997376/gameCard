using UnityEngine;
using System.Collections;

public class GuideManager : MonoBehaviour
{
    static GuideManager Ins;
    public UICamera mCamera;
    public GameObject mParent;
    public GameObject mHand;
    public UILabel txtDesc;
    public GameObject mNpc;
    public UILabel txtDesc_r;
    public GameObject mNpc_r;
    public GameObject model;
    private UluaBinding mPlot;
    private UluaBinding _dialog;
    Camera _uCamera = null;
    private Camera minCamera=null;
    void Awake()
    {
        //Ins = this;
        _uCamera = mCamera.GetComponent<Camera>();
    }
    void OnDestroy()
    {
        Ins = null;
    }
    void Start()
    {
        NGUITools.SetLayer(gameObject, LayerMask.NameToLayer("Guide"));
        mNpc.SetActive(false);
        mHand.SetActive(false);
        minCamera = GameObject.Find("GameManager/Camera").GetComponent<Camera>();
        _uCamera.rect = minCamera.rect;
    }
    public Vector3 posToView(Transform tran)
    {
        Vector3 pos = Camera.main.WorldToScreenPoint(tran.position);
        pos.z = 0;
        Vector3 pos2 = _uCamera.ScreenToWorldPoint(pos);
        return pos2;
    }
    public void showHand(Transform mTarget, bool isBuild)
    {
        if (mHand)
        {
            if (isBuild)
            {
                Vector3 pos = Camera.main.WorldToScreenPoint(mTarget.position);
                pos.z = 0;
                Vector3 pos2 = _uCamera.ScreenToWorldPoint(pos);
                mHand.transform.position = pos2;
            }
            else
            {
                mHand.transform.position = mTarget.position;
            }
            mHand.SetActive(true);
        }
    }
    private void setNpcPos(string _pos,GameObject _mNpc)
    {
        Bounds b = NGUIMath.CalculateRelativeWidgetBounds(_mNpc.transform);
        Vector3 p = new Vector3();
        float x = 30;
        float y = 40;
        switch (_pos)
        {
            case "left":
                p.x = -b.size.x / 2 - x;
                break;
            case "right":
                p.x = b.size.x / 2 + x;
                break;
            case "top":
                p.y = b.size.y / 2 + y;
                break;
            case "rightTop":
                p.y = b.size.y / 2 + y;
                p.x = b.size.x / 2 + x;
                break;
            case "bottom":
                p.y = -b.size.y / 2 - y;
                break;
            case "leftBottom":
                p.x = -b.size.x / 2 - x;
                p.y = -b.size.y / 2;
                break;
            case "leftTop":
                p.x = -b.size.x / 2 - x;
                p.y = b.size.y / 2 + y;
                break;
            case "rightButton":
                p.y = -b.size.y / 2 - y;
                p.x = b.size.x / 2 + x;
                break;
            default:
                break;
        }
        _mNpc.transform.localPosition = p;
    }
    public void showNpc(string text)
    {
        showNpc(text, "left");
    }
    public void showNpc(string text, string pos)
    {
        if (txtDesc)
        {
            if (string.IsNullOrEmpty(text))
            {
                mNpc.SetActive(false);
                mNpc_r.SetActive(false);
            }
            else
            {
                if (pos == "right" || pos == "rightTop" || pos == "rightButton")
                {
                    txtDesc_r.text = text;
                    mNpc.SetActive(false);
                    mNpc_r.SetActive(true);
                    setNpcPos(pos,mNpc_r);
                }
                else
                {
                    txtDesc.text = text;
                    mNpc.SetActive(true);
                    mNpc_r.SetActive(false);
                    setNpcPos(pos,mNpc);
                }
            }
        }
    }
    public bool show_bg
    {
        set
        {
            if (model && model.activeSelf != value) model.SetActive(value);
        }
    }
    
    public void hideHand()
    {
        mHand.SetActive(false);
    }

    /// <summary>
    /// 显示对话
    /// </summary>
    public void ShowPlot(params object[] args)
    {
        if (mPlot == null)
        {
            mPlot = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/conversationModule/conversation", mParent);
            NGUITools.SetLayer(mPlot.gameObject, mParent.layer);
        }
        mPlot.CallUpdateWithArgs(args);
        mPlot.gameObject.SetActive(true);
    }

    public void DestroyPlot()
    {
        if (mPlot != null)
        {
            DestroyImmediate(mPlot.gameObject);
            mPlot = null;
        }
    }

    public void PlayDialog(params object[] args)
    {
        if (_dialog == null)
        {
            _dialog = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/conversationModule/playDialog", mParent);
            NGUITools.SetLayer(_dialog.gameObject, mParent.layer);
        }
        _dialog.CallUpdateWithArgs(args);
    }

    public void ShowTalk(SLua.LuaTable target, bool isLeft, string name, string text, string img, bool ret = false,string pic="")
    {
        ShowPlot(target, isLeft, name, text, img, ret,pic);
    }

    /// <summary>
    /// 隐藏对话
    /// </summary>
    public void HidePlot()
    {
        if (mPlot)
        {
            mPlot.CallTargetFunction("hide");
            mPlot.gameObject.SetActive(false);
        }
    }

    /// <summary>
    /// 播放剧情
    /// </summary>
    public void PlayThePlot()
    {
        gameObject.AddComponent<AddNewBie>();
    }
    
    public void End()
    {
    }

    public void stop()
    {
    }
   
    public static GuideManager getInstance()
    {
        if (Ins == null)
        {
            var go = ClientTool.load("Prefabs/moduleFabs/guide/GuidePanel");
            go.transform.parent = GlobalVar.MainUI.transform;
            go.transform.localScale = Vector3.one;
            Ins = go.GetComponent<GuideManager>();
        }

        return Ins;
    }
    

    public static void isModel(bool ret)
    {
        ApiLoading.getInstance().isModelGuide(ret);
    }

    public void hide()
    {
        HidePlot();
        hideHand();
    }

}

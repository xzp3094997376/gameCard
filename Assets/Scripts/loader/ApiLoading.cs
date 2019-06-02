/*************************************************************************************
* CLR 版本：       4.0.30319.34014
* 类 名 称：       ApiLoading
* 机器名称：       SHEN
* 命名空间：       Assets.Scripts.loader
* 文 件 名：       ApiLoading
* 创建时间：       2014/6/18 10:22:32
* 作    者：       Oliver shen
* 说    明：       用于加载服务端请求的等待
* 修改时间：
* 修 改 人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
/// <summary>
/// 异步加载进度条
/// </summary>
public class ApiLoading : MonoBehaviour
{
    private bool callHide = false;
    public static ApiLoading install;
    private float mTimeOut = 5;
    Callback callBack;
    public GameObject loading;
    public GameObject touchEffect;
    public Camera mCamera;
    private UICamera ui_camera;
    private bool isGuide = false;
    void Awake()
    {
        install = this;
        hide();
        DontDestroyOnLoad(gameObject);
    }
    void Start()
    {

    }
    public void CallManyFrameLua(SLua.LuaFunction func)
    {
        CallManyFrameLua(func, 1);
    }
    public void CallManyFrameLua(SLua.LuaFunction func, int frame)
    {
        if (func == null || !gameObject.activeInHierarchy) return;
        StartCoroutine(WaitManyFrame(() =>
        {
            func.call();
        }, frame));
    }

    public void CallManyFrame(System.Action cb, int frame)
    {
        if(!gameObject.activeInHierarchy) return;
        StartCoroutine(WaitManyFrame(cb, frame));
    }
    private IEnumerator WaitManyFrame(System.Action cb, int frame)
    {
        int i = 0;
        while (i < frame)
        {
            yield return null;
            i++;
        }
        if (cb != null) cb();
    }
    public void isModelGuide(bool ret)
    {
        isGuide = ret;
        if (!ui_camera && GlobalVar.camera)
        {
            ui_camera = GlobalVar.camera.GetComponent<UICamera>();
        }
        if (ui_camera)
        {
            ui_camera.enabled = !ret;
        }
    }
    public void isModel(bool ret)
    {
        if (isGuide) return;
        if(!ui_camera && GlobalVar.camera)
        {
            ui_camera = GlobalVar.camera.GetComponent<UICamera>();
        }
        if (ui_camera)
        {
            ui_camera.enabled = !ret;
        }
    }
    public void show(float timeOut = 15, Callback callBack = null)
    {
        isModel(true);
        callHide = false;
        this.callBack = callBack;
        mTimeOut = timeOut;
        realShow();

    }
    private void realShow()
    {
        if (callHide) return;
        loading.SetActive(true);
    }
    public void hide()
    {
        isModel(false);
        callHide = true;
        loading.SetActive(false);
    }
    /// <summary>
    /// 显示加载logo
    /// </summary>
    /// <param name="timeOut"></param>
    /// <param name="callBack"></param>
    public static void showLoading(float timeOut = 5, Callback callBack = null)
    {
        ApiLoading api = getInstance();
        if (api)
            api.show(timeOut, callBack);
    }
    IEnumerator TimeOut(float time = 5, Callback cb = null)
    {
        yield return new WaitForSeconds(time);
        if (cb != null)
        {
            cb();
        }
    }
    public static void hideLoading()
    {
        ApiLoading api = getInstance();
        if (api)
            api.hide();
    }
    void OnDestroy()
    {
        install = null;
    }

    public void stopEffect()
    {
        if (touchEffect)
        {
            touchEffect.gameObject.SetActive(false);
        }
    }

    public void showTouchEffect(Vector3 pos)
    {
        if (touchEffect)
        {
            if (pos != null)
            {
                touchEffect.transform.position = mCamera.ScreenToWorldPoint(pos);
            }
            touchEffect.gameObject.SetActive(false);
            touchEffect.gameObject.SetActive(true);
        }
    }
    
    public static ApiLoading getInstance()
    {
        //if (!install)
        //{
        //    GameObject go = ClientTool.load("Prefabs/publicPrefabs/ui_waiting");// GameObject.Instantiate(Resources.Load("Prefabs/publicPrefabs/ui_waiting")) as GameObject;
        //    install = go.GetComponent<ApiLoading>();
        //    GlobalVar.loading = install;
        //}
        return install;
    }
}

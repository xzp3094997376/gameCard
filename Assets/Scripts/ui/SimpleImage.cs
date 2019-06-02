using UnityEngine;
using System.Collections;
using SLua;
using System.IO;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class SimpleImage : MonoBehaviour
{
    private Shader grayShader;
    private Shader normalShader;
    public UITexture mTexture;
    public string imageType = "normal";
    public string autoLoadImage = "";
    private string mUrl = "test"; //加载路径
    public int mDepth = 0; //深度，用于排序
    public int mWidth = 1;
    public int mheight = 1;
    public float scale = 1;
    public bool isGray = false;
    private bool _isGray = false;
    private bool _loaded = false;
    private TexureItem _TexureItem;
    IEnumerator Start()
    {
        yield return null;
        if (!string.IsNullOrEmpty(autoLoadImage))
        {
            Url = UrlManager.GetImagesPath(autoLoadImage);
        }
    }

    void OnDestroy()
    {
        if (_TexureItem != null)
        {
            _TexureItem.release();
        }
    }
    //当前图片是否显示成灰色
    public void isShowGray(bool isShow = false)
    {
        if (_isGray == isShow) return;
        isGray = isShow;
        if (!_loaded) return;
        if (isShow)
        {
            if (grayShader == null)
                grayShader = Shader.Find("Unlit/Transparent Grays");
            mTexture.shader = grayShader;
            // mTexture.color = Color.black;
            _isGray = true;
        }
        else
        {
            if (normalShader == null)
                normalShader = Shader.Find("Unlit/Transparent Colored");
            mTexture.shader = normalShader;
            //mTexture.color = Color.white;
            _isGray = false;
        }
    }

    //特殊类型图片是否显示成灰色
    public void isShowSpecialGray(bool isShow = false)
    {
        if (_isGray == isShow) return;
        isGray = isShow;
        if (!_loaded) return;
        if (isShow)
        {
            mTexture.shader = Shader.Find("Custom/maskbypicture gray");
            _isGray = true;
        }
        else
        {
            mTexture.shader = Shader.Find("Custom/maskbypicture");
            _isGray = false;
        }
    }


    public void changeColor(LuaTable obj)
    {
        float[] tempData = UluaUtil.transTableToFloatArr(obj);
        mTexture.color = new Color(tempData[0], tempData[0], tempData[0]);
    }

    public string Url
    {
        get { return mUrl; }
        set
        {
            if (value != null)
            {
                if (mUrl == value)
                    return;
                mUrl = value;
                LoadUrl(value);
            }
        }
    }

    public void setSize(int w, int h)
    {
        mTexture.SetDimensions(w, h);
        mWidth = w;
        mheight = h;
    }

    protected virtual void LoadUrl(string url)
    {
        if (mTexture == null)
        {
            mTexture = GetComponent<UITexture>();
            if (mTexture == null)
            {
                mTexture = gameObject.AddComponent<UITexture>();
            }
        }
        mTexture.mainTexture = null;
        if (url == "")
        {
            if (_TexureItem != null)
            {
                _TexureItem.release();
                _TexureItem = null;
            }
            mTexture.gameObject.SetActive(false);
            return;
        }
        mTexture.gameObject.SetActive(true);
        load(url);
    }
    void load(string url)
    {
        TexureItem item = TextureCache.getInstance().addImage(url);
        if (item != null)
        {
            ChangeImage(item);
        }
        else
        {
            MyDebug.LogError("can't find image " + url);
        }
        //LoadManager.getInstance().LoadImg(url, CompleteCallBack);
    }
    private void ChangeImage(TexureItem item)
    {
        if (item == null) return;
        if (_TexureItem != null)
        {
            _TexureItem.release();
            _TexureItem = null;
        }
        _TexureItem = item;
        item.retain();
        _loaded = true;
        if (imageType == "normal")
        {
            isShowGray(isGray);
        }
        else
        {
            isShowSpecialGray(isGray);
        }
        mTexture.mainTexture = item.texture;
        if (mDepth != 0)
            mTexture.depth = mDepth;
        if (mWidth == 1 && mheight == 1)
        {
            return;
        }
        mTexture.SetDimensions(mWidth, mheight);
    }
    private void CompleteCallBack(LoadParam param)
    {
        var item = TextureCache.getInstance().addImage(param.texture2d, mUrl);
        ChangeImage(item);
        //_loaded = true;
        //if (imageType == "normal")
        //{
        //    isShowGray(isGray);
        //}
        //else
        //{
        //    isShowSpecialGray(isGray);
        //}
        ////mTexture.mainTexture = null;

        //mTexture.mainTexture = _TexureItem.texture;
        //param = null;
        //mTexture.depth = mDepth;
        //if (mWidth == 1 && mheight == 1)
        //{
        //    return;
        //}
        //mTexture.SetDimensions(mWidth, mheight);
    }

    public void Unload()
    {
        mTexture = null;
    }
}
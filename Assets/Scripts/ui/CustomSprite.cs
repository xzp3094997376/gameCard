using UnityEngine;
using System.Collections;
using System.IO;
public class CustomSprite : MonoBehaviour
{

    public UITexture mTexture;
    public int mDepth = 0; //深度，用于排序
    public int mWidth = 1;
    public int mheight = 1;
    public bool isGray = false;
    public string atlasName;
    private TexureItem _TexureItem;
    private string mUrl = "";
    private Shader grayShader;
    private Shader normalShader;
    public void isShowGray(bool isShow = false)
    {
        if (isGray == isShow) return;
        if (isShow)
        {
            if (grayShader == null)
                grayShader = Shader.Find("Unlit/Transparent Grays");
            mTexture.shader = grayShader;
            isGray = true;
        }
        else
        {
            if (normalShader == null)
                normalShader = Shader.Find("Unlit/Transparent Colored");
            mTexture.shader = normalShader;
            isGray = false;
        }
    }

    void OnDestroy()
    {
        if (_TexureItem != null)
        {
            _TexureItem.release();
        }
    }

    /// <summary>
    /// 设置图片
    /// </summary>
    /// <param name="_spriteName">图片名字</param>
    /// <param name="_altasName">图片贴图名字</param>
    public void setImage(string _spriteName, string _altasName)
    {
        setTexure(_spriteName, _altasName);
    }

    private string formatUrl(string url, string _altasName)
    {
        if (string.IsNullOrEmpty(_altasName)) return url;

        return UrlManager.GetImagesPath(_altasName + "/" + url + ".png");
    }

    private void setTexure(string url,string _altasName)
    {
        url = formatUrl(url,_altasName);
        if (mUrl == url) return;
        mUrl = url;
        if(mTexture == null)
        {
            mTexture = GetComponent<UITexture>();
            if (mTexture == null) return;
        }
        mTexture.mainTexture = null;
        if (url == "")
        {
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

        mTexture.mainTexture = item.texture;
        if (mWidth == 1 && mheight == 1)
        {
            return;
        }
        mTexture.SetDimensions(mWidth, mheight);
    }

}

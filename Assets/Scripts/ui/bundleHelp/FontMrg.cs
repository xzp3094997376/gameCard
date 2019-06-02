using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class FontItem
{
    public int refCount = 0;
    public UIFont font;
    public AssetBundle mBundle;
    public string path;
    public FontItem()
    {

    }
    public FontItem(string path, UIFont t, AssetBundle bundle)
    {
        font = t;
        mBundle = bundle;
        this.path = path;
    }
    public void retain()
    {
        refCount++;
    }
    public void release()
    {
        if (refCount == 0)
        {
            MyDebug.LogError("已经没有引用这个字体了。");
            if (font)
            {
                MyDebug.LogError(font.name);
            }
            return;
        }
        refCount--;
    }

    public bool autoRelease()
    {
        bool ret = false;
        if (refCount == 0)
        {
            destroy();
            ret = true;
        }
        return ret;
    }
    public void destroy()
    {
        font = null;
        if (mBundle)
        {
            mBundle.Unload(true);
        }

    }
}

public class FontMrg
{
    static private FontMrg _instance;
    private Dictionary<string, FontItem> FontDict = new Dictionary<string, FontItem>();
    static public FontMrg getInstance()
    {
        if (_instance == null)
        {
            _instance = new FontMrg();
        }
        return _instance;
    }

    public FontItem getFont(string url)
    {
        if (FontDict.ContainsKey(url))
        {
            return FontDict[url];
        }
        return null;
    }


    public void removeUnusedFont()
    {
        List<string> removeKeys = new List<string>();
        foreach (var i in FontDict)
        {
            FontItem item = i.Value;
            if (item.refCount == 0)
            {
                item.destroy();
                removeKeys.Add(i.Key);
            }
            else
            {
                Debug.Log(item.path + " refCount = " + item.refCount);
            }
        }
        for (int j = 0; j < removeKeys.Count; j++)
        {
            var k = removeKeys[j];
            FontDict[k] = null;
            FontDict.Remove(k);
        }
    }
    public FontItem addFont(string url)
    {
        if (!FontDict.ContainsKey(url))
        {
            string name = System.IO.Path.GetFileNameWithoutExtension(url);
            AssetBundle bundle = FileUtils.getInstance().getAssetBundle(url);
            FontItem item = null;
            if (bundle)
            {
                var go = bundle.LoadAsset(name, typeof(GameObject));
                var font = ((GameObject)go).GetComponent<UIFont>();
                item = new FontItem(url, font, bundle);
            }
            else
            {
                var go = ClientTool.Pureload(url);
                if (go)
                {
                    var font = go.GetComponent<UIFont>();
                    item = new FontItem(url, font, null);
                }
            }
            FontDict.Add(url, item);
            return item;
        }
        return getFont(url);
    }
}

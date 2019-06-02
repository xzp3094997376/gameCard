using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public class AtlasItem
{
    public int refCount = 0;
    public UIAtlas atlas;
    public AssetBundle mBundle;
    public string path;
    public AtlasItem()
    {

    }
    public AtlasItem(string path, UIAtlas t, AssetBundle bundle)
    {
        atlas = t;
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
            MyDebug.LogError("已经没有引用这个图集了。");
            if (atlas)
            {
                MyDebug.LogError(atlas.name);
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
        atlas = null;
        if (mBundle)
        {
            mBundle.Unload(true);
            Debug.Log("unload " + path);
        }
    }
}

public class AtlasMrg
{
    static private AtlasMrg _instance;
    private Dictionary<string, AtlasItem> AtlasDict = new Dictionary<string, AtlasItem>();
    static public AtlasMrg getInstance()
    {
        if (_instance == null)
        {
            _instance = new AtlasMrg();
        }
        return _instance;
    }

    public AtlasItem getAtlas(string url)
    {
        if (AtlasDict.ContainsKey(url))
        {
            return AtlasDict[url];
        }
        return null;
    }
    public void removeUnusedAtlas()
    {
        List<string> removeKeys = new List<string>();
        foreach (var i in AtlasDict)
        {
            AtlasItem item = i.Value;
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
            AtlasDict[k] = null;
            AtlasDict.Remove(k);
        }
    }
    public AtlasItem addAtlas(string url)
    {
        if (!AtlasDict.ContainsKey(url))
        {
            string name = System.IO.Path.GetFileNameWithoutExtension(url);
            AssetBundle bundle = FileUtils.getInstance().getAssetBundle(url);
             AtlasItem item = null;
            if (bundle) 
            {
                var go = bundle.LoadAsset(name, typeof(GameObject));
                var atlas = ((GameObject)go).GetComponent<UIAtlas>();
                item = new AtlasItem(url, atlas, bundle);
            }
            else
            {
                var go = ClientTool.Pureload(url);
                if (go)
                {
                    var atlas = go.GetComponent<UIAtlas>();
                    item = new AtlasItem(url, atlas, null);
                }
            }
            
            AtlasDict.Add(url, item);
            return item;
        }
        return getAtlas(url);
    }

    private Dictionary<string, bool> isLoading = new Dictionary<string, bool>();
    private Dictionary<string, List<System.Action<AtlasItem>>> cbList = new Dictionary<string, List<System.Action<AtlasItem>>>();
    private void callBackKey(string key,AtlasItem item)
    {
        if (cbList.ContainsKey(key))
        {
            var list = cbList[key];
            for (int i = 0; i < list.Count; i++)
            {
                list[i].Invoke(item);
            }
            cbList[key] = null;
            cbList.Remove(key);
            isLoading.Remove(key);
        }
    }
    public IEnumerator addAtlasAsync(string url, System.Action<AtlasItem> cb)
    {
        if (cb == null)
            yield break;
        if (AtlasDict.ContainsKey(url))
        {
            cb(getAtlas(url));
            yield break;
        }
        else
        {
            if (isLoading.ContainsKey(url) && isLoading[url])
            {
                cbList[url].Add(cb);
                yield break;
            }
            isLoading.Add(url, true);
            cbList.Add(url, new List<System.Action<AtlasItem>>() { cb });
            AssetBundleCreateRequest b = FileUtils.getInstance().getAssetBundleFromMemory(url);
            yield return b;
            string name = System.IO.Path.GetFileNameWithoutExtension(url);
            AssetBundle bundle = b.assetBundle;
            if (!bundle)
            {
                callBackKey(url, null);
                yield break;
            }
            var go = bundle.LoadAsset(name, typeof(GameObject));
            var atlas = ((GameObject)go).GetComponent<UIAtlas>();
            AtlasItem item = new AtlasItem(url, atlas, bundle);
            AtlasDict.Add(url, item);
            callBackKey(url, item);
        }
    }
}

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using AssetBundles;

public class TexureItem
{
    public int refCount = 0;
    public Texture2D texture;
    private string path;
    private LoadedAssetBundle asset;

    public TexureItem()
    {

    }
    public TexureItem(Texture2D t)
    {
        texture = t;
    }

    public TexureItem(Texture2D t, LoadedAssetBundle asset, string p) : this(t)
    {
        this.asset = asset;
        this.path = p;
    }

    public void retain()
    {
        refCount++;
        if (asset != null)
        {
            asset.retain();
        }
    }
    public void release()
    {
        if (refCount == 0)
        {
            MyDebug.LogError("已经没有引用这个贴图了。");
            if (texture)
            {
                MyDebug.LogError(texture.name);
            }
            return;
        }
        refCount--;
        if (asset != null)
            asset.release();
    }


    public void destroy()
    {
        if (asset != null)
        {
            texture = null;
            AssetBundles.AssetBundleLoader.UnloadAssetBundle(path);
        }
        else
        {
            Object.Destroy(texture);
            texture = null;
        }
    }
}

/// <summary>
/// 沈西优
/// 贴图管理
/// </summary>
public class TextureCache
{
    private Dictionary<string, TexureItem> _textures = new Dictionary<string, TexureItem>();
    public delegate void DelegateLoadImageCallBack(Texture2D texture);
    static TextureCache _ins;
    private FileUtils fileUtils = null;
    public TextureCache()
    {
        fileUtils = FileUtils.getInstance();
    }
    public static TextureCache getInstance()
    {
        if (_ins == null)
        {
            _ins = new TextureCache();
        }
        return _ins;
    }
    public TexureItem addImage(string path)
    {
        TexureItem textureItem = null;
        path = path.Substring(path.IndexOf("/images") + 1);
        var p = path.ToLower();
        p = Path.GetDirectoryName(p) + "/" + Path.GetFileNameWithoutExtension(p);
        if (_textures.ContainsKey(p))
        {
            textureItem = _textures[p];
        }
        else
        {
            string lastName = Path.GetFileNameWithoutExtension(p);
            if (lastName == "") return null;
            var error = "";
            var asset = AssetBundles.AssetBundleLoader.GetLoadedAssetBundle(p, out error);
            AssetBundle bundle = null;
            if (asset != null)
            {
                bundle = asset.m_AssetBundle;
            }
            if (bundle)
            {

                Texture2D tx = bundle.LoadAsset(lastName, typeof(Texture2D)) as Texture2D;
                if (!tx)
                {
                    bundle.Unload(true);
                    return null;
                }
                textureItem = new TexureItem(tx, asset, p);
                if (_textures.ContainsKey(p))
                {
                    _textures[p] = textureItem;
                }
                else
                    _textures.Add(p, textureItem);
            }
            else
            {
                path = fileUtils.getFullPath(path);
                byte[] thebytes = fileUtils.getBytes(path);
                if (thebytes == null) return null;
                Texture2D texture = null;

                texture = new Texture2D(200, 200, TextureFormat.RGB24, false);

                texture.LoadImage(thebytes);
                thebytes = null;
                //texture.alphaIsTransparency = true;
                texture.Compress(false);
                textureItem = new TexureItem(texture);
                if (_textures.ContainsKey(path))
                {
                    _textures[path] = textureItem;
                }
                else
                    _textures.Add(p, textureItem);
                texture = null;
            }

        }
        return textureItem;
    }

    public void addImageAsync(string path, DelegateLoadImageCallBack callback)
    {

    }

    public TexureItem addImage(Texture2D texture, string path)
    {
        if (texture == null) return null;
        texture.Compress(true);
        TexureItem textureItem = null;
        if (_textures.ContainsKey(path))
        {
            textureItem = _textures[path];
        }
        else
        {
            textureItem = new TexureItem(texture);
            _textures.Add(path, textureItem);
        }
        return textureItem;
    }

    public void removeAllTextures()
    {
        foreach (var i in _textures)
        {
            TexureItem item = i.Value;
            item.destroy();
        }
        _textures.Clear();
    }
    public void removeUnusedTextures()
    {
        List<string> removeKeys = new List<string>();
        int count = 0;
        foreach (var i in _textures)
        {
            TexureItem item = i.Value;
            if (item.refCount == 0)
            {
                
                //MyDebug.Log("释放图片->" + i.Key);
                item.destroy();
                removeKeys.Add(i.Key);
                count++; //每次释放3张纹理，分批释放
                if (count > 2)
                {
                    break;
                }
            }
        }
        for (int j = 0; j < removeKeys.Count; j++)
        {
            var k = removeKeys[j];
            _textures[k] = null;
            _textures.Remove(k);
        }
    }
    public void removeTexture(Texture2D texture)
    {
        string findKey = "";
        foreach (var i in _textures)
        {
            TexureItem item = i.Value;
            if (item.texture == texture)
            {
                item.destroy();
                findKey = i.Key;
                break;
            }
        }
        if (!string.IsNullOrEmpty(findKey))
        {
            _textures[findKey] = null;
            _textures.Remove(findKey);
        }
    }

    public void removeTextureForKey(string key)
    {
        if (_textures.ContainsKey(key))
        {
            _textures[key].destroy();
            _textures[key] = null;
            _textures.Remove(key);
        }
    }

    public string getCachedTextureInfo()
    {
        string desc = "";
        foreach (var i in _textures)
        {
            var item = i.Value;
            string str = "贴图信息：名字{0} width:{1},height:{2},引用：{3}";
            var t = item.texture;
            desc += string.Format(str, i.Key, t.width, t.height, item.refCount) + "\n";
        }
        MyDebug.Log(desc);
        return desc;
    }
}

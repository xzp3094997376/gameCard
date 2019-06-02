using UnityEngine;
using AssetBundles;
public class AssetBundleRef : MonoBehaviour
{
    public string mPath;
    public string mName;
    public static void Add(GameObject go, string path, string name)
    {
        if (!go || string.IsNullOrEmpty(path)) return;
        if(AssetBundleLoader.Retain(path) != null)
        {
            AssetBundleRef com = go.GetComponent<AssetBundleRef>();
            if (!com) com = go.AddComponent<AssetBundleRef>();
            com.mPath = path;
            com.mName = name;
        }
    }

    void OnDestroy()
    {
        AssetBundleLoader.Release(mPath);
    }
}

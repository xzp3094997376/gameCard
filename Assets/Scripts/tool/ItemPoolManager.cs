using UnityEngine;
using PathologicalGames;
public class ItemPoolManager
{
    public static SpawnPool spawnPool;
    public static PrefabPool refabPool;
    private static ItemPoolManager _itemPool = null;
    private static bool _inited = false;

    public static void initPrefabs()
    {
        _inited = true;
        var go = ClientTool.Pureload("Prefabs/publicPrefabs/itemAll");
        if (go)
        {
            AssetBundles.AssetBundleLoader.Retain("Prefabs/publicPrefabs/itemAll".ToLower());
            TTPoolManager.InitPoolAutoLoad("itemAllPool", go.transform, 10);
            go = null;
        }
    }

    public static Transform getItamAllFromPool(Transform parent)
    {
        if (!_inited) initPrefabs();
        return TTPoolManager.GetObjectFromCached("itemAllPool", "itemAll");
    }

    public static void putItamAllToPool(Transform _trans)
    {
        TTPoolManager.Despawn("itemAllPool", _trans);
    }
}

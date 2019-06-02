using UnityEngine;
using System.Collections;
using PathologicalGames;

public class RecycleItemAll : MonoBehaviour
{
    /// <summary>
    /// 到时候记得回收
    /// </summary>
    public void recycleItemAll()
    {
        ItemPoolManager.putItamAllToPool(this.transform);
    }
}

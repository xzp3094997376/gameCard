using UnityEngine;
using System.Collections;

/// <summary>
/// 之所以用LZItemCell 而不用接口，是因为gameObject.GetComponent() 方法不直接接口
/// </summary>
public class LZItemCell : MonoBehaviour
{
    public UluaBinding binding;
    public virtual void Init(object obj, SLua.LuaTable table, bool isDispose=false)
    {
        if (binding != null)
        {
            binding.CallUpdateWithArgs(obj, table);
        }
    }
    public virtual void Dispose()
    {
        binding.CallUpdateWithArgs(null, null);
    }
}

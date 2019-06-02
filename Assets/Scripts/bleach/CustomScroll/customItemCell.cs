using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class customItemCell : MonoBehaviour
{
    public UluaBinding binding;
    public void updateView(object obj,SLua.LuaTable table)
    {
        if (binding != null)
        {
            binding.CallUpdateWithArgs(obj,table);
        }
    }
}

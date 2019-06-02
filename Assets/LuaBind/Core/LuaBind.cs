using UnityEngine;
using System.Collections;
using SLua;
public class LuaBind : MonoBehaviour
{
    private LuaTable bind;
    private LuaFunction _update;
    void Start()
    {
        if (bind != null)
        {
            bind.invoke("Start");
        }
    }

    void Update()
    {
        if (_update != null)
            _update.call(bind);
    }

    public void init(LuaTable b)
    {
        bind = b;
        if (bind != null)
            _update = bind["Update"] as LuaFunction;
    }
}

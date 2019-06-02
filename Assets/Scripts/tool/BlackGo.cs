using UnityEngine;
using System.Collections;

public class BlackGo 
{
    /// <summary>
    /// 设置变灰的
    /// </summary>
    /// <param name="black"></param>
    public static void setBlack(float black, Transform t)
    {
        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            setBlack(black, t0);
        }
        UIWidget[] widget = t.GetComponents<UIWidget>();
        if (widget != null)
        {
            int count = widget.Length;
            for (int i = 0; i < count; i++)
            {
                widget[i].color = new Color(black, black, black);
            }
        }
    }
}

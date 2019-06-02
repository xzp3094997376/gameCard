/*************************************************************************************
* CLR 版本：       4.0.30319.34014
* 类 名 称：       BasePrefabs
* 机器名称：       SHEN
* 命名空间：       Assets.Scripts.ui
* 文 件 名：       BasePrefabs
* 创建时间：       2014/5/29 17:37:56
* 作    者：       Oliver shen
* 说    明：
* 修改时间：
* 修 改 人：
*************************************************************************************/
using UnityEngine;
using System.Collections;

public class BasePrefabs : MonoBehaviour
{
    public UIWidget widget;
    public bool fixesPostion = false;
    public Vector2 pos = Vector2.zero;    
    public Vector3 getPosition(UIAnchor point)
    {
        if (!fixesPostion)
        {
            if (!widget) widget = GetComponent<UIWidget>();
            if (widget)
            {
                pos.x = widget.width;
                pos.y = widget.height;
            }

            if (point == null)
            {
                pos.x = pos.x / 2;
                pos.y = -pos.y / 2;
            }
            else
            {
                switch (point.side)
                {
                    case UIAnchor.Side.BottomLeft:
                        pos.x = pos.x / 2;
                        pos.y = pos.y / 2;
                        break;
                    case UIAnchor.Side.Left:
                        pos.x = pos.x / 2;
                        pos.y = 0;
                        break;
                    case UIAnchor.Side.TopLeft:
                        pos.x = pos.x / 2;
                        pos.y = -pos.y / 2;
                        break;
                    case UIAnchor.Side.Top:
                        pos.x = 0;
                        pos.y = -pos.y / 2;
                        break;
                    case UIAnchor.Side.TopRight:
                        pos.x = -pos.x / 2;
                        pos.y = -pos.y / 2;
                        break;
                    case UIAnchor.Side.BottomRight:
                        pos.x = -pos.x / 2;
                        pos.y = pos.y / 2;
                        break;
                    case UIAnchor.Side.Right:
                        pos.x = -pos.x / 2;
                        pos.y = 0;
                        break;
                    case UIAnchor.Side.Bottom:
                        pos.x = 0;
                        pos.y = pos.y / 2;
                        break;
                    case UIAnchor.Side.Center:
                        pos.x = 0;
                        pos.y = 0;
                        break;


                }
            }
        }
        
        
        return pos;
    }

    public void initPrefabs(UIAnchor point)
    {
        transform.localScale = Vector3.one;
        transform.localPosition = getPosition(point);
    }

}

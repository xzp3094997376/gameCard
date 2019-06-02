using UnityEngine;
using System;

/// <summary>
/// 负责移动滚动条的类
/// </summary>
public class LZDragComponent : MonoBehaviour
{
    public LZScrollView scrollview;
    public GameObject dragCollider;
    public Transform movePanel;
    private int mousePos = 0;
    private int recordDrapDis = 0; // 记录每一次移动的位移(有正有负)
    private int moveRange = 0; //松开手指最后一刹那的作用力
    private Vector3 dropOverTargetPos = Vector3.zero; //最终位置
    private bool dropOverMoving = false;//是否开始位移
    private float tempDisplacement = 0; // 临时位移
    private float accelerated = 0.05f;//加速度  0.1-1 之间
    private float moveSpeed = 1;//速度

    void Start()
    {
        UIEventListener.Get(dragCollider).onDrag = DragPanel;
        UIEventListener.Get(dragCollider).onPress = PressCollider;
    }

    /// <summary>
    /// 拖动函数
    /// </summary>
    /// <param name="delta">delta.y 负数则是往下拖动  正数往上拖动</param>
    /// 
    public void DragPanel(GameObject go, Vector2 delta)
    {
        if (scrollview.isPlaying)
        {
            return;
        }
        if (scrollview.getSourceData.Count <= 0)
        {
            return;
        }
        int interval = 0;
        if (scrollview.movement == LZMovement.Vertical)
        {
            interval = Math.Abs(mousePos - Convert.ToInt32(Input.mousePosition.y)) * getsymbol(delta.y);
        }
        else
        {
            interval = Math.Abs(mousePos - Convert.ToInt32(Input.mousePosition.x)) * getsymbol(delta.x);
        }
        recordDrapDis += interval;
        if (scrollview.isPress)
        {
            Vector3 v3 = movePanel.localPosition;
            if (scrollview.movement == LZMovement.Vertical)
            {
                mousePos = Convert.ToInt32(Input.mousePosition.y); //新值
                v3.y += interval;
            }
            else
            {
                mousePos = Convert.ToInt32(Input.mousePosition.x); //新值
                v3.x += interval;
            }
            movePanel.localPosition = v3;
            interval = 0;
            calculate();
        }
        if (scrollview.movement == LZMovement.Vertical)
        {
            moveRange = Convert.ToInt32(delta.y);
        }
        else
        {
            moveRange = Convert.ToInt32(delta.x);
        }
    }

    // 获取相乘的符号
    private int getsymbol(float num)
    {
        if (num >= 0)
            return 1;
        else
            return -1;
    }

    //计算子物件的增加或者减少
    private void calculate()
    {
        if (scrollview.movement == LZMovement.Vertical)
        {
            if (recordDrapDis > scrollview.itemWidthandheight.y / 2) //往上一定是正数
            {
                int fount = (int)((double)recordDrapDis / Convert.ToInt32(scrollview.itemWidthandheight.y) + 0.5);
                recordDrapDis = recordDrapDis - fount * Convert.ToInt32(scrollview.itemWidthandheight.y);
                for (int i = 0; i < fount; i++)
                {
                    scrollview.plusItem();
                }
            }
            else if (recordDrapDis < -scrollview.itemWidthandheight.y / 2)
            {
                int fount = (int)((double)Math.Abs(recordDrapDis) / Convert.ToInt32(scrollview.itemWidthandheight.y) + 0.5);
                recordDrapDis = recordDrapDis + (fount * Convert.ToInt32(scrollview.itemWidthandheight.y));
                for (int i = 0; i < fount; i++)
                {
                    scrollview.minuItem();
                }
            }
        }
        else
        {
            if (recordDrapDis < -scrollview.itemWidthandheight.x / 2) //往左一定是负数
            {
                int fount = (int)((double)Math.Abs(recordDrapDis) / Convert.ToInt32(scrollview.itemWidthandheight.x) + 0.5);
                recordDrapDis = recordDrapDis + fount * Convert.ToInt32(scrollview.itemWidthandheight.x);
                for (int i = 0; i < fount; i++)
                {
                    scrollview.plusItem();
                }
            }
            else if (recordDrapDis > scrollview.itemWidthandheight.x / 2) //往右是正数
            {
                int fount = (int)((double)Math.Abs(recordDrapDis) / Convert.ToInt32(scrollview.itemWidthandheight.x) + 0.5);
                recordDrapDis = recordDrapDis - (fount * Convert.ToInt32(scrollview.itemWidthandheight.x));
                for (int i = 0; i < fount; i++)
                {
                    scrollview.minuItem();
                }
            }
        }
    }

    public void PressCollider(GameObject go, bool bo)
    {
        if (scrollview.isPlaying || scrollview.getSourceData.Count <= 0)
        {
            return;
        }
        if (bo)
        {
            recordDrapDis = 0;
            if (scrollview.movement == LZMovement.Vertical)
            {
                mousePos = Convert.ToInt32(Input.mousePosition.y); //开始拖动的时候记录鼠标的基础位置
            }
            else
            {
                mousePos = Convert.ToInt32(Input.mousePosition.x); //开始拖动的时候记录鼠标的基础位置
            }
        }
        scrollview.isPress = bo;
        if (scrollview.isPress == false) //移动结束
        {
            overDragCalculate();
        }
    }


    private void overDragCalculate()
    {
        DragFinished();
    }

    /// <summary>
    /// 开始移动
    /// </summary>
    void Update()
    {
        if (dropOverMoving)
        {
            float dis = Vector3.Distance(movePanel.localPosition, dropOverTargetPos);
            if (dis <= 0)
            {
                moveRange = 0;
                dropOverMoving = false;
                movePanel.localPosition = dropOverTargetPos;
                DragFinished();
                return;
            }
            movePanel.localPosition = Vector3.MoveTowards(movePanel.localPosition, dropOverTargetPos, moveSpeed);
            moveSpeed = moveSpeed - accelerated;
            tempDisplacement = tempDisplacement + moveSpeed;

            if (scrollview.movement == LZMovement.Vertical)
            {
                if (tempDisplacement >= scrollview.itemWidthandheight.y)
                {
                    if (moveRange > 0)
                    {
                        scrollview.plusItem();
                    }
                    else
                    {
                        scrollview.minuItem();
                    }
                    tempDisplacement = tempDisplacement - scrollview.itemWidthandheight.y;
                }
            }
            else
            {
                if (tempDisplacement >= scrollview.itemWidthandheight.x)
                {
                    if (moveRange > 0)
                    {
                        scrollview.plusItem();
                    }
                    else
                    {
                        scrollview.minuItem();
                    }
                    tempDisplacement = tempDisplacement - scrollview.itemWidthandheight.x;
                }
            }
        }
    }

    public void DragFinished()
    {
        scrollview.adjustingLocation();
    }

    public void onDispose()
    {
        dragCollider = null;
        movePanel = null;
    }
}
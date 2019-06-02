using UnityEngine;
using System.Collections;
using System;

public class DragPageComponent : MonoBehaviour
{
    public GameObject dragCollider;
    public GameObject[] arrayItem;
    public Transform movePanel;
    private int currPage = 1; //当前页数  最小为1
    private int maxPage = 3;//最大页数 最小为3
    private int truePage = 1;//当前实际最大页数
    public float moveCount = 50;//拖动大于moveCount 或者小于-moveCount  会翻页
    public float moveSpeed = 5;//翻页的速度
    public float distance = 800;//每个item的间距  中心对中心
    private Vector3 identityPos;//翻页前的坐标
    private Vector3 targetPos;
    public static float deltaCount;//已经拖动的值
    public static bool isPress;  //可能其他地方有用到
    public static bool isPlaying; //可能其他地方有用到

    public delegate void InitTransInfo(GameObject[] go, int page);
    public InitTransInfo initTransInfo;

    public delegate void ChangeTransInfo(GameObject go, int page, bool bol);
    public ChangeTransInfo changeTransInfo;

    public delegate void ErrorCallBack(bool bol);
    public ErrorCallBack errorCallback;


    public int GetCurrPage()
    {
        return currPage;
    }

    /// <summary>
    /// 上一页下一页翻动的函数
    /// </summary>
    /// <param name="_targetPage"></param>
    public void SetCurrPage(string _targetPage)
    {
        if (isPlaying)
        {
            return;
        }
        if (isPress)
        {
            return;
        }
        int targetPage = Convert.ToInt32(_targetPage);
        if (targetPage == currPage || targetPage > truePage || targetPage < 1)
        {
            return;
        }
        identityPos = movePanel.localPosition;
        if (Math.Abs(targetPage - currPage) >= 2)
        {
            currPage = targetPage;
            SetInitTrans();
            return;
        }
        if (targetPage < currPage)
        {
            MoveToRight();
        }
        else
        {
            MoveToLeft();
        }
        isPlaying = true;
    }

    private enum MoveState
    {
        none,
        left,
        right,
        back
    }

    private MoveState moveState = MoveState.none;
    void Start()
    {
        UIEventListener.Get(dragCollider).onDrag = DragPanel;
        UIEventListener.Get(dragCollider).onPress = PressCollider;
        arrayItem[0].transform.localPosition = new Vector3(-distance, 0, 0);
        arrayItem[1].transform.localPosition = new Vector3(0, 0, 0);
        arrayItem[2].transform.localPosition = new Vector3(distance, 0, 0);
    }

    public void SetInit(int _currPage, int _maxPage, int _truePage)
    {
        if (_currPage < 1)
        {
            _currPage = 1;
        }
        if (_maxPage < _currPage)
        {
            _maxPage = _currPage;
        }
        if (_maxPage < 3)
        {
            MyDebug.LogError("Max Page Must Bigger Than 3");
            return;
        }
        currPage = _currPage;
        truePage = _truePage;
        maxPage = _maxPage;
        SetInitTrans();
    }

    /// <summary>
    /// 初始化数据
    /// </summary>
    void SetInitTrans()
    {
        if (currPage == 1)
        {
            arrayItem[0].name = maxPage.ToString();
            arrayItem[1].name = currPage.ToString();
            arrayItem[2].name = (currPage + 1).ToString();
        }
        else if (currPage == maxPage)
        {
            arrayItem[0].name = (maxPage - 1).ToString();
            arrayItem[1].name = currPage.ToString();
            arrayItem[2].name = "1";
        }
        else
        {
            arrayItem[0].name = (currPage - 1).ToString();
            arrayItem[1].name = currPage.ToString();
            arrayItem[2].name = (currPage + 1).ToString();
        }
        if (initTransInfo != null)
        {
            initTransInfo.Invoke(arrayItem, currPage);
        }
    }

    void Update()
    {
        if (isPlaying)
        {
            float dis = Vector3.Distance(movePanel.localPosition, targetPos);
            if (dis <= 0)
            {
                movePanel.localPosition = targetPos;
                MoveFinished();
            }
            else
            {
                movePanel.localPosition = Vector3.MoveTowards(movePanel.localPosition, targetPos, Time.deltaTime * 500 * moveSpeed);
            }
        }
    }

    public void DragPanel(GameObject go, Vector2 delta)
    {
        if (isPlaying)
        {
            return;
        }
        if (!isPress)
        {
            return;
        }
        Vector3 v3 = movePanel.localPosition;
        deltaCount += delta.x;
        v3.x += delta.x;
        if (deltaCount >= 70)
        {
            if (currPage <= 1)
            {
                return;
            }
        }
        else if (deltaCount <= -70)
        {
            if (currPage >= truePage)
            {
                return;
            }
        }
        movePanel.localPosition = v3;
    }

    public void PressCollider(GameObject go, bool bo)
    {
        if (isPlaying)
        {
            return;
        }
        if (bo)
        {
            deltaCount = 0;
            identityPos = movePanel.localPosition;
        }
        else
        {
            if (isPress)
            {
                if (deltaCount >= moveCount)
                {
                    if (currPage > 1)
                    {
                        MoveToRight();
                    }
                    else
                    {
                        if (errorCallback != null)
                        {
                            errorCallback.Invoke(false);
                        }
                        BackToIdentity();
                    }
                }
                else if (deltaCount <= -moveCount)
                {
                    if (currPage < truePage)
                    {
                        MoveToLeft();
                    }
                    else
                    {
                        if (errorCallback != null)
                        {
                            errorCallback.Invoke(true);
                        }
                        BackToIdentity();
                    }
                }
                else
                {
                    BackToIdentity();
                }
            }
        }
        isPress = bo;
    }


    /// <summary>
    /// 下一页
    /// </summary>
    public void MoveToLeft()
    {
        moveState = MoveState.left;
        Vector3 v3 = movePanel.localPosition;
        targetPos = identityPos;
        targetPos.x -= distance;
        isPlaying = true;
        MusicManager.playByID(20);
    }

    /// <summary>
    /// 上一页
    /// </summary>
    public void MoveToRight()
    {
        moveState = MoveState.right;
        Vector3 v3 = movePanel.localPosition;
        targetPos = identityPos;
        targetPos.x += distance;
        isPlaying = true;
        MusicManager.playByID(20);
    }

    public void BackToIdentity()
    {
        moveState = MoveState.back;
        Vector3 v3 = movePanel.localPosition;
        targetPos = identityPos;
        isPlaying = true;
    }

    public void MoveFinished()
    {
        GameObject tempGo = null;
        switch (moveState)
        {
            case MoveState.left:
                currPage++;
                if (currPage > maxPage)
                {
                    currPage = 1;
                }
                tempGo = arrayItem[0];
                arrayItem[0] = arrayItem[1];
                arrayItem[1] = arrayItem[2];
                arrayItem[2] = tempGo;
                SetLeftPage(tempGo);

                break;
            case MoveState.right:
                currPage--;
                if (currPage < 1)
                {
                    currPage = maxPage;
                }

                tempGo = arrayItem[2];
                arrayItem[2] = arrayItem[1];
                arrayItem[1] = arrayItem[0];
                arrayItem[0] = tempGo;
                SetRightPage(tempGo);
                break;
            case MoveState.back:
                break;
        }
        isPlaying = false;
    }

    void SetRightPage(GameObject go)
    {
        int tempName = (currPage - 1);
        if (tempName < 1)
        {
            tempName = maxPage;
        }
        go.name = tempName.ToString();
        Vector3 v3 = go.transform.localPosition;
        v3.x -= 3 * distance;
        go.transform.localPosition = v3;
        SetInfo(go, tempName);
    }

    void SetLeftPage(GameObject go)
    {
        int tempName = (currPage + 1);
        if (tempName > maxPage)
        {
            tempName = 1;
        }
        go.name = tempName.ToString();
        Vector3 v3 = go.transform.localPosition;
        v3.x += 3 * distance;
        go.transform.localPosition = v3;
        SetInfo(go, tempName);
    }

    /// <summary>
    /// 移动之后的回调方法
    /// </summary>
    /// <param name="go"></param>
    /// <param name="page"></param>
    void SetInfo(GameObject go, int page)
    {
        if (changeTransInfo != null)
        {
            changeTransInfo.Invoke(go, currPage, true);
        }
    }

    public void onDispose()
    {
        dragCollider = null;
        arrayItem[0] = null;
        arrayItem[1] = null;
        arrayItem[2] = null;
        arrayItem = null;
        movePanel = null;
        initTransInfo = null;
        changeTransInfo = null;
        errorCallback = null;
    }
}
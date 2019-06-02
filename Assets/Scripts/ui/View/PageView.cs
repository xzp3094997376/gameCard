/*************************************************************************************
* CLR 版本：       4.0.30319.34014
* 类 名 称：       PageView
* 机器名称：       SHEN
* 命名空间：       
* 文 件 名：       PageView
* 创建时间：       2014/5/24 9:58:21
* 作    者：       Oliver shen
* 说    明：       翻页列表
* 修改时间：
* 修 改 人：
*************************************************************************************/
using UnityEngine;
using System.Collections;

public class PageView : MonoBehaviour
{

    public GameObject pageItemPrefab;
    public GameObject dragCollider;
    public GameObject[] arrayItem;

    public Transform movePanel;
    public Transform pageItemParent;

    private GameObject[] pageItem;

    private int currPage = 1; //当前页数  最小为1
    private int maxPage = 3;//最大页数 最小为3

    public float moveCount = 50;//拖动大于moveCount 或者小于-moveCount  会翻页
    public float moveSpeed = 5;//翻页的速度
    public float distance = 900;//每个item的间距  中心对中心
    private float deltaCount;//已经拖动的值

    private Vector3 identityPos;//翻页前的坐标
    private Vector3 targetPos;

    private bool isPress;
    private bool isPlaying;

    public delegate void InitTransInfo(GameObject[] go, int page);
    public InitTransInfo initTransInfo;

    public delegate void ChangeTransInfo(GameObject go, int page);
    public ChangeTransInfo changeTransInfo;
    public SLua.LuaFunction callBack;
    public int GetCurrPage()
    {
        return currPage;
    }

    private enum MoveState
    {
        none,
        left,
        right,
        back
    }

    private MoveState moveState = MoveState.none;
    private bool isStart;
    private bool _want_init;

    // Use this for initialization
    void Start()
    {
        UIEventListener.Get(dragCollider).onDrag = DragPanel;
        UIEventListener.Get(dragCollider).onPress = PressCollider;

        arrayItem[0].transform.localPosition = new Vector3(-distance, 0, 0);
        arrayItem[1].transform.localPosition = new Vector3(0, 0, 0);
        arrayItem[2].transform.localPosition = new Vector3(distance, 0, 0);
        isStart = true;
        if (_want_init)
        {
            SetInit(currPage, maxPage);
        }
        //for test
        /*currPage = 9;
        maxPage = 9;
		SetInit(currPage,maxPage);*/
    }
    public void SetCallBack(SLua.LuaFunction cb)
    {
        callBack = cb;
    }

    public void SetInit(int _currPage, int _maxPage)
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
        maxPage = _maxPage;
        if (!isStart)
        {
            _want_init = true;
            return;
        }
        if (pageItemPrefab)
        {
            CreatPageItem();
        }
        SetInitTrans();
    }

    void CreatPageItem()
    {
        pageItem = new GameObject[maxPage];
        int width = pageItemPrefab.GetComponent<UISprite>().width;
        for (int i = 0; i < maxPage; i++)
        {
            GameObject go = Instantiate(pageItemPrefab) as GameObject;
            go.transform.parent = pageItemParent;
            go.transform.localPosition = new Vector3(i * width, 0, 0);
            go.transform.localScale = Vector3.one;
            pageItem[i] = go;
        }
        float pos = pageItem[0].transform.localPosition.x + pageItem[maxPage - 1].transform.localPosition.x;
        Vector3 v3 = pageItemParent.localPosition;
        v3.x = -pos / 2;
        pageItemParent.localPosition = v3;
    }

    void SetInitTrans()
    {
        if (currPage == 1)
        {
            arrayItem[0].name = maxPage.ToString();
            arrayItem[1].name = currPage.ToString();
            arrayItem[2].name = (currPage + 1).ToString();
            if (initTransInfo != null)
            {
                initTransInfo.Invoke(arrayItem, currPage);
            }
            else
            {
                SetInfo(arrayItem[0], maxPage, true);
                SetInfo(arrayItem[1], currPage, true);
                SetInfo(arrayItem[2], currPage + 1, true);
            }
        }
        else if (currPage == maxPage)
        {
            arrayItem[0].name = (maxPage - 1).ToString();
            arrayItem[1].name = currPage.ToString();
            arrayItem[2].name = "1";
            if (initTransInfo != null)
            {
                initTransInfo.Invoke(arrayItem, currPage);
            }
            else
            {
                SetInfo(arrayItem[0], maxPage - 1, true);
                SetInfo(arrayItem[1], currPage, true);
                SetInfo(arrayItem[2], 1, true);
            }
        }
        else
        {
            arrayItem[0].name = (currPage - 1).ToString();
            arrayItem[1].name = currPage.ToString();
            arrayItem[2].name = (currPage + 1).ToString();
            if (initTransInfo != null)
            {
                initTransInfo.Invoke(arrayItem, currPage);
            }
            else
            {
                SetInfo(arrayItem[0], currPage - 1, true);
                SetInfo(arrayItem[1], currPage, true);
                SetInfo(arrayItem[2], currPage + 1, true);
            }
        }
        if (pageItemPrefab)
            SetPageLight();

    }
    /// <summary>
    /// 上一页下一页翻动的函数
    /// </summary>
    /// <param name="_targetPage"></param>
    public void move(int dir)
    {
        if (isPlaying)
        {
            return;
        }
        if (isPress)
        {
            return;
        }
        
        identityPos = movePanel.localPosition;
        if (dir == 1)
        {
            MoveToRight();
        }
        else
        {
            MoveToLeft();
        }
        isPlaying = true;
    }
    void SetPageLight()
    {
        foreach (GameObject go in pageItem)
        {
            UISprite sprite = go.GetComponentInChildren<UISprite>();
            Color color = sprite.color;
            color.a = 0.5f;
            sprite.color = color;
        }

        UISprite pageSprite = pageItem[currPage - 1].GetComponentInChildren<UISprite>();
        Color pageColor = pageSprite.color;
        pageColor.a = 1f;
        pageSprite.color = pageColor;
    }

    // Update is called once per frame
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
                    MoveToRight();
                }
                else if (deltaCount <= -moveCount)
                {
                    MoveToLeft();
                }
                else
                {
                    BackToIdentity();
                }
            }
        }

        isPress = bo;
    }

    public void MoveToLeft()
    {
        moveState = MoveState.left;
        Vector3 v3 = movePanel.localPosition;
        targetPos = identityPos;
        targetPos.x -= distance;
        isPlaying = true;
    }

    public void MoveToRight()
    {
        moveState = MoveState.right;
        Vector3 v3 = movePanel.localPosition;
        targetPos = identityPos;
        targetPos.x += distance;
        isPlaying = true;
    }

    void BackToIdentity()
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
        if (pageItemPrefab)
            SetPageLight();

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
    public void DisableDrag(bool ret)
    {
        if (dragCollider)
        {
            dragCollider.GetComponent<Collider>().enabled = !ret;
        }
    }
    public int getCurPage()
    {
        return currPage;
    }
    public UluaBinding getCurPageObject()
    {
        var go = getCenter();
        return go.GetComponent<UluaBinding>();
    }
    public GameObject getCenter()
    {
        return arrayItem[1];
    }
    void SetInfo(GameObject go, int page,bool ret = false)
    {
        if (changeTransInfo != null)
        {
            changeTransInfo.Invoke(go, page);
        }
        else
        {
            if (callBack != null)
            {
                var bind = go.GetComponent<UluaBinding>();
                callBack.call(bind, page, ret);
            }
        }
    }
}

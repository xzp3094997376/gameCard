using UnityEngine;
using System.Collections.Generic;
using SimpleJson;
using System.Collections;

public class NoticeWindow : MonoBehaviour
{
    static private NoticeWindow instance;
    public GameObject Content;
    public RichTextContent showText;
    private List<string> noticeList = new List<string>(); //接下来马上播放的信息
    public bool isShowing = false; //是否正在漂字
    private int autoPlayTimes = 0;
    private int autoPlayInterval = 10; //自动读取配置文件信息的时间间隔
    private List<NoticeMsgVO> tempNoticeList = new List<NoticeMsgVO>(); //存储接下来需要播放的信息（XX分钟以后播放的那种）
    private int totelIndex = 0;
    private ArrayList msgList = new ArrayList();
    private bool isPlaying = false;
    void Start()
    {
        this.gameObject.SetActive(false);
        TableReader.Instance.ForEachTable("loadTips", (int num, JsonObject row) =>
        {
            msgList.Add(row["desc"]);
            return false;
        });
        totelIndex = msgList.Count;
        autoPlayInterval = TableReader.Instance.TableRowByID("GMconfig", 1).get<int>("args1");
        InvokeRepeating("LaunchProjectile", 1, 5);//1秒后调用LaunchProjectile () 函数，之后每5秒调用一次
    }

    public void LaunchProjectile()
    {
        if (GlobalVar.currentScene == "")
        {
            if (msgList.Count>0)
            {
                msgList.Clear();
            }
            return;
        }
        // ①看看缓存列表里面的时间是否到点
        int tempCount = tempNoticeList.Count;
        if (tempCount > 0)
        {
            for (int i = tempCount - 1; i >= 0; i--)
            {
                tempNoticeList[i].times -= 5;
                if (tempNoticeList[i].times <= 0)
                {
                    noticeList.Add(tempNoticeList[i].noticeMsg);
                    tempNoticeList.RemoveAt(i);
                }
            }
        }

        //②如果没有信息，则自动5分钟一次调用配置里的信息
        autoPlayTimes += 5;
        if (autoPlayTimes >= autoPlayInterval) //临时数据
        {
            autoPlayTimes = 0;
            if (noticeList.Count <= 0)
            {
                noticeList.Add(msgList[Random.Range(1, totelIndex)].ToString());
            }
        }
        //③显示详细信息
        if (noticeList.Count > 0)
        {
            this.gameObject.SetActive(true);
            showText.clearContent();
            showText.ParseValue(noticeList[0]);
            noticeList.RemoveAt(0);
          //  FrameTimerManager.getInstance().add(2, 1, moveLabel);
            Content.transform.localPosition = new Vector3(485, 2, 0);
            targetPos = new Vector3(showText.currentContentMaxWidth > 480 ? (480 - showText.currentContentMaxWidth) : (showText.currentContentMaxWidth - 480), 2, 0);
            isPlaying = true;
        }
        else
        {
            this.gameObject.SetActive(false);
        }
    }

    private Vector3 targetPos = Vector3.one;
    void Update()
    {
        if (isPlaying)
        {
            float dis = Vector3.Distance(Content.transform.localPosition, targetPos);
            if (dis <= 0)
            {
                Content.transform.localPosition = targetPos;
                isPlaying = false;
            }
            else
            {
                Content.transform.localPosition = Vector3.MoveTowards(Content.transform.localPosition, targetPos, Time.deltaTime * 150);
            }
        }
    }

    public void moveLabel()
    {
        FrameTimerManager.getInstance().remove(moveLabel);
        Content.transform.localPosition = new Vector3(485, 2, 0);
        int xpoint = showText.currentContentMaxWidth > 480 ? (480 - showText.currentContentMaxWidth) : 0;
        TweenPosition.Begin(Content, 4, new Vector3(xpoint, 2, 0));
    }

    
    /// <summary>
    /// 获取单例
    /// </summary>
    /// <returns></returns>
    public static NoticeWindow getInstance()
    {
        if (instance == null)
        {
            instance = GameObject.Find("GameManager/Camera/notice/annunciate/content").GetComponent<NoticeWindow>();
        }
        return instance;
    }
}
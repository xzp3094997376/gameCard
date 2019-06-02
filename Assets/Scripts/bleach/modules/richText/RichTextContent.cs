using UnityEngine;
using System.Text.RegularExpressions;
using System;
using System.Collections.Generic;
using SLua;

/// <summary>
/// 富文本类
/// </summary>
public class RichTextContent : MonoBehaviour
{
    public GameObject contentGo;
    public UIWidget bg;
    public int defaultFontSize = 20;
    public Transform labelTrans;
    public Transform spriteTrans;
    public Transform imageTrans;
    private int initHeight = 0;
    private int initWidth = 0;
    private List<string> contentlist = new List<string>();  //需要生成的内容
    private int currentPointX = 0;
    private int currentPointY = 0;
    private int currentLineMaxHeight = 25;
    public List<Transform> currentLineThing = new List<Transform>();
    private List<int> currentLineThingHeight = new List<int>();
    private UILabel contentLabel;
    private UISprite contentSprite;
    private SimpleImage contentImage;
    public int currentContentMaxWidth = 0;// 此富文本最大长度
    void Start()
    {
        initHeight = bg.height;
        initWidth = bg.width;
        labelTrans.gameObject.SetActive(false);
        if (spriteTrans != null)
            spriteTrans.gameObject.SetActive(false);
        imageTrans.gameObject.SetActive(false);
    }

    /// <summary>
    /// 需要填充的富文本
    /// </summary>
    /// <param name="tables"></param>
    /// <param name="needFillString"></param>
    public void fillCharacter(LuaTable tables, string needFillString)
    {
        List<string> tempList = new List<string>();
        foreach (var item in tables)
        {
            tempList.Add(item.value.ToString());
        }
        if (tempList.Count > 0)
        {
            ParseValue(String.Format(needFillString, tempList.ToArray()));
        }
        tempList = null;
        tables = null;
    }

    public void ParseValueURL(string value)
    {
        if (string.IsNullOrEmpty(value))
            return;
        //value = System.Web.HttpUtility.UrlDecode(value);
        ParseValue(value);
    }

    /// <summary>
    /// 不需要任何填充的富文本内容
    /// </summary>
    /// <param name="value"></param>
    public void ParseValue(string value)
    {
        if (string.IsNullOrEmpty(value))
            return;
        currentContentMaxWidth = 0;
        int startIndex = 0;
        int endIndex = 0;
        string saveString = "";
        string pattern = "(?<=<split>).*?(?=</split>)";
        MatchCollection matchs = Regex.Matches(value, pattern);
        int counts = matchs.Count;
        if (counts > 0)
        {
            for (int i = 0; i < counts; i++)
            {
                startIndex = i > 0 ? matchs[i - 1].Index + matchs[i - 1].Value.Length + 8 : 0;
                endIndex = i > 0 ? matchs[i].Index - matchs[i - 1].Index - matchs[i - 1].Value.Length - 8 : matchs[i].Index;
                string partFirst = value.Substring(startIndex, endIndex);
                int indexFont = partFirst.IndexOf("<split>");
                saveString = partFirst.Substring(0, indexFont);
                if (!string.IsNullOrEmpty(saveString))
                {
                    contentlist.Add(saveString);
                }
                contentlist.Add(matchs[i].Value);
                if (i == counts - 1)
                {
                    if (matchs[i].Index + matchs[i].Value.Length + 8 < value.Length)
                    {
                        startIndex = matchs[i].Index + matchs[i].Value.Length + 8;
                        endIndex = value.Length - startIndex;
                        saveString = value.Substring(startIndex, endIndex);
                        contentlist.Add(saveString);
                    }
                }
            }
        }
        else
        {
            contentlist.Add(value);
        }
        analyzeStr();
    }

    //分析
    private void analyzeStr()
    {
        FrameTimerManager.getInstance().add(1, 0, analyzeStrTimer);
        currentHandleIndex = 0;
    }

    private int currentHandleIndex = 0; //当前处理的位置
    private void analyzeStrTimer()
    {
        for (int i = 0; i < 10; i++) //1帧处理10条文本
        {
            if (currentHandleIndex == contentlist.Count)
            {
                aligningEveryLine();
                setBgHeight();
                FrameTimerManager.getInstance().remove(analyzeStrTimer);
                currentHandleIndex = 0;
                return;
            }
            string tempStr = contentlist[currentHandleIndex];
            if (tempStr.IndexOf("sprite=") != -1)
            {
                CreateSprite(tempStr, false);
            }
            else if (tempStr.IndexOf("spriteLink=") != -1)
            {
                CreateSprite(tempStr, true);
            }
            else if (tempStr.IndexOf("img=") != -1)
            {
                CreateUrlImage(tempStr, false);
            }
            else if (tempStr.IndexOf("imgLink=") != -1)
            {
                CreateUrlImage(tempStr, true);
            }
            else
            {
                CreatLabels(tempStr);
            }
            currentHandleIndex++;
        }
    }

    /// <summary>
    /// 生成文本
    /// </summary>
    /// <param name="str"></param>
    public void CreatLabels(string str)
    {
        string[] strArr = RichTextUtil.GroupString(str);
        string pattern = "<br=[0-9]+>";
        string tempStr = "";
        for (int i = 0; i < strArr.Length; i++)
        {
            tempStr = strArr[i];
            int count = Regex.Matches(tempStr, pattern).Count;
            if (count > 0)
            {
                currentContentMaxWidth = 0;
                currentPointY -= (currentLineMaxHeight + Convert.ToInt32(tempStr.Substring(4, tempStr.Length - 5)));
                currentPointX = 0;//换行之后，就要重新设置X值
                aligningEveryLine();//重新排版
                currentLineThing.Clear();
                currentLineThingHeight.Clear();
                currentLineMaxHeight = 25;
            }
            else
            {
                if (strArr[i].IndexOf("labelclick=") != -1)
                {
                    CreateLinkLabel(strArr[i]);
                }
                else
                {
                    CreateLabel(strArr[i]);
                }
            }
        }
    }

    /// <summary>
    /// 生成超链接文本
    /// </summary>
    /// <param name="str"></param>
    public void CreateLinkLabel(string str)
    {
        int fontsize = defaultFontSize;
        if (str.IndexOf("ξ") != -1)
        {
            string[] fontArr = str.Split(new char[] { 'ξ' });
            str = fontArr[1];
            fontsize = Convert.ToInt32(fontArr[0]);
            fontArr = null;
        }
        str = str.Replace("labelclick=", "");
        string[] strArr = str.Split(',');
        Transform trans = null;
        contentLabel = null;
        trans = (Transform)Instantiate(labelTrans);
        trans.gameObject.SetActive(true);
        BoxCollider box = trans.gameObject.AddComponent<BoxCollider>();
        trans.gameObject.AddComponent<CustomButton>();
        trans.parent = contentGo.transform;
        contentLabel = trans.GetComponent<UILabel>();
        contentLabel.transform.localScale = Vector3.one;
        contentLabel.text = strArr[0];
        box.size = new Vector3(contentLabel.width, contentLabel.height, 1);
        box.center = new Vector3(contentLabel.width / 2, -contentLabel.height / 2, 1);
        contentLabel.transform.localPosition = new Vector3(currentPointX, currentPointY, 0);
        contentLabel.fontSize = fontsize;
        currentPointX += contentLabel.width;
        RichTextClick clickEvent = contentLabel.gameObject.AddComponent<RichTextClick>();
        clickEvent.currentParams = strArr; //参数复制
        currentLineThing.Add(trans);
        currentLineThingHeight.Add(contentLabel.height);
        if (currentLineMaxHeight < contentLabel.height)
        {
            currentLineMaxHeight = contentLabel.height;
        }
        currentContentMaxWidth += contentLabel.width;
    }

    /// <summary>
    /// 生成普通文本
    /// </summary>
    /// <param name="str"></param>
    public void CreateLabel(string str)
    {
        string[] strArr = str.Split(new char[] { 'ξ' });
        Transform trans = null;
        contentLabel = null;
        trans = (Transform)Instantiate(labelTrans);
        trans.gameObject.SetActive(true);
        trans.parent = contentGo.transform;
        contentLabel = trans.GetComponent<UILabel>();
        contentLabel.transform.localScale = Vector3.one;
        if (strArr.Length > 1)
        {
            contentLabel.text = str.Substring(str.IndexOf("ξ") + 1, str.Length - str.IndexOf("ξ") - 1);
            contentLabel.fontSize = Convert.ToInt32(strArr[0]);
        }
        else
        {
            contentLabel.text = strArr[0];
        }
        contentLabel.transform.localPosition = new Vector3(currentPointX, currentPointY, 0);
        currentPointX += contentLabel.width;
        currentLineThing.Add(trans);
        currentLineThingHeight.Add(contentLabel.height);
        currentLineMaxHeight = currentLineMaxHeight > contentLabel.height ? currentLineMaxHeight : contentLabel.height;
        currentContentMaxWidth += contentLabel.width;
    }

    //普通的精灵图片
    public void CreateSprite(string spriteName, bool isCanClick)
    {
        //sprite=star,10,20
        spriteName = spriteName.Replace("sprite=", "");
        string[] strArr = spriteName.Split(',');
        Transform trans = null;
        contentSprite = null;
        trans = (Transform)Instantiate(spriteTrans);
        trans.gameObject.SetActive(true);
        trans.parent = contentGo.transform;
        trans.localScale = Vector3.one;
        contentSprite = trans.GetComponent<UISprite>();
        contentSprite.SetDimensions(Convert.ToInt32(strArr[1]), Convert.ToInt32(strArr[2]));
        contentSprite.spriteName = strArr[0];
        contentSprite.transform.localPosition = new Vector3(currentPointX + 5, currentPointY, 0);
        currentPointX += contentSprite.width + 5;
        currentLineMaxHeight = currentLineMaxHeight > contentSprite.height ? currentLineMaxHeight : contentSprite.height;
        currentLineThing.Add(trans);
        currentLineThingHeight.Add(contentSprite.height);
        currentContentMaxWidth += contentSprite.width;
    }

    //url图片
    public void CreateUrlImage(string url, bool isCanClick)
    {
        //img=imgurl,10,20
        url = url.Replace("img=", "");
        string[] strArr = url.Split(',');
        Transform trans = null;
        contentSprite = null;
        trans = (Transform)Instantiate(imageTrans);
        trans.gameObject.SetActive(true);
        trans.parent = contentGo.transform;
        trans.localScale = Vector3.one;
        contentImage = trans.GetComponent<SimpleImage>();
        contentImage.setSize(Convert.ToInt32(strArr[1]), Convert.ToInt32(strArr[2]));
        contentImage.Url = UrlManager.GetImagesPath(strArr[0]);
        contentImage.transform.localPosition = new Vector3(currentPointX + 5, currentPointY, 0);
        currentPointX += Convert.ToInt32(strArr[1]) + 5;
        currentLineMaxHeight = currentLineMaxHeight > Convert.ToInt32(strArr[2]) ? currentLineMaxHeight : Convert.ToInt32(strArr[2]);
        currentLineThing.Add(trans);
        currentLineThingHeight.Add(Convert.ToInt32(strArr[2]));
        currentContentMaxWidth += Convert.ToInt32(strArr[1]) + 5;
    }

    //富文本背景以及可拖动范围设置
    private void setBgHeight()
    {
        if (-currentPointY > initHeight)
        {
            bg.SetDimensions(initWidth, -currentPointY);
            BoxCollider box = bg.GetComponent<BoxCollider>();
            box.size = new Vector3(initWidth, -currentPointY, 1);
            box.center = new Vector3(initWidth / 2, currentPointY / 2, 1);
        }
    }

    /// <summary>
    /// 每一行的排版函数
    /// </summary>
    private void aligningEveryLine()
    {
        int count = currentLineThing.Count;
        if (count > 20 || count == 0)
        {
            currentLineThing.Clear();
            currentLineThingHeight.Clear();
            return;
        }
        for (int i = 0; i < count; i++)
        {
            currentLineThing[i].localPosition += new Vector3(0, (currentLineThingHeight[i] - currentLineMaxHeight), 0);
        }
    }

    public void clearContent()
    {
        int count = contentGo.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            GameObject go = contentGo.transform.GetChild(i).gameObject;
            Destroy(go);
        }
        defaultFontSize = 20;
        currentPointX = 0;
        currentPointY = 0;
        currentLineMaxHeight = 25;
        contentlist.Clear();
        currentLineThing.Clear();
        currentLineThingHeight.Clear();
    }
    void OnDestroy()
    {
        FrameTimerManager.getInstance().remove(analyzeStrTimer);
    }
}
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class OperateAlert
{
    private static OperateAlert instance;
    private float DIS = 90;		//最高位置
    private float SPACE = 20;	//文本之间相隔距离
    private int DELAY = 30;	//消失的间隔时间,单位:帧
    private List<UIPanel> txts = new List<UIPanel> { };
    private bool _running;
    private Dictionary<UIPanel, float> dic = new Dictionary<UIPanel, float>();
    private List<object> textList;
    private List<GameObject> DynamicTextList;
    private GameObject preGameObjectParent = null;
    private int mMaxCount = 20;
    private bool isPlayingg;
    public OperateAlert()
    {
    }

    public void show(string message)
    {
        GameObject go = ApiLoading.getInstance().gameObject;
        UIPanel txtContain = NGUITools.AddChild<UIPanel>(go);
        txtContain.gameObject.layer = go.layer;
        txtContain.name = "OperateAlert";
        txtContain.transform.localPosition = new Vector3(0, 0, 0);
        txtContain.transform.localScale = Vector3.one;
        txtContain.depth = 600;

        UILabel txt;
        GameObject txtObj = null;
        txtObj = ClientTool.load("Prefabs/baseUIFabs/Label", txtContain.gameObject);
        txt = txtObj.GetComponent<UILabel>();
        //txtObj.transform.parent = txtContain.transform;
        txtObj.transform.localScale = Vector3.one;
        txt.width = Screen.width;
        txt.pivot = UIWidget.Pivot.Center;
        txt.effectColor = new Color(0, 0, 0);
        txt.effectStyle = UILabel.Effect.Outline;
        txt.fontSize = 20;
        txt.color = Color.red;
        txt.transform.localPosition = new Vector3(0, 0, 0);
        txt.text = message;
        dic[txtContain] = DELAY;
        txts.Add(txtContain);
        adjust();
        if (!_running)
        {
            FrameTimerManager.getInstance().add(2, 0, onMove);
            _running = true;
        }
    }

    public void showMsgToGameObject(string message, GameObject go)
    {
        UIPanel txtContain = NGUITools.AddChild<UIPanel>(go);
        txtContain.gameObject.layer = go.layer;
        txtContain.name = "OperateAlert";
        txtContain.transform.localPosition = new Vector3(0, 0, 0);
        txtContain.transform.localScale = Vector3.one;
        txtContain.depth = 600;

        UILabel txt;
        GameObject txtObj = null;
        txtObj = ClientTool.load("Prefabs/baseUIFabs/Label", txtContain.gameObject);
        txt = txtObj.GetComponent<UILabel>();
        txtObj.transform.localScale = Vector3.one;
        txt.width = Screen.width;
        txt.pivot = UIWidget.Pivot.Center;
        txt.effectColor = new Color(0, 0, 0);
        txt.effectStyle = UILabel.Effect.Outline;
        txt.fontSize = 20;
        txt.transform.localPosition = new Vector3(0, 0, 0);
        txt.text = message;
        dic[txtContain] = DELAY;
        txts.Add(txtContain);
        //adjust();
        if (!_running)
        {
            FrameTimerManager.getInstance().add(3, 0, onMove);
            _running = true;
        }

    }

    IEnumerator PlayMsgText(UIPanel txt)
    {
        yield return new WaitForSeconds(1f);

        Debug.Log("add -----------");
    }

    private void onMove()
    {
        for (int i = 0; i < txts.Count; i++)
        {
            UIPanel txt = txts[i];
            float left = dic[txt];
            left--;
            dic[txt] = left;
            if (left < 10)
            {
                txt.alpha = left * 0.1f;
            }
            if (left <= 0 || txt.transform.localPosition.y > DIS)
            {
                GameObject.Destroy(txt.gameObject);
                dic.Remove(txt);
                txts.RemoveAt(i);
                i--;
                if (txts.Count == 0)
                {
                    //没有内容就删除定时器
                    FrameTimerManager.getInstance().remove(onMove);
                    _running = false;
                }
            }
        }
    }
    //适应位置
    private void adjust()
    {
        if (txts.Count <= 1) return;

        UIPanel endTxt = txts[txts.Count - 1];
        UIPanel prevTxt = txts[txts.Count - 2];
        float endTxtY = endTxt.transform.localPosition.y;
        float prevTxtY = prevTxt.transform.localPosition.y;
        float sp = endTxtY - prevTxtY;
        if (sp < SPACE)
        {
            foreach (UIPanel txt in txts)
            {
                if (endTxt != txt)
                    txt.transform.localPosition = new Vector3(txt.transform.localPosition.x, txt.transform.localPosition.y + (SPACE - sp), -600);
            }
        }
    }
    void ClearDynamicTextList()
    {
        if (DynamicTextList == null) return;
        foreach (var i in DynamicTextList)
        {
            GameObject.Destroy(i);
        }
        DynamicTextList.Clear();
        isPlayingg = false;
    }
    public void showToGameObject(SLua.LuaTable textList, GameObject go)
    {
        showList(ClientTool.LuaTableToCSharp(textList), go);
    }

    public void showToGameObjectQuick(string message, GameObject go)
    {
        //showList(ClientTool.LuaTableToCSharp(textList), go, true);
        HUDText text = go.GetComponentInChildren<HUDText>();
        if (!text)
        {
            var DynamicText = ClientTool.load("Prefabs/publicPrefabs/DynamicText2", go);
            text = DynamicText.GetComponent<HUDText>();
        }
        text.Add(message, Color.white, 0);
    }

    public void showList(List<object> list, GameObject go, bool isQuick = false)
    {
        HUDText text = go.GetComponentInChildren<HUDText>();
        if (!text)
        {
            string path = "Prefabs/publicPrefabs/DynamicText";
            path = isQuick ? "Prefabs/publicPrefabs/DynamicText2":path;
            var DynamicText = ClientTool.load(path, go);
            text = DynamicText.GetComponent<HUDText>();
        }
        text.StopAllCoroutines();
        if (text.gameObject.activeInHierarchy)
        {
            text.StartCoroutine(PlayHudText(list, text));
        }
    }
    IEnumerator PlayHudText(List<object> list, HUDText text)
    {
        for (int i = 0; i < list.Count; i++)
        {
            yield return new WaitForSeconds(1.0f);
            text.Add(list[i], Color.white, 0);
        }
    }
    

    private int goodsCount, goodsIndex;
    public void showGetGoods(SLua.LuaTable textList, GameObject go)
    {
        showGetGoods(textList, go, 0, null);
    }
    public void showGetGoods(SLua.LuaTable textList, GameObject go, int i)
    {
        showGetGoods(textList, go, i, null);
    }
    public void showGetGoods(SLua.LuaTable textList, GameObject go, int i, SLua.LuaFunction cb)
    {
        goodsCount = 0;
        goodsIndex = 0;
        List<object> list = ClientTool.LuaTableToCSharp(textList);
        goodsCount = list.Count;
        if(go == null || goodsCount < 1) return;
		if (i == 0)
			showGoods (list, go);
		else
            showGetGoodsWithBox(list, go, cb);
    }
    bool needAddPiece(string type)
    {
        if (type == "charPiece" || type == "ghostPiece" || type == "petPiece")
            return true;
        else
            return false;

    }
        
        
    void showGoods(List<object> list, GameObject go)
    {
        if (go == null) return;

        var panel = go.GetComponentInChildren<UIPanel>();

        if (panel == null)
        {
            panel = NGUITools.AddChild<UIPanel>(go);
            panel.depth = 100;
        }   
        if (goodsIndex >= list.Count) return;
        var dynamic = ClientTool.load("Prefabs/publicPrefabs/bugTips", panel.gameObject);
        SLua.LuaTable data = (SLua.LuaTable)list[goodsIndex];
        string text = data["text"].ToString();
		string goodsname = data["goodsname"].ToString();	
        string type = data["type"].ToString();

        if (!string.IsNullOrEmpty(text))
        {
            if (!string.IsNullOrEmpty(type) && needAddPiece(type))
            {
				dynamic.transform.Find("Label").GetComponent<UILabel>().text = "[05fc17]" + Localization.Get("Text_1_178") + " [-]" + "[ffffff]" + goodsname +Localization.Get("LocalKey_330") + "[-]" + "[05fc17]" + " X" + text + "[-]";
            }
            else
            {
				dynamic.transform.Find("Label").GetComponent<UILabel>().text = "[05fc17]" + Localization.Get("Text_1_178") + " [-]" + "[ffffff]" + goodsname + "[-]" + "[05fc17]" + " X" + text + "[-]";
            }
		}
        goodsIndex++;
		var pos = dynamic.transform.localPosition;
        pos.y += 160;
        var tween = TweenPosition.Begin(dynamic, 1.5f, pos, false);
        var scale = TweenScale.Begin(dynamic, 1f, Vector3.one);
        tween.SetOnFinished(() =>
        {
                GameObject.Destroy(dynamic.gameObject);
        });
        if(goodsCount > 1)
        {
            goodsCount--;
            if (list[goodsCount] != null)
            {
                FrameTimerManager.getInstance().add(15, 1, () =>
                {
                    showGoods(list, go);
                });
            }
        }
    }

    public static OperateAlert getInstance
    {
             get
            {
                if (instance == null)
                {
                    instance = new OperateAlert();
                }
                return instance;
            }
    }

    //宝箱弹出获得物品
    public void showGetGoodsWithBox(List<object> list, GameObject go)
    {
        showGetGoodsWithBox(list, go, null);
    }
    public void showGetGoodsWithBox(List<object> list, GameObject go, SLua.LuaFunction cb)
    {
        MusicManager.playByID(43);
		var Baoxiang_prefab = ClientTool.load("Prefabs/publicPrefabs/Baoxiang_prefab", GlobalVar.center);
		UIGrid grid = Baoxiang_prefab.gameObject.transform.FindChild ("Grid").GetComponent<UIGrid> ();
		GameObject ani = Baoxiang_prefab.gameObject.transform.FindChild ("baoxiang").gameObject;
		ClientTool.PlayAnimation (ani,"Take 001");
		DestroyObject goodsManager = Baoxiang_prefab.gameObject.transform.FindChild ("Sprite").GetComponent<DestroyObject> ();
        if (cb != null)
        {
            goodsManager.setCallBack(() =>
            {
                cb.call();
            });
        }
        
		List <GameObject> gos = new List<GameObject> ();
		List <GameObject> items = new List<GameObject> ();
		List <GoodsItem> goods = new List<GoodsItem> ();
        FrameTimerManager.getInstance().add(1, 1, () =>
        {
			if (list == null || go == null)
				return;
			for(int i = 0 ; i < list.Count ; i ++)
			{
				GoodsItem item = new GoodsItem ();
                SLua.LuaTable data = (SLua.LuaTable)list[i];
			//	string type;
				//int.TryParse(data["type"].ToString(), out type);
                item.type = data["type"].ToString();
				item.icon = data["icon"].ToString();
				item.text = data["text"].ToString();
				item.goodsname = data["goodsname"].ToString();
				item.atlasName = data["atlasName"].ToString();
                item.frame = data["frame"].ToString();
				goods.Add(item);
			}
			if (goods.Count > 0 )
			{
				for(int i = 0 ; i < goods.Count ; i++)
				{
					GameObject temp = new GameObject();
					temp.transform.parent = grid.gameObject.transform;
					temp.transform.localPosition = new Vector3(0,0,-800);
					temp.transform.localScale = Vector3.one;
					gos.Add(temp);
				}	
			}
			grid.Reposition();
		});
		FrameTimerManager.getInstance().add (20, 1,() => 
        {
			var effect = ClientTool.load("Effect/Prefab/ui_kaibaoxiang", Baoxiang_prefab.gameObject);
			effect.gameObject.transform.localPosition = new Vector3(0,-100,-600);
        });

		FrameTimerManager.getInstance().add (5, 1,() => 
    	{
			if (gos.Count > 0 )
			{
				for(int i = 0 ; i < gos.Count ; i++)
				{
					var item = ClientTool.load("Prefabs/publicPrefabs/goodsItem",Baoxiang_prefab.gameObject);
					item.SetActive(false);
					GoodsItemManager manager = item.gameObject.GetComponent<GoodsItemManager>();
					manager.serInfo(goods[i].icon,goods[i].goodsname,goods[i].text,goods[i].type,goods[i].frame,goods[i].atlasName);
					item.transform.localPosition = new Vector3(0,-120,-500);
					items.Add(item);
				}
				FrameTimerManager.getTimer().add (2, 1,() => 
          		{
					for(int i = 0 ; i < items.Count ; i++)
					{
						items[i].SetActive(true);
						items[i].transform.parent = gos[i].transform;
						UITweener ts = TweenPosition.Begin(items[i],0.4f,Vector3.zero);
						items[i].GetComponent<GoodsItemManager>().flash.SetActive(true);
						items[i].GetComponent<TweenRotation>().enabled = true;
                        ts.SetOnFinished(() =>
                        {
							goodsManager.isClick = true;
						});
					}
				});
            }
            else
				Debug.LogError("what the fuck");
		});
    }
}




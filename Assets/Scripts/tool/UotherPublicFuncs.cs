using UnityEngine;
using SLua;
using System;
using System.Collections.Generic;
using DataModel;
/// <summary>
///公共方法
/// </summary>
[CustomLuaClass]
public class UotherPublicFuncs
{
    private static UotherPublicFuncs _instance = null;
    public string m_SceneName = null;
    public static UotherPublicFuncs Instance
    {
        get
        {
            if (_instance == null)
                _instance = new UotherPublicFuncs();
            return _instance;
        }
    }

    /// <summary>
    /// 实例化放在Resoures下的预设，以后可能会放到服务器，需要先加载，后实例化
    /// </summary>
    /// <param name="dataVO"></param>
    /// <returns></returns>
    public void instantiateGmeObject(LuaTable dataVO)
    {
    }


    /// <summary>
    /// 实例化物品
    /// </summary>
    /// <param name="parentGo"></param>
    /// <param name="dataVO"></param>
    public void instantiateGmeObject(GameObject parentGo, LuaTable dataVO)
    {
        GameObject tempGO = null;
        float[] _pos = UluaUtil.transTableToFloatArr(dataVO["mPos"] as LuaTable);
        float[] _scale = UluaUtil.transTableToFloatArr(dataVO["mLocale"] as LuaTable);
        tempGO = GameObject.Instantiate(Resources.Load(dataVO["mUrlString"].ToString())) as GameObject;
        tempGO.transform.parent = parentGo.transform;
        tempGO.name = dataVO["mGoName"].ToString();
        tempGO.transform.localPosition = new Vector3(_pos[0], _pos[1], _pos[2]);
        tempGO.transform.localScale = new Vector3(_scale[0], _scale[1], _scale[2]);
        UIGrid grid = parentGo.GetComponent<UIGrid>();
        if (grid != null)
        {
            grid.Reposition();
        }
    }

    /// <summary>
    /// 生成预设，并且回调预设内的方法
    /// </summary>
    /// <param name="parentGo"></param>
    /// <param name="dataVO"></param>
    /// <param name="dataes"></param>
    /// <param name="target"></param>
    public UluaBinding instantiateGmeObjectAndCallBack(GameObject parentGo, LuaTable dataVO)
    {
        GameObject go = ClientTool.load(dataVO["mUrlString"].ToString(), parentGo);
        if (dataVO["index"] != null)
        {
            go.name = dataVO["index"].ToString();
        }
        var comp = go.GetComponent<UluaBinding>();
        UIGrid grid = parentGo.GetComponent<UIGrid>();
        if (grid != null)
        {
            grid.Reposition();
        }
        if (comp)
        {
            comp.CallUpdate(dataVO);
        }
        return comp;
    }

    /// <summary>
    /// 缓动预设
    /// </summary>
    /// <param name="go"></param>
    /// <param name="args"></param>
    public void itwwenGo(GameObject go, LuaTable args, LuaFunction cb = null)
    {
        Vector3 _pos = UluaUtil.transTableToVectory3(args["mPos"] as LuaTable);
        float _time = UluaUtil.transTableToFloat(args["mTime"] as LuaTable);
        TweenPosition.Begin(go, _time, _pos);
        if (cb != null)
        {
            tempFun = cb;
            FrameTimerManager.getTimer().add(1, 1, ImplementCallback);
        }
    }

    private LuaFunction tempFun;
    private void ImplementCallback()
    {
        FrameTimerManager.getTimer().remove(ImplementCallback);
        tempFun.call();
    }

    /// <summary>
    /// 批处理命令生成子类预设
    /// </summary>
    /// <param name="actionList"></param>
    public void instantiateCommands(LuaTable actionList, LuaFunction calls)
    {
        foreach (var objitem in actionList)
        {
            instantiateGmeObject(objitem.value as LuaTable);
        }
        if (calls != null)
        {
            calls.call();
        }
    }
    public void openOrCloseWindow(string mdouleName, string prefabsUrl, LuaTable index, LuaFunction callBack)
    {
    }
    /// <summary>
    /// 销毁对象
    /// </summary>
    /// <param name="obj"></param>
    public void DestroyGameOject(GameObject obj)
    {
        if (obj == null) return;
        GameObject.Destroy(obj);
    }

    /// <summary>
    /// 根据名字销毁对象
    /// </summary>
    /// <param name="dataVO"></param>
    public void DestroyGameOjectByName(LuaTable dataVO)
    {
    }
    public void callBackFightFromScrip(LuaTable data)
    {
        FightManager.Inst.m_IsNewBie = false;
        FightManager.Inst.m_IsCGBattle = true;
      
        string scene_id = data["scene"] as string; ;//UnityEngine.Random.value > 0.2f ? "chanZuiGongQianMen" : "chanZuiGong";
     
        GlobalVar.FightData = data;

        string fakeScript = data["script"] as string;
        if (!string.IsNullOrEmpty(fakeScript))
        {
            FightManager.Inst.m_IsNewBie = true;//设置虚假战斗的标志
           
            TranslateScripts.Inst.ExcuteLuaFile("uLuaModule/modules/conversation/" + fakeScript + ".lua");
            return;
        }
    }
    /// <summary>
    /// 选人界面之后调用的战斗接口
    /// </summary>
    /// <param name="data"></param>
    public void callBackFight(LuaTable data)
    {
        FightManager.Inst.m_IsNewBie = false;
        FightManager.Inst.m_IsCGBattle = false;
        SimpleJson.JsonObject battle_data = data["battle"] as SimpleJson.JsonObject;
        FightManager.Inst.m_Data = battle_data;
        if (data["drop"] != null)
        {
            FightManager.Inst.m_Data["drop"] = data["drop"];
        }
        string scene_id = "map_008";//UnityEngine.Random.value > 0.2f ? "chanZuiGongQianMen" : "chanZuiGong";

        if (battle_data.ContainsKey("battle3"))
            battle_data = battle_data["battle3"] as SimpleJson.JsonObject;
        if (battle_data.ContainsKey("scene"))
        {
            scene_id = battle_data.str("scene");
        }
        GlobalVar.FightData = data;
        if (GlobalVar.FightData["mdouleName"] as string == "commonChapter")
        {//判断是否第一次打普通关卡 是否需要加载新手
            int cid = System.Convert.ToInt32(GlobalVar.FightData["chapter_zj"]);
            int xid = System.Convert.ToInt32(GlobalVar.FightData["chapter_xj"]);
            SimpleJson.JsonObject tableData = TableReader.Instance.TableRowByUniqueKey("commonChapter", cid, xid);
            // double val = 0;
            cid = tableData.num("id");
            MStruct mst = MPlayer2.Instance.getStruct("Chapter");
            mst = mst.getStructObject("status");
            double val = mst.getStruct(cid.ToString()).getNumber("star");
            if (val == 0 && tableData.ContainsKey("battle_script"))
            {
                string fakeScript =  tableData.str("battle_script");// "battle1_1_1";//
                if (!string.IsNullOrEmpty(fakeScript))
                {
                    FightManager.Inst.m_IsNewBie = true;//设置虚假战斗的标志
                    TranslateScripts.Inst.ExcuteLuaFile("uLuaModule/modules/conversation/" + fakeScript + ".lua");
                    return;
                }
            }
        }
        FightManager.Inst.InitBattleInfo(FightManager.Inst.m_Data, scene_id);
        //FightManager.Inst.StartFight();
        //SceneManager.beginLoadScene(m_SceneName);

    }

    /// <summary>
    /// 字符串填充
    /// </summary>
    /// <param name="tables"></param>
    /// <param name="needFillString"></param>
    public string fillString(LuaTable tables, string needFillString)
    {
        List<string> tempList = new List<string>();
        foreach (var item in tables)
        {
            tempList.Add(item.value.ToString());
        }
        if (tempList.Count > 0)
        {
            return String.Format(needFillString, tempList.ToArray());
        }
        return needFillString;
    }

    public string[] DivisionStr(string needDivisionStr, string sign)
    {
        char[] charArr = sign.ToCharArray();
        return needDivisionStr.Split(charArr);
    }
}

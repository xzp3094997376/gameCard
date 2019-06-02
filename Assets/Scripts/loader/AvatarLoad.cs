using UnityEngine;
using System.Collections;
using SimpleJson;

//*********************************************
//**author:zengjiadong                       **
//**copyright:乐云工作室                     **
//*********************************************
public class AvatarLoad : Behaviour
{

    private static AvatarLoad _instance = null;
    public delegate void CompeleteLoading(AvatarCtrl obj);
    [System.Serializable]
    //临时类 存放 回调函数 json表格数据
    public class TempClass
    {
        public CompeleteLoading m_CallBack = null;
        public SimpleJson.JsonObject m_TableData = null;
        public string model_name;
        public string model_path;
        public bool ispet;
    }
    public static AvatarLoad Instance//单例对象。
    {
        get
        {
            if (_instance == null)
            {
                _instance = new AvatarLoad();
            }
            return _instance;
        }
    }
    /// <summary>
    /// 根据ID生成模型
    /// </summary>
    /// <param name="id"></param>
    /// <param name="callback"></param>
    public void LoadAvatar(int id, CompeleteLoading callback,bool needTranform = false, int needSmall = 0, bool isPet = false)
    {
        SimpleJson.JsonObject obj = null;
        if (isPet == true)
            obj = TableReader.Instance.TableRowByID("petavter", id);
        else
            obj = TableReader.Instance.TableRowByID("avter", id);
        if (obj == null)
        {
            MyDebug.Log("avata id not find!id:" + id);
            return;
        }
             
        TempClass data = new TempClass();
        data.m_CallBack = callback;
        data.m_TableData = obj;
        data.model_name = obj.str("model");
        data.ispet = isPet;
#if UNITY_IOS
		data.model_path = UrlManager.ModelPath(data.model_name + "_hd", "heroprefab"); 
		data.model_name = data.model_name + "_hd";
#else
        if (needSmall == 0) // 加载大模型,不分高低配
        {
            if (!QualityManager.IsLow())
            {
                data.model_path = UrlManager.ModelPath(data.model_name + "_hd", "heroprefab");
                if (data.model_path == "")
                {
                    data.model_path = UrlManager.ModelPath(data.model_name, "heroprefab");
                }
                else
                {
                    data.model_name = data.model_name + "_hd";
                }
            }
            else
            {
                data.model_path = UrlManager.ModelPath(data.model_name, "heroprefab");
            }
        }
        else if ((needSmall == 1 && QualityManager.IsLow()) || needSmall == 2) // 高配大模，低配小模
        {
            data.model_path = UrlManager.ModelPath(data.model_name + "_s", "heroprefab");
            if (data.model_path == "")
            {
                data.model_path = UrlManager.ModelPath(data.model_name, "heroprefab");
            }
            else
            {
                data.model_name = data.model_name + "_s";
            }
        }
        else
        {
            data.model_path = UrlManager.ModelPath(data.model_name, "heroprefab");
        }
#endif
        LoadManager.getInstance().LoadSceneModel(data.model_path, data.model_name, ModelLoadCompelete, data);
        return;
    }
    void ModelLoadCompelete(LoadParam param)
    {
        TempClass tmp = param.param as TempClass;
        GameObject gobj = param.mainGameObject;
        GameObject newObj = Instantiate(gobj, Vector3.zero, Quaternion.identity) as GameObject;
        //if (tmp.m_TableData.num("turn") != 1 )
        {
            newObj.transform.localEulerAngles = new Vector3(0, 180, 0);
        }
        
        newObj.transform.localScale = new Vector3(1f, 1f, 1f);
        ModelShowUtil.CompleteRenderMaterialShader(newObj);
        AvatarCtrl ctrl = newObj.AddComponent<AvatarCtrl>();
        ctrl.model_path = tmp.model_path;
        LoadAssetRef assetRef = newObj.AddComponent<LoadAssetRef>();
        assetRef.SetUrl(tmp.model_path);
        try
        {
            tmp.m_CallBack(ctrl);
        }
        catch(System.Exception e){

        }
        
        if (ctrl.transform.parent == null)
        {
            DestroyObject(ctrl.gameObject);
        }
    }
}

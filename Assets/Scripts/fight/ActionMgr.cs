using UnityEngine;
using System.Collections;

public class ActionMgr : MonoBehaviour {

    public ActionsData[] m_Actions = null;
    // Use this for initialization
    public static ActionMgr Ins = null;

    private string actionsLoadDir = "actions_config";

    void Awake()
    {
        Ins = this;
    }
    void Start()
    {
#if UNITY_EDITOR
        string tmpPath = "Assets/BattleEditor/actions_config/" + "ActionsDefault" + ".asset";
        //FileUtils.getInstance().createDirectory(Application.dataPath + "/actions_config");
        Object o = UnityEditor.AssetDatabase.LoadAssetAtPath(tmpPath, typeof(ActionsScriptableData));
        ActionsScriptableData newObj =  o as ActionsScriptableData;
        m_Actions = newObj.m_Actions;

#else
        string path = UrlManager.AssetBuildPath("ActionsDefault", actionsLoadDir);
        if (path == "")
        {
            return;
        }
        AssetDetail cur = new AssetDetail();
        cur.type = AssetType.Null;
        cur.name = "ActionsDefault";

        LoadManager.getInstance().LoadSceneUnity3d(path, cur.name,LoadCompelete, cur);
#endif
        }

    void LoadCompelete(LoadParam load)
    {
        AssetDetail ad = load.param as AssetDetail;
        if (ad.type == AssetType.Null)
        {
            ActionsScriptableData cur = AssetBundles.Utility.getMainAsset<ActionsScriptableData>(load.assetbundle);
            if (cur == null)
            {
                Debug.LogWarning("can not find" + ad.name);
            }
            m_Actions = cur.m_Actions;
            QualityManager.RecycleAssetBundle(UrlManager.ModelPath(ad.name, actionsLoadDir));
        }
    }
	
	// Update is called once per frame
	void Update () {
	
	}
    public ActionsData GetAction(int actionid)
    {
        
        foreach(ActionsData dat in m_Actions)
        {
            if (dat.m_ActionID == actionid)
            {
                return dat;
            }
        }
        return null;
    }
}   

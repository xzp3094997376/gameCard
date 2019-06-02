using UnityEngine;
using System.Collections;

public class UI3DModelII : MonoBehaviour {
    private int _modelId = 0;
    public int size = 100;
    public int sortOrder = 0;
    // Use this for initialization
    void Start () {
        //LoadByModelId(109, "idle", null, false, 0, 1, 255, 1);
    }
	
	// Update is called once per frame
	void Update () {
	
	}
    public void LoadByModelId(int modelId, string aniName, SLua.LuaFunction callBack)
    {
        LoadByModelId(modelId, aniName, callBack, false);
    }
    public void LoadByModelId(int modelId, string aniName, SLua.LuaFunction callBack, bool isTransform)
    {
        LoadByModelId(modelId, aniName, callBack, isTransform, 0);
    }
    public void LoadByModelId(int modelId, string aniName, SLua.LuaFunction callBack, bool isTransform, int effId)
    {
        LoadByModelId(modelId, aniName, callBack, isTransform, effId, 1);
    }
    public void LoadByModelId(int modelId, string aniName, SLua.LuaFunction callBack, bool isTransform, int effId, float scale, float alpha = 255, int isSmall = 0)
    {
        if (modelId == _modelId) return;
        _modelId = modelId;
        //var mTran = modelParent.transform;
        bool isPet = false;
        if (effId == 100)
            isPet = true;
        for (int i = transform.childCount - 1; i >= 0; i--)
        {
            Object.Destroy(transform.GetChild(i).gameObject);
        }
        AvatarLoad.Instance.LoadAvatar(_modelId, (AvatarCtrl act) =>
        {
            act.SetPySkin(isTransform);
            if (alpha < 255) act.SetAlpha(alpha);
            if (!string.IsNullOrEmpty(aniName))
                act.PlayAnimation(aniName, true);
            for (int i = transform.childCount - 1; i >= 0; i--)
            {
                Object.Destroy(transform.GetChild(i).gameObject);
            }
            act.transform.parent = gameObject.transform;
            if (isPet)
            {
                act.transform.localScale = new Vector3(0.4f, 0.4f, 0.4f);
            }
            else
            {
                act.transform.localScale = new Vector3(1.0f, 1.0f, 1.0f);
            }
            NGUITools.SetLayer(act.gameObject, gameObject.layer);
            act.transform.localScale = act.transform.localScale * scale * (size / 16.0f);
            act.transform.localPosition = new Vector3(0.0f, -size /3, 0.0f);
            Renderer[] renders = gameObject.GetComponentsInChildren<Renderer>();
            foreach(Renderer r in renders)
            {
                r.sortingOrder = sortOrder;
            }
            if (callBack != null)
                callBack.call(act);
        }, isTransform, isSmall, isPet);
    }
}

using UnityEngine;
using System.Collections;

public class LoadAssetRef : MonoBehaviour {
    private string m_url;
    public void SetUrl(string url)
    {
        if (url == null || url == "")
            return;
        if (m_url != null)
        {
            LoadManager.getInstance().ReduceLoadAssetRefCount(m_url);
            m_url = null;
        }
        m_url = url;
        LoadManager.getInstance().AddLoadAssetRefCount(m_url);
    }
	
	void OnDestroy()
    {
        if (m_url == null || m_url == "")
            return;
        LoadManager.getInstance().ReduceLoadAssetRefCount(m_url);
    }
}

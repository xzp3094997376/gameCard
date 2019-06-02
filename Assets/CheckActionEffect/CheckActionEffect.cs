using UnityEngine;
using System.Collections;
//using UnityEditor;
using System.IO;

public class CheckActionEffect : MonoBehaviour
{
    private string[] allEffect;
    void Awake ()
    {
       
    }

    public void CheckAndroidEffect()
    {
        string effectPath = Application.dataPath + "/../ArtResources/Android/effects/";
        allEffect = Directory.GetFiles(effectPath);
        string actionPath = Application.dataPath + "/../ArtResources/Android/action_config/";
        CheckAllEffect(actionPath, effectPath, ".ab");
    }

    public void CheckIOSEffect()
    {
        string effectPath = Application.dataPath + "/../ArtResources/IOS/effects/";
        allEffect = Directory.GetFiles(effectPath);
        string actionPath = Application.dataPath + "/../ArtResources/IOS/action_config/";
        CheckAllEffect(actionPath, effectPath, ".os");
    }

    public void CheckAllEffect(string actionPath, string effectPath, string fileFormat)
    {
        fileFormat = "";
        string[] allAction = Directory.GetFiles(actionPath);
        foreach (string item in allAction)
        {
            StartCoroutine(LoadAsset(item, effectPath, fileFormat));
        }

    }
    public IEnumerator LoadAsset(string path, string effectPath, string fileFormat)
    {
        WWW bundle = new WWW("file://"+ path);

        yield return bundle;

        ScriptableActionData cur = AssetBundles.Utility.getMainAsset<ScriptableActionData>(bundle.assetBundle);
        foreach(BaseAction item in cur.m_NormalData)
        {
            if (item.m_ActionType == ActionTypeEnum.PlayEffect)
            {
                if (IsExistsEffect(effectPath + item.m_StrValue + fileFormat) == false)
                {
                    Debug.Log("Normal action name:" + cur.name + " is Lose Effect :" + item.m_StrValue + fileFormat);
                }
            }
        }
        foreach (BaseAction item in cur.m_TransformData)
        {
            if (item.m_ActionType == ActionTypeEnum.PlayEffect)
            {
                if (IsExistsEffect(effectPath + item.m_StrValue + fileFormat) == false)
                {
                    Debug.Log("Transform action name:" + cur.name + " is Lose Effect :" + item.m_StrValue + fileFormat);
                }
            }
        }
        foreach (BaseAction item in cur.m_SpecialData)
        {
            if (item.m_ActionType == ActionTypeEnum.PlayEffect)
            {
                if (IsExistsEffect(effectPath + item.m_StrValue + fileFormat) == false)
                {
                    Debug.Log("Special action name:" + cur.name + " is Lose Effect :" + item.m_StrValue + fileFormat);
                }
            }
        }
        foreach (BaseAction item in cur.m_SuperData)
        {
            if (item.m_ActionType == ActionTypeEnum.PlayEffect)
            {
                if (IsExistsEffect(effectPath + item.m_StrValue + fileFormat) == false)
                {
                    Debug.Log("Super action name:" + cur.name + " is Lose Effect :" + item.m_StrValue + fileFormat);
                }
            }
        }
    }

    public bool IsExistsEffect(string name)
    {
        foreach (string item in allEffect)
        {
            if (item.Equals(name))
            {
                return true;
            }
        }
        return false;
    }

}

using UnityEngine;
using System.Collections;
using UnityEditor;
using System.IO;
public class encrpty : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}

    [MenuItem("Assets/ModifyLua")]
    public static void Encrypt()
    {
        if (Selection.activeObject == null)
        {
            Debug.LogError("have select some folder.");
            return;
        }

        string filePath = AssetDatabase.GetAssetPath(Selection.activeObject);
        filePath = (Application.dataPath + filePath.Substring(6));

        byte[] data = File.ReadAllBytes(filePath);
        data = ConfigManager.ecodeLuaFile(data);
        File.WriteAllBytes(filePath, data);
    }
	// Update is called once per frame
	void Update () {
	
	}
}

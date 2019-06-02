using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class ClearPersistentPath : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}

     [MenuItem("Tools/清除Persistent路径下 的所有文件")]
    public static void ClearPersistentPathFiles()
    {

        DirectoryInfo di = new DirectoryInfo(Application.persistentDataPath);
        di.Delete(true);
    }
	
	// Update is called once per frame
	void Update () {
	
	}
}

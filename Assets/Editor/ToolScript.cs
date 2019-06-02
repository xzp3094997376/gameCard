using UnityEngine;
using System.Collections;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Net;
using System.Text;


//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class ToolScript : MonoBehaviour
{
    static private string findPath(Transform tran)
    {
        string path = tran.name;
        Transform parent = tran.parent;
        while (parent)
        {
            path = parent.name + "/" + path;
            parent = parent.parent;
        }
        return path;
    }
    //[MenuItem("Tools/主场景/获取路径")]
    static public void FindBuildCtrlTargetPath()
    {
        if (Application.isPlaying)
        {
            BuildCtrlTarget[] com = GameObject.FindObjectsOfType<BuildCtrlTarget>();
            if (com.Length == 0) return;
            StreamWriter file = new StreamWriter("Assets/Z_Test/buildpath.txt", false, Encoding.UTF8);
            file.WriteLine("{");
            string str = "\t{0} = {5} path = '{1}', rotate = {2} {6}{3}";
            for (int i = 0; i < com.Length; i++)
            {
                Transform go = com[i].transform;
                string path = findPath(go);
                string line = string.Format(str, go.name, path, 0, i < com.Length - 1 ? "," : "", "", "{", "}");
                file.WriteLine(line);
            }
            file.WriteLine("}");
            file.Close();
            AssetDatabase.Refresh();
        }

    }
}

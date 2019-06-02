using System.IO;
using System.Collections.Generic;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine;

public class DeCodeConfig : Editor
{
    [MenuItem("Build/解密并创建配置副本")]
    static void DeCodeConfigFile()
    {
        string filePath = Application.dataPath + "../../../table/client_table/";//配置文件路径
        string outPath = filePath + "../copydata/";
        DirectoryInfo dir = new DirectoryInfo(filePath);
        var files = dir.GetFiles();
        if (!Directory.Exists(outPath)) 
        {
            Directory.CreateDirectory(outPath);
        }
        foreach (var f in files) 
        {
            byte[] strBytes = FileUtils.getInstance().getBytes(filePath + f.Name);
            var data = moduleOpen(strBytes);

            File.WriteAllText(outPath + f.Name, data, System.Text.Encoding.UTF8);
        }
    }

    public static string moduleOpen(byte[] bs)
    {
        byte[] keys = System.Text.Encoding.UTF8.GetBytes("moduleName");
        for (int i = 0; i < bs.Length; i++)
        {
            bs[i] = (byte)(bs[i] ^ keys[i % keys.Length]);
        }
        return System.Text.Encoding.UTF8.GetString(bs);
    }
}
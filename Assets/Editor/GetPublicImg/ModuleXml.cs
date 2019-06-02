/*********************************************************************
* 类 名 称：       ModuleXml
* 命名空间：       
* 创建时间：       2014/8/4 17:22:10
* 作    者：       张晶晶
* 说    明：       生成每个模块中的基本信息生成json的配置文件，包括模块名，及其所有预设名，每个预设上的某个物体用到了那个图集和图片
* 最后修改时间：   2014/8/5
* 最后修 改 人：   张晶晶
* 曾修改人：    
**********************************************************************/

using UnityEngine;
using System.Collections;
using SimpleJson;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Text;

public class ModuleXml : MonoBehaviour {

    public static string modulePath = "Assets/Resources/Prefabs/TempFabs";
    public static string confiFile = "Assets/Resources/Prefabs/configuration.json";
    public static List<ModuleManager> m_ModuleList = new List<ModuleManager>();
    public static string confJsonString;
    public static JsonObject modules = new JsonObject();  //"modules":[
    /// <summary>
    /// 修改完各个预设上对应的图集信息并记录下来
    /// </summary>
    /// <param name="spriteInfos"></param>
   [MenuItem("Tools/获取模块的配置文件")]
    public static JsonObject createConfigurationString()
    {
        m_ModuleList.Clear();
        modules = new JsonObject();
        //获取项目的模块列表中的模块名对应的预设
        m_ModuleList = SeparatePublicTexture.getModulePrefabsInfo(modulePath);
        //获取某个模块下某个预设中的那个gameobject上的图集中使用的某种图片
        Dictionary<string, List<SpriteManager>> m_sprites = SeparatePublicTexture.StatisticsSpriteInModule(m_ModuleList,true);
        JsonArray moduleArray = new JsonArray();  //"modules":["module1":  
        //记录模块编号
        int moduleNum = 0;
        foreach (string moduleName in m_sprites.Keys)
        {

            List<string> prefabList = new List<string>();
            JsonObject oneModuleInfo = new JsonObject();   //{"module1":

            JsonArray prefabArray = new JsonArray();  //"prefabs":[prefab1, prefabs 

            JsonArray atlasArray = new JsonArray();   //"atlas":[a1, a2'
            int prefabNum = 0;

            List<SpriteManager> sList = m_sprites[moduleName];
            foreach (SpriteManager sm in sList)
            {  //获取每个预设名

                string prefabName = sm.prefabName;
                
            
                if (sm.m_UIAtlas != null)
                {
                    string atlasName = sm.m_UIAtlas.name;
                    if (!atlasArray.Contains(atlasName))
                    {
                        atlasArray.Add(atlasName);
                    }
                }
                
                if (!prefabList.Contains(prefabName))
                {    //每个预设内容部的信息  "prefab1":{  "name" : prefabName
                    prefabNum++;
                    JsonObject prefabInfo = new JsonObject();
                    prefabInfo["url"] = prefabName;
                    prefabInfo["name"] = Path.GetFileName(prefabName);                           
                    prefabArray.Add(prefabInfo);
                    prefabList.Add(prefabName);

                }
            }
            JsonObject module = new JsonObject();
            oneModuleInfo["name"] = Path.GetFileName(moduleName);
            oneModuleInfo.Add("prefabs", prefabArray);
            oneModuleInfo.Add("atlas", atlasArray);
            module["module" + moduleNum] = oneModuleInfo;
            moduleNum++;

            moduleArray.Add(module);
        }
        modules["modules"] = moduleArray;

        confJsonString = SimpleJson.SimpleJson.SerializeObject(modules);
          MyDebug.Log("jsonstring :   " + confJsonString);
        //将获得json字符串写入到文件
        writeConfigurationFile(confJsonString);
        return modules;

    }

    /// <summary>
    /// 将得到的配置文件字符串写入到文件中
    /// </summary>
    /// <param name="str"></param>
    public static void writeConfigurationFile(string str)
    {
        if (File.Exists(confiFile))
        {
            StreamWriter sw = new StreamWriter(confiFile, false, Encoding.UTF8);
            sw.WriteLine(str);
            sw.Close();
            MyDebug.Log("配置文件写入成功");
        }
        else
        {
            FileStream fs = new FileStream(confiFile, FileMode.CreateNew);
            fs.Close();
            StreamWriter sw = new StreamWriter(confiFile,false, Encoding.UTF8);
            sw.WriteLine(str);
            sw.Close();
 //           MyDebug.Log("配置文件创建并写入成功");
        }
       
    }
}

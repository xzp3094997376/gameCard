/*********************************************************************
* 类 名 称：       GetFile
* 命名空间：   
* 创建时间：       2014/7/26 9:58:21
* 作    者：       张晶晶
* 说    明：       遍历某目录下指定的格式文件
* 最后修改时间：   2014/7/30 
* 最后修 改 人：   张晶晶
* 曾修改人：
**********************************************************************/


using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;


public class GetFile : MonoBehaviour {
 
   /// <summary>
   /// 采用递归遍历某文件夹中的指定格式文件并存储在字典中
   ///
   public static void getFilesByType(string filePath, Dictionary<string, GameObject> dic, string type) 
    {
        DirectoryInfo dir = new DirectoryInfo(filePath);
        DirectoryInfo dir_app = new DirectoryInfo(Application.dataPath);
        //如果本目录下没有文件夹作为该目录的截止条件并添加其目录下的文件
        if (dir.GetDirectories().Length == 0)
        {
            FileInfo[] files = dir.GetFiles();
            foreach (FileInfo file in files)
            {
                if (file.ToString().EndsWith(type))
                {
                    string fileStr = file.ToString();
                    //根据路径获取某物体
                    fileStr = fileStr.Replace(dir_app.FullName, "Assets");
                    GameObject obj = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(fileStr);
                    dic.Add(fileStr, obj);
                }
            }
            return;
        }
        else
        {
            //递归遍历本目录下的所有目录，并添加到字典中
            foreach (DirectoryInfo d in dir.GetDirectories())
            {
                getFilesByType(d.ToString(), dic, type);
            }
            foreach (FileInfo f in dir.GetFiles())
            {
                if (f.ToString().EndsWith(type))
                {
                    string fStr = f.ToString();
                    fStr = fStr.Replace(dir_app.FullName, "Assets");
                    GameObject obj = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(fStr);
                    dic.Add(fStr, obj);
                }
            }
        }
    }
    
    /// <summary>
    /// 获取目录下图集预设及图集中包含的所有精灵列表
    /// </summary>
    /// <param name="filePath"></param>
    /// <param name="dic"></param>
    /// <param name="type"></param>
    /// 
   public static void getAtlasByType(string filePath, Dictionary<UIAtlas, BetterList<string>> dic, string type)
   {
       DirectoryInfo dir = new DirectoryInfo(filePath);
       DirectoryInfo dir_app = new DirectoryInfo(Application.dataPath);
       //如果本目录下没有文件夹作为该目录的截止条件并添加其目录下的文件
       if (dir.GetDirectories().Length == 0)
       {
           FileInfo[] files = dir.GetFiles();
           foreach (FileInfo file in files)
           {
               if (file.ToString().EndsWith(type))
               {
                   string fileStr = file.ToString();
                   fileStr = fileStr.Replace(dir_app.FullName, "Assets");
                   GameObject obj = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(fileStr);
                   //获取该物体上所用到的图集
                   UIAtlas atlas = obj.GetComponent<UIAtlas>();
                   if (atlas != null)
                   {
                       BetterList<string> list = new BetterList<string>();
                       //得到该图集上的所有精灵列表返回格式为betterlist
                       list = atlas.GetListOfSprites();
                       dic.Add(atlas, list);
                   }
                   
               }
           }
           return;
       }
       else
       {
           //递归遍历本目录下的所有目录，并添加到字典中
           foreach (DirectoryInfo d in dir.GetDirectories())
           {
               getAtlasByType(d.ToString(), dic, type);
           }
           //获取该目录下的文件
           foreach (FileInfo f in dir.GetFiles())
           {
               if (f.ToString().EndsWith(type))
               {
                   string fStr = f.ToString();
                   fStr = fStr.Replace(dir_app.FullName, "Assets");
                   GameObject obj = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(fStr);
                   UIAtlas atlas = obj.GetComponent<UIAtlas>();
                   if (atlas != null)
                   {
                       BetterList<string> list = new BetterList<string>();
                       list = atlas.GetListOfSprites();
                       dic.Add(atlas, list);
                   }
               }
           }
       }
   }

    /// <summary>
    /// 获取某目录下根据名字获取该名字的具体路径
    /// </summary>
    /// <param name="name"></param>
    /// <param name="dicTextrues"></param>
    /// <returns></returns>

    public static List<string> getPathByName(string name, Dictionary<string, GameObject> dicTextrues){
        List<string> path = new List<string>();
        foreach(string str in dicTextrues.Keys){
            if (Path.GetFileName(str).Contains(name))  //得到某个图片的路径
            {
				if(!path.Contains(str)){
                  path.Add(str);
				}				              
            }
        }
        return path;
    }

 

    /// <summary>
    /// 获取具体的某个预设上的具体uisprite信息
    /// </summary>
    /// <param name="t"></param>
    /// <param name="spriteList"></param>
    /// 
    public static void getUISprite(string moduleName,string rootObj, Transform t, List<SpriteManager> spriteList, bool isContainPublic)
    {
       
       
        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            if (t0 != null)
            {
                MyDebug.Log(" root obj"+rootObj+ " t" +t +" to " + t0.gameObject);
                UISprite us = t0.gameObject.GetComponent<UISprite>();
                if (us != null)
                {
                    UIAtlas ua = us.atlas;
                    string sprite = us.spriteName;
                    if (isContainPublic)
                    {
                       // if (ua != null)
                     //   {
                        
                            SpriteManager sm = new SpriteManager(moduleName, rootObj, t0.gameObject, ua, sprite);
                            spriteList.Add(sm);
                       // }    
               
                    }
                    else
                    {
                        //  //进行图片的统计不包括已经是公共图片
                        if (ua != null)
                        {
                            if (ua.name != "public")
                            {
                                SpriteManager sm = new SpriteManager(moduleName, rootObj, t0.gameObject, ua, sprite);
                                spriteList.Add(sm);
                            } 
                        }
                                            
                    }                         
                }
                else
                {
                    getUISprite(moduleName, rootObj, t0, spriteList, isContainPublic);
                }
            }

        }

    }

    /// <summary>
    /// 获取某个图集预设上的所有精灵
    /// </summary>
    /// <param name="t"></param>
    /// <param name="textures"></param>
    public static  void getSpriteList(Transform t, BetterList<string> textures)
    {

        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            if (t0 != null)
            {
                UIAtlas atlas = t0.gameObject.GetComponent<UIAtlas>();

                if (atlas != null)
                {                 
                    textures = atlas.GetListOfSprites();                                     
                }
                else
                {
                     getSpriteList(t0, textures);
                }
            }
           
        }

    }
}

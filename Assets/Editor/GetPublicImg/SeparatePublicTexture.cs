/*********************************************************************
* 类 名 称：       SeparatePublicTexture
* 命名空间：       
* 创建时间：       2014/7/26 9:58:21
* 作    者：       张晶晶
* 说    明：       一键式模块打包构建
* 最后修改时间：  2014/8/5 
* 最后修 改 人：  张晶晶
* 曾修改人：
**********************************************************************/

using UnityEngine;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using UnityEditor;
using System.Timers;

public class SeparatePublicTexture : MonoBehaviour
{

    public static string modulePrefabPath = "Assets/Resources/Prefabs/moduleFabs";
    public static Dictionary<string, GameObject> mPrefabs = new Dictionary<string, GameObject>();  //查找对应路径下的所有预设
    public static List<ModuleManager> mModuleList = new List<ModuleManager>();  //所有模块列表

    public static string imgPath = @"Assets\__res\NewUI";   //放置图片的目录
    public static Dictionary<string, GameObject> allTexture = new Dictionary<string, GameObject>();  //存放所有的Texture及其路径
 
    public static string atlasPath = "Assets/Resources/AllAtlas/ModuleAtlas";  //存放所有图集预设目录
    public static Dictionary<UIAtlas, BetterList<string>> allAtlas = new Dictionary<UIAtlas, BetterList<string>>();  //得到所有图集预设中的对应所有的图片

    public static Dictionary<string, List<SpriteManager>> mSpritesInfo = new Dictionary<string, List<SpriteManager>>();     //b遍历所有模块预设记录所有的图集相关信息包括其附着的物体， 来自哪个图集中的那张图片
 
    public static Dictionary<string, int> sameSpriteCount = new Dictionary<string,int>();   //记录每一种图片及其出现的次数
   
    public static List<Texture> sameTextures = new List<Texture>();  //放置重复率超过2的图片

    public static string savePublicTexture = @"Assets/__res/PublicImg";  //存放整理出来的公共图片目录

    public static List<string> mDelNames = new List<string>();   //需要删除的图片
    public static Dictionary<UIAtlas, List<string>> mDelNullSprite = new Dictionary<UIAtlas,List<string>>();

    public static string publicAtlas = "Assets/Resources/AllAtlas/PublicAtlas/public.prefab";  //公共预设
    public static UIAtlas public_UIAtlas;   //设置公共图集

    public static bool isNewPublicAtals = false;    //是否已经创建公共图集


    /// <summary>
    /// 创建一个新的公共预设并根据预设中的精灵列表更新该预设
    /// </summary>
    
 //    [MenuItem("Tools/创建并更新公共预设")]
    static void createAtlas()
    {		
        AtlasManager atlas = new AtlasManager();
        atlas.OnEnable();
		if (sameTextures.Count != 0) {
		//	MyDebug.Log("create");
			atlas.createNewAtlas (publicAtlas, sameTextures);      //创建空图集
			atlas.updateAtlas(sameTextures);
		}
        atlas.OnDisable();

    }

    /// <summary>
    /// 更新公共模块预设
    /// </summary>

    public static void updateAtlas()
    {
        AtlasManager atlas = new AtlasManager();
        atlas.OnEnable();
        atlas.selectAtlas(publicAtlas);
        atlas.updateAtlas(sameTextures);//创建空图集
        atlas.OnDisable();
    }

    /// <summary>
    /// 公共预设创建后，修改原本用到了公共预设中图片的物体，将其中的预设名修改为公共预设名
    /// </summary>
  
 //   [MenuItem("Tools/修改角色对应的图集预设及图片")]
     static void updateAtlasInObj()
     {
         //设置当前需要修改的预设名,即公共预设
		setPublicAtlas (publicAtlas);

        //修改角色对应的图集预设
        foreach (string moduleName in mSpritesInfo.Keys)
        {
            List<SpriteManager> sprites = mSpritesInfo[moduleName];
            for (int i = 0; i < sprites.Count; i++)
            {
                SpriteManager sm = sprites[i];

                foreach (Texture t in sameTextures)
                {
                    //得到用到了公共图片的物体，并修改其预设为公共预设并重新设置其图片
                    if (sm.m_SpriteName == t.name)
                    {
                        GameObject obj = sm.AttachedGameObject;                       
                        UISprite uiSprite = obj.GetComponent<UISprite>();
                        uiSprite.atlas = public_UIAtlas;
                        uiSprite.spriteName = t.name;
                        sm.m_UIAtlas = public_UIAtlas;
                    }
                }
            }
        }	
     }


    /// <summary>
    /// 删除模块预设中用到了公共精灵的图片
    /// </summary>

   // [MenuItem("Tools/删除某预设中的图片")]
    static void deleteOldSprite()
    {
        //设定删除的预设名
        AtlasManager atlas = new AtlasManager();      

        Dictionary<UIAtlas, List<string>> m_deleteSprite;
        // m_deleteSprite.Clear ();
        m_deleteSprite = getDeleteSpriteOfAtlas(allAtlas, sameTextures);
        foreach (UIAtlas a in m_deleteSprite.Keys)
        {
			atlas.OnEnable();
            string atlaName = atlasPath + "/" + a.name + ".prefab";
//			MyDebug.Log("atlName" + atlaName);
            atlas.selectAtlas(atlaName);
            atlas.deleteSprite(m_deleteSprite[a]);
        }
        
        //删除图集中未使用的图片
        foreach (UIAtlas a in mDelNullSprite.Keys)
        {
            string atlasName = atlasPath + "/" + a.name + ".prefab";
            atlas.selectAtlas(atlasName);
            atlas.deleteSprite(mDelNullSprite[a]);
        }

        atlas.OnDisable();
    }

    
    /// <summary>
    /// 设置公共预设PublisAtlas的值
    /// </summary>
   
    static void setPublicAtlas(string path)
     {
        GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
        public_UIAtlas = obj.GetComponent<UIAtlas>();
//		MyDebug.Log ("name " + public_UIAtlas.name);        
     } 
    
    /// <summary>
    /// 得到模块预设中用到了公共图片的图片列表及对应的预设名，并添加到删除列表中
    /// </summary>
    /// <returns></returns>

    static Dictionary<UIAtlas, List<string>> getDeleteSpriteOfAtlas(Dictionary<UIAtlas, BetterList<string>> atlas, List<Texture> sameTex)
     {
         Dictionary<UIAtlas, List<string>> dic = new Dictionary<UIAtlas, List<string>>();
         bool flag = false;
		//List<string> moduleDel = new List<string> ();
         foreach (UIAtlas a in atlas.Keys)
         {
			List<string> moduleDel = new List<string> ();
             BetterList<string> list = atlas[a];
//			MyDebug.Log("atlas " + a.name);
             foreach (Texture t in sameTex)
             {
                 //遍历所有预设得到那些预设中用到了公共图片并添加到需要删除的列表中，如果找到并设置flag为真，将对应的图集预设添加到字典中
          
                 if (list.Contains(t.name) && !moduleDel.Contains(t.name))
                 {
					MyDebug.Log("atlas" + a + "atlas need delete" + t.name);
					if(!mDelNames.Contains(t.name)){
						mDelNames.Add(t.name);
					}                
					 moduleDel.Add(t.name);
                     flag = true;
                 }
             }
             if (!dic.ContainsKey(a) && flag)
             {
		//		MyDebug.Log("add atlas" + a +" delete atlas" + moduleDel.Count);
                 dic.Add(a, moduleDel);
                 flag = false;
             }
         }
         return dic;
     }

    /// <summary>
    /// 获取模块列表中用到了图片的角色及相关信息并记录
    /// </summary>
    /// <param name="m_modules"></param>
    /// <returns></returns>
    public static Dictionary<string, List<SpriteManager>> StatisticsSpriteInModule(List<ModuleManager> m_modules, bool isContainPublic)
    {
        Dictionary<string, List<SpriteManager>> m_sprites = new Dictionary<string, List<SpriteManager>>();
        foreach (ModuleManager module in m_modules)
        {
            string moduleName = module.name;
           
            Dictionary<string, GameObject> dic = module.prefabs;
            List<SpriteManager> list = new List<SpriteManager>();
            foreach (string objName in dic.Keys)
            {

                
                UISprite us1 = dic[objName].transform.gameObject.GetComponent<UISprite>();
                MyDebug.Log("dic  "+dic[objName].transform.gameObject.GetComponent<UISprite>());

                if(us1 != null){
                      UIAtlas ua1 = us1.atlas;
                      string sprite1 = us1.spriteName;
                      SpriteManager sm1 = new SpriteManager(moduleName, objName, dic[objName], ua1, sprite1);
                      list.Add(sm1);
                }
                else
                {
                    SpriteManager sm2 = new SpriteManager(moduleName, objName, dic[objName], null, null);
                    list.Add(sm2);
                }
              
                GetFile.getUISprite(moduleName, objName, dic[objName].transform, list, isContainPublic);
            }
	//		MyDebug.Log("module name " + moduleName + " list count: " + list.Count);
            m_sprites.Add(moduleName, list);
        }
        return m_sprites;
    }


     /// <summary>
     /// 记录所有需要的信息到字典或list中,并判断是否各种信息记录完毕
     /// </summary>
  //  [MenuItem("Tools/获取所有模块预设")]
     public static void recordInfo()
    {

         //获取某目录下所有的模块相关信息
        mModuleList = getModulePrefabsInfo(modulePrefabPath);

        //得到所有图片信息并存放于allTexture<图片路径，texture>
        GetFile.getFilesByType(imgPath, allTexture, "png");

        //得到所有图集信息并存放allAtlas<预设UIAtlas，对应图片列表>
        GetFile.getAtlasByType(atlasPath, allAtlas, "prefab");

         //统计每个模块中所用到的图片不包含公共图片，并记录相关信息
        mSpritesInfo = StatisticsSpriteInModule(mModuleList, false);
      
        //分析统计不同预设中图片的使用情况并记录与sameSpriteCount
        sameSpriteCount = analyzeRateOfSameSprite(mSpritesInfo);
         //将重复率超过一定数目的图片移动到公共文件夹
        setSameTextures();    
    }


    /// <summary>
     /// 获取图片使用次数超过2次的并添加到公共图片目录，删除源目录下的该图片及sameTexture中
    /// </summary>
    /// <returns></returns>
     public static void setSameTextures()
     {
         foreach (string sprite in sameSpriteCount.Keys)
         {
             if (sameSpriteCount[sprite] >= 2)  //当图片使用次数超过2次
             {
                 List<string> spritePath = GetFile.getPathByName(sprite, allTexture);  //获取公共图片所在的目录有哪些
				FileManager.moveFileList(spritePath, savePublicTexture);
				FileManager.deleteFiles(spritePath);       
             }
         }
         //获取Public图集下的sameTexture图片
         getPublicTexture(savePublicTexture);
     }

    /// <summary>
    /// 获取公共图集中的图片Texture
    /// </summary>
    /// <param name="path"></param>
     static void getPublicTexture(string path)
     {
         DirectoryInfo dir = new DirectoryInfo(path);
         if (dir.GetDirectories().Length == 0)
         {
             FileInfo[] files = dir.GetFiles();
             foreach (FileInfo file in files)
             {
                 if (!file.ToString().EndsWith(".meta"))
                 {
                     string projectPath = Application.dataPath.Replace("Assets", "").Replace("/", "\\");
                     string file_Asset = file.FullName.Replace(projectPath, "");
                     MyDebug.Log("public file is " + file_Asset);
                     MyDebug.Log("is moved " + File.Exists(file_Asset));
                     Texture tex = null;
                     tex = AssetDatabase.LoadAssetAtPath(file_Asset, typeof(Texture)) as Texture;
                     sameTextures.Add(tex);
                 }             
             }          
         }
     } 
   
    /// <summary>
    /// 分析获取在得到的模块预设中使用到相同图片的数量，并采用字典得到某种图片用到的次数
    /// </summary>
    /// <param name="SpriteCount"></param>
    public static Dictionary<string, int> analyzeRateOfSameSprite(Dictionary<string, List<SpriteManager>> spriteInfos)
    {
        Dictionary<string, int> countSprite = new Dictionary<string,int>();
      //  string[] s = new string[spriteInfos.Count];   //记录有同名的spritename

         Dictionary<string, Dictionary<string, int>> dic = getModuleSpriteList(mSpritesInfo);
        foreach(string module in dic.Keys){   //获取每个模块
            foreach(string sprite in dic[module].Keys){  //每个模块下的sprite名
//				MyDebug.Log("the sprite"+sprite);
                if(!countSprite.ContainsKey(sprite)){  //统计记录中不包含该sprite就添加进入
                    countSprite.Add(sprite, 1);
                }else{
                    countSprite[sprite] ++;  //如果有就累加
                }
            } 
        }      
        return countSprite;
    }
    

    /// <summary>
    /// 获取模块中的图片列表并不包含重复的图片
    /// </summary>
    /// <param name="spriteInfos"></param>
    /// <returns></returns>
    public static  Dictionary<string, Dictionary<string, int>> getModuleSpriteList(Dictionary<string, List<SpriteManager>> spriteInfos){
        
        Dictionary<string, Dictionary<string, int>> dic = new Dictionary<string,Dictionary<string,int>>();
        foreach(string mName in spriteInfos.Keys){
            Dictionary<string, int> spriteCount = new Dictionary<string,int>();

            UIAtlas atlas = spriteInfos[mName][0].m_UIAtlas;  //获取该模块用到的私人预设
		//	MyDebug.Log("atlas " + atlas.name);

				foreach(SpriteManager sm in spriteInfos[mName])
				{
					string sprite = sm.m_SpriteName;
					if(!spriteCount.ContainsKey(sprite))
					{
						spriteCount.Add(sprite, 1);
					}              
				}
				mDelNullSprite.Add(atlas, getNoUsedSpriteInUIAtlas(spriteCount, atlas));
				dic.Add(mName, spriteCount);  //每个模块下的图片使用情况统计
			}
        
        return dic;
    }

    /// <summary>
    /// 获取某个预设未使用到的图片并删除
    /// </summary>
    /// <param name="spriteCount"></param>
    /// <param name="atlas"></param>
    public static List<string> getNoUsedSpriteInUIAtlas(Dictionary<string, int> spriteCount, UIAtlas atlas)
    {

        List<string> delList = new List<string>();
        bool isHave = false;
        foreach (string altasSprite in atlas.GetListOfSprites())
        {
            isHave = false;
            foreach (string sprite in spriteCount.Keys)
            {
                //判断预设中的每张图片是否用到
                if (altasSprite.Equals(sprite))
                {
                    isHave = true;
                }
            }
            if (!isHave)
            {
                MyDebug.Log("is not have is " + altasSprite);
                delList.Add(altasSprite);
            }
        }
        return delList;
    }

    /// <summary>
    /// 当动作结束后清空所有的数组以防止有重复的添加
    /// </summary>

    public static void clearAllCollection()
    {
        mPrefabs.Clear();
        mSpritesInfo.Clear();
        sameSpriteCount.Clear();
        allTexture.Clear();
		allAtlas.Clear ();
		sameTextures.Clear ();
		mDelNames.Clear ();
		mDelNullSprite.Clear ();
		mModuleList.Clear ();
    }


    /// <summary>
    /// 获取所有模块中的预设信息
    /// </summary>
    /// <param name="modulePath"></param>
    public static List<ModuleManager> getModulePrefabsInfo(string modulePath)
    {
        List<ModuleManager> moduleList = new List<ModuleManager>();
        //获取该目录下的所有目录
        
        DirectoryInfo dirInfo = new DirectoryInfo(modulePath);
        DirectoryInfo[] dirs = dirInfo.GetDirectories();
        foreach (DirectoryInfo d in dirs)
        {
            Dictionary<string, GameObject> dic = new Dictionary<string,GameObject>();
            GetFile.getFilesByType(d.ToString(), dic, "prefab");
            ModuleManager mm = new ModuleManager();
            mm.name = d.ToString();   //设置该模块的路径
            mm.prefabs = dic;
            moduleList.Add(mm);
         }
        return moduleList;
    }

    /// <summary>
    /// 判断一个字符串是否包含于字符串数组中，如果不包含返回-1， 如果包含返回与那个索引位置相同
    /// </summary>
    /// <param name="s"></param>
    /// <param name="str"></param>
    /// <returns></returns>
   
    public static int isContain(string[] s, string str)
    {
        int index = -1;
        for (int i = 0; i < s.Length; i++)
        {        
            if (str == s[i])
            {
                index = i;
                break;
            }
        }
            return index;
    }


    /// <summary>
    /// 一键模块打包
    /// </summary>

    [MenuItem("Tools/模块图集资源优化")]
    public static void CreateModuleAssets()
    {
        //清空所有的字典和list
        clearAllCollection();

        //存储所有需要的信息到字典或list中
        recordInfo();
        if (!File.Exists(publicAtlas))
        {
    //        createAtlas();
        }
        else
        {
      //      updateAtlas();
        }      
            //根据创建的公用图集修改物体上公共图集照片预设并修改其旧图集为公共图集
     //    updateAtlasInObj();

            //删除各模块图集预设中的公共图片
        // deleteOldSprite();

         ModuleXml.createConfigurationString();
     //    ModuleXml.createConfiguration(mSpritesInfo);
            //清空所有字典和图集
         clearAllCollection();     
    }
}

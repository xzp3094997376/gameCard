using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using LitJson;
using System.Text;
using System.Text.RegularExpressions;

namespace LuaBind
{

    public class BundleMrg
    {
        public const string BundleDataPath = "Assets/BundleManager/BundleData.txt";
        public const string BundleBuildStatePath = "Assets/BundleManager/BuildStates.txt";
        public const string rootPath = "Assets/UI";
        #region 新手录制
        const string kRecordGuideStepOn = "Setting/新手录制/开";
        const string kRecordGuideStepOff = "Setting/新手录制/关";

        [MenuItem(kRecordGuideStepOn)]
        public static void setRecordGuideStepOn()
        {
            UluaBinding.recordGuideStep = !UluaBinding.recordGuideStep;
        }

        [MenuItem(kRecordGuideStepOn, true)]
        public static bool checkRecordGuideStepOn()
        {
            return !UluaBinding.recordGuideStep;
        }

        [MenuItem(kRecordGuideStepOff)]
        public static void setRecordGuideStepOff()
        {
            UluaBinding.recordGuideStep = !UluaBinding.recordGuideStep;
        }

        [MenuItem(kRecordGuideStepOff, true)]
        public static bool checkRecordGuideStepOff()
        {
            return UluaBinding.recordGuideStep;
        }
        #endregion

        #region 配置文件
        [MenuItem("Setting/配置文件更改", false, 0)]
        static void BuidSetting()
        {

            BuildWindow window = EditorWindow.GetWindow<BuildWindow>("打包工具");
            window.minSize = new Vector2(300, 400);
            window.Show();
        }
        #endregion


        #region AssetsBundle
        
        public static void SetConfig()
        {
            string[] paths = AssetDatabase.FindAssets("t:Prefab", new string[] { rootPath });
            int count = paths.Length;
            for (int i = 0; i < count; i++)
            {
                var guid = paths[i];
                string p = AssetDatabase.GUIDToAssetPath(guid);
                paths[i] = p;
            }
            SetConfig(paths);
        }

        public static void ClearAssetBundleName()
        {
            if (Selection.assetGUIDs.Length == 0)
            {
                EditorUtility.DisplayDialog("tips", "请选择一个或多个目录", "OK");
                return;
            }
            for (int i = 0; i < Selection.assetGUIDs.Length; i++)
            {
                var guid = Selection.assetGUIDs[i];
                string path = AssetDatabase.GUIDToAssetPath(guid);
                FileUtils.getInstance().ForEachDirectory(path, (p) =>
                {
                    p = p.Substring(p.IndexOf("/Assets/") + 1);
                    AssetImporter im = AssetImporter.GetAtPath(p);
                    if (im)
                        im.assetBundleName = "";
                });
            }

        }

        internal static void SetConfig(string[] paths)
        {
            Dictionary<string, UIAtlas> atlasDict = new Dictionary<string, UIAtlas>();
            Dictionary<string, UIFont> fontsDict = new Dictionary<string, UIFont>();
            Dictionary<string, GameObject> norDict = new Dictionary<string, GameObject>();
            int ff = 0;
            int count = paths.Length;
            for (int i = 0; i < count; i++)
            {
                string p = paths[i];
                EditorUtility.DisplayProgressBar("配置打包预设", "正在搜索" + Path.GetFileName(p), ff / (float)count);

                GameObject go = AssetDatabase.LoadAssetAtPath(p, typeof(GameObject)) as GameObject;
                UIAtlas atlas = go.GetComponent<UIAtlas>();
                UIFont font = go.GetComponent<UIFont>();
                string path = p.Replace(rootPath + "/", "");
                path = path.Replace(Path.GetExtension(path), "");
                if (atlas)
                {
                    atlasDict.Add(p, atlas);
                }
                else if (font)
                {
                    fontsDict.Add(p, font);
                }
                else
                {
                    clearGameObjectTexture(go);
                    clearSpriteII(go);
                    norDict.Add(p, go);
                }
                ff++;
            }
            //List<BundleData> list = new List<BundleData>();
            //List<BundleBuildState> stateList = new List<BundleBuildState>();
            //foreach (var i in fontsDict)
            //{
            //    UIFont f = i.Value;
            //    if (f.atlas)
            //    {
            //        string o = AssetDatabase.GetAssetPath(f.atlas);
            //        if (atlasDict.ContainsKey(o))
            //        {
            //            atlasDict[o] = null;
            //            atlasDict.Remove(o);
            //        }
            //        EditorUtility.DisplayProgressBar("配置打包预设", "正在搜索" + f.name, ff / (float)count);
            //
            //    }
            //    list.Add(createBundleData(i.Key, rootPath));
            //    stateList.Add(createBundleBuildState(i.Key, rootPath));
            //}

            //foreach (var i in atlasDict)
            //{
            //    UIAtlas a = i.Value;
            //    list.Add(createBundleData(i.Key, rootPath));
            //    stateList.Add(createBundleBuildState(i.Key, rootPath));
            //    EditorUtility.DisplayProgressBar("配置打包预设", "正在搜索" + a.name, ff / (float)count);
            //
            //}

            //foreach (var i in norDict)
            //{
            //    GameObject go = i.Value;
            //    if (!go) continue;
            //    var b = createBundleData(i.Key, rootPath);
            //    list.Add(b);
            //    stateList.Add(createBundleBuildState(i.Key, rootPath));
            //    EditorUtility.DisplayProgressBar("配置打包预设", "正在搜索" + go.name, ff / (float)count);
            //}

            TextWriter tw = new StreamWriter(BundleDataPath);
            if (tw == null)
            {
                Debug.LogError("Cannot write to " + BundleDataPath);
                return;
            }

            //string jsonStr = JsonFormatter.PrettyPrint(JsonMapper.ToJson(list));

            //tw.Write(jsonStr);
            //tw.Flush();
            //tw.Close();

            //tw = new StreamWriter(BundleBuildStatePath);
            //if (tw == null)
            //{
            //    Debug.LogError("Cannot write to " + BundleBuildStatePath);
            //    return;
            //}

            //jsonStr = JsonFormatter.PrettyPrint(JsonMapper.ToJson(stateList));
            //
            //tw.Write(jsonStr);
            //tw.Flush();
            //tw.Close();
            EditorUtility.ClearProgressBar();
        }

        [MenuItem("Setting/Bundle/配置打包资源", false, 0)]
        public static void Config()
        {
            if (EditorUtility.DisplayDialog("提示", "配置AssetsBunlde，需要很长一段时间，如果点错，请取消。", "确定", "取消"))
            {
                SetConfig();
            }
        }
        /*
        [MenuItem("Assets/Bundle/打包选中的资源")]
        public static void BuildSelect()
        {
            int[] obj = Selection.instanceIDs;
            List<string> bundles = new List<string>();
            for (int i = 0; i < obj.Length; i++)
            {
                string path = AssetDatabase.GetAssetPath(obj[i]);
                path = path.Replace(rootPath + "/", "");
                path = path.Replace("Assets/", "");
                bundles.Add(Path.GetDirectoryName(path) + "/" + Path.GetFileNameWithoutExtension(path));
            }
            BuildHelper.BuildBundles(bundles.ToArray());
        }

        private static BundleData createBundleData(string p, string rootPath)
        {
            string path = p.Replace(rootPath + "/", "");
            path = path.Replace(Path.GetExtension(path), "");
            BundleData data = new BundleData();
            data.name = path;
            data.includs.Add(p);
            data.includeGUIDs.Add(AssetDatabase.AssetPathToGUID(p));
            string[] arg = AssetDatabase.GetDependencies(new string[] { p });
            List<string> depend = new List<string>(arg);
            depend.RemoveAll(x => data.includs.Contains(x));

            BundleBuildState newBuildState = new BundleBuildState();

            List<string> guids = new List<string>();
            for (int j = 0; j < depend.Count; j++)
            {
                guids.Add(AssetDatabase.AssetPathToGUID(depend[j]));
            }
            data.dependAssets = depend;
            data.dependGUIDs = guids;
            return data;
        }

        private static BundleBuildState createBundleBuildState(string p, string rootPath)
        {
            BundleBuildState state = new BundleBuildState();
            string path = p.Replace(rootPath + "/", "");
            path = path.Replace(Path.GetExtension(path), "");
            state.bundleName = path;
            return state;
        }
        */
        #endregion

        /*
        #region 检查引用,优化
        public static void checkAtlasRef()
        {
            var list = BMDataAccessor.Bundles;
            Dictionary<string, List<string>> dic = new Dictionary<string, List<string>>();
            for (int i = 0; i < list.Count; i++)
            {
                BundleData bundle = list[i];
                if (bundle.includs.Count == 0) continue;
                string path = bundle.includs[0];
                UIAtlas o = AssetDatabase.LoadAssetAtPath(path, typeof(UIAtlas)) as UIAtlas;
                if (!o) continue;
                dic.Add(path, new List<string>());
            }
            for (int i = 0; i < list.Count; i++)
            {
                BundleData bundle = list[i];
                List<string> denpend = bundle.dependAssets;
                for (int j = 0; j < denpend.Count; j++)
                {
                    var key = denpend[j];
                    if (dic.ContainsKey(key))
                    {
                        dic[key].Add(bundle.includs[0]);
                    }
                }
            }

            //foreach (var i in dic)
            //{
            //    //Debug.Log(i.Key + "--atlas-->" + dic[i.Key]);
            //}
            BuildWindow.saveObjectToJsonFile(dic, Application.dataPath + "/Z_Test/ref_text.json");
        }

        [MenuItem("Setting/Bundle/检测图集引用")]
        public static void checkRef()
        {
            if (EditorUtility.DisplayDialog("提示", "检测图集引用，引用为0的可以删了,引用多于1要注意下，不好优化。" +
                "本操作需要一段时间，如果点错，请取消。", "确定", "取消"))
            {
                checkFontRef();
                checkAtlasRef();
            }
        }

        public static void checkFontRef()
        {
            var list = BMDataAccessor.Bundles;
            Dictionary<string, int> dic = new Dictionary<string, int>();
            for (int i = 0; i < list.Count; i++)
            {
                BundleData bundle = list[i];
                if (bundle.includs.Count == 0) continue;
                string path = bundle.includs[0];
                UIFont o = AssetDatabase.LoadAssetAtPath(path, typeof(UIFont)) as UIFont;
                if (!o) continue;
                dic.Add(path, 0);
            }
            for (int i = 0; i < list.Count; i++)
            {
                BundleData bundle = list[i];
                List<string> denpend = bundle.dependAssets;
                for (int j = 0; j < denpend.Count; j++)
                {
                    var key = denpend[j];
                    if (dic.ContainsKey(key))
                    {
                        dic[key]++;
                    }
                }
            }

            foreach (var i in dic)
            {
                Debug.Log(i.Key + "--font-->" + dic[i.Key]);
            }
        }
        
        #endregion
        */
        #region 修复

        [MenuItem("Setting/Bundle/检查贴图是否为正方形")]
        public static void checkAtlasSquare()
        {
            string[] paths = AssetDatabase.FindAssets("t:Prefab", new string[] { rootPath + "/AllAtlas" });
            for (int i = 0; i < paths.Length; i++)
            {
                var guid = paths[i];
                string p = AssetDatabase.GUIDToAssetPath(guid);
                UIAtlas atlas = AssetDatabase.LoadAssetAtPath(p, typeof(UIAtlas)) as UIAtlas;
                if (!atlas) continue;
                Material m = atlas.spriteMaterial;
                var t = m.mainTexture;
                if (t.width != t.height)
                {
                    resetAssetToSquare(atlas);
                    Debug.Log(atlas);
                }
            }
        }

        [MenuItem("Assets/重置图集")]
        public static void resetMaterial()
        {
            var go = Selection.activeObject;
            if (!go) return;
            if (go as GameObject)
            {
                UIAtlas atlas = (go as GameObject).GetComponent<UIAtlas>();
                if (atlas)
                    resetMaterial(atlas);
            }
            else if (go as Material)
            {
                resetMaterial(go as Material);
            }
        }

        public static void resetMaterial(UIAtlas atlas)
        {
            resetMaterial(atlas.spriteMaterial);
        }
        public static void resetMaterial(Material material)
        {
            Shader shader = material.shader;
            if (shader.name == "Custom/Split Images")
            {
                shader = Shader.Find("Unlit/Transparent Colored");
                material.shader = shader;
                var path = AssetDatabase.GetAssetPath(material);
                path = Path.GetDirectoryName(path) + "/" + Path.GetFileNameWithoutExtension(path) + ".png";
                var tex = AssetDatabase.LoadAssetAtPath(path, typeof(Texture2D)) as Texture2D;
                material.SetTexture("_MainTex", tex);

                var src = tex;
                string p = AssetDatabase.GetAssetPath(src);
                TextureImporter textureimporter = AssetImporter.GetAtPath(p) as TextureImporter;
                if (textureimporter != null)
                {
                    textureimporter.textureType = TextureImporterType.Advanced;
                    textureimporter.isReadable = true;
                    textureimporter.alphaIsTransparency = true;
                    textureimporter.mipmapEnabled = false;

                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                    AssetDatabase.ImportAsset(p);
                }
                AssetDatabase.SaveAssets();
            }
        }


        [MenuItem("Assets/分解图集")]
        public static void reloadMaterial()
        {
            var go = Selection.activeObject;
            if (!go) return;
            if (go as GameObject)
            {
                UIAtlas atlas = (go as GameObject).GetComponent<UIAtlas>();
                if (atlas)
                    reloadMaterial(atlas);
            }
            else if (go as Material)
            {
                reloadMaterial(go as Material);
            }
        }

        public static void resetAssetToSquare(UIAtlas atlas)
        {
            if (!atlas) return;
            Material m = atlas.spriteMaterial;
            var path = AssetDatabase.GetAssetPath(m);
            resetMaterial(m);
            AssetDatabase.Refresh();
            m = AssetDatabase.LoadAssetAtPath(path, typeof(Material)) as Material;
            var t = m.mainTexture;
            if (t.width == t.height)
                return;
            if (atlas.spriteList.Count == 0) return;
            NGUISettings.forceSquareAtlas = true;
            Texture2D tex = NGUIEditorTools.ImportTexture(atlas.texture, true, true, false);
            var sd = atlas.spriteList[0];
            var name = sd.name;
            UIAtlasMaker.SpriteEntry se = UIAtlasMaker.ExtractSprite(atlas, name);
            UIAtlasMaker.AddOrUpdate(atlas, se);
            AssetDatabase.Refresh();
            m = AssetDatabase.LoadAssetAtPath(path, typeof(Material)) as Material;
            reloadMaterial(m);
        }

        [MenuItem("Assets/删除无用Sprite")]
        public static void RemoveUnUseSprite()
        {
            var go = Selection.activeGameObject;
            if (!go) return;
            ReplaceAtlasWindow.RemoveUnUseSprite(go);
        }

        [MenuItem("Assets/规范图集")]
        public static void resetToSquare()
        {
            var go = Selection.activeGameObject;
            if (!go) return;
            UIAtlas atlas = go.GetComponent<UIAtlas>();
            resetAssetToSquare(atlas);
        }
        public static void reloadMaterial(UIAtlas atlas)
        {
            reloadMaterial(atlas.spriteMaterial);
        }

        public static void reloadMaterial(Material material)
        {
            Shader shader = material.shader;
            if (shader.name == "Unlit/Transparent Colored")
            {
                SplitTexture.SplitTextureByMaterial(material);
            }
        }

        [MenuItem("Setting/修复/重新加载")]
        public static void reload()
        {
            GameObject go = Selection.activeObject as GameObject;
            if (go)
            {
                reloadTextueAndFont(go);
            }
        }

        private static void reloadTextueAndFont(GameObject go)
        {
            string path = AssetDatabase.GetAssetPath(go);
            Object[] arg = AssetDatabase.LoadAllAssetsAtPath(path);

            for (int i = 0; i < arg.Length; i++)
            {
                var g = arg[i] as GameObject;
                if (!g) continue;
                SimpleImage img = g.GetComponent<SimpleImage>();
                UITexture t = g.GetComponent<UITexture>();
                if (img && t && !t.mainTexture && !string.IsNullOrEmpty(img.autoLoadImage))
                {
                    var imgPath = "Assets/StreamingAssets/images/" + img.autoLoadImage;
                    Texture2D o = AssetDatabase.LoadAssetAtPath(imgPath, typeof(Texture2D)) as Texture2D;
                    t.mainTexture = o;
                }
                UILabel lab = g.GetComponent<UILabel>();
                if (lab && lab.bitmapFont == null)
                {
                    GameObject obj = AssetDatabase.LoadAssetAtPath("Assets/Resources/font/MyDanicFont.prefab", typeof(GameObject)) as GameObject;
                    UIFont font = obj.GetComponent<UIFont>();
                    lab.bitmapFont = font;
                }
            }
        }

        [MenuItem("Setting/修复/clearTexture")]
        public static void clearTexture()
        {
            GameObject go = Selection.activeObject as GameObject;
            if (go)
            {
                clearGameObjectTexture(go);
            }
        }

        [MenuItem("Setting/修复/clearSpriteII")]
        public static void clearSpriteII()
        {
            GameObject go = Selection.activeObject as GameObject;
            if (go)
            {
                clearSpriteII(go);
            }
        }
        [MenuItem("Setting/修复/clearScrollView")]
        public static void clearScrollView()
        {
            GameObject[] args = Selection.gameObjects;
            List<string> paths = new List<string>();
            if (args != null)
            {
                for (int i = 0; i < args.Length; i++)
                    _clearScrollView(args[i], ref paths);
            }
            for (int j = 0; j < paths.Count; j++)
                AssetDatabase.DeleteAsset(paths[j]);
            AssetDatabase.Refresh();
        }
        private static void _clearScrollView(GameObject go, ref List<string> paths)
        {
            if (!go) return;
            string path = AssetDatabase.GetAssetPath(go);
            GameObject o = GameObject.Instantiate(go) as GameObject;
            var arg = o.GetComponentsInChildren<ScrollView>(true);
            var find = false;
            for (int i = 0; i < arg.Length; i++)
            {
                var view = arg[i];
                if (!view) continue;
                if (view.viewItem.transform.parent == null)
                {
                    find = true;
                    var obj = NGUITools.AddChild(view.Content, view.viewItem);
                    obj.name = obj.name.Replace("(Clone)", "");
                    string p = AssetDatabase.GetAssetPath(view.viewItem);
                    view.viewItem = obj;
                    if (paths.IndexOf(p) == -1)
                        paths.Add(p);
                }
            }
            if (find)
                PrefabUtility.CreatePrefab(path, o);
            if (o)
                GameObject.DestroyImmediate(o);
        }
        private static void clearSpriteII(GameObject go)
        {
            string path = AssetDatabase.GetAssetPath(go);
            Object[] arg = AssetDatabase.LoadAllAssetsAtPath(path);
            var mat = AssetDatabase.LoadAssetAtPath(rootPath + "/meterial/circle_mask.mat", typeof(Material)) as Material;
            var save = false;
            //UIAtlas atlas = AssetDatabase.LoadAssetAtPath(rootPath + "/AllAtlas/PublicAtlas/public_one.prefab", typeof(UIAtlas)) as UIAtlas;
            for (int i = 0; i < arg.Length; i++)
            {
                var g = arg[i] as GameObject;
                if (!g) continue;
                UISpriteII sp = g.GetComponent<UISpriteII>();
                if (sp)
                {
                    var t = g.AddComponent<UITexture>();
                    NGUISettings.CopyWidget(sp);
                    NGUISettings.PasteWidget(t, true);
                    if (sp.m_MyShader && sp.m_MyShader.name == "Custom/mask_roundness")
                    {
                        //t.shader = Shader.Find("Custom/mask_roundness_texture");
                        t.material = mat;
                    }
                    Object.DestroyImmediate(sp, true);
                    save = true;
                    //sp.atlas = null;
                }
                else
                {
                    UITexture tx = g.GetComponent<UITexture>();
                    if (tx)
                    {
                        if (tx.shader && tx.shader.name == "Custom/mask_roundness_texture")
                        {
                            tx.shader = null;
                            tx.material = mat;
                            save = true;
                        }
                    }
                }
                //var _sp = g.GetComponent<UISprite>();
                //if (_sp && _sp.atlas && _sp.atlas.name == "public_three")
                //{
                //    _sp.atlas = atlas;
                //    save = true;
                //}
            }
            if (save)
            {
                Object obj = GameObject.Instantiate(go);

                PrefabUtility.CreatePrefab(path, obj as GameObject);
                Object.DestroyImmediate(obj);
            }

            AssetDatabase.SaveAssets();

        }

        private static void clearGameObjectTexture(GameObject go)
        {
            string path = AssetDatabase.GetAssetPath(go);
            Object[] arg = AssetDatabase.LoadAllAssetsAtPath(path);
            var save = false;
            Dictionary<GameObject, GameObject> dict = new Dictionary<GameObject, GameObject>();
            for (int i = 0; i < arg.Length; i++)
            {
                var g = arg[i] as GameObject;
                if (!g) continue;
                UluaBinding bind = g.GetComponent<UluaBinding>();
                if (bind)
                {
                    LuaVariable[] vals = bind.mVariables;
                    for (int j = 0; j < vals.Length; j++)
                    {
                        var val = vals[j];
                        if (val.type == "SimpleImage" && val.gameObject)
                        {
                            UITexture t = val.gameObject.GetComponent<UITexture>();
                            if (t) t.mainTexture = null;
                            if (!dict.ContainsKey(val.gameObject))
                                dict.Add(val.gameObject, val.gameObject);
                        }

                    }
                }
            }

            for (int i = 0; i < arg.Length; i++)
            {
                var g = arg[i] as GameObject;
                if (!g) continue;
                if (dict.ContainsKey(g)) continue;
                SimpleImage img = g.GetComponent<SimpleImage>();
                UITexture t = g.GetComponent<UITexture>();
                if (img && t && t.mainTexture)
                {
                    string p = AssetDatabase.GetAssetPath(t.mainTexture);
                    p = p.Replace("Assets/StreamingAssets/images/", "");
                    img.autoLoadImage = p;
                    t.mainTexture = null;
                    save = true;
                }
                else if (!img && t && t.mainTexture)
                {
                    string p = AssetDatabase.GetAssetPath(t.mainTexture);
                    if (p.IndexOf(rootPath) > -1) continue;
                    p = p.Replace("Assets/StreamingAssets/images/", "");
                    img = t.gameObject.AddComponent<SimpleImage>();
                    img.autoLoadImage = p;
                    t.mainTexture = null;
                    if (g.GetComponent<AutoDestoryTexture2D>())
                    {
                        Object.DestroyImmediate(g.GetComponent<AutoDestoryTexture2D>(), true);
                    }
                    save = true;
                }
            }
            if (save)
            {
                Object obj = GameObject.Instantiate(go);

                PrefabUtility.CreatePrefab(path, obj as GameObject);
                Object.DestroyImmediate(obj);
            }
            AssetDatabase.SaveAssets();

        }
		[MenuItem("Setting/本地化", false, 0)]
		public static void exportAllText()
		{
			Dictionary<string, string> keyMap = new Dictionary<string, string> ();
			var p_t = Application.dataPath + "/Z_Test/textMap_N.txt";

			int txt_length = 0;
			if (File.Exists(p_t))
			{
				string[] txt_lines = File.ReadAllLines(p_t);
				txt_length = txt_lines.Length;
				for (int j = 1; j < txt_length; j++)
				{
					var line = txt_lines[j];
					var arg = line.Split(',');
					var key = arg[0];
					if (arg [0] != "" && arg[0].Contains("LocalKey_")) 
					{
						keyMap[arg[1]] = key;
					}
				}
			}

			string[] paths = AssetDatabase.FindAssets("t:Prefab", new string[] { rootPath });
			Dictionary<GameObject, GameObject> dict = new Dictionary<GameObject, GameObject>();

			StreamWriter file = new StreamWriter("Assets/Z_Test/textMap.txt", false, Encoding.UTF8);

			int len = paths.Length;
			for (int i = 0; i < paths.Length; i++)
			{
				var guid = paths[i];
				string p = AssetDatabase.GUIDToAssetPath(guid);
				Object[] go = AssetDatabase.LoadAllAssetsAtPath(p);

				for (int k = 0; k < go.Length; k++)
				{
					var g = go[k] as GameObject;
					if (!g) continue;
					UluaBinding bind = g.GetComponent<UluaBinding>();
					if (bind)
					{
						LuaVariable[] vals = bind.mVariables;
						for (int j = 0; j < vals.Length; j++)
						{
							var val = vals[j];
							if (val.type == "UILabel" && val.gameObject)
							{
								if (!dict.ContainsKey(val.gameObject))
									dict.Add(val.gameObject, val.gameObject);
							}

						}
					}
				}
				bool find = false;
				for (int j = 0; j < go.Length; j++)
				{
					var g = go[j] as UILabel;
					if (!g) continue;
					if (dict.ContainsKey(g.gameObject)) continue;
					if (string.IsNullOrEmpty(g.text)) continue;
					string value = g.text;
					value = Regex.Replace(value, "[\n\r]+", @"\n");
					if (!Regex.IsMatch(value, "[\u4E00-\u9FA5]+"))
					{
						continue;
					}
					//value = value + "," + Path.GetFileName(p) + "->" + g.name;
					find = true;
					if (!keyMap.ContainsKey(value))
					{
						keyMap.Add(value,"LocalKey_"+(592+1).ToString());
						file.WriteLine(keyMap[value]+","+value+",");
					}
					UILocalize local = g.gameObject.GetComponent<UILocalize>();
					if (local)
					{
						local.key =keyMap[value];
					}
					else
					{
						local = g.gameObject.AddComponent<UILocalize>();
						local.key = keyMap[value];
					}
				}
				if (find)
				{
					//var obj = GameObject.Instantiate(AssetDatabase.LoadAssetAtPath(p, typeof(GameObject))) as GameObject;
					//Object target = AssetDatabase.LoadAssetAtPath(p, typeof(GameObject));
					//PrefabUtility.ReplacePrefab(obj, target, ReplacePrefabOptions.ConnectToPrefab);
					//break;

				}

				EditorUtility.DisplayProgressBar("本地化", "正在搜索" + Path.GetFileName(p), i / (float)len);

			}
			file.Close();
			EditorUtility.ClearProgressBar();
			AssetDatabase.Refresh();

		}
        //[MenuItem("Setting/打更新包", false, 0)]
        //static void buildUpdatePackge()
        //{
        //    BuildUpdateWindow window = EditorWindow.GetWindow<BuildUpdateWindow>("打更新包");
        //    window.minSize = new Vector2(300, 350);
        //    window.Show();
        //}

        [MenuItem("Setting/打更新包", false, 0)]
        static void buildNewUpdatePackge()
        {
            AssetBundleUpdate window = EditorWindow.GetWindow<AssetBundleUpdate>("新更新包");
            window.minSize = new Vector2(300, 350);
            window.Show();
        }

        #endregion

        public static void MatchChinese(string content, ref List<string> list)
        {
            Regex reg = new Regex("\"([^\"].*?)\"");
            var matches = reg.Matches(content);
            foreach (Match i in matches)
            {
                var find = i.Value;
                find = Regex.Replace(find, "\"", "");
                if (Regex.IsMatch(find, "[\u4e00-\u9fa5]"))
                {
                    if (list.Contains(find))
                        continue;
                    list.Add(find);
                }
            }
        }

        public static void MatchChineseLine(string[] allLine, ref List<string> list, ref Dictionary<string, string> listDict, ref int txt_length)
        {
            Regex reg = new Regex("['\"]([^'^\"].*?)['\"]");
            for (int i = 0; i < allLine.Length; i++)
            {
                var line = allLine[i];
                if (line.Trim().IndexOf("--") == 0)//--去掉注释
                    continue;
                int index = line.IndexOf("print(");
                int log = line.IndexOf("Debug.Log(");
                if (index > -1 || log > -1) continue;//去掉打印
                var matches = reg.Matches(line);

                foreach (Match match in matches)
                {
                    var find = match.Value;
                    find = Regex.Replace(find, "\"", "");
                    find = Regex.Replace(find, "'", "");
                    if (Regex.IsMatch(find, "[\u4e00-\u9fa5]"))
                    {
                        if (listDict.ContainsValue(find))
                            continue;
                        txt_length++;
						listDict["Text_1_" +(220+txt_length).ToString()] = find;
                        find = Regex.Replace(find, ",", "，");
						find = "Text_1_" + (220+txt_length).ToString() + "," + find + ",";
                        list.Add(find);

                    }
                }
            }
        }

        static void ReplaceLuaChineseToMeau(Dictionary<string, string> listDict, string path, FileUtils utils)
        {
            FileStream file = File.Open(path, FileMode.Open);
            byte[] array = new byte[file.Length];
            file.Read(array, 0, array.Length);
            file.Close();
            string str = Encoding.UTF8.GetString(array);
            /*for(int i=0; i<listDict.Count; i++)
            {   
                str = str.Replace("\""+listDict[i]+"\"","TextMap.GetValue(\""+listDict[i]+"\")");
            }*/
            foreach (string key in listDict.Keys)
            {
                str = str.Replace("\"" + listDict[key] + "\"", "TextMap.GetValue(\"" + key + "\")");
                str = str.Replace("'" + listDict[key] + "'", "TextMap.GetValue(\"" + key + "\")");
            }

            string new_path = path;//.Replace ("uLuaModule","uLua_New");

            byte[] args = Encoding.UTF8.GetBytes(str);

            utils.writeFile(new_path, args);

        }

        [MenuItem("Setting/找查代码中的中文", false, 0)]
        public static void FindChinese()
        {
            EditorUtility.DisplayProgressBar("find ……", "", 0);
            FileUtils utils = FileUtils.getInstance();
            List<string> list = new List<string>();
            Dictionary<string, string> listDict = new Dictionary<string, string>();
            var p = Application.dataPath + "/Z_Test/chinese_key.csv";

            int txt_length = 0;
            if (File.Exists(p))
            {
                string[] txt_lines = File.ReadAllLines(p);
                txt_length = txt_lines.Length;
            }

            utils.ForEachDirectory(Application.streamingAssetsPath + "/uLuaModule", "*.lua", (path) =>
            {
                //var str = utils.getString(path);
                //MatchChinese(str, ref list);
                var lines = File.ReadAllLines(path);
                MatchChineseLine(lines, ref list, ref listDict, ref txt_length);
                ReplaceLuaChineseToMeau(listDict, path, utils);
            });
            var desc = "";
            var len = list.Count;
            for (int i = 0; i < len; i++)
            {
                desc += list[i];
                if (i < len - 1)
                {
                    desc += "\n";
                }
            }

            if (!File.Exists(p))
            {
                utils.writeFile(p, desc);
            }
            else
            {
                File.AppendAllText(p, "\n" + desc);
            }
            EditorUtility.ClearProgressBar();
        }

        static string removeSpChar(string key_t)
        {
            return Regex.Replace(key_t, "[,，\\.。\\?？!！\\(（\\)）【】……:：\\s]", "");
        }



        [MenuItem("Setting/翻译")]
        static public void mergeLocalization()
        {
            var p = Application.streamingAssetsPath + "/Localization.csv";
            var p_t = Application.dataPath + "/Z_Test/Localization.csv";
            var source = File.ReadAllLines(p);
            var tran = File.ReadAllLines(p_t);

            Dictionary<string, string> TranList = new Dictionary<string, string>();


            for (int j = 0; j < tran.Length; j++)
            {
                var line_t = tran[j];
                var arg_t = line_t.Split('$');
                if (arg_t.Length > 1)
                {
                    var key_t = arg_t[0];
                    if (!TranList.ContainsKey(key_t))
                    {
                        TranList.Add(key_t, arg_t[1]);
                        key_t = removeSpChar(key_t);
                        if (!TranList.ContainsKey(key_t))
                        {
                            TranList.Add(key_t, arg_t[1]);
                        }
                    }

                }
            }

            for (int i = 0; i < source.Length; i++)
            {
                var line = source[i];
                var arg = line.Split(',');
                if (arg.Length == 3)
                {
                    var key = arg[1];
                    if (TranList.ContainsKey(key))
                    {
                        arg[2] = Regex.Replace(TranList[key], ",", "，");
                        source[i] = string.Join(",", arg);
                    }
                    else
                    {
                        key = removeSpChar(key);
                        if (TranList.ContainsKey(key))
                        {
                            arg[2] = Regex.Replace(TranList[key], ",", "，");
                            source[i] = string.Join(",", arg);
                        }
                    }
                }
            }
            StreamWriter file = new StreamWriter(p, false, Encoding.UTF8);
            for (int i = 0; i < source.Length; i++)
            {
                file.WriteLine(source[i]);
            }
            file.Close();
            AssetDatabase.Refresh();
        }
	}
		
}

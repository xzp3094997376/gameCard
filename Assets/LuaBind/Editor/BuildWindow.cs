using UnityEngine;
using UnityEditor;
using System.IO;
using System;
using System.Collections.Generic;
using ICSharpCode.SharpZipLib.Zip;
using LitJson;
using UnityEditor.Callbacks;
namespace LuaBind
{

    public class BuildWindow : EditorWindow
    {
        public class PathSetting
        {
            public string[] needCopy;
            private const string path_setting = "editor_config/path_setting.txt";
            private const string copy_list = "editor_config/copy_list.txt";

            static public string load()
            {
                return FileUtils.getInstance().getString(path_setting);
            }

            public static void save(string _path)
            {
                FileUtils.getInstance().writeFileWithCode(path_setting, _path, System.Text.Encoding.UTF8);
            }
            public static List<string> loadCopyList()
            {
                var str = FileUtils.getInstance().getString(copy_list);
                if (string.IsNullOrEmpty(str)) return new List<string>();
                return new List<string>(str.Split('\n'));
            }
            public static void saveCopyList(List<string> paths)
            {
                var str = "";
                str = string.Join("\n", paths.ToArray());
                FileUtils.getInstance().writeFile(copy_list, str);
            }
        }
        public class Project
        {
            public string packageUrl;
            public string remoteManifestUrl;
            public string remoteVersionUrl;
            public string version;
            public Dictionary<string, string> groupVersions;
            public string engineVersion;
            public Dictionary<string, string> assets;
            public List<string> searchPaths;
        }
        public class Setting
        {
            public bool update = false;
            public bool isLJSDK = false;
			public bool isChgeAcc = false;
            public bool isPush = false;
            public bool isDebug = true;
            public bool isGuide = false;
			public bool isChannel = false;
			public string channelName="";
            public string sdkPlatform = "";
			public string language = "CN";
            public string dataEyeChannelID = "";
            public string dataEyeAppID = "";
            public string platformIP = "";
            public int platformPort = 80;
            public string localIP = "";
            public int localPort = 80;
            public string gameName = "";
        }
		public class OptionData
		{
			public string name = "";
			public string id = "";
			public int port = 80;
			public string channel="";
			public string version = ""; 
			public string table = "";
		}


        private Setting setting;
        private Project project;
        private string _path;
        private static List<string> _copyList;
        private string temp_path;
        //选择贴图的对象
        private Texture texture;
        private static readonly string settingPath = Application.streamingAssetsPath + "/setting.json";
        private static readonly string projectPath = Application.streamingAssetsPath + "/project.manifest";
        private bool is_guide_open = false;
        private bool is_assetsBundle = false;
        private static GUIContent
        insertContent = new GUIContent("+", "添加变量"),
        browse = new GUIContent("浏览", "浏览文件夹"),
        deleteContent = new GUIContent("-", "删除变量");
        private static GUILayoutOption buttonWidth = GUILayout.MaxWidth(20f);

		int index =0;
		List<OptionData> optionsData = new List<OptionData> ();
		string [] options=new string[]{};

        public void Awake()
        {
            readSetting();
        }
        static public void saveObjectToJsonFile<T>(T data, string path)
        {
            string jsonStr = JsonFormatter.PrettyPrint(JsonMapper.ToJson(data));

            FileUtils.getInstance().writeFileWithCode(path, jsonStr, null);
        }
        static public T loadObjectFromJsonFile<T>(string path)
        {
            string str = FileUtils.getInstance().getString(path);
            if (string.IsNullOrEmpty(str))
            {
                Debug.LogError("Cannot find " + path);
                return default(T);
            }

            T data = JsonMapper.ToObject<T>(str);
            if (data == null)
            {
                Debug.LogError("Cannot read data from " + path);
            }

            return data;
        }

        bool isAssetsBundle
        {
            get
            {
                return PlayerPrefs.GetInt("isAssetsBundle", 0) == 1;
            }
            set
            {
                PlayerPrefs.SetInt("isAssetsBundle", value ? 1 : 0);
            }
        }

        bool isOpenGuide
        {
            get
            {
                return PlayerPrefs.GetInt("IsOpenGuide", 0) == 1;
            }
            set
            {
                PlayerPrefs.SetInt("IsOpenGuide", value ? 1 : 0);
            }
        }
        void readSetting()
        {
            setting = loadObjectFromJsonFile<Setting>(settingPath);
            project = loadObjectFromJsonFile<Project>(projectPath);
            _path = PathSetting.load();
            _copyList = PathSetting.loadCopyList();
            is_guide_open = isOpenGuide;
            is_assetsBundle = isAssetsBundle;
			optionsData = new List<OptionData> ();
			var p = Application.dataPath + "/StreamingAssets/11.csv";

			int txt_length = 0;
			if (File.Exists(p))
			{
				string[] txt_lines = File.ReadAllLines(p);
				txt_length = txt_lines.Length;
				options = new string[txt_length-1];
				for (int j = 1; j < txt_length; j++)
				{
					var line = txt_lines[j];
					var arg = line.Split(',');
					options [j-1] = arg [0];
					if (arg [0] != "") 
					{
						OptionData op = new OptionData ();
						op.name = arg [0];
						if (arg [1] != "") {
							op.id = arg [1];
						}
						if (arg [2] != "") {
							op.port = int.Parse(arg [2]);
						}
						if (arg [3] != "") {
							op.channel = arg [3];
						}
						if (arg [4] != "") {
							op.version = arg [4];
						}
						if (arg [5] != "") {
							op.table = arg [5];
						}
						optionsData.Add (op);
					}
				}
			}

        }
			

        //绘制窗口时调用
        void OnGUI()
        {
            //输入框控件
            GUILayout.Space(5);
            project.version = EditorGUILayout.TextField("版本号:", project.version);
            GUILayout.Space(5);
            setting.gameName = EditorGUILayout.TextField("游戏名首字母:", setting.gameName);
            GUILayout.Space(5);
            setting.platformIP = EditorGUILayout.TextField("远程IP:", setting.platformIP);
            GUILayout.Space(5);
            setting.platformPort = EditorGUILayout.IntField("远程端口:", setting.platformPort);
            GUILayout.Space(5);
            GUILayout.BeginHorizontal();
            setting.localIP = EditorGUILayout.TextField("本地IP:", setting.localIP);
            if (GUILayout.Button("快速切换"))
            {
                if (setting.localIP == setting.platformIP)
                {
                    setting.localIP = "127.0.0.1";
                }
                else
                {
                    setting.localIP = setting.platformIP;
                }
            }
            GUILayout.EndHorizontal();
            GUILayout.Space(5);
            setting.localPort = EditorGUILayout.IntField("本地端口:", setting.localPort);
				
            GUILayout.Space(5);
            setting.update = EditorGUILayout.Toggle("开启热更新:", setting.update);
            GUILayout.Space(5);

            GUILayout.Space(5);
            setting.sdkPlatform = EditorGUILayout.TextField("SDK渠道:", setting.sdkPlatform);
			GUILayout.Space(5);
			setting.language = EditorGUILayout.TextField("语言类型:", setting.language);
            GUILayout.Space(5);
            setting.dataEyeChannelID = EditorGUILayout.TextField("DataEye渠道:", setting.dataEyeChannelID);
            GUILayout.Space(5);
            setting.isLJSDK = EditorGUILayout.Toggle("包含SDK:", setting.isLJSDK);
            GUILayout.Space(5);
            setting.isPush = EditorGUILayout.Toggle("开启推送:", setting.isPush);
            GUILayout.Space(5);
            setting.isDebug = EditorGUILayout.Toggle("开启Log:", setting.isDebug);
            GUILayout.Space(5);
            GUILayout.BeginHorizontal();
            GUILayout.Label("表格目录", GUILayout.Width(146), GUILayout.Height(18f));
            GUILayout.Label(_path, "HelpBox", GUILayout.Height(18f));
            if (GUILayout.Button(browse))
            {
                string path = EditorUtility.OpenFolderPanel("配置表格目录", _path, "table_client");
                if (!string.IsNullOrEmpty(path))
                {
                    _path = path;
                    PathSetting.save(_path);
                }

            }
			GUILayout.EndHorizontal();
			GUILayout.Space(5);
			setting.isChannel = EditorGUILayout.Toggle("是否选择渠道:", setting.isChannel);
			if (setting.isChannel) 
			{
				GUILayout.Space(5);
				index =EditorGUILayout.Popup(index, options);
				setting.localIP = optionsData [index].id;
				project.version = optionsData [index].version;
				setting.localPort = optionsData [index].port;
				setting.channelName = optionsData [index].channel;
				_path = optionsData [index].table;
			}
            GUILayout.Space(5);
            setting.isGuide = EditorGUILayout.Toggle("开启新手:", setting.isGuide);
            is_assetsBundle = EditorGUILayout.Toggle("Prefab使用AssetsBundle:", is_assetsBundle);
            GUILayout.Space(5);

            #region 复制文件列表

            GUILayout.Space(5);
            EditorTools.DrawSeparator();
            if (EditorTools.DrawHeader("需要复制的文件"))
            {
                EditorTools.BeginContents();
                GUILayout.Space(5);
                for (int i = 0; i < _copyList.Count; i++)
                {
                    if (i % 2 == 0) GUI.backgroundColor = Color.cyan;
                    else GUI.backgroundColor = Color.magenta;
                    drawLine(_copyList[i]);
                }
                EditorTools.EndContents();
                GUILayout.Space(5);
                GUI.backgroundColor = Color.yellow;
                EditorTools.BeginContents();
                GUI.backgroundColor = Color.white;
                GUILayout.Space(5);
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label(temp_path, "HelpBox", GUILayout.Height(16f));
                if (GUILayout.Button(browse, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(80f)))
                {
                    var path = openFolder();
                    temp_path = path;
                }

                if (GUILayout.Button(insertContent, EditorStyles.miniButtonLeft, buttonWidth))
                {
                    if (!string.IsNullOrEmpty(temp_path))
                    {
                        _copyList.Add(temp_path);
                        PathSetting.saveCopyList(_copyList);
                    }
                }
                EditorGUILayout.EndHorizontal();

                EditorTools.EndContents();
                GUILayout.Space(5);
            }
            GUILayout.Space(5);

            #endregion
            GUILayout.Space(5);
            if (GUILayout.Button("本地打包"))
            {
                saveSetting();
                Build();
            }
            GUILayout.Space(5);
            if (GUILayout.Button("打包并运行"))
            {
                saveSetting();
                Build(false, true);
            }
            GUILayout.Space(5);
            if (GUILayout.Button("导出项目"))
            {
                saveSetting();
                Build(true);
            }
            //if (GUILayout.Button("复制"))
            //{
            //    CopyFile();
            //}
            //if (GUILayout.Button("转表"))
            //{
            //    var process = new System.Diagnostics.ProcessStartInfo();
            //    process.FileName = "cmd.exe";

            //    var p = System.Diagnostics.Process.Start(process);
            //}
            //GUILayout.Space(5);
            //if (GUILayout.Button("打包"))
            //{
            //    StartBuild();
            //}

            //if (GUILayout.Button("关闭通知", GUILayout.Width(200)))
            //{
            //    //关闭通知栏
            //    this.RemoveNotification();
            //}

            ////文本框显示鼠标在窗口的位g置
            //EditorGUILayout.LabelField("鼠标在窗口的位置", Event.current.mousePosition.ToString());

            ////选择贴图
            //texture = EditorGUILayout.ObjectField("添加贴图", texture, typeof(Texture), true) as Texture;

            //if (GUILayout.Button("关闭窗口", GUILayout.Width(200)))
            //{
            //    //关闭窗口
            //    this.Close();
            //}

        }
        string openFolder()
        {
            var root = Application.dataPath.Replace("/Assets", "");
            var path = EditorUtility.OpenFolderPanel("选择目录", root, "");
            if (!string.IsNullOrEmpty(path))
            {
                path = FileUtils.getLinuxPath(path);
                if (path.IndexOf(root + "/") == -1)
                {
                    EditorUtility.DisplayDialog("tips", "请选择与Assets相同目录", "OK");
                    return "";
                }
                path = path.Replace(root + "/", "");
            }
            return path;
        }

        private void drawLine(string path)
        {

            EditorGUILayout.BeginHorizontal();

            GUILayout.Label(path, "HelpBox", GUILayout.Height(16f));

            if (GUILayout.Button(deleteContent, EditorStyles.miniButtonLeft, buttonWidth))
            {
                _copyList.Remove(path);
                PathSetting.saveCopyList(_copyList);
            }
            EditorGUILayout.EndHorizontal();
            GUILayout.Space(5);
        }
        private static void Build(bool isExport = false, bool run = false)
        {
            if (UnityEditor.EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android)
            {
                if (isExport)
                {
                    BuildAndroidExport();
                }
                else
                {
                    BuildAndroid(run);
                }
            }
            else if (UnityEditor.EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS)
            {
                if (isExport)
                {
                    BuildIOSExport();
                }
                else
                {
                    BuildIOS();
                }
            }
            else
            {
                EditorUtility.DisplayDialog("tips", "只能安卓和ios平台可以打包。\n请切一下平台吧!", "^_^");
            }
        }


        void OnFocus()
        {
            readSetting();
        }

        void OnLostFocus()
        {
            saveSetting();
        }

        private void saveSetting()
        {
            saveObjectToJsonFile(setting, settingPath);
            saveObjectToJsonFile(project, projectPath);
            isOpenGuide = is_guide_open;
            isAssetsBundle = is_assetsBundle;
        }

        void OnHierarchyChange()
        {
            //Debug.Log("当Hierarchy视图中的任何对象发生改变时调用一次");
        }

        void OnProjectChange()
        {
            //Debug.Log("当Project视图中的资源发生改变时调用一次");
        }

        void OnInspectorUpdate()
        {
            //Debug.Log("窗口面板的更新");
            //这里开启窗口的重绘，不然窗口信息不会刷新
            this.Repaint();
        }

        void OnSelectionChange()
        {
            //当窗口出去开启状态，并且在Hierarchy视图中选择某游戏对象时调用
            //foreach (Transform t in Selection.transforms)
            //{
            //    //有可能是多选，这里开启一个循环打印选中游戏对象的名称
            //    //Debug.Log("OnSelectionChange" + t.name);
            //}
        }

        void OnDestroy()
        {
            //Debug.Log("当窗口关闭时调用");
        }
        public static void CopyDirectory(string sourcePath, string destinationPath)
        {
            DirectoryInfo info = new DirectoryInfo(sourcePath);
            FileUtils.getInstance().createDirectory(destinationPath);
            foreach (FileSystemInfo fsi in info.GetFileSystemInfos())
            {
                string destName = Path.Combine(destinationPath, fsi.Name);
                if (fsi is System.IO.FileInfo)
                    File.Copy(fsi.FullName, destName, true);
                else
                {
                    FileUtils.getInstance().createDirectory(destName);
                    CopyDirectory(fsi.FullName, destName);
                }
            }
        }
        //在这里找出你当前工程所有的场景文件，假设你只想把部分的scene文件打包 那么这里可以写你的条件判断 总之返回一个字符串数组。
        static string[] GetBuildScenes()
        {
            List<string> names = new List<string>();
            foreach (EditorBuildSettingsScene e in EditorBuildSettings.scenes)
            {
                if (e == null)
                    continue;
                if (e.enabled)
                    names.Add(e.path);
            }
            return names.ToArray();
        }
        //得到项目的名称
        public static string projectName
        {
            get
            {
                //在这里分析shell传入的参数， 还记得上面我们说的哪个 project-$1 这个参数吗？
                //这里遍历所有参数，找到 project开头的参数， 然后把-符号 后面的字符串返回，
                //这个字符串就是 91 了。。
                foreach (string arg in System.Environment.GetCommandLineArgs())
                {
                    if (arg.StartsWith("project"))
                    {
                        var paths = arg.Split('-');
                        if (paths.Length >= 2)
                            return paths[1];
                    }
                }
                return "";
            }
        }
        /// <summary>
        /// 按平台复制文件
        /// </summary>
        /// <param name="pf">Android|IOS</param>
        private static void copy(string pf)
        {
            EditorUtility.DisplayProgressBar("Copy Assets", "正在复制表格", 0);
            string configPath = PathSetting.load();
            if (!Directory.Exists(configPath) || !File.Exists(configPath + "/files.data"))
            {
                if (UnityEditor.EditorUtility.DisplayDialog("提示", "找不到配置表格，请在菜单Setting->配置文件更改->浏览(表格目录) 配置", "确定"))
                {
                }
                return;
            }
            for (int i = 0; i < _copyList.Count; i++)
            {
                var p = _copyList[i] + "/" + pf;
                CopyDirectory(p, Application.streamingAssetsPath + "/" + p);
            }

            CopyDirectory(configPath, Application.streamingAssetsPath + "/configs");
            EditorUtility.DisplayProgressBar("安卓打包", "正在复制文件", 0.5f);
            zipLua(Application.streamingAssetsPath + "/uLuaModule");

            EditorUtility.DisplayProgressBar("安卓打包", "复制文件完毕", 1);
            EditorUtility.ClearProgressBar();
        }

        /// <summary>
        /// 导出安卓工程
        /// </summary>
        public static void BuildAndroidExport()
        {
            string[] args = System.Environment.GetCommandLineArgs();

            var project = loadObjectFromJsonFile<Project>(projectPath);
            string version = project.version;
            string path = projectName;
            if (string.IsNullOrEmpty(path))
                path = EditorUtility.SaveFolderPanel("导出项目", Application.dataPath, "bleach_" + version);
            if (string.IsNullOrEmpty(path))
            {
                return;
            }
            copy("Android");
            Caching.CleanCache();
            var error = BuildPipeline.BuildPlayer(GetBuildScenes(), path, BuildTarget.Android, BuildOptions.AcceptExternalModificationsToPlayer);
            if (!string.IsNullOrEmpty(error))
            {
                clear();
            }
        }

        /// <summary>
        /// 一键打包android
        /// </summary>
        public static void BuildAndroid(bool ret = false)
        {
            var project = loadObjectFromJsonFile<Project>(projectPath);
            string version = project.version;
            string path = projectName;
            if (string.IsNullOrEmpty(path))
                path = EditorUtility.SaveFilePanel("保存apk", Application.dataPath, "bleach_" + version, "apk");
            if (string.IsNullOrEmpty(path))
            {
                return;
            }
            copy("Android");
            Caching.CleanCache();
            var run = BuildOptions.None;
            if (ret)
            {
                run = BuildOptions.AutoRunPlayer;
            }
            var error = BuildPipeline.BuildPlayer(GetBuildScenes(), path, BuildTarget.Android, run);
            if (!string.IsNullOrEmpty(error))
            {
                clear();  
            }
        }

        public static void zipLua(string path)
        {
            EditorUtility.DisplayProgressBar("安卓打包", "正在加密lua", 0.5f);

            FileUtils.getInstance().ForEachDirectory(path, "*.lua", (filePath) =>
            {
                byte[] data = File.ReadAllBytes(filePath);
                data = ConfigManager.ecodeLuaFile(data);
                File.WriteAllBytes(filePath, data);
                EditorUtility.DisplayProgressBar("安卓打包", "正在加密：" + Path.GetFileNameWithoutExtension(filePath), 0.5f);

            });
            EditorUtility.ClearProgressBar();
        }

        /// <summary>
        /// 导出ios工程
        /// </summary>
        public static void BuildIOSExport()
        {
            var project = loadObjectFromJsonFile<Project>(projectPath);
            string version = project.version;
            string path = projectName;
            if (string.IsNullOrEmpty(path))
                path = EditorUtility.SaveFolderPanel("导出项目", Application.dataPath, "");
            if (string.IsNullOrEmpty(path))
            {
                return;
            }
            path += "/bleach_" + version;
            copy("IOS");
            Caching.CleanCache();
            string error = BuildPipeline.BuildPlayer(GetBuildScenes(), path, BuildTarget.iOS, BuildOptions.None);
            if (!string.IsNullOrEmpty(error))
            {
                clear();
            }
        }
        private static void BuildIOS()
        {
            Debug.Log("有空完善一下");
        }

        [MenuItem("Setting/加密|解密lua文件")]
        public static void zipOrUnZipLua()
        {
            zipLua(Application.streamingAssetsPath + "/uLuaModule");
        }

        [MenuItem("Setting/加密|解密指定单个lua文件~")]
        public static void zipOrUnZipSingleLua()
        {
            var path = AssetDatabase.GetAssetPath(Selection.activeObject);
            if (string.IsNullOrEmpty(path)) return;

            byte[] data = File.ReadAllBytes(path);
            data = ConfigManager.ecodeLuaFile(data);
            File.WriteAllBytes(path, data);
        }

        [MenuItem("Setting/加密|解密指定单个文件夹lua文件~")]
        public static void zipOrUnZipSingleDirLua()
        {
            var path = AssetDatabase.GetAssetPath(Selection.activeObject);
            if (string.IsNullOrEmpty(path)) return;

            zipLua(path);
        }

        static void clear()
        {
            AssetDatabase.DeleteAsset("Assets/StreamingAssets/configs");
            for (int i = 0; i < _copyList.Count; i++)
            {
                var p = _copyList[i];
                AssetDatabase.DeleteAsset("Assets/StreamingAssets/" + p);
                FileUtils.getInstance().removeDirectory(Application.streamingAssetsPath + "/" + p);
                FileUtils.getInstance().removeFile(Application.streamingAssetsPath + "/" + p + ".meta");
            }
            zipLua(Application.streamingAssetsPath + "/uLuaModule");
            EditorUtility.ClearProgressBar();
        }


        /// <summary>
        /// 导出完成，做一些操作
        /// </summary>
        /// <param name="target"></param>
        /// <param name="pathToBuiltProject"></param>
        [PostProcessBuild(100)]
        private static void OnPostProcessBuild(BuildTarget target, string pathToBuiltProject)
        {
            if (target == BuildTarget.Android)
            {
                Debug.Log("*********Android Ok**********");
            }
            else if (target == BuildTarget.iOS)
            {
                Debug.Log("************IOS Ok**********");

            }
            clear();
        }
    }
}

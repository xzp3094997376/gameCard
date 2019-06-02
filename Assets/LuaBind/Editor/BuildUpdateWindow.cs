using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;

namespace LuaBind
{
    public class BuildUpdateWindow : EditorWindow
    {
        public const string rootPath = "Assets/UI";
        private string mInput;
        private string mOutput;
        private string mVersion;
        
        void OnGUI()
        {
            GUILayout.BeginHorizontal();
            GUILayout.Label("更新资源目录", GUILayout.Width(146), GUILayout.Height(18f));
            GUILayout.Label(mInput, "HelpBox", GUILayout.Height(18f));
            if (GUILayout.Button("浏览"))
            {
                string path = EditorUtility.OpenFolderPanel("更新文件目录", mInput, "Assets");
                if (!string.IsNullOrEmpty(path))
                {
                    mInput = path;
                }

            }
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
            GUILayout.Label("Output", GUILayout.Width(146), GUILayout.Height(18f));
            GUILayout.Label(mOutput, "HelpBox", GUILayout.Height(18f));
            if (GUILayout.Button("浏览"))
            {
                string path = EditorUtility.OpenFolderPanel("Output", mOutput, "Assets");
                if (!string.IsNullOrEmpty(path))
                {
                    mOutput = path;
                }

            }
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
            GUILayout.Label("版本号", GUILayout.Width(146), GUILayout.Height(18f));
            mVersion = EditorGUILayout.TextField(mVersion, GUILayout.Height(18f));
            GUILayout.EndHorizontal();

            if (GUILayout.Button("打包"))
            {
                BuildPrefab();
                BuildLua();
                Copy();
                Zip();
            }

            //if (GUILayout.Button("打包lua"))
            //{
            //    BuildLua();
            //}

        }

        void Zip()
        { 
            FastZip fast = new FastZip();
            var pf = FileUtils.getInstance().getRuntimePlatform();
            var zipPath = mOutput + "/" + mVersion + ".zip";
            fast.CreateZip(zipPath, mOutput + "/" + pf, true, "");

            FileUtils.getInstance().removeDirectory(mOutput + "/" + pf + "/" + mVersion);
            File.Move(zipPath, mOutput + "/" + pf + "/" + Path.GetFileName(zipPath));
        }
        public static void CopyDirectory(string sourcePath, string destinationPath)
        {
			if(!Directory.Exists(sourcePath)) return;
            DirectoryInfo info = new DirectoryInfo(sourcePath);
            FileUtils.getInstance().createDirectory(destinationPath);
            foreach (FileSystemInfo fsi in info.GetFileSystemInfos())
            {
                string destName = Path.Combine(destinationPath, fsi.Name);
                if (fsi is System.IO.FileInfo)
                {
                    if(fsi.FullName.IndexOf(".meta") > -1) continue;
                    File.Copy(fsi.FullName, destName, true);
                }
                else
                {
                    FileUtils.getInstance().createDirectory(destName);
                    CopyDirectory(fsi.FullName, destName);
                }
            }
        }
        private void Copy()
        {
            var pf = FileUtils.getInstance().getRuntimePlatform();
            var outPut = mOutput + "/" + pf + "/" + mVersion;
            CopyDirectory(mInput + "/ArtResources/" + pf, outPut + "/ArtResources/" + pf);

            CopyDirectory(mInput + "/client_table", outPut + "/configs");
            //CopyDirectory(mInput + "/Assets/images", outPut + "/images");
            var f = mInput + "Assets/StreamingAssets/shareSDKConfig.json";
            outPut = mOutput + "/" + pf;
            if (File.Exists(f))
                File.Copy(f, outPut + "/shareSDKConfig.json", true);
            f = mInput + "Assets/StreamingAssets/BindUnityList.txt";
            if(File.Exists(f))
                File.Copy(f, outPut + "/BindUnityList.txt", true);
            f = mInput + "Assets/StreamingAssets/Localization.csv";
            if (File.Exists(f)) { 
                string path = mOutput + "/" + pf + "/" + mVersion + "/lan/";
                if (!Directory.Exists(path)) {
                    Directory.CreateDirectory(path);
                }
                File.Copy(f, path + "Localization.csv", true);
            }
        }

        private void BuildPrefab()
        {
            FileUtils utils = FileUtils.getInstance();
            List<string> bundleFull = new List<string>();
            List<string> moveList = new List<string>();
            List<string> assets_paths = new List<string>();
            List<string> depsList = new List<string>();
            utils.ForEachDirectory(mInput, "*.prefab", (path) =>
            {
                path = FileUtils.getLinuxPath(path);
                if (path.IndexOf("/Assets/UI/") > -1)
                {
                    assets_paths.Add(path.Substring(path.IndexOf("/trunk/") + 8));
                    var url = path.Substring(path.IndexOf("/Assets/UI/") + 11);
                    url = Path.GetDirectoryName(url) + "/" + Path.GetFileNameWithoutExtension(url);
                    moveList.Add(url);
                    bundleFull.Add(url);
                } 
            });
            utils.ForEachDirectory(mInput + "/Assets/images/", "*.*", (path) =>
            {
                if (!path.EndsWith(".meta"))
                {
                    path = FileUtils.getLinuxPath(path);
                    if (path.IndexOf("/Assets/images/") > -1)
                    {
                        assets_paths.Add(path.Substring(path.IndexOf("/trunk/") + 8));
                        var url = path.Substring(path.IndexOf("/Assets/") + 8);
                        url = Path.GetDirectoryName(url) + "/" + Path.GetFileNameWithoutExtension(url);
                        moveList.Add(url);
                        bundleFull.Add(url);
                    }
                }
            });

            string outAb = Application.dataPath + "/../AssetBundle/" + utils.getRuntimePlatform() + "/";
            BuildAll(assets_paths.ToArray(), outAb, depsList);
            //TODO dxj image图片
            //BundleMrg.SetConfig(assets_paths.ToArray());
            //BuildHelper.BuildBundles(bundles.ToArray());
            var pf = FileUtils.getInstance().getRuntimePlatform();
            var outPut = mOutput + "/" + pf + "/" + mVersion;

            for (int i = 0; i < moveList.Count; i++)
            {
                var path = Application.dataPath + "/../AssetBundle/" + utils.getRuntimePlatform() + "/" + moveList[i];
                if (utils.isFileExist(path))
                {
                    var p = outPut + "/AssetBundle/" + utils.getRuntimePlatform() + "/" + moveList[i];
                    if (!Directory.Exists(Path.GetDirectoryName(p)))
                    {
                        Directory.CreateDirectory(Path.GetDirectoryName(p));
                    }
                    File.Copy(path, p, true);
                }
            }
        }



        public void BuildAll(string[] paths, string outPut, List<string> deleteList)
        {

            for (int i = 0; i < paths.Length; i++)
            {
                var item = paths[i];
                if (item != null && !string.IsNullOrEmpty(item))
                {
                    SetAssetBundleName(item, rootPath, deleteList);
                }
            }
            // Choose the output path according to the build target.
            //string outputPath = Path.Combine("shanluanceshi", FileUtils.getInstance().getRuntimePlatform());
            if (!Directory.Exists(outPut))
                Directory.CreateDirectory(outPut);
            BuildPipeline.BuildAssetBundles(outPut, BuildAssetBundleOptions.None, EditorUserBuildSettings.activeBuildTarget);
        }

        public void SetAssetBundleName(string path, string root, List<string> depsList)
        {
            string full = path;
            if (string.IsNullOrEmpty(root)) path = "Assets";
            else path = root;

            string[] deps = AssetDatabase.GetDependencies(full);

            for (int i = 0; i < deps.Length; i++)
            {
                string sRoot = "Assets";
                string p = deps[i];
                string fullPath = deps[i];
                if (p.EndsWith(".cs")) continue;
                AssetImporter im = AssetImporter.GetAtPath(p);
                if (p.IndexOf("Assets/UI", 0) != -1) 
                {
                    sRoot = "Assets/UI";
                }
                p = p.Replace(sRoot + "/", "");
                p = Path.GetDirectoryName(p) + "/" + Path.GetFileNameWithoutExtension(p);
                im.assetBundleName = p;
                if (!fullPath.Equals(full)) depsList.Add(p);
                //EditorUtility.DisplayProgressBar("Prefab", path, 1);
                //EditorUtility.ClearProgressBar();
            }

            //for (int i = 0; i < deps.Length; i++)
            //{
            //    string p2 = deps[i];
            //    if (p2.EndsWith(".cs")) continue;
            //    AssetImporter im2 = AssetImporter.GetAtPath(p2);
            //    p2 = p2.Replace(path + "/", "");
            //    p2 = Path.GetDirectoryName(p2) + "/" + Path.GetFileNameWithoutExtension(p2);
            //    im2.assetBundleName = p2;
            //    deleteList.Add(p2);
            //}
        }

        private void pushDeps(string url, ref List<string> bundles, ref List<string> moveList)
        {
            //var data =  BundleManager.GetBundleData(url);
            //if (data != null)
            //{
            //    for (int i = 0; i < data.dependAssets.Count; i++)
            //    {
            //        var p = data.dependAssets[i];
            //        if (p.LastIndexOf(".prefab") > -1)
            //        {
            //            if (AssetDatabase.LoadAssetAtPath(p, typeof(UIAtlas)))
            //            {
            //                p = p.Replace("Assets/Resources/", "");
            //                p = p.Replace(".prefab", "");
            //                if (moveList.Contains(p))
            //                    continue;
            //                bundles.Add(p);
            //                moveList.Add(p);
            //            }
            //        }
            //    }
            //}
        }

        private void BuildLua()
        {
            FileUtils utils = FileUtils.getInstance();
            var pf = FileUtils.getInstance().getRuntimePlatform();
            var outPut = mOutput + "/" + pf + "/" + mVersion;
            utils.ForEachDirectory(mInput, "*.lua", (path) =>
            {
                path = FileUtils.getLinuxPath(path);
                if (path.IndexOf("/Assets/StreamingAssets/uLuaModule/") > -1)
                {
                    var p = outPut + "/" + path.Substring(path.IndexOf("/StreamingAssets/") + 17);
                    if (!Directory.Exists(Path.GetDirectoryName(p)))
                    {
                        Directory.CreateDirectory(Path.GetDirectoryName(p));
                    }
                    File.Copy(path, p, true);
                }

            });
            BuildWindow.zipLua(outPut + "/uLuaModule");
            EditorUtility.ClearProgressBar();
        }
    }
}
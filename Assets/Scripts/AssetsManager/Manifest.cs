using System;
using System.Collections.Generic;
using TinyJSON;
namespace AssetsCtrl
{
    public class Manifest
    {
        const string KEY_VERSION = "version";
        const string KEY_PACKAGE_URL = "packageUrl";
        const string KEY_MANIFEST_URL = "remoteManifestUrl";
        const string KEY_VERSION_URL = "remoteVersionUrl";
        const string KEY_GROUP_VERSIONS = "groupVersions";
        const string KEY_ENGINE_VERSION = "engineVersion";
        const string KEY_ASSETS = "assets";
        const string KEY_COMPRESSED_FILES = "compressedFiles";
        const string KEY_SEARCH_PATHS = "searchPaths";

        const string KEY_PATH = "path";
        const string KEY_MD5 = "md5";
        const string KEY_GROUP = "group";
        const string KEY_COMPRESSED = "compressed";
        const string KEY_SIZE = "size";
        const string KEY_COMPRESSED_FILE = "compressedFile";
        const string KEY_DOWNLOAD_STATE = "downloadState";
        //private
        //! Indicate whether the version informations have been fully loaded
        private bool _versionLoaded = false;

        //! Indicate whether the manifest have been fully loaded
        private bool _loaded = false;

        //! The local manifest root
        private string _manifestRoot = "";

        //! The remote package url
        private string _packageUrl = "";

        //! The remote path of manifest file
        private string _remoteManifestUrl = "";

        //! The remote path of version file [Optional]
        private string _remoteVersionUrl = "";

        //! The version of local manifest
        private string _version = "";

        //! All groups exist in manifest [Optional]
        private List<string> _groups = new List<string>();

        //! The versions of all local group [Optional]
        private Dictionary<string, string> _groupVer = new Dictionary<string, string>();

        //! The version of local engine
        private string _engineVer = "";

        //! Full assets list
        private Dictionary<string, Asset> _assets = new Dictionary<string, Asset>();

        //! All search paths
        private List<string> _searchPaths = new List<string>();
        private string localPath;

        Node _json;

        FileUtils _fileUtils;


        //protected function
        /** @brief Constructor for Manifest class
     * @param manifestUrl Url of the local manifest
     */
        public Manifest(string manifestUrl = "")
        {
            _fileUtils = FileUtils.getInstance();
            if (!string.IsNullOrEmpty(manifestUrl))
            {
                parse(manifestUrl);
            }
        }

        /** @brief Load the json file into local json object
         * @param url Url of the json file
         */
        public void loadJson(string url)
        {
            clear();
            string content = "";
            if (_fileUtils.isFileExist(url))
            {
                localPath = url;
                content = _fileUtils.getString(url);
                if (string.IsNullOrEmpty(content))
                {
                    AssetsManager.LogError("Fail to read file -> " + url);
                    return;
                }
                _json = JSON.parse(content);
                if (_json == null)
                {
                    AssetsManager.LogError("Fail to parse Json -> " + url);
                    throw new Exception("Fail to parse Json -> " + url);
                }
            }
        }

        /** @brief Parse the version file information into this manifest
         * @param versionUrl Url of the local version file
         */
        public void parseVersion(string versionUrl)
        {
            loadJson(versionUrl);

            if (_json.IsTable())
            {
                loadVersion(_json);
            }
        }

        /** @brief Parse the manifest file information into this manifest
         * @param manifestUrl Url of the local manifest
         */
        public void parse(string manifestUrl)
        {
            loadJson(manifestUrl);
            if (_json != null && _json.IsTable())
            {
                _manifestRoot = System.IO.Path.GetDirectoryName(manifestUrl) + "/"; ;
                loadManifest(_json);
            }
        }
        private string lastVersive
        {
            get
            {
                List<string> bGroups = getGroups();
                if (bGroups.Count > 0)
                {
                    return bGroups[bGroups.Count - 1];
                }
                return _version;
            }
        }
        /** @brief Check whether the version of this manifest equals to another.
         * @param b   The other manifest
         */
        public bool versionEquals(Manifest b)
        {
            if (_version != b.getVersion())
            {
                if (Convert.ToInt32(_version) >= Convert.ToInt32(b.getVersion()))
                    return true;

                return false;
            }
            // Check group versions
            if(Convert.ToInt32(lastVersive) >= Convert.ToInt32(b.lastVersive))
                return true;
            List<string> bGroups = b.getGroups();
            Dictionary<string, string> bGroupVer = b.getGroupVerions();
            if (bGroups.Count != _groups.Count) return false;
            for (int i = 0; i < _groups.Count; i++)
            {
                string gid = _groups[i];
                if (gid != bGroups[i]) return false;
                if (_groupVer.ContainsKey(gid) && bGroupVer.ContainsKey(gid) && _groupVer[gid] != bGroupVer[gid]) return false;
            }
            return true;
        }

        /// <summary>
        /// 对比更改
        /// </summary>
        /// <param name="b"></param>
        /// <returns></returns>
        public Dictionary<string, AssetDiff> genDiff(Manifest b)
        {
            Dictionary<string, AssetDiff> diff_map = new Dictionary<string, AssetDiff>();
            Dictionary<string, Asset> bAssets = b.getAssets();
            List<string> group = b.getGroups();
            Dictionary<string, bool> diff_version = new Dictionary<string, bool>();
            int lenB = group.Count;
            int last = Convert.ToInt32(lastVersive);
            for (int i = 0; i < lenB; i++)
            {
                var v = group[i];
                if (_groups.Contains(v))
                    continue;
                if (diff_version.ContainsKey(v))
                    continue;
                if (last < Convert.ToInt32(v))
                    diff_version.Add(v, true);
                else
                {
                    b.SetGroupDownLoadState(v, DownloadState.SUCCESSED);
                }
            }
            string key = "";
            Asset valueA, valueB;
            foreach (var it in _assets)
            {
                key = it.Key;
                valueA = it.Value;
                if (string.IsNullOrEmpty(valueA.group))
                    continue;
                if (!diff_version.ContainsKey(valueA.group))
                    continue;
                if (!bAssets.ContainsKey(key))
                {
                    AssetDiff diff;
                    diff.asset = valueA;
                    diff.type = DiffType.DELETED;
                    diff_map.Add(key, diff);
                    continue;
                }

                valueB = bAssets[key];
                if (valueA.md5 != valueB.md5)
                {
                    AssetDiff diff;
                    diff.asset = valueB;
                    diff.type = DiffType.MODIFIED;
                    diff_map.Add(key, diff);
                }

            }
            Dictionary<string, bool> md5 = new Dictionary<string, bool>();
            foreach (var it in bAssets)
            {
                key = it.Key;
                valueB = it.Value;
                if (string.IsNullOrEmpty(valueB.group))
                    continue;
                if (!diff_version.ContainsKey(valueB.group))
                    continue;
                if (FileUtils.getInstance().isFileExist(_manifestRoot + valueB.path))
                {
                    var m_Md5 = FileUtils.getInstance().GetMd5(_manifestRoot + valueB.path);
                    if (m_Md5 == valueB.md5)
                    {
                        AssetsManager.Log(valueB.path);
                        continue;
                    }
                }
                if (!_assets.ContainsKey(key))
                {
                    if (md5.ContainsKey(valueB.md5))
                    {
                        continue;
                    }
                    AssetDiff diff;
                    diff.asset = valueB;
                    diff.type = DiffType.ADDED;
                    diff_map.Add(key, diff);
                    md5.Add(valueB.md5, true);
                }
            }

            return diff_map;
        }



        /// <summary>
        /// 生成恢复下载资源列表
        /// </summary>
        /// <param name="units"></param>
        public void genResumeAssetsList(ref Dictionary<string, Downloader.DownloadUnit> units)
        {
            genResumeAssetsList(ref units);
        }
        internal void genResumeAssetsList(ref Dictionary<string, Downloader.DownloadUnit> units, ref List<string> _compressedFiles)
        {
            foreach (var it in _assets)
            {
                Asset asset = it.Value;

                if (asset.downloadState != DownloadState.SUCCESSED)
                {
                    Downloader.DownloadUnit unit;
                    unit.customId = it.Key;
                    unit.srcUrl = _packageUrl + asset.path;
                    unit.storagePath = _manifestRoot + asset.path;
                    if (asset.downloadState == DownloadState.DOWNLOADING)
                    {
                        unit.resumeDownload = true;
                    }
                    else
                    {
                        unit.resumeDownload = false;
                    }
                    units.Add(unit.customId, unit);
                }
                else if (asset.downloadState == DownloadState.SUCCESSED)
                {
                    if (!_compressedFiles.Contains(_manifestRoot + asset.path) && FileUtils.getInstance().isFileExist(_manifestRoot + asset.path))
                    {
                        _compressedFiles.Add(_manifestRoot + asset.path);
                    }
                }
            }
        }
        /** @brief Prepend all search paths to the FileUtils.
         */
        public void prependSearchPaths()
        {
            var utils = FileUtils.getInstance();
            utils.addSearchPath(_manifestRoot, true);
            List<string> searchPaths = FileUtils.getInstance().getSearchPaths();

            for (int i = (int)_searchPaths.Count - 1; i >= 0; i--)
            {
                string path = _searchPaths[i];
                if (path.Length > 0 && path[path.Length - 1] != '/')
                    path += "/";
                path = _manifestRoot + path;
                searchPaths.Insert(0, path);
            }
            utils.setSearchPaths(searchPaths);
            for (int i = 0; i < _groups.Count; i++)
            {
                utils.addSearchPath(_manifestRoot + _groups[i], true);
            }
            AssetBundles.AssetBundleLoader.inited = false;
        }

        public void loadVersion(Node json)
        {
            if (json[KEY_MANIFEST_URL])
            {
                //版本文件URL
                _remoteManifestUrl = json[KEY_MANIFEST_URL].ToString();
            }

            if (json[KEY_VERSION_URL])
            {
                //版本号URL
                _remoteVersionUrl = json[KEY_VERSION_URL].ToString();
            }

            if (json[KEY_VERSION])
            {
                //版本号
                _version = json[KEY_VERSION].ToString();
            }

            if (json[KEY_GROUP_VERSIONS])
            {
                Node groupVers = json[KEY_GROUP_VERSIONS];
                if (groupVers.IsTable())
                {
                    Dictionary<string, Node> dict = (Dictionary<string, Node>)groupVers;
                    foreach (var it in dict)
                    {
                        string group = it.Key;
                        Node val = it.Value;
                        string version = "0";
                        if (val.IsString())
                        {
                            version = val.ToString();
                        }
                        _groups.Add(group);
                        if (_groupVer.ContainsKey(group))
                        {
                            _groupVer[group] = version;
                        }
                        else
                        {
                            _groupVer.Add(group, version);
                        }
                    }
                }
                _groups.Sort((a, b) =>
                {
                    return Convert.ToInt32(a) > Convert.ToInt32(b) ? 1 : -1;
                });
            }

            if (json[KEY_ENGINE_VERSION])
            {
                _engineVer = json[KEY_ENGINE_VERSION].ToString();
            }

            _versionLoaded = true;


        }

        public void loadManifest(Node json)
        {
            loadVersion(json);
            if (json[KEY_PACKAGE_URL])
            {
                _packageUrl = json[KEY_PACKAGE_URL].ToString();

                if (_packageUrl.Length > 0 && _packageUrl[_packageUrl.Length - 1] != '/')
                {
                    _packageUrl += "/";
                }
                
            }

            // Retrieve all assets
            if (json[KEY_ASSETS])
            {
                Node assets = json[KEY_ASSETS];
                if (assets.IsTable())
                {
                    Dictionary<string, Node> dict = (Dictionary<string, Node>)assets;
                    foreach (var itr in dict)
                    {
                        string key = itr.Key;
                        Asset asset = parseAsset(key, itr.Value);
                        _assets.Add(key, asset);
                    }
                }
            }

            // Retrieve all search paths
            if (json[KEY_SEARCH_PATHS])
            {
                Node paths = json[KEY_SEARCH_PATHS];
                if (paths.IsArray())
                {
                    for (int i = 0; i < paths.Count; i++)
                    {
                        if (paths[i].IsString())
                        {
                            _searchPaths.Add(paths[i].ToString());
                        }
                    }
                }
            }

            _loaded = true;

        }

        public void saveToFile(string filepath)
        {
            string json = JSON.stringify(_json);
            FileUtils.getInstance().writeFile(filepath, json);
        }

        public Asset parseAsset(string path, Node json)
        {
            Asset asset = new Asset();
            if (json[KEY_MD5])
                asset.md5 = json[KEY_MD5].ToString();
            if (json[KEY_PATH])
                asset.path = json[KEY_PATH].ToString();
            if (json[KEY_COMPRESSED])
                asset.compressed = (bool)json[KEY_COMPRESSED];
            if (json[KEY_SIZE])
                asset.size = (double)json[KEY_SIZE];
            else
                asset.compressed = false;
            if (json[KEY_DOWNLOAD_STATE])
                asset.downloadState = (DownloadState)((int)json[KEY_DOWNLOAD_STATE]);
            else
                asset.downloadState = DownloadState.UNSTARTED;
            if (json[KEY_GROUP])
                asset.group = json[KEY_GROUP].ToString();
            return asset;
        }

        public void clear()
        {
            if (_versionLoaded || _loaded)
            {
                _groups.Clear();
                _groupVer.Clear();

                _remoteManifestUrl = "";
                _remoteVersionUrl = "";
                _version = "";
                _engineVer = "";

                _versionLoaded = false;
            }

            if (_loaded)
            {
                _assets.Clear();
                _searchPaths.Clear();
                _loaded = false;
            }
        }

        /** @brief Gets all groups.
         */
        public List<string> getGroups()
        {
            return _groups;
        }

        /** @brief Gets all groups version.
         */
        public Dictionary<string, string> getGroupVerions()
        {
            return _groupVer;
        }

        /** @brief Gets version for the given group.
         * @param group   Key of the requested group
         */
        public string getGroupVersion(string group)
        {
            if (_groupVer.ContainsKey(group))
                return _groupVer[group];
            return "";
        }

        /** @brief Gets assets.
         */
        public Dictionary<string, Asset> getAssets()
        {

            return _assets;
        }

        public void SetGroupDownLoadState(string group, DownloadState state)
        {
            foreach(var asset in _assets)
            {
                if(asset.Value.group == group)
                {
                    setAssetDownloadState(asset.Key, state);
                }
            }
        }

        /// <summary>
        /// brief Set the download state for an asset
        /// </summary>
        /// <param name="key">Key of the asset to set</param>
        /// <param name="state">The current download state of the asset</param>
        public void setAssetDownloadState(string key, DownloadState state)
        {
            if (!_assets.ContainsKey(key))
            {
                return;
            }
            Asset asset = _assets[key];
            asset.downloadState = state;
            if (!_json.IsTable()) return;
            var save = false;
            if (_json[KEY_ASSETS])
            {
                if (!_json[KEY_ASSETS].IsTable())
                    return;
                Dictionary<string, Node> assets = (Dictionary<string, Node>)_json[KEY_ASSETS];
                foreach (var i in assets)
                {
                    string jkey = i.Key;
                    if (jkey != key) continue;
                    Node entry = i.Value;
                    //更新下载状态
                    entry[KEY_DOWNLOAD_STATE] = Node.NewInt((int)state);
                    save = true;
                }
            }

            if (save)
            {
                saveToFile(localPath);
            }
        }



        //public function
        //! The type of difference
        public enum DiffType
        {
            ADDED,
            DELETED,
            MODIFIED
        };

        public enum DownloadState
        {
            UNSTARTED,
            DOWNLOADING,
            SUCCESSED
        };

        /// <summary>
        /// Asset object
        /// </summary>
        public struct Asset
        {
            public string md5;
            public string path;
            public bool compressed;
            public double size;
            public string group;
            public DownloadState downloadState;
        };

        /// <summary>
        ///  Object indicate the difference between two Assets
        /// </summary>
        public struct AssetDiff
        {
            public Asset asset;
            public DiffType type;
        };


        /// <summary>
        /// brief Check whether the version informations have been fully loaded
        /// </summary>
        /// <returns></returns>
        public bool isVersionLoaded()
        {
            return _versionLoaded;
        }

        /// <summary>
        /// brief Check whether the manifest have been fully loaded
        /// </summary>
        /// <returns></returns>
        public bool isLoaded()
        {
            return _loaded;
        }

        /// <summary>
        /// brief Gets remote package url.
        /// </summary>
        /// <returns></returns>
        public string getPackageUrl()
        {
            return _packageUrl;
        }

        /// <summary>
        /// brief Gets remote manifest file url.
        /// </summary>
        /// <returns></returns>
        public string getManifestFileUrl()
        {
            return _remoteManifestUrl;
        }

        /// <summary>
        /// brief Gets remote version file url.
        /// </summary>
        /// <returns></returns>
        public string getVersionFileUrl()
        {
            return _remoteVersionUrl;
        }

        /// <summary>
        /// manifest 版本号
        /// </summary>
        /// <returns></returns>
        public string getVersion()
        {
            return _version;
        }

        /// <summary>
        /// 引擎版本
        /// </summary>
        /// <returns></returns>
        public string getEngineVersion()
        {
            return _engineVer;
        }

        /** @brief Get the search paths list related to the Manifest.
         */
        public List<string> getSearchPaths()
        {
            List<string> searchPaths = new List<string>();
            searchPaths.Add(_manifestRoot);

            for (int i = (int)_searchPaths.Count - 1; i >= 0; i--)
            {
                string path = _searchPaths[i];
                if (path.Length > 0 && path[path.Length - 1] != '/')
                    path += ("/");
                path = _manifestRoot + path;
                searchPaths.Add(path);
            }
            return searchPaths;
        }

    }
}

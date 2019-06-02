using System.Collections.Generic;
using System.Linq;

namespace AssetsCtrl
{
    public struct ProgressItem
    {
        public float percent;//单个文件下载百分比
        public float percentByFile;//多文件下载百分比
        public string assetId;//下载分组
        public int totalToDownload;//下载的文件数
        public double totalDownloaded;//已下载
        public double totalSize;//下载总数
    }
    public class AssetsManager
    {
        public enum State
        {
            UNCHECKED,
            PREDOWNLOAD_VERSION,
            DOWNLOADING_VERSION,
            VERSION_LOADED,
            PREDOWNLOAD_MANIFEST,
            DOWNLOADING_MANIFEST,
            MANIFEST_LOADED,
            NEED_UPDATE,
            UPDATING,
            UP_TO_DATE,
            FAIL_TO_UPDATE
        };

        public enum EventCode
        {
            /// <summary>
            /// 本地没有project.manifest文件
            /// </summary>
            ERROR_NO_LOCAL_MANIFEST,

            /// <summary>
            /// 无法下载配置文件
            /// </summary>
            ERROR_DOWNLOAD_MANIFEST,

            /// <summary>
            /// 配置文件转换失败，不是json格式
            /// </summary>
            ERROR_PARSE_MANIFEST,

            /// <summary>
            /// 有新的版本
            /// </summary>
            NEW_VERSION_FOUND,

            /// <summary>
            /// 所以更新已下载完成，应该更新
            /// </summary>
            ALREADY_UP_TO_DATE,

            /// <summary>
            /// 更新进度
            /// </summary>
            UPDATE_PROGRESSION,

            /// <summary>
            /// 单个文件下载完成
            /// </summary>
            ASSET_UPDATED,

            /// <summary>
            /// 更新失败
            /// </summary>
            ERROR_UPDATING,

            /// <summary>
            /// 更新完成
            /// </summary>
            UPDATE_FINISHED,

            /// <summary>
            /// 更新失败，列表失败的文件列表，尝试重试下载。
            /// </summary>
            UPDATE_FAILED,

            /// <summary>
            /// 解压失败
            /// </summary>
            ERROR_DECOMPRESS,

            // 跳过
            Skip
        };

        public delegate void EventAssetsManager(AssetsManager am, EventCode code, ProgressItem item, string message);

        public const string VERSION_FILENAME = "version.manifest";
        public const string TEMP_MANIFEST_FILENAME = "project.manifest.temp";
        public const string MANIFEST_FILENAME = "project.manifest";
        public const string VERSION_ID = "@version";
        public const string MANIFEST_ID = "@manifest";
        public const string BATCH_UPDATE_ID = "@batch_update";
        public EventAssetsManager onCallBack = null;
        const int BUFFER_SIZE = 8192;
        const int MAX_FILENAME = 512;
        const int DEFAULT_CONNECTION_TIMEOUT = 8;
        private FileUtils _fileUtils;
        private ProgressItem _progressItem = new ProgressItem();
        public AssetsManager(string manifestUrl, string storagePath, EventAssetsManager cb)
        {
            onCallBack = cb;

            _manifestUrl = manifestUrl;
            _updateState = State.UNCHECKED;
            _fileUtils = FileUtils.getInstance();
            _downloadUnits = new Dictionary<string, Downloader.DownloadUnit>();
            _failedUnits = new Dictionary<string, Downloader.DownloadUnit>();
            _downloader = new Downloader();
            _downloader.setConnectionTimeout(DEFAULT_CONNECTION_TIMEOUT);
            _downloader._onError = onError;
            _downloader._onProgress = onProgress;
            _downloader._onSuccess = onSuccess;

            setStoragePath(storagePath);

            _cacheVersionPath = _storagePath + VERSION_FILENAME;
            _cacheManifestPath = _storagePath + MANIFEST_FILENAME;
            _tempManifestPath = _storagePath + TEMP_MANIFEST_FILENAME;
            initManifests(manifestUrl);
        }





        /** @brief  Check out if there is a new version of manifest.
         *          You may use this method before updating, then let user determine whether
         *          he wants to update resources.
         */
        public void checkUpdate()
        {
            if (!_inited)
            {
                Log("AssetsManagerEx : Manifests uninited.\n");
                dispatchUpdateEvent(EventCode.ERROR_NO_LOCAL_MANIFEST);
                return;
            }
            if (!_localManifest.isLoaded())
            {
                Log("AssetsManagerEx : No local manifest file found error.\n");
                dispatchUpdateEvent(EventCode.ERROR_NO_LOCAL_MANIFEST);
                return;
            }

            switch (_updateState)
            {
                case State.UNCHECKED:
                case State.PREDOWNLOAD_VERSION:
                    {
                        downloadVersion();
                    }
                    break;
                case State.UP_TO_DATE:
                    {
                        dispatchUpdateEvent(EventCode.ALREADY_UP_TO_DATE);
                    }
                    break;
                case State.FAIL_TO_UPDATE:
                case State.NEED_UPDATE:
                    {
                        dispatchUpdateEvent(EventCode.NEW_VERSION_FOUND);
                    }
                    break;
                default:
                    break;
            }
        }

        /** @brief Update with the current local manifest.
         */
        public void update()
        {
            if (!_inited)
            {
                Log("AssetsManagerEx : Manifests uninited.\n");
                dispatchUpdateEvent(EventCode.ERROR_NO_LOCAL_MANIFEST);
                return;
            }
            if (!_localManifest.isLoaded())
            {
                Log("AssetsManagerEx : No local manifest file found error.\n");
                dispatchUpdateEvent(EventCode.ERROR_NO_LOCAL_MANIFEST);
                return;
            }

            _waitToUpdate = true;

            switch (_updateState)
            {
                case State.UNCHECKED:
                    {
                        _updateState = State.PREDOWNLOAD_VERSION;
                        downloadVersion();
                    }
                    break;
                case State.PREDOWNLOAD_VERSION:
                    {
                        downloadVersion();
                    }
                    break;
                case State.VERSION_LOADED:
                    {
                        parseVersion();
                    }
                    break;
                case State.PREDOWNLOAD_MANIFEST:
                    {
                        downloadManifest();
                    }
                    break;
                case State.MANIFEST_LOADED:
                    {
                        parseManifest();
                    }
                    break;
                case State.FAIL_TO_UPDATE:
                case State.NEED_UPDATE:
                    {
                        // Manifest not loaded yet
                        if (!_remoteManifest.isLoaded())
                        {
                            _waitToUpdate = true;
                            _updateState = State.PREDOWNLOAD_MANIFEST;
                            downloadManifest();
                        }
                        else
                        {
                            startUpdate();
                        }
                    }
                    break;
                case State.UP_TO_DATE:
                case State.UPDATING:
                    _waitToUpdate = false;
                    break;
                default:
                    break;
            }
        }

        /** @brief Reupdate all failed assets under the current AssetsManagerEx context
         */
        public void downloadFailedAssets()
        {
            Log(string.Format("AssetsManager : Start update {0} failed assets.\n", _failedUnits));
            updateAssets(_failedUnits);
        }

        /** @brief Gets the current update state.
         */
        public State getState()
        {
            return _updateState;
        }

        /** @brief Gets storage path.
         */
        public string getStoragePath()
        {
            return _storagePath;
        }

        /** @brief Function for retrieve the local manifest object
         */
        public Manifest getLocalManifest()
        {
            return _localManifest;
        }

        /** @brief Function for retrieve the remote manifest object
         */
        public Manifest getRemoteManifest()
        {
            return _remoteManifest;
        }

        string basename(string path)
        {
            int found = path.LastIndexOf("/\\");

            if (-1 != found)
            {
                return path.Substring(0, found);
            }
            else
            {
                return path;
            }
        }

        protected string get(string key)
        {
            if (_assets.ContainsKey(key))
            {
                return _storagePath + _assets[key].path;
            }
            return "";
        }

        protected void initManifests(string manifestUrl)
        {
            _inited = true;
            _localManifest = new Manifest();
            loadLocalManifest(manifestUrl);
            _tempManifest = new Manifest();
            _tempManifest.parse(_tempManifestPath);
            if (!_tempManifest.isLoaded())
            {
                _fileUtils.removeFile(_tempManifestPath);
            }
            _remoteManifest = new Manifest();
        }

        protected void loadLocalManifest(string manifestUrl)
        {
            Manifest cachedManifest = null;
            // Find the cached manifest file
            if (_fileUtils.isFileExist(_cacheManifestPath))
            {
                cachedManifest = new Manifest();
                if (cachedManifest != null)
                {
                    cachedManifest.parse(_cacheManifestPath);
                    if (!cachedManifest.isLoaded())
                    {
                        _fileUtils.removeFile(_cacheManifestPath);
                        cachedManifest = null;
                    }
                }
            }

            // Load local manifest in app package
            _localManifest.parse(_manifestUrl);
            if (_localManifest.isLoaded())
            {
                // Compare with cached manifest to determine which one to use
                if (cachedManifest != null)
                {
                    if (string.Compare(_localManifest.getVersion(), cachedManifest.getVersion()) > 0)
                    {
                        // Recreate storage, to empty the content
                        _fileUtils.removeDirectory(_storagePath);
                        _fileUtils.createDirectory(_storagePath);
                        cachedManifest = null;
                    }
                    else
                    {
                        _localManifest = null;
                        _localManifest = cachedManifest;
                    }
                }
                prepareLocalManifest();
            }

            // Fail to load local manifest
            if (!_localManifest.isLoaded())
            {
                UnityEngine.Debug.Log("AssetsManagerEx : No local manifest file found error.\n");
                dispatchUpdateEvent(EventCode.ERROR_NO_LOCAL_MANIFEST);
            }
        }

        protected void prepareLocalManifest()
        {
            // An alias to assets
            _assets = _localManifest.getAssets();

            // Add search paths
            _localManifest.prependSearchPaths();
        }

        protected void setStoragePath(string storagePath)
        {
            _storagePath = storagePath;
            adjustPath(ref _storagePath);
            _fileUtils.createDirectory(_storagePath);
#if UNITY_IOS
            UnityEngine.iOS.Device.SetNoBackupFlag(_storagePath);
#endif
        }

        protected void adjustPath(ref string path)
        {
            if (!string.IsNullOrEmpty(path) && path[path.Length - 1] != System.IO.Path.DirectorySeparatorChar)
            {
                path += "/";
            }
        }

        protected void dispatchUpdateEvent(EventCode code, string message = "", string assetId = "")
        {
            if (onCallBack != null)
            {
                _progressItem.assetId = assetId;
                _progressItem.totalToDownload = _totalToDownload;
                _progressItem.percent = _percent;
                _progressItem.percentByFile = _percentByFile;
                _progressItem.totalDownloaded = _totalDownloaded;
                _progressItem.totalSize = _totalSize;
                onCallBack(this, code, _progressItem, message);
            }
        }

        protected void downloadVersion()
        {
            if (_updateState > State.PREDOWNLOAD_VERSION)
                return;

            string versionUrl = _localManifest.getVersionFileUrl();

            if (!string.IsNullOrEmpty(versionUrl))
            {
                _updateState = State.DOWNLOADING_VERSION;
                // Download version file asynchronously
                _downloader.downloadAsync(versionUrl + "?pf=" + FileUtils.getInstance().getRuntimePlatform()+"&cl="+GlobalVar.dataEyeChannelID, _cacheVersionPath, VERSION_ID);
            }
            // No version file found
            else
            {
                Log("AssetsManagerEx : No version file found, step skipped\n");
                _updateState = State.PREDOWNLOAD_MANIFEST;
                downloadManifest();
            }
        }
        protected void parseVersion()
        {
            if (_updateState != State.VERSION_LOADED)
                return;

            _remoteManifest.parseVersion(_cacheVersionPath);

            if (!_remoteManifest.isVersionLoaded())
            {
                Log("AssetsManagerEx : Fail to parse version file, step skipped\n");
                _updateState = State.PREDOWNLOAD_MANIFEST;
                downloadManifest();
            }
            else
            {
                if (_localManifest.versionEquals(_remoteManifest))
                {
                    _updateState = State.UP_TO_DATE;
                    dispatchUpdateEvent(EventCode.ALREADY_UP_TO_DATE);
                }
                else
                {
                    _updateState = State.NEED_UPDATE;
                    dispatchUpdateEvent(EventCode.NEW_VERSION_FOUND);

                    // Wait to update so continue the process
                    if (_waitToUpdate)
                    {
                        _updateState = State.PREDOWNLOAD_MANIFEST;
                        downloadManifest();
                    }
                }
            }
        }
        protected void downloadManifest()
        {
            if (_updateState != State.PREDOWNLOAD_MANIFEST)
                return;

            string manifestUrl = _localManifest.getManifestFileUrl();
            if (!string.IsNullOrEmpty(manifestUrl))
            {
                _updateState = State.DOWNLOADING_MANIFEST;
                // Download version file asynchronously
                _downloader.downloadAsync(manifestUrl + "?pf=" + FileUtils.getInstance().getRuntimePlatform(), _tempManifestPath, MANIFEST_ID);
            }
            // No manifest file found
            else
            {
                Log("AssetsManagerEx : No manifest file found, check update failed\n");
                dispatchUpdateEvent(EventCode.ERROR_DOWNLOAD_MANIFEST);
                _updateState = State.UNCHECKED;
            }
        }
        protected void parseManifest()
        {
            if (_updateState != State.MANIFEST_LOADED)
                return;

            _remoteManifest.parse(_tempManifestPath);

            if (!_remoteManifest.isLoaded())
            {
                Log("AssetsManagerEx : Error parsing manifest file\n");
                dispatchUpdateEvent(EventCode.ERROR_PARSE_MANIFEST);
                _updateState = State.UNCHECKED;
            }
            else
            {
                if (_localManifest.versionEquals(_remoteManifest))
                {
                    _updateState = State.UP_TO_DATE;
                    dispatchUpdateEvent(EventCode.ALREADY_UP_TO_DATE);
                }
                else
                {
                    _updateState = State.NEED_UPDATE;
                    dispatchUpdateEvent(EventCode.NEW_VERSION_FOUND);

                    if (_waitToUpdate)
                    {
                        startUpdate();
                    }
                }
            }
        }
        protected void startUpdate()
        {
            if (_updateState != State.NEED_UPDATE)
                return;

            _updateState = State.UPDATING;
            // Clean up before update
            _failedUnits.Clear();
            _downloadUnits.Clear();
            _compressedFiles.Clear();
            _totalWaitToDownload = _totalToDownload = 0;
            _percent = _percentByFile = 0;
            _sizeCollected = 0;
            _totalSize = 0;
            _downloadedSize.Clear();
            _totalEnabled = false;

            // Temporary manifest exists, resuming previous download
            if (_tempManifest.isLoaded() && _tempManifest.versionEquals(_remoteManifest))
            {
                _tempManifest.genResumeAssetsList(ref _downloadUnits, ref _compressedFiles);

                _totalWaitToDownload = _totalToDownload = _downloadUnits.Count;
                _downloader.batchDownloadAsync(_downloadUnits, BATCH_UPDATE_ID);

                string msg = string.Format("Resuming from previous unfinished update, {0} files remains to be finished.", _totalToDownload);
                dispatchUpdateEvent(EventCode.UPDATE_PROGRESSION, "", msg);
            }
            // Check difference
            else
            {
                // Temporary manifest not exists or out of date,
                // it will be used to register the download states of each asset,
                // in this case, it equals remote manifest.
                _tempManifest = null;
                _tempManifest = _remoteManifest;

                Dictionary<string, Manifest.AssetDiff> diff_map = _localManifest.genDiff(_remoteManifest);
                if (diff_map.Count == 0)
                {
                    updateSucceed();
                }
                else
                {
                    // Generate download units for all assets that need to be updated or added
                    string packageUrl = _remoteManifest.getPackageUrl();
                    foreach (var it in diff_map)
                    {
                        Manifest.AssetDiff diff = it.Value;

                        if (diff.type == Manifest.DiffType.DELETED)
                        {
                            _fileUtils.removeFile(_storagePath + diff.asset.path);
                        }
                        else
                        {
                            string path = diff.asset.path;
                            // Create path
                            _fileUtils.createDirectory(_storagePath + System.IO.Path.GetDirectoryName(path));
                            Downloader.DownloadUnit unit;
                            unit.customId = it.Key;
                            unit.srcUrl = packageUrl + path;
                            unit.storagePath = _storagePath + path;
                            unit.resumeDownload = false;
                            _downloadUnits.Add(unit.customId, unit);
                            if (!_downloadedSize.ContainsKey(it.Key))
                            {
                                _downloadedSize.Add(it.Key, 0);
                                _totalSize += diff.asset.size;
                                _totalEnabled = true;
                            }
                        }
                    }
                    // Set other assets' downloadState to SUCCESSED
                    var assets = _tempManifest.getAssets();
                    foreach (var it in assets)
                    {
                        var val = it.Value;
                        if (val.downloadState == Manifest.DownloadState.SUCCESSED)
                        {
                            if (FileUtils.getInstance().isFileExist(_storagePath + val.path))
                            {
                                _compressedFiles.Add(_storagePath + val.path);
                            }
                        }
                    }

                    _totalWaitToDownload = _totalToDownload = _downloadUnits.Count;
                    _downloader.batchDownloadAsync(_downloadUnits, BATCH_UPDATE_ID);

                    string msg = string.Format("Start to update {0} files from remote package.", _totalToDownload);
                    dispatchUpdateEvent(EventCode.UPDATE_PROGRESSION, "", msg);
                }
            }

            _waitToUpdate = false;
        }
        protected void updateSucceed()
        {
            // Every thing is correctly downloaded, do the following
            // 1. rename temporary manifest to valid manifest
            _fileUtils.renameFile(_storagePath, TEMP_MANIFEST_FILENAME, MANIFEST_FILENAME);
            // 2. swap the localManifest
            if (_localManifest != null)
                _localManifest = null;
            _localManifest = _remoteManifest;
            _remoteManifest = null;
            // 3. make local manifest take effect
            prepareLocalManifest();
            // 4. decompress all compressed files
            decompressDownloadedZip();
            // 5. Set update state
            _updateState = State.UP_TO_DATE;
            // 6. Notify finished event
            FileUtils.getInstance().ClearCache();
            dispatchUpdateEvent(EventCode.UPDATE_FINISHED);
        }
        /// <summary>
        /// 解压
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        protected bool decompress(string zip)
        {
            return _fileUtils.unZip(zip);
        }
        protected void decompressDownloadedZip()
        {
            for (int i = 0; i < _compressedFiles.Count; i++)
            {
                string zipfile = _compressedFiles[i];
                if (!decompress(zipfile))
                {
                    dispatchUpdateEvent(EventCode.ERROR_DECOMPRESS, "", "Unable to decompress file " + zipfile);
                }
                _fileUtils.removeFile(zipfile);
            }
            _compressedFiles.Clear();
        }

        /** @brief Update a list of assets under the current AssetsManagerEx context
         */
        protected void updateAssets(Dictionary<string, Downloader.DownloadUnit> assets)
        {
            if (!_inited)
            {
                Log("AssetsManager : Manifests uninited.\n");
                dispatchUpdateEvent(EventCode.ERROR_NO_LOCAL_MANIFEST);
                return;
            }

            if (_updateState != State.UPDATING && _localManifest.isLoaded() && _remoteManifest.isLoaded())
            {
                int size = assets.Count;
                if (size > 0)
                {
                    _updateState = State.UPDATING;
                    _downloadUnits.Clear();
                    _downloadUnits = assets;
                    _downloader.batchDownloadAsync(_downloadUnits, BATCH_UPDATE_ID);
                }
                else if (size == 0 && _totalWaitToDownload == 0)
                {
                    updateSucceed();
                }
            }
        }

        /** @brief Retrieve all failed assets during the last update
         */
        protected Dictionary<string, Downloader.DownloadUnit> getFailedAssets() { return _failedUnits; }

        /** @brief Function for destorying the downloaded version file and manifest file
         */
        protected void destroyDownloadedVersion()
        {
            _fileUtils.removeFile(_cacheVersionPath);
            _fileUtils.removeFile(_cacheManifestPath);
        }

        /** @brief  Call back function for error handling,
         the error will then be reported to user's listener registed in addUpdateEventListener
         @param error   The error object contains ErrorCode, message, asset url, asset key
         @warning AssetsManagerEx internal use only
         * @js NA
         * @lua NA
         */
        protected virtual void onError(Downloader.Error error)
        {
            // Skip version error occured
            if (error.customId == VERSION_ID)
            {
                Log("AssetsManager Fail to download version file, step skipped\n");
                _updateState = State.PREDOWNLOAD_MANIFEST;
                downloadManifest();
            }
            else if (error.customId == MANIFEST_ID)
            {
                dispatchUpdateEvent(EventCode.ERROR_DOWNLOAD_MANIFEST, error.customId, error.message);
            }
            else
            {
                if (error.code == Downloader.ErrorCode.Skip) 
                {
                    dispatchUpdateEvent(EventCode.Skip, error.customId, error.message);
                    return;
                }
                bool unitIt = _downloadUnits.ContainsKey(error.customId);
                // Found unit and add it to failed units
                if (unitIt)
                {
                    Downloader.DownloadUnit unit = _downloadUnits[error.customId];
                    _failedUnits.Add(unit.customId, unit);
                }
                dispatchUpdateEvent(EventCode.ERROR_UPDATING, error.customId, error.message);
            }
        }

        /** @brief  Call back function for recording downloading percent of the current asset,
         the progression will then be reported to user's listener registed in addUpdateProgressEventListener
         @param total       Total size to download for this asset
         @param downloaded  Total size already downloaded for this asset
         @param url         The url of this asset
         @param customId    The key of this asset
         @warning AssetsManagerEx internal use only
         * @js NA
         * @lua NA
         */
        protected virtual void onProgress(double total, double downloaded, string url, string customId)
        {
            if (customId == VERSION_ID || customId == MANIFEST_ID)
            {
                _percent = (float)(100 * downloaded / total);
                // Notify progression event
                dispatchUpdateEvent(EventCode.UPDATE_PROGRESSION, customId);
                return;
            }
            else
            {
                // Calcul total downloaded
                bool found = false;
                double totalDownloaded = 0;
                string[] keys = _downloadedSize.Keys.ToArray<string>();
                foreach (var key in keys)
                {
                    var val = _downloadedSize[key];
                    if (key == customId)
                    {
                        _downloadedSize[key] = downloaded;
                        val = downloaded;
                        found = true;
                    }
                    totalDownloaded += val;
                }
                // Collect information if not registed
                if (!found)
                {
                    // Set download state to DOWNLOADING, this will run only once in the download process
                    _tempManifest.setAssetDownloadState(customId, Manifest.DownloadState.DOWNLOADING);
                    // Register the download size information
                    _downloadedSize.Add(customId, downloaded);
                    _totalSize += total;
                    _sizeCollected++;
                    // All collected, enable total size
                    if (_sizeCollected == _totalToDownload)
                    {
                        _totalEnabled = true;
                    }
                }
                _totalDownloaded = totalDownloaded;
                if (_totalEnabled && _updateState == State.UPDATING)
                {
                    float currentPercent = (float)(100 * totalDownloaded / _totalSize);
                    // Notify at integer level change
                    if ((int)currentPercent != (int)_percent)
                    {
                        _percent = currentPercent;
                        // Notify progression event
                        dispatchUpdateEvent(EventCode.UPDATE_PROGRESSION, customId);
                    }
                }
            }
        }

        /** @brief  Call back function for success of the current asset
         the success event will then be send to user's listener registed in addUpdateEventListener
         @param srcUrl      The url of this asset
         @param customId    The key of this asset
         @warning AssetsManagerEx internal use only
         * @js NA
         * @lua NA
         */
        protected virtual void onSuccess(string srcUrl, string storagePath, string customId)
        {
            if (customId == VERSION_ID)
            {
                _updateState = State.VERSION_LOADED;
                parseVersion();
            }
            else if (customId == MANIFEST_ID)
            {
                _updateState = State.MANIFEST_LOADED;
                parseManifest();
            }
            else if (customId == BATCH_UPDATE_ID)
            {
                // Finished with error check
                if (_failedUnits.Count > 0 || _totalWaitToDownload > 0)
                {
                    // Save current download manifest information for resuming
                    _tempManifest.saveToFile(_tempManifestPath);

                    decompressDownloadedZip();

                    _updateState = State.FAIL_TO_UPDATE;
                    dispatchUpdateEvent(EventCode.UPDATE_FAILED);
                }
                else
                {
                    updateSucceed();
                }
            }
            else
            {
                Dictionary<string, Manifest.Asset> assets = _remoteManifest.getAssets();
                if (assets.ContainsKey(customId))
                {
                    var assetIt = assets[customId];
                    _tempManifest.setAssetDownloadState(customId, Manifest.DownloadState.SUCCESSED);

                    // Add file to need decompress list
                    if (assetIt.compressed)
                    {
                        _compressedFiles.Add(storagePath);
                    }
                }

                if (_downloadUnits.ContainsKey(customId))
                {
                    // Reduce count only when unit found in _downloadUnits
                    _totalWaitToDownload--;

                    _percentByFile = 100 * (float)(_totalToDownload - _totalWaitToDownload) / _totalToDownload;
                    // Notify progression event
                    dispatchUpdateEvent(EventCode.UPDATE_PROGRESSION, "");
                }

                // Notify asset updated event
                dispatchUpdateEvent(EventCode.ASSET_UPDATED, customId);

                if (_failedUnits.ContainsKey(customId))
                {
                    _failedUnits.Remove(customId);
                }

            }
        }



        //! Reference to the global event dispatcher
        //EventDispatcher *_eventDispatcher;
        //! Reference to the global file utils
        //FileUtils *_fileUtils;

        //! State of update
        State _updateState;

        //! Downloader
        Downloader _downloader;

        //! The reference to the local assets
        Dictionary<string, Manifest.Asset> _assets = new Dictionary<string, Manifest.Asset>();

        //! The path to store downloaded resources.
        string _storagePath;

        //! The local path of cached version file
        string _cacheVersionPath;

        //! The local path of cached manifest file
        string _cacheManifestPath;

        //! The local path of cached temporary manifest file
        string _tempManifestPath;

        //! The path of local manifest file
        string _manifestUrl;

        //! Local manifest
        Manifest _localManifest;

        //! Local temporary manifest for download resuming
        Manifest _tempManifest;

        //! Remote manifest
        Manifest _remoteManifest;

        //! Whether user have requested to update
        bool _waitToUpdate;

        //! All assets unit to download
        Dictionary<string, Downloader.DownloadUnit> _downloadUnits = new Dictionary<string, Downloader.DownloadUnit>();

        //! All failed units
        Dictionary<string, Downloader.DownloadUnit> _failedUnits = new Dictionary<string, Downloader.DownloadUnit>();

        //! All files to be decompressed
        List<string> _compressedFiles = new List<string>();

        //! Download percent
        float _percent = 0;

        //! Download percent by file
        float _percentByFile = 0;

        //! Indicate whether the total size should be enabled
        bool _totalEnabled;

        //! Indicate the number of file whose total size have been collected
        int _sizeCollected = 0;

        //! Total file size need to be downloaded (sum of all file)
        double _totalSize = 0;
        double _totalDownloaded = 0;
        //! Downloaded size for each file
        Dictionary<string, double> _downloadedSize = new Dictionary<string, double>();

        //! Total number of assets to download
        int _totalToDownload = 0;
        //! Total number of assets still waiting to be downloaded
        int _totalWaitToDownload = 0;

        //! Marker for whether the assets manager is inited
        bool _inited;

        static public void Log(string log)
        {
            MyDebug.Log(log);
        }
        public static void LogError(string log)
        {
            MyDebug.LogError(log);
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BestHTTP;
using System.IO;
namespace AssetsCtrl
{
    public class Downloader
    {
        public int _connectionTimeout;

        public ErrorCallback _onError;

        public ProgressCallback _onProgress;

        public SuccessCallback _onSuccess;
        int _totalWaitToDownload = 0;
        const string TEMP = ".temp";
        public struct DownloadUnit
        {
            public string srcUrl;
            public string storagePath;
            public string customId;
            public bool resumeDownload;
        };
        public enum ErrorCode
        {
            /// <summary>
            /// Initial status of a request
            /// </summary>
            Initial,

            /// <summary>
            /// Waiting in a queue to be processed
            /// </summary>
            Queued,

            /// <summary>
            /// Processing of the request started
            /// </summary>
            Processing,

            /// <summary>
            /// The request finished without problem.
            /// </summary>
            Finished,

            /// <summary>
            /// The request finished with an unexpected error. The request's Exception property may contain more info about the error.
            /// </summary>
            Error,

            /// <summary>
            /// The request aborted by the client.
            /// </summary>
            Aborted,

            /// <summary>
            /// Ceonnecting to the server is timed out.
            /// </summary>
            ConnectionTimedOut,

            /// <summary>
            /// The request didn't finished in the given time.
            /// </summary>
            TimedOut,

            //
            Skip,
        };
        public struct Error
        {
            public ErrorCode code;
            public string message;
            public string customId;
            public string url;
        };

        public struct ProgressData
        {
            public Downloader downloader;
            public string customId;
            public string url;
            public string path;
            public string name;
            public double downloaded;
            public double totalToDownload;
        };

        public delegate void ErrorCallback(Error err);
        public delegate void ProgressCallback(double total, double downloaded, string url, string customId);
        public delegate void SuccessCallback(string srcUrl, string storagePath, string customId);
        public void setConnectionTimeout(int timeout)
        {
            if (timeout >= 0)
                _connectionTimeout = timeout;
        }

        private void download()
        {

        }


        public void downloadAsync(string srcUrl, string storagePath, string customId)
        {
            ProgressData data = new ProgressData();
            prepareDownload(srcUrl, storagePath, customId, ref data);
            HTTPRequest request = BestHTTP.HTTPManager.SendRequest(srcUrl, onCallBack);
            request.Tag = data;
        }

        private void prepareDownload(string srcUrl, string storagePath, string customId, ref ProgressData data)
        {
            data.downloader = this;
            data.customId = customId;
            data.url = srcUrl;
            data.name = Path.GetFileName(storagePath);
            data.path = Path.GetDirectoryName(storagePath) + "/";
        }
        private void doActionWhenDownLoaded(ProgressData data, HTTPResponse response)
        {
            if (data.customId == AssetsManager.VERSION_ID || data.customId == AssetsManager.MANIFEST_ID)
            {
                string json = response.DataAsText;
                FileUtils.getInstance().writeFile(data.path + data.name, json);
                _onSuccess.Invoke(data.url, data.path + data.name, data.customId);
            }
            else
            {
                doActionProcessing(data, response.GetStreamedFragments());
                if (response.IsStreamingFinished)
                {
                    FileUtils.getInstance().renameFile(data.path, data.name + TEMP, data.name);
                    _onSuccess.Invoke(data.url, data.path + data.name, data.customId);
                    _totalWaitToDownload--;
                    if (_totalWaitToDownload == 0)
                    {
                        _onSuccess.Invoke("", "", AssetsManager.BATCH_UPDATE_ID);
                    }
                }
            }
        }
        private void doActionProcessing(ProgressData data, List<byte[]> fragments)
        {
            if (fragments == null || fragments.Count == 0) return;
            FileUtils.getInstance().writeFileStream(data.path, data.name + TEMP, fragments);
        }
        private void onCallBack(HTTPRequest request, HTTPResponse response)
        {
            if (response != null)
            {
                Error err;
                string ret = response.DataAsText;
                if (ret.Equals("success")) 
                {
                    // 不更新
                    err = new Error();
                    err.customId = "";
                    err.code = ErrorCode.Skip;
                    err.message = "Processing the request Skip!";
                    _onError.Invoke(err);
                    return;
                }
                ProgressData data = (ProgressData)request.Tag;
                switch (request.State)
                {
                    case HTTPRequestStates.Processing:
                        doActionProcessing(data, response.GetStreamedFragments());
                        break;
                    case HTTPRequestStates.Finished:
                        if (response.IsSuccess)
                        {
                            doActionWhenDownLoaded(data, response);
                        }
                        else
                        {
                            string status = string.Format("Request finished Successfully, but the server sent an error. Status Code: {0}-{1} Message: {2}",
                                                        response.StatusCode,
                                                        response.Message,
                                                        response.DataAsText);
                            err = new Error();
                            err.customId = data.customId;
                            err.code = ErrorCode.Error;
                            err.message = status;
                            _onError.Invoke(err);
                        }

                        break;
                    // The request finished with an unexpected error. The request's Exception property may contain more info about the error.
                    case HTTPRequestStates.Error:
                        err = new Error();
                        err.customId = data.customId;
                        err.code = ErrorCode.Error;
                        err.message = "Request Finished with Error! " + (request.Exception != null ? (request.Exception.Message + "\n" + request.Exception.StackTrace) : "No Exception");
                        _onError.Invoke(err);
                        request = null;
                        break;

                    // The request aborted, initiated by the user.
                    case HTTPRequestStates.Aborted:
                        err = new Error();
                        err.customId = data.customId;
                        err.code = ErrorCode.Aborted;
                        err.message = "Request Aborted!";
                        _onError.Invoke(err);
                        break;

                    // Ceonnecting to the server is timed out.
                    case HTTPRequestStates.ConnectionTimedOut:
                        err = new Error();
                        err.customId = data.customId;
                        err.code = ErrorCode.ConnectionTimedOut;
                        err.message = "Connection Timed Out!";
                        _onError.Invoke(err);
                        break;

                    // The request didn't finished in the given time.
                    case HTTPRequestStates.TimedOut:
                        err = new Error();
                        err.customId = data.customId;
                        err.code = ErrorCode.TimedOut;
                        err.message = "Processing the request Timed Out!";
                        _onError.Invoke(err);
                        break;
                }

            }
            else
            {
                Error err = new Error();
                err.code = ErrorCode.Error;
                err.customId = "err";
                err.message = "Request fail! ";
                _onError.Invoke(err);
            }
        }

        private void groupBatchDownload(DownloadUnit unit, string batchId)
        {
            ProgressData d = new ProgressData();
            prepareDownload(unit.srcUrl, unit.storagePath, unit.customId, ref d);
            HTTPRequest _request = new HTTPRequest(new Uri(unit.srcUrl), onCallBack);
            _request.Tag = d;
            _request.DisableCache = true;
            if (batchId == AssetsManager.BATCH_UPDATE_ID)
            {
                _request.UseStreaming = true;
                _request.OnProgress = OnDownloadProgress;
            }
            else
            {
                _request.UseStreaming = false;
            }
            HTTPManager.SendRequest(_request);

        }

        private void OnDownloadProgress(HTTPRequest request, int downloaded, int length)
        {
            ProgressData data = (ProgressData)request.Tag;
            _onProgress.Invoke(length, downloaded, data.url, data.customId);
        }

        /// <summary>
        /// 批量下载
        /// </summary>
        /// <param name="units"></param>
        /// <param name="batchId"></param>
        public void batchDownloadAsync(Dictionary<string, DownloadUnit> units, string batchId)
        {
            _totalWaitToDownload = units.Count;
            foreach (var item in units)
            {
                DownloadUnit unit = item.Value;
                groupBatchDownload(unit, batchId);
            }
        }
    }
}

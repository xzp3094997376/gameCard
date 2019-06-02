module("UpdateAssets", package.seeall)

local manifestFile = "project.manifest"
local projectPath = ""
local checkInstallPack = ""
local filePath = ""
local storagePath = ""
local fileUtils = ""
local OnProgress = nil
local OnFinished = nil
local asset = nil
local failCount = 0

function init(path)
    projectPath = Application.persistentDataPath .. "/" .. path .. "/" .. manifestFile
    checkInstallPack = Application.persistentDataPath .. "/" .. manifestFile
    filePath = Application.streamingAssetsPath .. "/" .. manifestFile
    storagePath = Application.persistentDataPath
    fileUtils = FileUtils.getInstance()
end

function checkUpdate(path, onProgress, onFinished)
    init(path)
    OnProgress = onProgress
    OnFinished = onFinished
    storagePath = storagePath .. "/" .. path
    failCount = 0
    if fileUtils:isFileExist(checkInstallPack) then
        if fileUtils:EqualsMd5(filePath, checkInstallPack) then
            updateAssets()
            return
        else
            print("......")
            fileUtils:clearPath(Application.persistentDataPath)
        end
    else
        fileUtils:clearPath(Application.persistentDataPath)
    end

    local result = ""
    result = fileUtils:getString(filePath)
    fileUtils:writeFile(projectPath, result)
    fileUtils:writeFile(checkInstallPack, result)
    updateAssets()
end

function onCallBack(am, code, item, message)
    local assetId = item.assetId
    if code == AssetsManager.EventCode.ERROR_NO_LOCAL_MANIFEST then
        print("没有发现本地的manifest文件,跳过更新")
        OnProgress(am, code, item, message)
    elseif code == AssetsManager.EventCode.UPDATE_PROGRESSION then
        OnProgress(am, code, item, message)
    elseif code == AssetsManager.EventCode.ERROR_DOWNLOAD_MANIFEST or code == AssetsManager.EventCode.ERROR_PARSE_MANIFEST then
        print("Fail to download manifest file, update skipped.")
        OnProgress(am, code, item, message)
    elseif code == AssetsManager.EventCode.ALREADY_UP_TO_DATE or code == AssetsManager.EventCode.UPDATE_FINISHED then
        print("Update finished. " .. message);
        OnFinished()
    elseif code == AssetsManager.EventCode.UPDATE_FAILED then
        --更新失败，重试
        failCount = failCount + 1
        if failCount < 5 then
            am:downloadFailedAssets()
        else
            print("重试更新失败，跳过更新");
            OnProgress(am, code, item, message)
        end
    elseif code == AssetsManager.EventCode.ERROR_UPDATING then
        print("Asset " .. assetId .. " : " .. message)
        OnProgress(am, code, item, message)
    elseif code == AssetsManager.EventCode.ERROR_DECOMPRESS then
        print("Asset " .. assetId .. " : " .. message)
        OnProgress(am, code, item, message)
    elseif code == AssetsManager.EventCode.NEW_VERSION_FOUND then
        OnProgress(am, code, item, message)
    elseif code ==  11 then --AssetsManager.EventCode.Skip 
        OnProgress(am, code, item, message)
    end
end

function updateAssets()
    asset = AssetsManager(projectPath, storagePath, onCallBack)
    -- asset:checkUpdate()
    asset:update()
end
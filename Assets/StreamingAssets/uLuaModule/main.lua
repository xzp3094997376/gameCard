import "UnityEngine"
import "AssetsCtrl"
_TableReader = TableReader
TableReader = TableReader.Instance
UIMrg = UIMrg.Ins
ApiLoading = ApiLoading.getInstance()
__Network = Network
Network = Network.Instance
TempPath = "bleach"

deviceUniqueIdentifier = SystemInfo.deviceUniqueIdentifier --唯一的设备标识。
deviceName = SystemInfo.deviceName --用户指定的设备名称。
deviceModel = SystemInfo.deviceModel --设备型号。
operatingSystem = SystemInfo.operatingSystem --操作系统名称和版本。


function reload_files(files)
    package.loaded[files] = nil
    require(files)
end

function reStart()
    reload_files "uLuaModule/app"
    App.Start()
end

function main()
    FileUtils.getInstance():addSearchPath(Application.persistentDataPath .. "/" .. TempPath, true)
    reStart()
    App.Run()
end

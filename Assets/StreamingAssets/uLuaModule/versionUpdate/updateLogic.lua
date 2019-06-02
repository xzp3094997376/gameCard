module("updateLogic", package.seeall)
local slider = nil
local txt_desc = nil
local txt_version = nil
local TXT_DOWNLOADING = TextMap.GetValue("Text1490")
local TempPath = "bleach"
function find(parent,path)
	local go = parent.transform:Find(path)
	if go then 
		return go
	end
	return nil
end

function findType(parent,path,tp)
	local go = find(parent,path)
	if go then 
		return go:GetComponent(tp)
	end
end

function loadUI()
	-- if SettingConfig.getDataEyeChannel() == "ios" then
	-- 	load_login_new_for_ios()
	-- else
		load_login_new_for_other()
		-- load_login_new_for_ios()
	-- end

	local go = ClientTool.load("Prefabs/publicPrefabs/updateLayer")
	UIMrg:pushWindow(go)
	go.transform.localScale = Vector3(1,1,1)
	slider = findType(go,"img_bg/slider",UISlider)
	slider.gameObject:SetActive(false)
	txt_desc = findType(go,"img_bg/text_bg/txt_desc",UILabel)
	
end

function load_login_new_for_other( )
	local go = ClientTool.load("load-icon/Login_new")
    UIMrg:replaceObjectWithName("Login_new", go, true);
    go.transform.localScale = Vector3.one
end

function load_login_new_for_ios()
	local go = ClientTool.load("load-icon/Login_ios")
          UIMrg:replaceObjectWithName("Login_ios", go, true);
          go.transform.localScale = Vector3.one
end

function setVersion()
	txt_version = GameObject.Find("fps_Label")
	if txt_version then 
		txt_version = txt_version:GetComponent(UILabel)
		txt_version.text = TextMap.GetValue("Text1491") .. SettingConfig.getVersion()
	end
end
function setDesc(text)
	if txt_desc then 
		txt_desc.text = text
	end
end

function getText(text,...)
	local args = {...}
	for i = 1, #args do 
		local arg = args[i]
		if arg then 
			text = string.gsub(text,"{".. (i-1) .."}",arg)
		end
	end
	return text
end

function formatByte(num)
	return string.format("%.1f", (num/1024/1024)) .. "MB"
end

function update()
	loadUI()
	setVersion()
	setDesc(TextMap.GetValue("Text1492"))
	SettingConfig.Init()
	if GlobalVar.isNeedUpdate == false then 
		setDesc(TextMap.GetValue("Text1493"))
		-- slider.value = 1
		Init()
		return
	end 

    UpdateAssets.checkUpdate(TempPath,function(am,code,item,message)
    	local percent,percentByFile,assetId = item.percent,item.percentByFile,item.assetId
    	local totalToDownload = item.totalToDownload --下载的文件数
    	local totalDownloaded = item.totalDownloaded --已下载
    	local totalSize = item.totalSize --下载总数
		local msg = ""
		-- if assetId == AssetsManager.VERSION_ID then
		-- elseif assetId == AssetsManager.MANIFEST_ID then
		-- else
		-- end
		local ret = true
		local btnName = TextMap.GetValue("Text351")
		if code == AssetsManager.EventCode.ERROR_NO_LOCAL_MANIFEST then
			-- msg = "没有发现本地的project.manifest文件"
			setDesc(TextMap.GetValue("Text1493"))
			slider.value = 1
			Init()
			return
		elseif code == AssetsManager.EventCode.ERROR_PARSE_MANIFEST then
			-- msg = "配置文件格式错误!"
			setDesc(TextMap.GetValue("Text1493"))
			slider.value = 1
			Init()
			return
		elseif code == AssetsManager.EventCode.ERROR_DOWNLOAD_MANIFEST then
			-- msg = "下载配置文件失败!"
			setDesc(TextMap.GetValue("Text1493"))
			slider.value = 1
			Init()
			return
		elseif code == AssetsManager.EventCode.UPDATE_FAILED then
						--更新失败,重试
			msg = TextMap.GetValue("Text1494")
			ret = function()
							-- ChatController.Quit()
				ClientTool.onQuit()
			end
			btnName = TextMap.GetValue("Text1495")
						
		elseif code == AssetsManager.EventCode.ERROR_UPDATING then
			-- msg = "连接更新服务器失败!"
			if ClientTool.Platform ~= "ios" then
				DialogMrg.ShowDialog(TextMap.GetValue("Text_1_2909"),function()
					UpdateAssets.updateAssets()
				end, function()
					DialogMrg.ShowDialog(TextMap.GetValue("Text_1_2910"),function()
						UpdateAssets.updateAssets()
					end,function()
						setDesc(TextMap.GetValue("Text1493"))
						slider.value = 1
						Init()
					end, nil, nil, TextMap.GetValue("Text_1_2911"), TextMap.GetValue("Text_1_2912"))
				end, nil, nil, TextMap.GetValue("Text_1_2911"), TextMap.GetValue("Text_1_2912"))
			else 
				setDesc(TextMap.GetValue("Text1493"))
				slider.value = 1
				Init()				
			end
		elseif code == AssetsManager.EventCode.ERROR_DECOMPRESS then
			-- msg = "解压文件失败!"
			setDesc(TextMap.GetValue("Text1493"))
			slider.value = 1
			Init()
			return
		elseif code == AssetsManager.EventCode.NEW_VERSION_FOUND then
			--发现新版本
			print("发现新版本")
			-- am:update()
			return
		elseif code == 11 then --AssetsManager.EventCode.Skip 
			slider.value = 1
			Init()
			return 
		end
		if msg ~= "" then 
			DialogMrg.ShowDialog(msg,function()
				if ret ~= true then 
					am:downloadFailedAssets()
					return
				end
			ChatController.Quit()
			ClientTool.onQuit()
			end,ret,TextMap.GetValue("Text1496"),nil,btnName,TextMap.GetValue("Text1266"))
			return
		end
		local p = percent
		local desc = getText(TXT_DOWNLOADING,formatByte(totalDownloaded),formatByte(totalSize),math.floor(p))
		setDesc(desc)
		if slider.gameObject.activeInHierarchy == false then 
			slider.gameObject:SetActive(true)
		end 
		slider.value = p/100;
		if p/100 >= 1 then 
			setDesc(TextMap.GetValue("Text1497"))
		end

	end,function()
		setDesc(TextMap.GetValue("Text1493"))
		slider.value = 1
		Init()
		
	end)
end

function LoadTableComplete()
	Messenger.RemoveListener("LoadTableComplete",LoadTableComplete)
	UIMrg:popWindow()
	App.loadScript()
	
end



--初始化配置
function Init()
	Localization.language = "CN"

	LuaHelper.Clear()
	reStart()
	setVersion()
	App.StartDataEye()
	_TableReader.Destroy()
	Messenger.AddListener("LoadTableComplete",LoadTableComplete)
	ConfigManager.getInstance():readTableFileList()
end


using System.IO;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

//配置文件管理器
public class ConfigManager
{
    private static ConfigManager instance;
    public bool inited = false;
    public ConfigManager()
    {
        
    }

    private string[] files;
    private int fileCount;

    public void readTableFileList()
    {
        string filePath = UrlManager.GetConfigPath("files.data");//配置文件路径
        byte[] strBytes = FileUtils.getInstance().getBytes(filePath);
        loadTable(unGZip(strBytes));
    }
    /// 读取二级制文件
    public void loadTable(string str)
    {
        string content = str;
        content = content.Replace("monster,", "");
        content = content.Replace("monsterTeam,", "");
        files = content.Split(',');
        fileCount = files.Length;
        string[] strs = new string[fileCount];
        //for (int i = 0; i < fileCount; i++)
        //{
        //    byte[] tempByte = FileUtils.getInstance().getBytes(UrlManager.GetConfigPath(files[i] + ".data"));
        //    string json = unGZip(tempByte);
        //    strs[i] = json;
        //}
        TableReader.Instance.Load(strs, files);
    }
    public string getTableJson(string sTableName)
    {
        string path = UrlManager.GetConfigPath(sTableName + ".data");
        if (!File.Exists(path)) return null;
        byte[] tempByte = File.ReadAllBytes(path);
        string json = unGZip(tempByte);
        if (string.IsNullOrEmpty(json)) return null;
        if (json[0] != '{')
        {
            json = json.Substring(1);
        }
        return json;
    }
    public void onLoadComplete()
    {
        //MsgUtil.callFunc("configComplete", null);
        Messenger.Broadcast("LoadTableComplete");
        inited = true;
    }


    /// <summary>
    /// 解压配置文件
    /// </summary>
    /// <param name="info"></param>
    /// <returns></returns>
    private string unGZip(byte[] info)
    {
        string result = moduleOpen(info);
        return result;
    }
    public static string moduleOpen(byte[] bs)
    {
        byte[] keys = System.Text.Encoding.UTF8.GetBytes("moduleName");
        for (int i = 0; i < bs.Length; i++)
        {
            bs[i] = (byte)(bs[i] ^ keys[i % keys.Length]);
        }
        return System.Text.Encoding.UTF8.GetString(bs);
    }
    public static byte[] ecodeLuaFile(byte[] bs)
    {
        byte[] keys = System.Text.Encoding.UTF8.GetBytes("moduleName");
        for (int i = 0; i < bs.Length; i++)
        {
            bs[i] = (byte)(bs[i] ^ keys[i % keys.Length]);
        }
        return bs;
    }
    public static ConfigManager getInstance()
    {
        if (instance == null)

            instance = new ConfigManager();
        return instance;
    }
}

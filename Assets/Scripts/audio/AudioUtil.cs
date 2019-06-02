using SimpleJson;

public class AudioUtil
{
    /// <summary>
    /// 根据id获取表结构
    /// </summary>
    /// <param name="musicID">音频ID</param>
    /// <returns></returns>
    public static JsonObject getLevelByID(int musicID)
    {
        JsonObject obj = TableReader.Instance.TableRowByID("audio", musicID);
       if(obj!=null)
       {
           return obj;
       }
       return null;
    }

    /// <summary>
    /// 根据key获取音频等级
    /// </summary>
    /// <param name="musicID">音频ID</param>
    /// <returns></returns>
    public static JsonObject getLevelByUniKey(string musicName)
    {
        JsonObject obj = TableReader.Instance.TableRowByUnique("audio", "name", musicName);
        if (obj != null)
        {
            return obj;
        }
        return null;
    }

}

using UnityEngine;
using System.Collections.Generic;
using SimpleJson;
using System;

/// <summary>
/// 音乐管理
/// </summary>
public class MusicManager
{
    //背景音乐
    public static Dictionary<string, AudioItem> dic = new Dictionary<string, AudioItem>();
    //特效音乐
    public static Dictionary<string, AudioItem> soundDic = new Dictionary<string, AudioItem>();

    public static List<bool> musicMuteBool = new List<bool>() { PlayerPrefs.GetString("music") == "0", PlayerPrefs.GetString("sound") == "0" };
    public static AudioItem clearItem;
    private static string currentLoadMusic = ""; //防止玩家连续点击

    public static void stopAllMusic()
    {
        foreach (string name2 in soundDic.Keys) //清除音效
        {
            QualityManager.RecycleAssetBundle(soundDic[name2].data.path);
            if (soundDic[name2])
            {
                GameObject.Destroy(soundDic[name2]);
                soundDic[name2].dispose();
            }
        }
        soundDic.Clear();

        foreach (string name in dic.Keys) //清楚背景音乐
        {
            QualityManager.RecycleAssetBundle(dic[name].data.path);
            if (dic[name])
            {
                dic[name].dispose();
                GameObject.Destroy(dic[name]);
            }
            
        }
        dic.Clear();
        Resources.UnloadUnusedAssets();
    }

    /// <summary>
    /// 关闭某种音效
    /// </summary>
    /// <param name="level">1为背景音乐  2 为其他</param>
    /// <param name="bol">true 静音 false 打开音乐</param>
    public static void setMuteLevel(int level, bool bol)
    {
        musicMuteBool[level - 1] = bol;
        if (bol)
        {
            if (level == 1) //关闭背景音乐
            {
                foreach (string name in dic.Keys)
                {
                    QualityManager.RecycleAssetBundle(UrlManager.GetAudioPath(dic[name].data.path));
                    dic[name].dispose();
                    GameObject.Destroy(dic[name]);
                }
                dic.Clear();
            }
            else //关闭音效
            {
                foreach (string name2 in soundDic.Keys) 
                {
                    QualityManager.RecycleAssetBundle(UrlManager.GetAudioPath(soundDic[name2].data.path));
                    soundDic[name2].dispose();
                    GameObject.Destroy(soundDic[name2]);
                }
                soundDic.Clear();
            }
            Resources.UnloadUnusedAssets();
        }
        else
        {
            if (level == 1)
            {
                openMusicBG();
            }
        }
    }

    /// <summary>
    /// 播放音乐(根据音乐表内的id)
    /// </summary>
    /// <param name="id"></param>
    public static void playByID(int id)
    {
        if (id == 0)
            return;
        JsonObject obj = AudioUtil.getLevelByID(id);
        if (obj == null)
        {
            MyDebug.Log("音乐配置文件内不存在id为：" + id + "的行");
            return;
        }
        if(obj["path"].ToString() == "")
        {
            MyDebug.Log("音乐文件没配-->id:" + id);
            return;
        }
        string names = obj["name"].ToString();
        if (musicMuteBool[Convert.ToInt32(obj["level"]) - 1])
            return;
        if (currentLoadMusic == names)
            return;
        if (dic.ContainsKey(names))
        {
            readyToPlay(dic[names]);
            return;
        }
        if (soundDic.ContainsKey(names))
        {
            readyToPlay(soundDic[names]);
            return;
        }
        AudioVo vo = new AudioVo();
        vo.fileName = obj["name"].ToString();
        vo.level = Convert.ToInt32(obj["level"]);
        currentLoadMusic = vo.fileName;
        vo.isloop = Convert.ToInt32(obj["loop"]);
        vo.path = UrlManager.GetAudioPath(obj["path"].ToString());
        LoadManager.getInstance().LoadAudio(vo.path, onLoad, vo);
    }

    /// <summary>
    /// 播放音乐(根据音乐表内的id)
    /// </summary>
    /// <param name="id"></param>
    public static void play(AudioVo _vo)
    {
        if (_vo == null)
            return;
        if (musicMuteBool[_vo.level - 1])
            return;
        if (currentLoadMusic == _vo.fileName)
            return;
        if (dic.ContainsKey(_vo.fileName))
        {
            readyToPlay(dic[_vo.fileName]);
            return;
        }
        if (soundDic.ContainsKey(_vo.fileName))
        {
            readyToPlay(soundDic[_vo.fileName]);
            return;
        }
        currentLoadMusic = _vo.fileName;
        _vo.path = UrlManager.GetAudioPath("audios/" + _vo.fileName);
        LoadManager.getInstance().LoadAudio(_vo.path, onLoad, _vo);
    }

    /// <summary>
    /// 播放音乐（根据场景名或者技能名等）
    /// </summary>
    /// <param name="names"></param>
    public static void play(string names)
    {
        if (names == "")
            return;
        AudioVo vo = new AudioVo();
        vo.fileName = names;
        JsonObject obj = AudioUtil.getLevelByUniKey(names);
        if (obj == null)
        {
            vo.level = 2;
            vo.isloop = 1;
            vo.path = "audios/" + names;
        }
        else
        {
            vo.level = Convert.ToInt32(obj["level"]);
            vo.isloop = Convert.ToInt32(obj["loop"]);
            vo.path = obj["path"].ToString();
        }
        if (musicMuteBool[vo.level - 1])
            return;
        if (currentLoadMusic == vo.fileName)
            return;
        if (dic.ContainsKey(names)) //已经存在字典内的数据，直接读取字典
        {
            readyToPlay(dic[names]);
            return;
        }
        if (soundDic.ContainsKey(names))
        {
            readyToPlay(soundDic[names]);
            return;
        }
        currentLoadMusic = names;
        vo.path = UrlManager.GetAudioPath(vo.path);
        LoadManager.getInstance().LoadAudio(vo.path, onLoad, vo);
    }

    private static void onLoad(LoadParam param)
    {
        currentLoadMusic = "";
        AudioVo vo = (param.param as AudioVo);
        AudioItem src = GetAudioItem((param.param as AudioVo).fileName);
        src.loop = vo.isloop == -1;
        src.data = vo;
        src.clip = param.audioClip;
        if (src.data.level == 1)
            dic[src.data.fileName] = src;
        else
            soundDic[src.data.fileName] = src;
        readyToPlay(src);
    }

    private static AudioItem GetAudioItem(string name)
    {
        Camera tempCamera = getMusicAudioCamera();
        AudioItem temp = tempCamera.gameObject.AddComponent<AudioItem>();
        temp.volume = 0.6f;
        return temp;
    }

    public static Camera getMusicAudioCamera()
    {
        Camera[] camreas = Camera.allCameras;
        Camera returnCam = null;
        int count = camreas.Length;
        for (int i = 0; i < count; i++)
        {
            if (camreas[i].transform.parent != null && camreas[i].transform.parent.name == "GameManager")
            {
                returnCam = camreas[i];
            }
            else
            {
                AudioListener templisten = camreas[i].GetComponent<AudioListener>();
                if (templisten != null)
                {
                    GameObject.Destroy(templisten);
                }
            }
        }
        return returnCam;
    }

    private static void readyToPlay(AudioItem src)
    {
        src.loop = src.loop;
        src.mute = false;
        src.play();
        if (dic.ContainsKey(src.data.fileName))   //场景音乐
            src.countUpTo(0.3f);
        else
            src.countUpTo(0.6f);
    }

    /// <summary>
    /// 暂时静音
    /// </summary>
    public static void muteMusicBG(bool bol)
    {
        if (PlayerPrefs.GetString("music") == "1")
        {
            foreach (string name in dic.Keys)
            {
                if (dic[name] != null)
                {
                    if (bol)
                    {
                        dic[name].fadeOut();
                    }
                    else
                    {
                        dic[name].fadeIn();
                    }
                }
            }
        }
    }

    public static void openMusicBG()
    {
        if (dic.Keys.Count == 0)
        {
            playByID(1);
            return;
        }
        foreach (string name in dic.Keys)
        {
            if (dic[name] != null)
            {
                dic[name].fadeIn();
            }
        }
    }
}

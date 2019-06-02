using UnityEngine;
using System.Collections;
using SLua;
[CustomLuaClass]
public class SettingManager : MonoBehaviour {

    public GameObject music;   //音乐开关
    public GameObject musicOn;   //音乐开关
    public GameObject sound;   //音效开关
    public GameObject soundOn;   //音效开关
    public GameObject strength;   //领取体力开关
    public GameObject strengthOn;   //领取体力开关
    public GameObject refreshStore;   // 刷新商店
    public GameObject refreshStoreOn;   // 刷新商店
    public GameObject energyFull;          //精力恢复满
    public GameObject energyFullOn;          //精力恢复满
    public GameObject skillFull;             //技能点恢复满
    public GameObject skillFullOn;             //技能点恢复满
    public GameObject arena;            // 竞技场被攻击
    public GameObject arenaOn;            // 竞技场被攻击
    string setStr = "";

    
   
    //获取用户的上次设置并进行相应的修改
    public void getLastState()
    {
        //获取本地持久化设置信息
        string musicState = PlayerPrefs.GetString("music"); //获取音效设置
        string soundState = PlayerPrefs.GetString("sound");
        string strengthState = PlayerPrefs.GetString("strength");
        string refreshStoreState = PlayerPrefs.GetString("refreshStore");
        string energyFullState = PlayerPrefs.GetString("energy");
        string skillFullState = PlayerPrefs.GetString("skill");
        string arenaState = PlayerPrefs.GetString("arena");
        setIsActive(music, musicOn, musicState == "1");
        setIsActive(sound, soundOn, soundState == "1");
        setIsActive(strength, strengthOn, strengthState == "1");
        setIsActive(refreshStore, refreshStoreOn, refreshStoreState == "1");
        setIsActive(energyFull, energyFullOn, energyFullState == "1");
        setIsActive(skillFull, skillFullOn, skillFullState == "1");
        setIsActive(arena, arenaOn, arenaState == "1");
    }
    public void changeSprite(GameObject on, GameObject off)
    {
        bool isOpen = on.activeSelf;
        int musicLevel = off.name == "btn_musicOn" ? 1 : 2;
        if (isOpen)
        {
            off.SetActive(true);
            on.SetActive(false);
            MusicManager.setMuteLevel(musicLevel, true); //关闭音乐
        }
        else
        {
            off.SetActive(false);
            on.SetActive(true);
            MusicManager.setMuteLevel(musicLevel, false); //打开音乐
        }
    }

    public void setIsActive(GameObject t, GameObject on,  bool result)
    {
        if (result == true)
        {
            t.SetActive(true);
            on.SetActive(false);
        }
        else if(result ==false)
        {
            t.SetActive(false);
            on.SetActive(true);
        }
    }

    //退出保存用户设置
    public void quitAndSaveState()
    {
        PlayerPrefs.SetString("music", music.activeSelf ? "1" : "0"); //获取音效设置
        PlayerPrefs.SetString("sound", sound.activeSelf ? "1" : "0");
        PlayerPrefs.SetString("strength", strength.activeSelf ? "1" : "0");
        PlayerPrefs.SetString("refreshStore", refreshStore.activeSelf ? "1" : "0");
        PlayerPrefs.SetString("energy", energyFull.activeSelf ? "1" : "0");
        PlayerPrefs.SetString("skill", skillFull.activeSelf ? "1" : "0");
        PlayerPrefs.SetString("arena", arena.activeSelf ? "1" : "0");
        NotificationManager.setAlarmBySet();
    }
}

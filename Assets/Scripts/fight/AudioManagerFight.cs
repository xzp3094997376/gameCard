using UnityEngine;
using System.Collections;
/// <summary>
/// 战斗音效
/// </summary>
public class AudioManagerFight : MonoBehaviour
{
    public static AudioManagerFight Inst = null;
    Hashtable m_String2Audio;

    void Start()
    {
        Inst = this;
        m_String2Audio = new Hashtable();
    }

    public void PlayMusic() 
    {
        int idx = (int)Random.Range(1, 5);
        AudioVo vo = new AudioVo();
        vo.isloop = -1;
        vo.level = 1;
        vo.fileName = "bgm_battle0" + idx;
        vo.path = "audios/" + vo.fileName;
        if (FightManager.Inst.m_IsNewBie)
            vo.fileName = TranslateScripts.Inst.AudioName;
        string musicState = PlayerPrefs.GetString("music");
        if (!FightManager.Inst.m_IsBattleEditor)
            MusicManager.play(vo);
    }

    public void Play(string clip_name)
    {
        //加速不播放一些不必要的音乐
        if(RunUI.Ins && RunUI.Ins.m_SpeedLevel > 2){
            if (clip_name.IndexOf("se_") != 0 || !clip_name.EndsWith("hit"))
                return;
        }
        //设置音效
        string soundState = PlayerPrefs.GetString("sound");

        AudioVo vo = new AudioVo();
        vo.isloop = 1;
        vo.level = 2;
        vo.path = "audios/" + vo.fileName;
        vo.fileName = clip_name;
        MusicManager.play(vo);
        
    }
}

using UnityEngine;
using System.Collections;


/// <summary>
/// 原子音频播放类
/// </summary>
public class AudioItem : MonoBehaviour
{
    public AudioItem()
    { }
    public AudioVo data;
    public AudioSource _audioSource;
    private float currentVolumn;
    private float endVolumn;
    private bool beginPlay = false;

    public AudioSource audioSource
    {
        get
        {
            if (_audioSource == null)
            {
                _audioSource = gameObject.AddComponent<AudioSource>();
            }
            return _audioSource;
        }
        set
        {
            _audioSource = value;
        }
    }

    /// <summary>
    /// 慢慢调小音量，可渐变
    /// </summary>
    /// <param name="volume">最后想要的音量大小</param>
    public void countDownTo(float volume)
    {
        clearTimeOut();
        endVolumn = volume;
        InvokeRepeating("down", 0.1f, 0.1f);
    }

    /// <summary>
    /// 慢慢增大音量
    /// </summary>
    /// <param name="volume">最后想要的音量大小</param>
    public void countUpTo(float volume)
    {
        clearTimeOut();
        mute = false;
        endVolumn = volume;
        InvokeRepeating("up", 0.1f, 0.1f);
    }

    /// <summary>
    /// 停止正在调用的协程
    /// </summary>
    public void clearTimeOut()
    {
        CancelInvoke("up");
        CancelInvoke("down");
    }

    /// <summary>
    /// 增加音量
    /// </summary>
    private void up()
    {
        currentVolumn += 0.05f;
        if (currentVolumn >= endVolumn)
        {
            clearTimeOut();
            volume = endVolumn;
            return;
        }
        volume = currentVolumn;
    }

    /// <summary>
    /// 减小音量
    /// </summary>
    private void down()
    {
        currentVolumn -= 0.05f;
        if (currentVolumn <= endVolumn)
        {
            CancelInvoke("down");
            CancelInvoke("up");
            volume = endVolumn;
            return;
        }
        volume = currentVolumn;
    }

    /// <summary>
    /// 是否正在播放
    /// </summary>
    public bool isPlaying
    {
        get
        {
            return audioSource.isPlaying;
        }
    }

    /// <summary>
    /// 是否循环播放
    /// </summary>
    public bool loop
    {
        get
        {
            return audioSource.loop;
        }
        set
        {
            audioSource.loop = value;
        }
    }

    /// <summary>
    /// 获取或者设置音频
    /// </summary>
    public AudioClip clip
    {
        get
        {
            return audioSource.clip;
        }
        set
        {
            if (value != null && value.GetType().ToString() == "UnityEngine.AudioClip")
            {
                audioSource.clip = value;
            }
        }
    }

    /// <summary>
    /// 设置音量
    /// </summary>
    public float volume
    {
        get
        {
            return audioSource.volume;
        }
        set
        {
            value = (value <= 0f ? 0f : value);
            value = (value > 1f ? 1f : value);
            audioSource.volume = value;
            currentVolumn = value;
        }
    }

    /// <summary>
    /// 缓动静音音乐
    /// </summary>
    public void fadeOut()
    {
        countDownTo(0.01f);
    }

    /// <summary>
    /// 渐变打开音乐声音
    /// </summary>
    public void fadeIn()
    {
        countUpTo(0.6f);
    }

    /// <summary>
    /// 静音
    /// </summary>
    private void muteMusic()
    {
        CancelInvoke("muteMusic");
        mute = true;
    }

    public bool mute
    {
        get
        {
            return audioSource.mute;
        }
        set
        {
            audioSource.mute = value;
        }
    }

    /// <summary>
    /// 播放音乐
    /// </summary>
    /// <param name="delay">延迟时间</param>
    public void play(ulong delay = 0)
    {
        if(clip == null)
        {
            MyDebug.Log("null....");
        }
        if (clip.length > 20) //大于20秒，一般证明是场景背景音乐
        {
            audioSource.Play();
        }
        else
        {
            audioSource.PlayOneShot(clip, 1);
        }
    }

    /// <summary>
    /// 关闭音乐
    /// </summary>
    public void Stop()
    {
        if (this!=null && audioSource)
        {
            audioSource.Stop();
        }
    }

    /// <summary>
    /// 销毁本组件以及音频
    /// </summary>
    public void dispose()
    {
        clearTimeOut();
        _audioSource.clip = null;
        data = null;
        if (_audioSource)
            GameObject.Destroy(_audioSource);
        _audioSource = null;
    }
}

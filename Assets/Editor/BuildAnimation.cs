using UnityEngine;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using UnityEditor;
using UnityEditorInternal;

public class BuildAnimation : Editor
{

    //生成出的Prefab的路径
    private static string PrefabPath = "Assets/__res/Prefabs";
    //生成出的AnimationController的路径
    //private static string AnimationControllerPath = "Assets/AnimationController";
    //生成出的Animation的路径
    private static string AnimationPath = "Assets/_res/Animation";
    //美术给的原始图片路径
    public static string ImagePath = Application.dataPath + "/__res/effect_v2";

    [MenuItem("Build/BuildAnimaiton")]
    static void BuildAniamtion()
    {
        DirectoryInfo raw = new DirectoryInfo(ImagePath);
        foreach (DirectoryInfo dictorys in raw.GetDirectories())
        {
            List<MCAnimation> mcs = new List<MCAnimation>();
            foreach (DirectoryInfo dictoryAnimations in dictorys.GetDirectories())
            {
                //每个文件夹就是一组帧动画，这里把每个文件夹下的所有图片生成出一个动画文件
                mcs.Add(BuildAnimationClip(dictoryAnimations));
            }
            //把所有的动画文件生成在一个AnimationController里
           // AnimatorController controller = BuildAnimationController(clips, dictorys.Name);
            //最后生成程序用的Prefab文件
            BuildPrefab(dictorys, mcs);
        }
    }


    static MCAnimation BuildAnimationClip(DirectoryInfo dictorys)
    {
        string animationName = dictorys.Name;
        FileInfo[] images = dictorys.GetFiles("*.png");
        MCAnimation mc = new MCAnimation();
        //curveBinding.type = typeof(SpriteRenderer);
        //curveBinding.path = "";
        //curveBinding.propertyName = "m_Sprite";
        ObjectReferenceKeyframe[] keyFrames = new ObjectReferenceKeyframe[images.Length];
        //动画长度是按秒为单位，1/10就表示1秒切10张图片，根据项目的情况可以自己调节
        float frameTime = 1 / 10f;
        for (int i = 0; i < images.Length; i++)
        {
            Sprite sprite = AssetDatabase.LoadAssetAtPath<Sprite>(DataPathToAssetPath(images[i].FullName));
            keyFrames[i] = new ObjectReferenceKeyframe();
            keyFrames[i].time = frameTime * i;
            keyFrames[i].value = sprite;
        }
        return mc;
    }

    /*
    static AnimatorController BuildAnimationController(List<AnimationClip> clips, string name)
    {
        AnimatorController animatorController = AnimatorController.CreateAnimatorControllerAtPath(AnimationControllerPath + "/" + name + ".controller");
        AnimatorControllerLayer layer = animatorController.GetLayer(0);
        UnityEditorInternal.StateMachine sm = layer.stateMachine;
        foreach (AnimationClip newClip in clips)
        {
            State state = sm.AddState(newClip.name);
            state.SetAnimationClip(newClip, layer);
            Transition trans = sm.AddAnyStateTransition(state);
            trans.RemoveCondition(0);
        }
        AssetDatabase.SaveAssets();
        return animatorController;
    }*/

    static void BuildPrefab(DirectoryInfo dictorys, List<MCAnimation> mcs)
    {
        //生成Prefab 添加一张预览用的Sprite
        FileInfo[] images = dictorys.GetFiles("*.png");

        if (images.Length < 1) {
            Debug.LogError("此文件夹里没有特效文件。 " + dictorys.ToString());
            return;
        }

        GameObject go = new GameObject();
        go.name = dictorys.Name;
        var anim = go.AddComponent<MCAnimation>();

        //SpriteRenderer spriteRender = go.AddComponent<SpriteRenderer>();
        var show = images[0];
        var sprite =  AssetDatabase.LoadAssetAtPath<Sprite>(DataPathToAssetPath(show.FullName));

        var mc = go.GetComponent<MCSprite>();
        mc.sprite2D = sprite;

        anim.offsets = new Vector2[images.Length];
        anim.frames = new Sprite[images.Length];
        for (int i = 0; i < images.Length; i++)
        {
            FileInfo info = images[i];
            var spr = AssetDatabase.LoadAssetAtPath<Sprite>(DataPathToAssetPath(info.FullName));

            anim.offsets[i] = Vector2.zero;
            anim.frames[i] = spr;
        }

        PrefabUtility.CreatePrefab(PrefabPath + "/" + go.name + ".prefab", go);
        DestroyImmediate(go);
    }


    public static string DataPathToAssetPath(string path)
    {
        if (Application.platform == RuntimePlatform.WindowsEditor)
            return path.Substring(path.IndexOf("Assets\\"));
        else
            return path.Substring(path.IndexOf("Assets/"));
    }
}
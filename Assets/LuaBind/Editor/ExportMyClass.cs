using System.Collections.Generic;
using UnityEngine;
using SLua;
public class ExportMyClass
{
    static public void OnAddCustomClass(LuaCodeGen.ExportGenericDelegate add)
    {
        add(typeof(List<string>), "ListString");
        // add your custom class here

        add(typeof(Network), null);
        add(typeof(UluaBinding), null);
        add(typeof(ApiLoading), null);
        add(typeof(UrlManager), null);
        
        add(typeof(MusicManager), null);
        add(typeof(GlobalVar), null);
        add(typeof(DataModel.MStruct), null);
        add(typeof(DataModel.MRoot), null);
        add(typeof(DataModel.MPlayer2), null);
        add(typeof(DataModel.MStructObject), null);
        add(typeof(DataEyeTool), null);
		add(typeof(UmengAnalyticsTool), null);
        add(typeof(ScrollView), null);
        add(typeof(UISpriteII), null);
        add(typeof(MoveLabel), null);
        add(typeof(MyUIButton), null);
        add(typeof(MyUIInput), null);
        add(typeof(SliderButtonChange), null);
        add(typeof(CustomSprite), null);
        add(typeof(SimpleImage), null);
        add(typeof(NunberSelect), null);
        add(typeof(RayChapter), null);
        add(typeof(UIModule), null);
        add(typeof(StarPrefabs), null);
        add(typeof(MyGrid), null);
        add(typeof(MyTable), null);
        add(typeof(OperateAlert), null);
        add(typeof(ChapterInit), null);
        add(typeof(LZScrollView), null);
        add(typeof(LZItemCell), null);
        add(typeof(LZDragComponent), null);
        add(typeof(ChapterSelect), null);
        add(typeof(DragPageComponent), null);
        add(typeof(PageView), null);
        add(typeof(BlackGo), null);
        add(typeof(GuideManager), null);
        add(typeof(UI3DModel), null);
        add(typeof(TextureCache), null);
        add(typeof(MyDebug), null);
        add(typeof(StarAnimate), null);
        add(typeof(RotateCamera), null);
        add(typeof(UluaTimer), null);
        add(typeof(UIModule), null);
        add(typeof(RichTextContent), null);
        add(typeof(WordAndNGUIPosition), null);
        add(typeof(MySpriteAnimation), null);
        add(typeof(RunUI), null);
        add(typeof(SettingManager), null);
        add(typeof(AvatarCtrl), null);
        add(typeof(BuildCtrlTarget), null);
        add(typeof(RenderQueueModifier), null);
        add(typeof(MySdk), null);
        add(typeof(ConfigManager), null);
        add(typeof(Table), null);
        add(typeof(TableReader), null);
        add(typeof(Follow3DObject), null);
        add(typeof(UIFollowTargetCtrl), null);
        add(typeof(DestroyObject), null);
        add(typeof(DragHero), null);
        add(typeof(CustomLabel), null);
        add(typeof(CustomLabel2), null);
        //add(typeof(PushManager), null);
        // add(typeof(XGLocalMessageSender), null);
        // add(typeof(XGPushConfig), null);
        // add(typeof(XGPushManager), null);

        add(typeof(AssetsCtrl.AssetsManager), null);
        add(typeof(AssetsCtrl.AssetsManager.EventCode), null);
        add(typeof(AssetsCtrl.AssetsManager.State), null);
        add(typeof(AssetsCtrl.Downloader), null);
        add(typeof(AssetsCtrl.Manifest), null);
        add(typeof(AtlasMrg), null);
        add(typeof(FontMrg), null);
        add(typeof(FileUtils), null);
        add(typeof(Messenger), null);
        add(typeof(Phalanx), null);
        
    }

    internal static void OnAddUseClassList(ref List<string> list)
    {
        List<System.Type> types = new List<System.Type>()
        {
            typeof(Object),
            typeof(GameObject),
            typeof(Transform),
            typeof(RectTransform),
            typeof(Component),
            typeof(Behaviour),
            typeof(MonoBehaviour),
            typeof(Animation),
            typeof(AnimationClip),
            typeof(AnimationClipPair),
            typeof(AnimationCurve),
            typeof(AnimationEvent),
            typeof(AnimationState),
            typeof(Animator),
            typeof(AnimatorOverrideController),
            typeof(AnimatorStateInfo),
            typeof(AnimatorTransitionInfo),
            typeof(AnimatorUtility),
            typeof(Application),
            typeof(AssetBundle),
            typeof(AssetBundleCreateRequest),
            typeof(AssetBundleRequest),
            typeof(AsyncOperation),
            typeof(AudioChorusFilter),
            typeof(AudioClip),
            typeof(AudioDistortionFilter),
            typeof(AudioEchoFilter),
            typeof(AudioHighPassFilter),
            typeof(AudioListener),
            typeof(AudioLowPassFilter),
            typeof(AudioReverbFilter),
            typeof(AudioReverbPreset),
            typeof(AudioReverbZone),
            typeof(AudioRolloffMode),
            typeof(AudioSettings),
            typeof(AudioSource),
            typeof(AudioSpeakerMode),
            typeof(AudioType),
            typeof(AudioVelocityUpdateMode),
            typeof(Bounds),
            typeof(BoxCollider),
            typeof(BoxCollider2D),
            typeof(Camera),
            typeof(CameraClearFlags),
            typeof(Canvas),
            typeof(CanvasGroup),
            typeof(CanvasRenderer),
            typeof(Collider),
            typeof(Collider2D),
            typeof(Color),
            typeof(Color32),
            typeof(ColorSpace),
            typeof(Debug),
            typeof(Event),
            typeof(EventModifiers),
            typeof(EventType),
            typeof(GL),
            typeof(Gradient),
            typeof(GradientAlphaKey),
            typeof(GradientColorKey),
            typeof(HorizontalWrapMode),
            typeof(Light),
            typeof(LightmapData),
            typeof(LightmapSettings),
            typeof(LightmapsMode),
            typeof(LightProbeGroup),
            typeof(LightProbes),
            typeof(LightRenderMode),
            typeof(LightShadows),
            typeof(LightType),
            typeof(LineRenderer),
            typeof(Mathf),
            typeof(Matrix4x4),
            typeof(Mesh),
            typeof(MeshCollider),
            typeof(MeshRenderer),
            typeof(Particle),
            typeof(ParticleAnimator),
            typeof(ParticleSystem),
            typeof(ParticleSystemRenderer),
            typeof(ParticleSystemRenderMode),
            typeof(ParticleSystemSimulationSpace),
            typeof(Plane),
            typeof(PlayerPrefs),
            typeof(PlayMode),
            typeof(QualitySettings),
            typeof(Quaternion),
            typeof(QueueMode),
            typeof(Random),
            typeof(Ray),
            typeof(Ray2D),
            typeof(RaycastHit),
            typeof(RaycastHit2D),
            typeof(Rect),
            typeof(RectOffset),
            typeof(RectTransform.Axis),
            typeof(RectTransform.Edge),
            typeof(RectTransformUtility),
            typeof(Renderer),
            typeof(RenderTexture),
            typeof(RenderTextureFormat),
            typeof(RenderTextureReadWrite),
            typeof(Resources),
            typeof(Rigidbody),
            typeof(Rigidbody2D),
            typeof(ScaleMode),
            typeof(Screen),
            typeof(ScreenOrientation),
            typeof(SleepTimeout),
            typeof(Sprite),
            typeof(SpriteAlignment),
            typeof(SystemInfo),
            typeof(SystemLanguage),
            typeof(TextAsset),
            typeof(Texture),
            typeof(Texture2D),
            typeof(Texture3D),
            typeof(TextureFormat),
            typeof(TextureWrapMode),
            typeof(Time),
            typeof(Touch),
            typeof(TouchPhase),
            typeof(Vector2),
            typeof(Vector3),
            typeof(Vector4),
            typeof(WaitForEndOfFrame),
            typeof(WaitForFixedUpdate),
            typeof(WaitForSeconds),
            typeof(WWW),
            typeof(WWWForm),


            
        };
        for (int i = 0; i < types.Count; i++)
        {
            list.Add(types[i].FullName);
        }
    }
}
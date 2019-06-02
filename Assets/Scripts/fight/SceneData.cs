using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Rendering;
/***
*  Author:Jiadong Zeng
*  Content: using for save scene Info
***/
[System.Serializable]
public struct LightMapInfo
{
    public Texture2D Far;
    public Texture2D Near;
}
[System.Serializable]
public struct RendererInfo
{
    public Renderer renderer;
    public int lightmapIndex;
    public Vector4 lightmapOffsetScale;
}
public class SceneData : MonoBehaviour
{
    public LightMapInfo[] m_LightMaps;
    public RendererInfo[] m_RendererInfo;

    public Color ambientEquatorColor;
    public Color ambientGroundColor;
    public float ambientIntensity;
    public Color ambientLight;
    public AmbientMode ambientMode;
    public SphericalHarmonicsL2 ambientProbe;
    public Color ambientSkyColor;
    public Cubemap customReflection;
    public DefaultReflectionMode defaultReflectionMode;
    public int defaultReflectionResolution;
    public float flareFadeSpeed;
    public float flareStrength;
    public bool fog;
    public Color fogColor;
    public float fogDensity;
    public float fogEndDistance;
    public FogMode fogMode = FogMode.Linear;
    public float fogStartDistance;
    public float haloStrength;
    public int reflectionBounces;
    public float reflectionIntensity;
    public Material skybox;
    IEnumerator Start()
    {
        yield return null;
        StartResetScene();

        //StaticBatchingUtility.Combine(gameObject);


    }


    //reset scene property
    public void StartResetScene()
    {
        RenderSettings.ambientEquatorColor = ambientEquatorColor;
        RenderSettings.ambientGroundColor = ambientGroundColor;
        RenderSettings.ambientIntensity = ambientIntensity;
        RenderSettings.ambientLight = ambientLight;
        RenderSettings.ambientMode = ambientMode;
        //RenderSettings.ambientProbe = ambientProbe;
        RenderSettings.ambientSkyColor = ambientSkyColor;
        RenderSettings.customReflection = customReflection;
        RenderSettings.defaultReflectionMode = defaultReflectionMode;
        RenderSettings.defaultReflectionResolution = defaultReflectionResolution;
        RenderSettings.flareFadeSpeed = flareFadeSpeed;
        RenderSettings.flareStrength = flareStrength;
        RenderSettings.fog = fog;
        RenderSettings.fogColor = fogColor;
        RenderSettings.fogDensity = fogDensity;
        RenderSettings.fogEndDistance = fogEndDistance;
        RenderSettings.fogMode = fogMode;
        RenderSettings.fogStartDistance = fogStartDistance;
        RenderSettings.haloStrength = haloStrength;
        RenderSettings.reflectionBounces = reflectionBounces;
        RenderSettings.reflectionIntensity = reflectionIntensity;
        RenderSettings.skybox = skybox;

        
        var lightmaps = new List<LightmapData>(LightmapSettings.lightmaps);


        for (int i = 0; i < m_LightMaps.Length; i++)
        {
            LightmapData mapData = new LightmapData();

            if (m_LightMaps[i].Far != null)
                mapData.lightmapFar = m_LightMaps[i].Far;
            if (m_LightMaps[i].Near != null)
                mapData.lightmapNear = m_LightMaps[i].Near;

            lightmaps.Add(mapData);
        }

        ApplyRendererInfo(m_RendererInfo, lightmaps.Count);
        LightmapSettings.lightmaps = lightmaps.ToArray();

    }

    static void ApplyRendererInfo(RendererInfo[] infos, int lightmapOffsetIndex)
    {
        for (int i = 0; i < infos.Length; i++)
        {
            var info = infos[i];

            info.renderer.lightmapIndex = info.lightmapIndex + lightmapOffsetIndex;
            info.renderer.lightmapScaleOffset = info.lightmapOffsetScale;
        }
    }
}

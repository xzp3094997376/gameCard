using UnityEngine;
using System.Collections;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class ModelShowUtil
{
    static public void ChangeSpineSkeletonShader(Transform t, Color col, bool isHsv = true)
    {
        if (t == null)
        {
            return;
        }
        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            ChangeSpineSkeletonShader(t0, col);
        }
       
        if (t.GetComponent<Renderer>() != null && t.GetComponent<Renderer>().sharedMaterials != null)
        {
            Material[] ms = t.GetComponent<Renderer>().sharedMaterials;
            for (int i = 0; i < t.GetComponent<Renderer>().sharedMaterials.Length; i++)
            {
                //Material mat = new Material(Shader.Find("Spine/Skeleton_HSV"));
                //mat.mainTexture = ms[i].mainTexture;
                //ms[i] = mat;
                if (isHsv)
                {
                    ms[i].shader = Shader.Find("Spine/Skeleton_HSV");
                    ms[i].SetColor("_Color", col);
                }
                else
                {
                    ms[i].shader = Shader.Find("Spine/Skeleton");
                }
            }
        }
        Renderer re = t.GetComponent<Renderer>();
    }

    public static void resetShader(Transform t)
    {
//#if UNITY_EDITOR
        if (t == null) return;
        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            resetShader(t0);
        }

        if (t.GetComponent<Renderer>() != null && t.GetComponent<Renderer>().sharedMaterial != null)
        {
            Material[] ms = t.GetComponent<Renderer>().sharedMaterials;
            for (int i = 0; i < t.GetComponent<Renderer>().sharedMaterials.Length; i++)
            {
                if (ms[i].shader.name == "Spine/Skeleton_HSV") // 还原
                {
                    ms[i].shader = Shader.Find("Spine/Skeleton");
                }
                else
                {
                    ms[i].shader = Shader.Find(ms[i].shader.name);
                }
            }
        }
//#endif

    }

    public static void CompleteRenderMaterialShader(GameObject go)
    {
        //#if UNITY_EDITOR
        Renderer[] renders = go.GetComponentsInChildren<Renderer>(true);
        foreach (Renderer ren in renders)
        {
            if (null == ren.sharedMaterial)
            {
                Debug.LogWarning(go.name + "  Lost Material ");
            }
            else
            {
                if (null == ren.sharedMaterial.shader)
                {
                    Debug.LogWarning(go.name + " --> " + ren.sharedMaterial.name + "  Lost Shader ");

                }
                else
                {
                    Shader shader = Shader.Find(ren.sharedMaterial.shader.name);
                    if (null != shader)
                    {
                        ren.sharedMaterial.shader = shader;
                    }
                    else
                    {
                        Debug.LogWarning(ren.sharedMaterial.shader.name + " Can Not Found Shader ");
                    }
                }
            }
            if (null == ren.sharedMaterials || ren.sharedMaterials.Length <= 0) return;
            foreach (Material mat in ren.sharedMaterials)
            {
                if (null == mat)
                {
                    Debug.LogWarning(go.name + " Lost Material ");
                    continue;
                }
                if (null == mat.shader)
                {
                    Debug.LogWarning(go.name + " --> " + ren.sharedMaterial.name + " Lost Shader ");
                    continue;
                }
                Shader shader = Shader.Find(mat.shader.name);
                if (null != shader)
                {
                    mat.shader = shader;
                }
                else
                {
                    Debug.LogWarning(ren.sharedMaterial.shader.name + " Can Not Found Shader ");
                }
            }
        }
//#endif
    }


    /// <summary>
    /// modify heros shader
    /// </summary>
    /// <param name="t">hero transform</param>
    /// <param name="need">need shader</param>
    public static void ModifyModelShader(Transform t, Shader need)
    {
        if (t == null)
            return;
        Renderer[] renders = t.GetComponentsInChildren<Renderer>();
        //细化边框
        for (int i = 0; i < renders.Length; i++)
        {
            if (renders[i] == null)
                continue;

            Material[] mats = renders[i].materials;

            for (int j = 0; j < mats.Length; j++)
                if (mats[j].shader.name == "Diffuse")
                {
                    mats[j].shader = need;
                }
        }
        resetShader(t);
    }
    public static void resSetLayer(Transform t, int layer)
    {
        if (t == null) return;
        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            if (t0 != null)
            {
                t0.gameObject.layer = layer;
            }
            resSetLayer(t0, layer);
        }
    }
}

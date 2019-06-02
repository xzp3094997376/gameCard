Shader "Custom/IgnoreFog" {
	Properties {
			_Color ("Main Color", Color) = (.5,.5,.5,1)
			_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		//	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader {
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 100
		
		Pass {
			Fog{Mode Off }
			Lighting Off
			Cull Back
		//	Alphatest Greater [_Cutoff]
			Material{
				Diffuse[_Color]
			}
			SetTexture [_MainTex] { combine texture } 
		}
	} 
	FallBack "Diffuse"
}

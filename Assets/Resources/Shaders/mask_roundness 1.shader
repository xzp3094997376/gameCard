Shader "Hidden/Custom/mask_roundness 1"{

	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Mask ("Culling Mask", 2D) = "white" {}
		_Mask_Scale ("mask scale", float) = 8.4628
	}
	SubShader {
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		Pass {
			Cull Off
			Lighting Off
			ZWrite Off
			Offset -1, -1
			Fog { Mode Off }
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _Mask;
				float4 _Mask_ST;
				float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
				float2 _ClipArgs0 = float2(1000.0, 1000.0);
				float _Mask_Scale;
				//sampler2D _Mask;
				struct Input {
					float2 uv_MainTex;
				};
				struct appdata {
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
				};
				
				struct v2f {
					float4 pos : POSITION;
					float2 texcoord : TEXCOORD0;
					float2 worldPos : TEXCOORD1;
				};

				v2f vert (appdata v)
				{
					v2f o;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.worldPos = v.vertex.xy * _ClipRange0.zw + _ClipRange0.xy;
					return o;
				}

				float4 frag (v2f i) : COLOR
				{
					float2 factor = (float2(1.0, 1.0) - abs(i.worldPos)) * _ClipArgs0;
				
					float4 col = tex2D(_MainTex, i.texcoord) ;
					col=col*tex2D(_Mask, i.texcoord*float2(_Mask_Scale, _Mask_Scale));
					col.a *= clamp( min(factor.x, factor.y), 0.0, 1.0);
					 

					return col;
				}

			ENDCG	
		}

 	}

}
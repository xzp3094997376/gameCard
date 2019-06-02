Shader "Custom/mask_roundness" {
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Mask ("Culling Mask", 2D) = "white" {}
		_Mask_Scale("mask scale", float) = 8.4628
		//_Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			//AlphaTest GEqual [_Cutoff]
			Cull Back
			Lighting  Off
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _Mask;
				float4 _Mask_ST;
				float _Mask_Scale;
				struct Input {
					float2 uv_MainTex;
				};
				struct appdata {
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
					//float2 texcoord1 :TEXCOORD1;
				};
				
				struct v2f {
					float4 pos : POSITION;
					float2 texcoord : TEXCOORD0;
					//float2 texcoord1 :TEXCOORD1;
				};

				v2f vert (appdata v)
				{
					v2f o;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					//v.texcoord1.xy *= 0.5;
					//o.texcoord1 = v.texcoord1 * _Mask_ST.xy*float2(11.2527, 11.2527)+ _Mask_ST.zw;//TRANSFORM_TEX(v.texcoord1, _Mask);
					return o;
				}

				float4 frag (v2f i) : COLOR
				{
					//i.texcoord.xy += float2(0.2,0.2);
					float4 c  = tex2D(_MainTex, i.texcoord);
					//float4 d = tex2D(_Mask, i.texcoord);
					c=c*tex2D(_Mask, i.texcoord*float2(_Mask_Scale, _Mask_Scale));
					return c;
				}

			ENDCG	
		}

 	}
	
}

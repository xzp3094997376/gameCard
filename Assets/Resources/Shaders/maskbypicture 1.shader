Shader "Hidden/Custom/maskbypicture 1" {

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//_BackTex ("Background (RGB)", 2D) = "white" {}
		_AlphaTex ("_AlphaTex (RGB)", 2D) = "white" {}
		_Rate ("scale rate", Range (0,5)) = 0.4
		_Start ("start pos", Range (0,1)) = 0.3
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Back
			Lighting  Off
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _AlphaTex;
				//sampler2D _BackTex;
				float _Rate;
				float _Start;
				float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
				float2 _ClipArgs0 = float2(1000.0, 1000.0);
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
					float4 c  = tex2D(_MainTex, (i.texcoord*float2(_Rate,1) + float2(_Start, 0)));
					float4 d = tex2D(_AlphaTex, i.texcoord);

					c = c*d.a;
					//d = tex2D (_BackTex, i.texcoord);
					//c = c.a*c + (1-c.a)*d;
					c.a *= clamp( min(factor.x, factor.y), 0.0, 1.0);
					//float grayscale = Luminance(c.rgb);
					//c.rgb = float3(grayscale,grayscale, grayscale);
					return c;
				}

			ENDCG	
		}

 	}
	
	Fallback "VertexLit"
	
}

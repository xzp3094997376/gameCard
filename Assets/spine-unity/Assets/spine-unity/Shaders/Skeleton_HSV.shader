Shader "Spine/Skeleton_HSV" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_Cutoff ("Shadow alpha cutoff", Range(0,1)) = 0.1
		_MainTex ("Texture to blend", 2D) = "black" {}
	}
	// 2 texture stage GPUs
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		LOD 100

		Cull Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		Lighting Off

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct v2f {
				float4 vertex : POSITION;
				float2  uv : TEXCOORD1;
			};
			uniform float4 _MainTex_ST;
			uniform sampler2D _MainTex;

			v2f vert(appdata_base v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			float4 _Color;
			float3 RGB2HSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
				float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			float3 HSV2RGB(float3 c)
			{
				float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
				float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
			}
			float4 frag(v2f i) : COLOR{
				fixed4 texcol = tex2D(_MainTex, i.uv);
				fixed3 hsvS = RGB2HSV(texcol.rgb);
				fixed3 hsvD = RGB2HSV(_Color.rgb);
				hsvS[0] = hsvD[0];
				texcol.rgb = HSV2RGB(hsvS);;
				return texcol;
			}
			ENDCG
		}
	}
}
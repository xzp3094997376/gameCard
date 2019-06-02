Shader "Hidden/Custom/Fix alpha 1" {
Properties {
	_MainTex (" Texture", 2D) = "white" {}
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	//Blend SrcColor OneMinusSrcColor
	Blend SrcAlpha OneMinusSrcAlpha
	//AlphaTest Greater .01
	ColorMask RGBA
	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }

	// BindChannels {
	// 	Bind "Color", color
	// 	Bind "Vertex", vertex
	// 	Bind "TexCoord", texcoord
	// }
	SubShader {
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
			float2 _ClipArgs0 = float2(1000.0, 1000.0);

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;

			};

			struct v2f {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 worldPos : TEXCOORD1;

			};
			
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.worldPos = v.vertex.xy * _ClipRange0.zw + _ClipRange0.xy;
				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 c = tex2D(_MainTex, i.texcoord);
				float2 factor = (float2(1.0, 1.0) - abs(i.worldPos)) * _ClipArgs0;
				
				if((c.r + c.g + c.b)/3 > c.a)
					c.a = (c.r + c.g + c.b)/3 ;
				c.a *= clamp( min(factor.x, factor.y), 0.0, 1.0);
				return c;//2.0f * i.color * _TintColor * tex2D(_MainTex, i.texcoord);
			}
			ENDCG 
		}
	} 	
	// ---- Single texture cards (does not do color tint)
	SubShader {
		Pass {
			SetTexture [_MainTex] {
				combine texture * primary
			}
		}
	}
}
}

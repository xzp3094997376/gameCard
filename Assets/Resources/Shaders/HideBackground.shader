Shader "Custom/Fix alpha" {
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
			
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};
			
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 c = tex2D(_MainTex, i.texcoord);
				
				if((c.r + c.g + c.b)/3 > c.a)
					c.a = (c.r + c.g + c.b)/3 ;
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

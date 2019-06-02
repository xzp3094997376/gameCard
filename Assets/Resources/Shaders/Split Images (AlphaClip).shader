Shader "Custom/Split Images (AlphaClip)" {

	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex ("Alpha (RGB)", 2D) = "white" {}
	}

	SubShader
	{
		LOD 100

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			ColorMask RGB
			AlphaTest Greater .01
			Blend SrcAlpha OneMinusSrcAlpha 
			ColorMaterial AmbientAndDiffuse
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float4 _MainTex_ST;

			struct appdata_t
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 worldPos : TEXCOORD1;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				o.worldPos = TRANSFORM_TEX(v.vertex.xy, _MainTex);
				return o;
			}

			half4 frag (v2f IN) : COLOR
			{
				// Sample the texture
				half4 col = tex2D(_MainTex, IN.texcoord) * IN.color;
				half4 colAlpha = tex2D(_AlphaTex, IN.texcoord) ;

				float2 factor = abs(IN.worldPos);
				float val = 1.0 - max(factor.x, factor.y);

				// Option 1: 'if' statement
				col.a = colAlpha.r* IN.color.a;
				if (val < 0.0) col.a = 0.0;

				return col;
			}
			ENDCG
		}
	}
}

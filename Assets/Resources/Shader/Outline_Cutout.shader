Shader "Custom/Toon/Outline_Cutout" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" { }
	_Ramp("Ramp Texture", 2D) = "white" {}
		_Shininess("Shininess", int) = 16
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
		_Outline("Outline width", float) = .0005
			_ToonEffect("Toon Effect",float) = 0.5
			_Steps("Steps of toon",int) = 3
	}
	SubShader{
		Tags{ "Queue" = "Transparent" }

		// note that a vertex shader is specified here but its using the one above
		Pass{
			Name "OUTLINE"
			Tags{ "LightMode" = "Always" }
			Cull Front
			Lighting Off
			ZWrite On

			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			struct vertexinput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			struct v2f {
				float2 uv : TEXCOORD0;
				float4 pos : POSITION;
			};
			sampler2D _MainTex;
			float4 _MainTex_ST;
			uniform float _Outline;
			uniform float4 _OutlineColor;

			v2f vert(vertexinput v) {
				// just make a copy of incoming vertex data but scaled according to normal direction
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				float2 offset = TransformViewToProjection(norm.xy);
				o.pos.xy += offset * o.pos.z * _Outline;			
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			half4 frag(v2f i) :COLOR{
				float4 c = tex2D(_MainTex, i.uv);
				c.rgb = _OutlineColor.rgb;

				clip(c.a - 0.1f);
				return c;
			}
			ENDCG
		}

		Pass{
			Name "OBJECT"
			Tags{ "LightMode" = "Always" }
			Cull Off
			ZWrite On

			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			struct vertexinput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			struct v2f {
				float2 uv : TEXCOORD0;
				float4 pos : POSITION;
				float3 lightDir:TEXCOORD1;
				float3 viewDir:TEXCOORD2;
				float3 normal:TEXCOORD3;
			};
			uniform float4 _Color;
			sampler2D _MainTex;
			sampler2D _Ramp;
			float4 _MainTex_ST; 
			uniform float4 _LightColor0;
			uniform float _Shininess;
			float _Steps;
			float _ToonEffect;

			v2f vert(vertexinput v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				o.lightDir = ObjSpaceLightDir(v.vertex);
				o.viewDir = ObjSpaceViewDir(v.vertex);
				o.normal = v.normal;

				return o;
			}
			float4 frag(v2f i) : COLOR
			{
				i.lightDir = normalize(i.lightDir);
			i.viewDir = normalize(i.viewDir);
			i.normal = normalize(i.normal);

			//((dot(world_norml_4, world_light_5) + 1.0) * 0.45) + 0.05);

			//float difLight = max(0, dot(i.normal, i.viewDir));
			//difLight = (difLight + 1) / 2;
			//difLight = smoothstep(0, 1, difLight);
			//float rim_hLambert = (difLight + 1.0) * 0.45 + 0.05;

			//float rimLight = max(0, dot(i.normal, i.viewDir));
			//float rim_hLambert = rimLight * 0.5 + 0.2;
			//rim_hLambert = smoothstep(0, 0.6, rim_hLambert);
			//float3 ramp = tex2D(_Ramp, float2(rim_hLambert, 0)).rgb;
			
			//float3 hvec = i.viewDir;//( + i.lightDir) / 2;
			//float spec = max(0,dot(hvec,i.normal));
			//spec =  pow(spec,16) * _Shininess;
		
			
			float3 N = normalize(i.normal);
			float3 viewDir = normalize(i.viewDir);
			float diff = max(0, dot(N, viewDir));
			float spec = pow(diff, _Shininess);
			
			spec = smoothstep(0, 1, spec*0.2);
			float4 ramp = tex2D(_Ramp, float2(spec, 0));			
			float4 c = tex2D(_MainTex, i.uv);
			float temp = max(_ToonEffect, ramp.r);
			temp = min(temp, 1);
			c.rgb = c.rgb*_Color+ temp*0.1;
			
			clip(c.a - 0.1f);

			return c;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}

//URP CUSTOM SHADER TEMPLATE - https://gist.github.com/phi-lira/225cd7c5e8545be602dca4eb5ed111ba

Shader "David/UberBIP"
{
    Properties
    {
        [Header(Rendering)]
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Int) = 2

        //https://docs.unity3d.com/Manual/SL-ZWrite.html
        //Sets whether the depth buffer contents are updated during rendering.
        //Normally, ZWrite is enabled for opaque objects and disabled for semi - transparent ones.
        [ToggleUI] _ZWrite("ZWrite", Float) = 1

        //https://docs.unity3d.com/Manual/SL-ZTest.html
        // 0 - Disabled:
        // 1 - Never:
        // 2 - Less: Draw geometry that is in front of existing geometry.Do not draw geometry that is at the same distance as or behind existing geometry.
        // 3 - LEqual: Draw geometry that is in front of or at the same distance as existing geometry.Do not draw geometry that is behind existing geometry. (This is the default value)
        // 4 - Equal: Draw geometry that is at the same distance as existing geometry.Do not draw geometry that is in front of or behind existing geometry.
        // 5 - GEqual: Draw geometry that is behind or at the same distance as existing geometry.Do not draw geometry that is in front of existing geometry.
        // 6 - Greater: Draw geometry that is behind existing geometry.Do not draw geometry that is at the same distance as or in front of existing geometry.
        // 7 - NotEqual: Draw geometry that is not at the same distance as existing geometry.Do not draw geometry that is at the same distance as existing geometry.
        // 8 - Always: No depth testing occurs. Draw all geometry, regardless of distance.
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4

        //[KeywordEnum(Off, On)] _BlendState("Blending", Float) = 0
        //[Enum(UberShaderBIP.ToggleEnum)] _BlendState("Blending", Float) = 0
        //[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Float) = 1
        //[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DstBlend", Float) = 0

        [Toggle(_ALPHA_CUTOFF)] _EnableAlphaCutoff("Alpha Cutoff", Float) = 0
        [ToggleUI] _AlphaToMaskMode("Alpha to Coverage", Int) = 0
        [Toggle(_SPECULAR_HIGHLIGHTS)] _SpecularHighlights("Specular Highlights", Float) = 1
        [Toggle(_GLOSSY_REFLECTIONS)] _GlossyReflections("Glossy Reflections", Float) = 1
        [Toggle(_EMISSION)] _Emission("Emisson", Float) = 0
        [Toggle(_SPECULAR_OCCLUSION)] _SpecularOcclusion("Procedual Specular Occlusion", Float) = 1
        [Toggle(_TRANSLUCENCY)] _Translucency("Translucency", Float) = 0
        [Toggle(_ANISOTROPIC)] _Anistropic("Anistropic Specular", Float) = 0
        [Toggle(_MICRO_SHADOWING)] _MicroShadow("Micro Shadowing (Requires AO)", Float) = 0
        [Toggle(_NORMALMAP_SCALE)] _NormalMapScale("Normal Map Scale", Float) = 0
        [Toggle(_NORMALMAP_SHADOWS)] _NormalMapShadows("Normal Map Shadow (Requires Normal)", Float) = 0
        [Toggle(_PARALLAX_MAPPING)] _ParallaxMapping("Parallax Mapping (Requires Height)", Float) = 0
        [Toggle(_REFRACTION)] _PerformRefraction("Refraction", Float) = 0

        [Header(Color)]
        [MainColor] _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo", 2D) = "white" {}
        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        [Header(Bump)]
        _BumpScale("Normal Strength", Float) = 1
        _BumpShadowHeightScale("Normal Map Shadow Height Scale", Float) = 0.1
        _BumpShadowHardness("Normal Map Shadow Hardness", Float) = 50
        [TextureToggle(_NORMALMAP)] [NoScaleOffset] [Normal] _BumpMap("Normal Map", 2D) = "bump" {}

        [Header(Specular)]
        _Anisotropy("Anisotropy", Range(-1.0, 1.0)) = 0.0
        _Reflectance("Reflectance", Range(0.0, 1.0)) = 0.4
        _Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
        [Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        [TextureToggle(_METALLICGLOSSMAP)] [NoScaleOffset] _MetallicGlossMap("Metallic", 2D) = "white" {}
        _SpecularAntiAliasingVariance("Specular AA Variance",  Range(0, 1)) = 0.15
        _SpecularAntiAliasingThreshold("Specular AA Threshold", Range(0, 1)) = 0.25

        [Header(Emission)]
        [HDR] _EmissionColor("Color", Color) = (1,1,1,1)
        [NoScaleOffset] _EmissionMap("Emission", 2D) = "white" {}

        [Header(Height)]
        _Parallax("Height", Float) = 0.1
        [NoScaleOffset] _ParallaxMap("Height Map", 2D) = "bump" {}

        [Header(Occlusion)]
        _OcclusionStrength("Occlusion Strength", Range(0, 1)) = 1.0
        _ProcedualExposureOcclusion("Procedual Occlusion Sensitivity", Range(0, 1)) = 0.0
        [NoScaleOffset] _OcclusionMap("Ambient Occlusion", 2D) = "white" {}

        [Header(Translucency)]
        _TranslucencyColor("Translucency Color", Color) = (1,1,1,1)
        [NoScaleOffset] _ThicknessMap("Thickness Map", 2D) = "black" {}
        _ThicknessPower("Thickness Power", Float) = 20
        _TranslucencyDistortion("Translucency Distortion", Float) = 0
        _TranslucencyScale("Translucency Scale", Float) = 1
        _TranslucencyPower("Translucency Power", Float) = 25
        _TranslucencyAmbient("Translucency Ambient", Float) = 0
        _TranslucencyShadowStrength("Translucency Shadow Strength", Range(0, 1)) = 0.9

        [Header(Refraction)]
        _RefractionOpacity("Opacity", Range(0, 1)) = 0.5
        _RefractionMip("Refraction Mip Level", Float) = 1
        _RefractionDistortion("Refraction Distortion", Float) = 1

        [NonModifiableTextureData][HideInInspector] _BDRF_LUT("_BDRF_LUT", 2D) = "white" {}

        // Blending state
        [HideInInspector] _Mode("__mode", Float) = 0.0
        [HideInInspector] _SrcBlend("__src", Float) = 1.0
        [HideInInspector] _DstBlend("__dst", Float) = 0.0
        [HideInInspector] _ZWrite("__zw", Float) = 1.0
    }
    SubShader
    {
        Tags
        {
            "Queue" = "AlphaTest"
            //"RenderType" = "Opaque"
            "RenderType" = "TransparentCutout"
            "IgnoreProjector" = "True"
            "DisableBatching" = "LODFading"
        }

        Cull [_CullMode]
        AlphaToMask [_AlphaToMaskMode]
        ZWrite [_ZWrite]
        ZTest [_ZTest]
        //Blend [_SrcBlend][_DstBlend]
        //Blend [_Mode]

        LOD 100

        Pass
        {
            Name "UberBIP_ForwardBase"
            Tags { "LightMode" = "ForwardBase" }
  
            CGPROGRAM
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||

            //BUILT IN RENDER PIPELINE
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "UnityShadowLibrary.cginc"
            #include "UnityLightingCommon.cginc"
            #include "UnityStandardBRDF.cginc"

            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //custom includes
            #include "UberBIP_Config.cginc"
            #include "UberBIP_Math.cginc"
            #include "UberBIP_Material.cginc" //<-- material properties in here
            #include "UberBIP_Tonemapping.cginc"
            #include "UberBIP_BDRF.cginc"
            #include "UberBIP_Graphics.cginc"
            #include "UberBIP_SphericalHarmonics.cginc"
            #include "UberBIP_ForwardBase.cginc" //<-- main uber shading

            #pragma vertex vertex_base
            #pragma fragment fragment_forward_base
            #pragma target 3.0
            
            // -------------------------------------
            // Unity defined keywords
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_fwdbase

            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ UNITY_LIGHTMAP_FULL_HDR

            #if defined (CALCULATE_FOG)
                #pragma multi_compile_fog
            #endif

            #if defined (ALLOW_LOD_CROSSFADING)
                #pragma multi_compile _ LOD_FADE_CROSSFADE
            #endif

            #if defined (ALLOW_DYNAMICLIGHTMAP_ON)
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #endif

            #if defined (ALLOW_DIRLIGHTMAP_COMBINED)
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #else
                #undef DIRLIGHTMAP_COMBINED
            #endif

            #if defined (ALLOW_BOX_PROJECTED_REFLECTIONS)
                #pragma multi_compile _ UNITY_SPECCUBE_BOX_PROJECTION
            #endif

            #if defined (ALLOW_LIGHT_PROBE_PROXY_VOLUMES)
                #pragma multi_compile _ UNITY_LIGHT_PROBE_PROXY_VOLUME 
            #endif

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            // -------------------------------------
            // Custom keywords
            #pragma shader_feature_local _METALLICGLOSSMAP
            #pragma shader_feature_local _ALPHA_CUTOFF
            #pragma shader_feature_local _REFRACTION
            #pragma shader_feature _EMISSION

            #if defined (ALLOW_GLOSSY_REFLECTIONS)
                #pragma shader_feature_local _GLOSSY_REFLECTIONS
            #endif

            #if defined (ALLOW_SPECULAR_HIGHLIGHTS)
                #pragma shader_feature_local _SPECULAR_HIGHLIGHTS
            #endif

            #if defined (ALLOW_NORMALMAP)
                #pragma shader_feature_local _NORMALMAP
            #endif

            #if defined (ALLOW_TRANSLUCENCY)
                #pragma shader_feature_local _TRANSLUCENCY
            #endif

            #if defined (ALLOW_SPECULAR_OCCLUSION)
                #pragma shader_feature_local _SPECULAR_OCCLUSION
            #endif

            #if defined (ALLOW_ANISOTROPIC)
                #pragma shader_feature_local _ANISOTROPIC
            #endif

            #if defined (ALLOW_MICRO_SHADOWING)
                #pragma shader_feature_local _MICRO_SHADOWING
            #endif

            #if defined (ALLOW_NORMALMAP_SHADOWS)
                #pragma shader_feature_local _NORMALMAP_SHADOWS
            #endif

            #if defined (ALLOW_NORMALMAP_SCALE)
                #pragma shader_feature_local _NORMALMAP_SCALE
            #endif

            #if defined (ALLOW_PARALLAX_MAPPING)
                #pragma shader_feature_local _PARALLAX_MAPPING
            #endif

            ENDCG
        }

        Pass
        {
            Name "UberBIP_ForwardAdd"
            Tags { "LightMode" = "ForwardAdd" }

            //For additive passes, fog should be black
            Fog 
            {
                Color(0, 0, 0, 0) 
            }

            Blend One One

            CGPROGRAM
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||

            //BUILT IN RENDER PIPELINE
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "UnityShadowLibrary.cginc"
            #include "UnityLightingCommon.cginc"
            #include "UnityStandardBRDF.cginc"

            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //custom includes
            #include "UberBIP_Config.cginc"
            #include "UberBIP_Math.cginc"
            #include "UberBIP_Material.cginc" //<-- material properties in here
            #include "UberBIP_Tonemapping.cginc"
            #include "UberBIP_BDRF.cginc"
            #include "UberBIP_Graphics.cginc"
            #include "UberBIP_SphericalHarmonics.cginc"
            #include "UberBIP_ForwardAdd.cginc" //<-- main uber shading

            #pragma vertex vertex_add
            #pragma fragment fragment_forward_add
            #pragma target 3.0

            //#pragma multi_compile_fwdadd
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_instancing
            #pragma shader_feature_local _METALLICGLOSSMAP
            #pragma shader_feature_local _ALPHA_CUTOFF
            #pragma shader_feature_local _REFRACTION
            #pragma shader_feature _EMISSION

            #if defined (CALCULATE_FOG)
                #pragma multi_compile_fog
            #endif

            #if defined (ALLOW_LOD_CROSSFADING)
                #pragma multi_compile _ LOD_FADE_CROSSFADE
            #endif

            #if defined (ALLOW_SPECULAR_HIGHLIGHTS)
                #pragma shader_feature_local _SPECULAR_HIGHLIGHTS
            #endif

            #if defined (ALLOW_NORMALMAP)
                #pragma shader_feature_local _NORMALMAP
            #endif

            #if defined (ALLOW_TRANSLUCENCY)
                #pragma shader_feature_local _TRANSLUCENCY
            #endif
            
            #if defined (ALLOW_SPECULAR_OCCLUSION)
                #pragma shader_feature_local _SPECULAR_OCCLUSION
            #endif

            #if defined (ALLOW_ANISOTROPIC)
                #pragma shader_feature_local _ANISOTROPIC
            #endif

            #if defined (ALLOW_MICRO_SHADOWING)
                #pragma shader_feature_local _MICRO_SHADOWING
            #endif

            #if defined (ALLOW_NORMALMAP_SHADOWS)
                #pragma shader_feature_local _NORMALMAP_SHADOWS
            #endif

            #if defined (ALLOW_NORMALMAP_SCALE)
                #pragma shader_feature_local _NORMALMAP_SCALE
            #endif

            #if defined (ALLOW_PARALLAX_MAPPING)
                #pragma shader_feature_local _PARALLAX_MAPPING
            #endif

            #pragma fragmentoption ARB_precision_hint_fastest
            ENDCG
        }

        Pass
        {
            Name "UberBIP_ForwardShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }

            CGPROGRAM
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||

            //URP
            //#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"

            //BUILT IN RENDER PIPELINE
            #include "UnityCG.cginc"

            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //custom includes
            #include "UberBIP_Config.cginc"
            #include "UberBIP_Math.cginc"
            #include "UberBIP_Material.cginc" //<-- material properties in here
            #include "UberBIP_Shadow.cginc"

            #pragma vertex vertex_shadow_cast
            #pragma fragment fragment_shadow_caster
            #pragma target 3.0

            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing

            #pragma shader_feature_local _ALPHA_CUTOFF
            ENDCG
        }

        //BUILT IN PIPELINE META PASS
        UsePass "Standard/META"
    }

    //FallBack "VertexLit"
    //FallBack "Standard"
    //CustomEditor "UberEditorGUI"
}

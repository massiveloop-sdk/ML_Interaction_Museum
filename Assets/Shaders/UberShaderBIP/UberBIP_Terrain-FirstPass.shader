/*
* NOTE TO SELF:
* This is the UberTerrain-FirstPass shader.
* This is responsible for the main shading of the terrain for the first batch of 4 textures on the terrain.
* 
* AddPass is similar to the FirstPass however it is reponsible for handling the other batch set of 4 textures that are added. (Additionally another AddPass is done if more than 4 are used)
* BaseMap is a fallback used by older gpus (but its also used by the base map distance for reducing texture detail at a distance)
*/

Shader "David/UberBIP_Terrain"
{
    Properties
    {
        // used in fallback on old cards & base map
        [HideInInspector] _MainTex("BaseMap (RGB)", 2D) = "white" {}
        [HideInInspector] _Color("Main Color", Color) = (1,1,1,1)
        [HideInInspector] _TerrainHolesTexture("Holes Map (RGB)", 2D) = "white" {}

        [HideInInspector] _Mask0("mask 1", 2D) = "white" {}
        [HideInInspector] _Mask1("mask 2", 2D) = "white" {}
        [HideInInspector] _Mask2("mask 3", 2D) = "white" {}
        [HideInInspector] _Mask3("mask 4", 2D) = "white" {}

        [Header(Rendering)]
        [Toggle(_SPECULAR_HIGHLIGHTS)] _SpecularHighlights("Specular Highlights", Float) = 1
        [Toggle(_GLOSSY_REFLECTIONS)] _GlossyReflections("Glossy Reflections", Float) = 1
        [Toggle(_SPECULAR_OCCLUSION)] _SpecularOcclusion("Procedual Specular Occlusion", Float) = 1
        [Toggle(_SPECULAR_AA)] _SpecularAA("Specular Anti Aliasing", Float) = 0
        [Toggle(_MICRO_SHADOWING)] _MicroShadow("Micro Shadowing (Requires AO)", Float) = 0
        [Toggle(_NORMALMAP)] _UseNormalMap("Enable Normalmap", Float) = 1
        [Toggle(_NORMALMAP_SCALE)] _NormalMapScale("Normal Map Scale", Float) = 0
        [Toggle(_NORMALMAP_SHADOWS)] _NormalMapShadows("Normal Map Shadow (Requires Normal)", Float) = 0
        [Toggle(_PARALLAX_MAPPING)] _ParallaxMapping("Parallax Mapping (Requires Height)", Float) = 0
        [Toggle(_METALLICGLOSSMAP)] _UsePBRTex("Use PBR Mask", Float) = 0

        [Header(Bump)]
        _BumpShadowHeightScale("Normal Map Shadow Height Scale", Float) = 0.1
        _BumpShadowHardness("Normal Map Shadow Hardness", Float) = 50

        [Header(Specular)]
        _Reflectance("Reflectance", Range(0.0, 1.0)) = 0.4
        _SpecularAntiAliasingVariance("Specular AA Variance",  Range(0, 1)) = 0.15
        _SpecularAntiAliasingThreshold("Specular AA Threshold", Range(0, 1)) = 0.25

        [Header(Height)]
        _Parallax("Height", Float) = 0.1

        [Header(Occlusion)]
        _OcclusionStrength("Occlusion Strength", Range(0, 1)) = 1.0
        _ProcedualExposureOcclusion("Procedual Occlusion Sensitivity", Range(0, 1)) = 0.0
    }
    SubShader
    {
        Tags 
        {
            "TerrainCompatible" = "True"
            "Queue" = "Geometry-100"
            "RenderType" = "Opaque"
        }

        Pass 
        {
            Name "UberBIP_TerrainForwardBase"
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            //#include "UnityShadowLibrary.cginc"
            //#include "UnityLightingCommon.cginc"
            //#include "UnityStandardBRDF.cginc"
            #include "TerrainSplatmapCommon.cginc"

            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //custom includes

            #define TERRAIN_MODE

            #include "UberBIP_Config.cginc"
            #include "UberBIP_Math.cginc"
            #include "UberBIP_TerrainMaterial.cginc" //<-- material properties in here
            #include "UberBIP_Tonemapping.cginc"
            #include "UberBIP_BDRF.cginc"
            #include "UberBIP_Graphics.cginc"

            //main uber terrain shading
            #include "UberBIP_TerrainMain.cginc"

            #pragma vertex vertex_base
            #pragma fragment fragment_forward_base
            #pragma target 3.0
            //#pragma target PRAGMA_TARGET_LEVEL

            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ UNITY_LIGHTMAP_FULL_HDR
            #pragma shader_feature_local _METALLICGLOSSMAP

            #if defined (ALLOW_BOX_PROJECTED_REFLECTIONS)
                #pragma multi_compile _ UNITY_SPECCUBE_BOX_PROJECTION
            #endif

            #if defined (CALCULATE_FOG)
                #pragma multi_compile_fog
            #endif

            #if defined (ALLOW_DYNAMICLIGHTMAP_ON)
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #endif

            #if defined (ALLOW_DIRLIGHTMAP_COMBINED)
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #else
                #undef DIRLIGHTMAP_COMBINED
            #endif

            #if defined (ALLOW_GLOSSY_REFLECTIONS)
                #pragma shader_feature_local _GLOSSY_REFLECTIONS
            #endif

            #if defined (ALLOW_SPECULAR_HIGHLIGHTS)
                #pragma shader_feature_local _SPECULAR_HIGHLIGHTS
            #endif

            #if defined (ALLOW_NORMALMAP)
                #pragma shader_feature_local _NORMALMAP
            #endif

            #if defined (ALLOW_SPECULAR_OCCLUSION)
                #pragma shader_feature_local _SPECULAR_OCCLUSION
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
            Name "UberBIP_TerrainForwardAdd"
            Tags { "LightMode" = "ForwardAdd" }

            Fog { Color(0,0,0,0) } //For additive passes, fog should be black
            Blend One One

            CGPROGRAM
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            //#include "UnityShadowLibrary.cginc"
            //#include "UnityLightingCommon.cginc"
            //#include "UnityStandardBRDF.cginc"
            #include "TerrainSplatmapCommon.cginc"

            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| CUSTOM INCLUDES |||||||||||||||||||||||||||||
            //custom includes

            #define TERRAIN_MODE

            #include "UberBIP_Config.cginc"
            #include "UberBIP_Math.cginc"
            #include "UberBIP_TerrainMaterial.cginc" //<-- material properties in here
            #include "UberBIP_Tonemapping.cginc"
            #include "UberBIP_BDRF.cginc"
            #include "UberBIP_Graphics.cginc"

            //main uber terrain shading
            #include "UberBIP_TerrainMain.cginc"

            #pragma vertex vertex_add
            #pragma fragment fragment_forward_add
            #pragma target 3.0
            //#pragma target PRAGMA_TARGET_LEVEL

            //#pragma multi_compile_fwdadd
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_instancing
            #pragma shader_feature_local _METALLICGLOSSMAP

            #if defined (CALCULATE_FOG)
                #pragma multi_compile_fog
            #endif

            #if defined (ALLOW_SPECULAR_HIGHLIGHTS)
                #pragma shader_feature_local _SPECULAR_HIGHLIGHTS
            #endif

            #if defined (ALLOW_NORMALMAP)
                #pragma shader_feature_local _NORMALMAP
            #endif

            #if defined (ALLOW_SPECULAR_OCCLUSION)
                #pragma shader_feature_local _SPECULAR_OCCLUSION
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

        UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
        UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"
    }

    Dependency "AddPassShader" = "Hidden/UberBIP_Terrain-AddPass"
    Dependency "BaseMapShader" = "Hidden/UberBIP_Terrain-Base"
    Dependency "BaseMapGenShader" = "Hidden/UberBIP_Terrain-BaseGen"

    Fallback "Nature/Terrain/Diffuse"
}

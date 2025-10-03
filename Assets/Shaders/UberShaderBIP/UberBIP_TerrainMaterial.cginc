//Filamented Material Guide - https://google.github.io/filament/Material%20Properties.pdf
//added some macros around some of the effects, no use in declaring them if they are disabled

uniform samplerTexture _MainTex;

uniform samplerTexture _Mask0;
uniform samplerTexture _Mask1;
uniform samplerTexture _Mask2;
uniform samplerTexture _Mask3;

uniform real _Metallic0;
uniform real _Metallic1;
uniform real _Metallic2;
uniform real _Metallic3;

uniform real _Smoothness0;
uniform real _Smoothness1;
uniform real _Smoothness2;
uniform real _Smoothness3;

uniform real4 _MainTex_ST;

uniform real _Cutoff;
uniform real _Reflectance;
uniform real _OcclusionStrength;
uniform real _ProcedualExposureOcclusion;

#if defined(_SPECULAR_AA)
    uniform real _SpecularAntiAliasingVariance;
    uniform real _SpecularAntiAliasingThreshold;
#endif

#if defined(_NORMALMAP)
    uniform samplerTexture _BumpMap;
    
    #if defined (_NORMALMAP_SCALE)
        uniform real _BumpScale;
    #endif
#endif

#if defined (_NORMALMAP_SHADOWS)
    uniform real _BumpShadowHeightScale;
    uniform real _BumpShadowHardness;
#endif

#if defined (_PARALLAX_MAPPING)
    uniform real _Parallax;
    uniform samplerTexture _ParallaxMap;
#endif

struct TerrainMaterialData
{
    real4 albedo;
    real smoothness;
    real metallic;
    real occlusion;
    real reflectance;

#if defined (_PARALLAX_MAPPING)
    real height;
#endif
};

void SampleTerrainMaterialData(real2 vector_uv, real4 splatControl, out TerrainMaterialData data)
{
    real4 albedoMap0 = tex2D(_Splat0, (vector_uv * _Splat0_ST.xy) + _Splat0_ST.zw);
    real4 albedoMap1 = tex2D(_Splat1, (vector_uv * _Splat1_ST.xy) + _Splat1_ST.zw);
    real4 albedoMap2 = tex2D(_Splat2, (vector_uv * _Splat2_ST.xy) + _Splat2_ST.zw);
    real4 albedoMap3 = tex2D(_Splat3, (vector_uv * _Splat3_ST.xy) + _Splat3_ST.zw);

    real4 albedoFinal = real4(0, 0, 0, 0);
    albedoFinal = lerp(albedoFinal, albedoMap0, splatControl.r);
    albedoFinal = lerp(albedoFinal, albedoMap1, splatControl.g);
    albedoFinal = lerp(albedoFinal, albedoMap2, splatControl.b);
    albedoFinal = lerp(albedoFinal, albedoMap3, splatControl.a);

//#if defined (_METALLICGLOSSMAP)
    //real4 maskMap = tex2D(_MetallicGlossMap, vector_uv);
//#else
    real4 maskMap = real4(0, 0, 0, 0);

    //real4 maskMap0 = tex2D(_Mask0, (vector_uv * _Splat0_ST.xy) + _Splat0_ST.zw);
    //real4 maskMap1 = tex2D(_Mask1, (vector_uv * _Splat1_ST.xy) + _Splat1_ST.zw);
    //real4 maskMap2 = tex2D(_Mask2, (vector_uv * _Splat2_ST.xy) + _Splat2_ST.zw);
    //real4 maskMap3 = tex2D(_Mask3, (vector_uv * _Splat3_ST.xy) + _Splat3_ST.zw);
    real4 maskMap0 = real4(1, 1, 1, 1);
    real4 maskMap1 = real4(1, 1, 1, 1);
    real4 maskMap2 = real4(1, 1, 1, 1);
    real4 maskMap3 = real4(1, 1, 1, 1);

    maskMap.r = lerp(maskMap.r, maskMap0.r * _Metallic0, splatControl.r);
    maskMap.r = lerp(maskMap.r, maskMap1.r * _Metallic1, splatControl.g);
    maskMap.r = lerp(maskMap.r, maskMap2.r * _Metallic2, splatControl.b);
    maskMap.r = lerp(maskMap.r, maskMap3.r * _Metallic3, splatControl.a);

    //maskMap.a = lerp(maskMap.a, _Smoothness0, splatControl.r);
    //maskMap.a = lerp(maskMap.a, _Smoothness1, splatControl.g);
    //maskMap.a = lerp(maskMap.a, _Smoothness2, splatControl.b);
    //maskMap.a = lerp(maskMap.a, _Smoothness3, splatControl.a);
    maskMap.a = lerp(maskMap.a, maskMap0.a * _Smoothness0, splatControl.r);
    maskMap.a = lerp(maskMap.a, maskMap1.a * _Smoothness1, splatControl.g);
    maskMap.a = lerp(maskMap.a, maskMap2.a * _Smoothness2, splatControl.b);
    maskMap.a = lerp(maskMap.a, maskMap3.a * _Smoothness3, splatControl.a);
    maskMap.a = 1 - maskMap.a;
//#endif

    data.albedo = albedoFinal;

#if defined (DEBUG_WHITE_ABLEDO)
    data.albedo = real4(1,1,1, data.albedo.a);
#endif

    data.reflectance = _Reflectance;

    //Custom Mask Mapping
    //R = Metallic  (Greyscale)
    //G = Roughness (Greyscale)
    //B = Height    (Greyscale)
    //A = AO        (Greyscale)
#ifdef PBR_MASK_CUSTOM
    data.smoothness = maskMap.g;
    data.metallic = maskMap.r;
    data.occlusion = maskMap.a;

    #if defined(_PARALLAX_MAPPING)
        data.height = maskMap.b;
    #endif
#endif

    //Unity HDRP Mask Mapping
    //R = Metallic    (Greyscale)
    //G = AO          (Greyscale)
    //B = Detail Mask (Greyscale)
    //A = Roughness   (Greyscale)
#ifdef PBR_MASK_UNITY_HDRP
    data.metallic = maskMap.r;
    data.smoothness = maskMap.a;
    data.occlusion = maskMap.g;
#endif

    //Unity Built In Pipeline Metallic Standard
    //R = Metallic    (Greyscale)
    //G = Metallic    (Greyscale)
    //B = Metallic    (Greyscale)
    //A = Roughness   (Greyscale)
#ifdef PBR_MASK_UNITY_METALLIC
    data.metallic = maskMap.r;
    data.smoothness = maskMap.a;
    data.occlusion = 1.0;

    #if defined(_PARALLAX_MAPPING)
        data.height = tex2D(_ParallaxMap, vector_uv).r;
    #endif
#endif

    //Unity URP Mask Mapping
    //R = Metallic    (Greyscale)
    //G = AO          (Greyscale)
    //B = None        (Greyscale)
    //A = Roughness   (Greyscale)
#ifdef PBR_MASK_UNITY_URP
    data.metallic = maskMap.r;
    data.smoothness = maskMap.a;
    data.occlusion = maskMap.g;

    #if defined(_PARALLAX_MAPPING)
        data.height = tex2D(_ParallaxMap, vector_uv).r;
    #endif
#endif

    //Unreal Packed Mask Mapping
    //R = AO        (Greyscale)
    //G = Roughness (Greyscale)
    //B = Metallic  (Greyscale)
    //A = None      (Greyscale)
#ifdef PBR_MASK_UNREAL
    data.occlusion = maskMap.r;
    data.smoothness = maskMap.g;
    data.metallic = maskMap.b;

    #if defined(_PARALLAX_MAPPING)
        data.height = tex2D(_ParallaxMap, vector_uv).r;
    #endif
#endif
}

/*
#ifdef _NORMALMAP
sampler2D _Normal0, _Normal1, _Normal2, _Normal3;
float _NormalScale0, _NormalScale1, _NormalScale2, _NormalScale3;
#endif
*/

#if defined(_NORMALMAP)
real3 SampleTerrainNormalMap(real2 vector_uv, real4 splatControl)
{
    real3 normalFinal = real3(0, 0, 0);

    #if defined (_NORMALMAP_SCALE)
        real3 normalMap0 = UnpackScaleNormal(tex2D(_Normal0, (vector_uv * _Splat0_ST.xy) + _Splat0_ST.zw), _NormalScale0);
        real3 normalMap1 = UnpackScaleNormal(tex2D(_Normal1, (vector_uv * _Splat1_ST.xy) + _Splat1_ST.zw), _NormalScale1);
        real3 normalMap2 = UnpackScaleNormal(tex2D(_Normal2, (vector_uv * _Splat2_ST.xy) + _Splat2_ST.zw), _NormalScale2);
        real3 normalMap3 = UnpackScaleNormal(tex2D(_Normal3, (vector_uv * _Splat3_ST.xy) + _Splat3_ST.zw), _NormalScale3);
    #else
        real3 normalMap0 = UnpackNormal(tex2D(_Normal0, (vector_uv * _Splat0_ST.xy) + _Splat0_ST.zw));
        real3 normalMap1 = UnpackNormal(tex2D(_Normal1, (vector_uv * _Splat1_ST.xy) + _Splat1_ST.zw));
        real3 normalMap2 = UnpackNormal(tex2D(_Normal2, (vector_uv * _Splat2_ST.xy) + _Splat2_ST.zw));
        real3 normalMap3 = UnpackNormal(tex2D(_Normal3, (vector_uv * _Splat3_ST.xy) + _Splat3_ST.zw));
    #endif

    normalFinal = lerp(normalFinal, normalMap0, splatControl.r);
    normalFinal = lerp(normalFinal, normalMap1, splatControl.g);
    normalFinal = lerp(normalFinal, normalMap2, splatControl.b);
    normalFinal = lerp(normalFinal, normalMap3, splatControl.a);

    return normalFinal;
}
#endif
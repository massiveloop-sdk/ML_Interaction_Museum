//Filamented Material Guide - https://google.github.io/filament/Material%20Properties.pdf
//added some macros around some of the effects, no use in declaring them if they are disabled

uniform samplerTexture _MainTex;
uniform samplerTexture _MetallicGlossMap;
uniform samplerTexture _OcclusionMap;

uniform real4 _MainTex_ST;

uniform real _Cutoff;
uniform real _Glossiness;
uniform real _Reflectance;
uniform real _Metallic;
uniform real _OcclusionStrength;
uniform real _ProcedualExposureOcclusion;

#if defined(USE_SPECULAR_AA)
    uniform real _SpecularAntiAliasingVariance;
    uniform real _SpecularAntiAliasingThreshold;
#endif

#if defined(_NORMALMAP)
    uniform samplerTexture _BumpMap;
    
    #if defined (_NORMALMAP_SCALE)
        uniform real _BumpScale;
    #endif
#endif

#if defined (USE_ALBEDO_COLOR_MULTIPLIER)
    uniform real4 _Color;
#endif

#if defined (_EMISSION)
    uniform samplerTexture _EmissionMap;
    uniform real4 _EmissionColor;
#endif

#if defined (_TRANSLUCENCY)
    uniform samplerTexture _ThicknessMap;
    uniform real4 _TranslucencyColor;
    uniform real _ThicknessPower;
    uniform real _TranslucencyDistortion;
    uniform real _TranslucencyScale;
    uniform real _TranslucencyPower;
    uniform real _TranslucencyAmbient;
    uniform real _TranslucencyShadowStrength;
#endif

#if defined (_ANISOTROPIC)
    uniform real _Anisotropy;
#endif

#if defined (_NORMALMAP_SHADOWS)
    uniform real _BumpShadowHeightScale;
    uniform real _BumpShadowHardness;
#endif

#if defined (_PARALLAX_MAPPING)
    uniform real _Parallax;
    uniform samplerTexture _ParallaxMap;
#endif

uniform real _RefractionOpacity;
uniform real _RefractionMip;
uniform real _RefractionDistortion;

struct MaterialData
{
    real4 albedo;
    real smoothness;
    real metallic;
    real occlusion;
    real reflectance;

#if defined (_NORMALMAP)
    real4 normal;
#endif

#if defined (_TRANSLUCENCY)
    real thickness;
#endif

#if defined (_ANISOTROPIC)
    real anisotropy;
#endif

#if defined (_PARALLAX_MAPPING)
    real height;
#endif

#if defined (_EMISSION)
    real3 emission;
#endif
};

void SampleMaterialData(real2 vector_uv, out MaterialData data)
{
    //FIX: Pre-Initalize the entire data structure (incase we missed anything)
    UNITY_INITIALIZE_OUTPUT(MaterialData, data);

#if defined (USE_ALBEDO_COLOR_MULTIPLIER)
    data.albedo = UBER_TEXTURE2D(_MainTex, vector_uv) * _Color;
#else
    data.albedo = UBER_TEXTURE2D(_MainTex, vector_uv);
#endif

#if defined (_METALLICGLOSSMAP)
    real4 maskMap = UBER_TEXTURE2D(_MetallicGlossMap, vector_uv);
#endif

    data.reflectance = _Reflectance;

#if defined (_NORMALMAP)
    //real4 normalMap = tex2D(_MetallicGlossMap, vector_uv);
    data.normal = real4(0, 0, 0, 0);
#endif

    //Custom Mask Mapping
    //R = Metallic  (Greyscale)
    //G = Roughness (Greyscale)
    //B = Height    (Greyscale)
    //A = AO        (Greyscale)
#ifdef PBR_MASK_CUSTOM
    #if defined (_METALLICGLOSSMAP)
        data.smoothness = maskMap.g * _Glossiness;
        data.metallic = maskMap.r * _Metallic;
        data.occlusion = maskMap.a;

        #if defined(_PARALLAX_MAPPING)
            data.height = maskMap.b;
        #endif
    #else
        data.smoothness = _Glossiness;
        data.metallic = _Metallic;
        data.occlusion = 1.0f;

        #if defined(_PARALLAX_MAPPING)
            data.height = 1.0f;
        #endif
    #endif
#endif

    //Unity HDRP Mask Mapping
    //R = Metallic    (Greyscale)
    //G = AO          (Greyscale)
    //B = Detail Mask (Greyscale)
    //A = Roughness   (Greyscale)
#ifdef PBR_MASK_UNITY_HDRP
    #if defined (_METALLICGLOSSMAP)
        data.metallic = maskMap.r * _Metallic;
        data.smoothness = (1 - maskMap.a) * _Glossiness;
        data.occlusion = maskMap.g;
    #else
        data.metallic = _Metallic;
        data.smoothness = _Glossiness;
        data.occlusion = 1.0f;
    #endif
#endif

    //Unity Built In Pipeline Metallic Standard
    //R = Metallic    (Greyscale)
    //G = Metallic    (Greyscale)
    //B = Metallic    (Greyscale)
    //A = Roughness   (Greyscale)
#ifdef PBR_MASK_UNITY_METALLIC
    #if defined (_METALLICGLOSSMAP)
        data.metallic = maskMap.r * _Metallic;
        data.smoothness = maskMap.a * _Glossiness;
    #else
        data.metallic = _Metallic;
        data.smoothness = _Glossiness;
    #endif

    data.occlusion = UBER_TEXTURE2D(_OcclusionMap, vector_uv);

    #if defined(_PARALLAX_MAPPING)
        data.height = UBER_TEXTURE2D(_ParallaxMap, vector_uv).r;
    #endif
#endif

    //Unity URP Mask Mapping
    //R = Metallic    (Greyscale)
    //G = AO          (Greyscale)
    //B = None        (Greyscale)
    //A = Roughness   (Greyscale)
#ifdef PBR_MASK_UNITY_URP
    #if defined (_METALLICGLOSSMAP)
        data.metallic = maskMap.r * _Metallic;
        data.smoothness = maskMap.a * _Glossiness;
        data.occlusion = maskMap.g;
    #else
        data.metallic = _Metallic;
        data.smoothness =  _Glossiness;
        data.occlusion = 1.0f;
    #endif

    #if defined(_PARALLAX_MAPPING)
        //data.height = tex2D(_ParallaxMap, vector_uv).r;
        data.height = UBER_TEXTURE2D(_ParallaxMap, vector_uv).r;
    #endif
#endif

    //Unreal Packed Mask Mapping
    //R = AO        (Greyscale)
    //G = Roughness (Greyscale)
    //B = Metallic  (Greyscale)
    //A = None      (Greyscale)
#ifdef PBR_MASK_UNREAL
    #if defined (_METALLICGLOSSMAP)
        data.occlusion = maskMap.r;
        data.smoothness = maskMap.g * _Glossiness;
        data.metallic = maskMap.b * _Metallic;
    #else
        data.occlusion = 1.0f;
        data.smoothness = _Glossiness;
        data.metallic = _Metallic;
    #endif

    #if defined(_PARALLAX_MAPPING)
        data.height = UBER_TEXTURE2D(_ParallaxMap, vector_uv).r;
    #endif
#endif

#ifdef _TRANSLUCENCY
    real thickness = 1.0 - UBER_TEXTURE2D(_ThicknessMap, vector_uv).r;
    data.thickness = pow(thickness, _ThicknessPower); //not a fan of this power term
#endif

#if defined(_EMISSION)
    data.emission = UBER_TEXTURE2D(_EmissionMap, vector_uv).rgb * _EmissionColor.rgb;
#endif

#if defined (_ANISOTROPIC)
    data.anisotropy = _Anisotropy;
#endif

//|||||||||||||||||||||||||||||||| DEBUG ||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||| DEBUG ||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||| DEBUG ||||||||||||||||||||||||||||||||

#if defined (DEBUG_DIFFUSE_WHITE_ABLEDO)
    data.albedo = real4(1, 1, 1, data.albedo.a);
#endif

#if defined (DEBUG_SPECULAR_SMOOTHNESS)
    data.smoothness = DEBUG_SPECULAR_SMOOTHNESS_VALUE;
#endif

#if defined (DEBUG_SPECULAR_METALLIC)
    data.metallic = DEBUG_SPECULAR_METALLIC_VALUE;
#endif
}


#if defined(_NORMALMAP)
real3 UnpackNormalMap(real4 packedNormalMap)
{
    return packedNormalMap.xyz * 2 - 1;
}

real3 UnpackNormalMapWithScale(real4 packednormal, real scale)
{
    real3 normal;
    normal.xy = (packednormal.xy * 2 - 1) * scale;
    normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
    return normal;
}

real3 SampleNormalMap(real2 uv)
{
    #if defined (_NORMALMAP_SCALE)
        //return UnpackNormalMapWithScale(tex2D(_BumpMap, uv.xy), _BumpScale);
        //return UnpackNormalWithScale(tex2D(_BumpMap, uv.xy), _BumpScale);
        return UnpackNormalWithScale(UBER_TEXTURE2D(_BumpMap, uv.xy), _BumpScale);
    #else
        //return UnpackNormalMap(tex2D(_BumpMap, uv.xy));
        //return UnpackNormal(tex2D(_BumpMap, uv.xy));
        return UnpackNormal(UBER_TEXTURE2D(_BumpMap, uv.xy));
    #endif
}
#endif

/*
//experimental normal map generation from height.
//doesn't really work in this case because ddx/ddy inherently use the screenspace to determine pixel deviation, not in texture space.
real3 NormalMapFromHeight(MaterialData data)
{
    //build the x and y from height
    real2 normal_xy = real2(ddx(data.height), ddy(data.height));

    //scale the xy normal to -1..1
    normal_xy = normal_xy * 2.0 - 1.0;

    //compute the z value
    real normal_z = sqrt(1.0f - (normal_xy.x * normal_xy.x + normal_xy.y * normal_xy.y));

    //combine the normals
    real3 normal_xyz = real3(normal_xy, normal_z);

    //scale the normal back to 0..1
    normal_xyz = normal_xyz * 0.5 + 0.5;

    return normal_xyz;
}
*/

//From: https://github.com/TwoTailsGames/Unity-Built-in-Shaders/blob/master/CGIncludes/UnityStandardConfig.cginc
//UNITY_SPECCUBE_LOD_STEPS = 6
//real PerceptualRoughnessToMipmapLevel(real perceptualRoughness)
//{
    //return perceptualRoughness * 6;
//}

/*
//From: https://github.com/TwoTailsGames/Unity-Built-in-Shaders/blob/master/CGIncludes/UnityStandardUtils.cginc
real3 BoxProjectedCubemapDirection(real3 worldRefl, real3 worldPos, real4 cubemapCenter, real4 boxMin, real4 boxMax)
{
    // Do we have a valid reflection probe?
    UNITY_BRANCH
        if (cubemapCenter.w > 0.0)
        {
            real3 nrdir = normalize(worldRefl);

#if 1
            real3 rbmax = (boxMax.xyz - worldPos) / nrdir;
            real3 rbmin = (boxMin.xyz - worldPos) / nrdir;

            real3 rbminmax = (nrdir > 0.0f) ? rbmax : rbmin;

#else // Optimized version
            real3 rbmax = (boxMax.xyz - worldPos);
            real3 rbmin = (boxMin.xyz - worldPos);

            real3 select = step(real3(0, 0, 0), nrdir);
            real3 rbminmax = lerp(rbmax, rbmin, select);
            rbminmax /= nrdir;
#endif

            real fa = min(min(rbminmax.x, rbminmax.y), rbminmax.z);

            worldPos -= cubemapCenter.xyz;
            worldRefl = worldPos + nrdir * fa;
        }
    return worldRefl;
}

//From: https://github.com/TwoTailsGames/Unity-Built-in-Shaders/blob/master/CGIncludes/UnityCG.cginc
real3 DecodeHDR(real4 data, real4 decodeInstructions)
{
    // Take into account texture alpha if decodeInstructions.w is true(the alpha value affects the RGB channels)
    real alpha = decodeInstructions.w * (data.a - 1.0) + 1.0;

    // If Linear mode is not supported we can skip exponent part
#if defined(UNITY_COLORSPACE_GAMMA)
    return (decodeInstructions.x * alpha) * data.rgb;
#else
#   if defined(UNITY_USE_NATIVE_HDR)
    return decodeInstructions.x * data.rgb; // Multiplier for future HDRI relative to absolute conversion.
#   else
    return (decodeInstructions.x * pow(alpha, decodeInstructions.y)) * data.rgb;
#   endif
#endif
}
*/
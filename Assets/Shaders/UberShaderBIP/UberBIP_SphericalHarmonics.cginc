/*
https://docs.unity3d.com/Manual/LightProbes-TechnicalInformation.html
https://docs.unity3d.com/ScriptReference/Rendering.SphericalHarmonicsL2.html
Unity uses third order Spherical harmonics.
- 3 bands, 9 coefficients

NOTES: For the ProbeVolumes, no need for multi-directionality depending on the normal vector.
Natrually we get multi-directionality since we are already sampling from multiple probes from a 3D texture.
Instead of with single only probes where we are trying to squeeze multi-directionality from a single probe.

------------------------------------------------------------------
- Unity SH lighting environment (SHADER/GPU)

- 7 float4's (28 floats)
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC; //The 4th channel for this is always 1

------------------------------------------------------------------
- Unity SH lighting environment (CPU)

- Constant + Linear
float4 unity_SHAr = float4(sh[0, 3], sh[0, 1], sh[0, 2], sh[0, 0] - sh[0, 6]);
float4 unity_SHAg = float4(sh[1, 3], sh[1, 1], sh[1, 2], sh[1, 0] - sh[1, 6]);
float4 unity_SHAb = float4(sh[2, 3], sh[2, 1], sh[2, 2], sh[2, 0] - sh[2, 6]);

- Quadratic polynomials
float4 unity_SHBr = float4(sh[0, 4], sh[0, 6], sh[0, 5] * 3, sh[0, 7]);
float4 unity_SHBg = float4(sh[1, 4], sh[1, 6], sh[1, 5] * 3, sh[1, 7]);
float4 unity_SHBb = float4(sh[2, 4], sh[2, 6], sh[2, 5] * 3, sh[2, 7]);

- Final quadratic polynomial
float4 unity_SHC = float4(sh[0, 8], sh[2, 8], sh[1, 8], 1);
------------------------------------------------------------------
- Recovering the raw SH coefficents from the Unity SH lighting environment
- 3 bands, 9 coefficients
- 27 total coefficents

- Band 1
float unity_sh_0_0 = unity_SHAr.a + unity_SHBr.g;
float unity_sh_0_1 = unity_SHAr.g;
float unity_sh_0_2 = unity_SHAr.b;
float unity_sh_0_3 = unity_SHAr.r;
float unity_sh_0_4 = unity_SHBr.r;
float unity_sh_0_5 = unity_SHBr.b / 3;
float unity_sh_0_6 = unity_SHBr.g;
float unity_sh_0_7 = unity_SHBr.a;
float unity_sh_0_8 = unity_SHC.r;

- Band 2
float unity_sh_1_0 = unity_SHAg.a + unity_SHBg.g;
float unity_sh_1_1 = unity_SHAg.g;
float unity_sh_1_2 = unity_SHAg.b;
float unity_sh_1_3 = unity_SHAg.r;
float unity_sh_1_4 = unity_SHBg.r;
float unity_sh_1_5 = unity_SHBg.b / 3;
float unity_sh_1_6 = unity_SHBg.g;
float unity_sh_1_7 = unity_SHBg.a;
float unity_sh_1_8 = unity_SHC.b;

- Band 3
float unity_sh_2_0 = unity_SHAb.a + unity_SHBb.g;
float unity_sh_2_1 = unity_SHAb.g;
float unity_sh_2_2 = unity_SHAb.b;
float unity_sh_2_3 = unity_SHAb.r;
float unity_sh_2_4 = unity_SHBb.r;
float unity_sh_2_5 = unity_SHBb.b / 3;
float unity_sh_2_6 = unity_SHBb.g;
float unity_sh_2_7 = unity_SHBb.a;
float unity_sh_2_8 = unity_SHC.g;

------------------------------------------------------------------
- Recovering the raw SH coefficents from the Unity SH lighting environment
- Same thing but in float array format
- 3 bands, 9 coefficients
- 27 total coefficents

- Band 1
float unity_sh_band1[9] =
{
    unity_SHAr.a + unity_SHBr.g,
    unity_SHAr.g,
    unity_SHAr.b,
    unity_SHAr.r,
    unity_SHBr.r,
    unity_SHBr.b / 3,
    unity_SHBr.g,
    unity_SHBr.a,
    unity_SHC.r
};

- Band 2
float unity_sh_band2[9] =
{
    unity_SHAg.a + unity_SHBg.g,
    unity_SHAg.g,
    unity_SHAg.b,
    unity_SHAg.r,
    unity_SHBg.r,
    unity_SHBg.b / 3,
    unity_SHBg.g,
    unity_SHBg.a,
    unity_SHC.b
};

- Band 3
float unity_sh_band3[9] =
{
    unity_SHAb.a + unity_SHBb.g,
    unity_SHAb.g,
    unity_SHAb.b,
    unity_SHAb.r,
    unity_SHBb.r,
    unity_SHBb.b / 3,
    unity_SHBb.g,
    unity_SHBb.a,
    unity_SHC.g
};

------------------------------------------------------------------
float3 unity_sh_0_0 = float3(unity_SHAr.a + unity_SHBr.g, unity_SHAg.a + unity_SHBg.g, unity_SHAb.a + unity_SHBb.g);
float3 unity_sh_0_1 = float3(unity_SHAr.g, unity_SHAg.g, unity_SHAb.g);
float3 unity_sh_0_2 = float3(unity_SHAr.b, unity_SHAg.b, unity_SHAb.b);
float3 unity_sh_0_3 = float3(unity_SHAr.r, unity_SHAg.r, unity_SHAb.r);
float3 unity_sh_0_4 = float3(unity_SHBr.r, unity_SHBg.r, unity_SHBb.r);
float3 unity_sh_0_5 = float3(unity_SHBr.b / 3, unity_SHBg.b / 3, unity_SHBb.b / 3);
float3 unity_sh_0_6 = float3(unity_SHBr.g, unity_SHBg.g, unity_SHBb.g);
float3 unity_sh_0_7 = float3(unity_SHBr.a, unity_SHBg.a, unity_SHBb.a);
float3 unity_sh_0_8 = float3(unity_SHC.r, unity_SHC.b, unity_SHC.g);

float3 unity_sh[9] =
{
    float3(unity_SHAr.a + unity_SHBr.g, unity_SHAg.a + unity_SHBg.g, unity_SHAb.a + unity_SHBb.g),
    float3(unity_SHAr.g, unity_SHAg.g, unity_SHAb.g),
    float3(unity_SHAr.b, unity_SHAg.b, unity_SHAb.b),
    float3(unity_SHAr.r, unity_SHAg.r, unity_SHAb.r),
    float3(unity_SHBr.r, unity_SHBg.r, unity_SHBb.r),
    float3(unity_SHBr.b / 3, unity_SHBg.b / 3, unity_SHBb.b / 3),
    float3(unity_SHBr.g, unity_SHBg.g, unity_SHBb.g),
    float3(unity_SHBr.a, unity_SHBg.a, unity_SHBb.a),
    float3(unity_SHC.r, unity_SHC.b, unity_SHC.g)
};

*/

//||||||||||||||||||||||||||||| SPHERICAL HARMONIC SHADING |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC SHADING |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC SHADING |||||||||||||||||||||||||||||
//Here contains main functions used to shade an object
// 
//NOTE 1: the normal vectors should be normalized
//NOTE 2: the normal vector needs to be a float4 with the "w" vector as 1 otherwise results get skewed.
//NOTE 3: this function is SH shading up to 2 orders.
real3 SphericalHarmonics_ComputeL0L1(real3 normal)
{
    // Linear (L1) + constant (L0) polynomial terms
    real3 x = real3(
        dot(unity_SHAr, real4(normal, 1)),
        dot(unity_SHAg, real4(normal, 1)),
        dot(unity_SHAb, real4(normal, 1))
    );

    return x;
}

//NOTE 3: this function is the 3rd order SH (which is added ontop of the previous 2 orders).
real3 SphericalHarmonics_ComputeL2(real3 normal)
{
    // 4 of the quadratic (L2) polynomials
    real4 vB = normal.xyzz * normal.yzzx;
    real3 x1 = real3(
        dot(unity_SHBr, vB),
        dot(unity_SHBg, vB),
        dot(unity_SHBb, vB)
    );

    // Final (5th) quadratic (L2) polynomial
    real vC = normal.x * normal.x - normal.y * normal.y;
    real3 x2 = unity_SHC.rgb * vC;

    return x1 + x2;
}

//NOTE 1: the normal vectors should be normalized
//NOTE 2: the normal vector needs to be a float4 with the "w" vector as 1 otherwise results get skewed.
real3 SphericalHarmonics_GetDiffuseLighting(real3 normal)
{
    //2 order SH shading
    real3 res = SphericalHarmonics_ComputeL0L1(normal); //Linear + constant polynomial terms

    //3 order SH shading
    #if defined (SPHERICAL_HARMONICS_BETTER_QUALITY)
        res += SphericalHarmonics_ComputeL2(normal); //Quadratic polynomials
    #endif

    #ifdef UNITY_COLORSPACE_GAMMA
        res = LinearToGammaSpace(res);
    #endif

    return res;
}

//NOTE 1: the normal vectors should be normalized
//NOTE 2: the normal vector needs to be a float4 with the "w" vector as 1 otherwise results get skewed.
//NOTE 3: this function is SH shading up to 2 orders.
real3 SphericalHarmonics_ProbeVolume_GetDiffuseLighting(real3 normal, real3 worldPos)
{
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------

    const real transformToLocal = unity_ProbeVolumeParams.y;
    const real texelSizeX = unity_ProbeVolumeParams.z;

    //The SH coefficients textures and probe occlusion are packed into 1 atlas.
    //-------------------------
    //| ShR | ShG | ShB | Occ |
    //-------------------------

    real3 position = (transformToLocal == 1.0f) ? mul(unity_ProbeVolumeWorldToObject, real4(worldPos, 1.0)).xyz : worldPos;
    real3 texCoord = (position - unity_ProbeVolumeMin.xyz) * unity_ProbeVolumeSizeInv.xyz;
    texCoord.x = texCoord.x * 0.25f;

    // We need to compute proper X coordinate to sample.
    // Clamp the coordinate otherwize we'll have leaking between RGB coefficients
    real texCoordX = clamp(texCoord.x, 0.5f * texelSizeX, 0.25f - 0.5f * texelSizeX);

    // sampler state comes from SHr (all SH textures share the same sampler)
    texCoord.x = texCoordX;
    real4 SHAr = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    texCoord.x = texCoordX + 0.25f;
    real4 SHAg = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    texCoord.x = texCoordX + 0.5f;
    real4 SHAb = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------

    // Linear (L1) + constant (L0) polynomial terms
    real3 x1 = real3(
        dot(SHAr, real4(normal, 1)),
        dot(SHAg, real4(normal, 1)),
        dot(SHAb, real4(normal, 1))
    );

    return x1;
}

//||||||||||||||||||||||||||||| SPHERICAL HARMONIC REFLECTIONS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC REFLECTIONS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC REFLECTIONS |||||||||||||||||||||||||||||
//experimental feature
//the idea is that if specular cubemaps are too expensive (or they are not avaliable)
//we can utilize the SH coefficents given to us, which are already a representation of the current enviorment but just at a really low fedelity.
//we use that instead as our proxy for the enviorment (downside of course is that its 3rd order SH so no chance of getting sharp specular highlights)
// 
//NOTE 1: the reflection vectors should be normalized
//NOTE 2: this function represents the SH enviorment up to 2/3 orders.
real3 SphericalHarmonics_GetEnviormentReflection(real3 reflectionDirection, real smoothness)
{
    //scale smoothness so we can more quickly sample the SH enviorment at better quality
    //we want to do this since again the SH enviorment even up to 3 orders is very low fedelity.
    //and of course the highest smoothness means razor sharp reflections.
    //since the SH is already low freqeuency we want to quickly scale up the reflections so that they look proper
    real3 adjustedReflectionDirection = reflectionDirection * saturate(smoothness * UNITY_PI);
    //real3 adjustedReflectionDirection = reflectionDirection * clamp(smoothness * UNITY_PI, 0, UNITY_PI);

    //compute 2nd order SH shading
    real3 reflection = SphericalHarmonics_ComputeL0L1(adjustedReflectionDirection); //Linear + constant polynomial terms

    //compute the 3rd order SH shading
    #if defined (SPHERICAL_HARMONICS_BETTER_QUALITY)
        reflection += SphericalHarmonics_ComputeL2(adjustedReflectionDirection); //Quadratic polynomials
    #endif

    reflection = max(0.0, reflection);

    return reflection;
}

//||||||||||||||||||||||||||||| SPHERICAL HARMONIC VECTORS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC VECTORS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC VECTORS |||||||||||||||||||||||||||||

real3 GetDominantSphericalHarmoncsDirection()
{
    //add the L1 bands from the spherical harmonics probe to get our direction.
    //real3 sphericalHarmonics_dominantDirection = unity_SHAr.xyz + unity_SHAg.xyz + unity_SHAb.xyz;

    //#if defined (SPHERICAL_HARMONICS_BETTER_QUALITY)
        //sphericalHarmonics_dominantDirection += unity_SHBr.xyz + unity_SHBg.xyz + unity_SHBb.xyz + unity_SHC; //add the L2 bands for better precision
    //#endif

    //Neitri proposed to use greyscale to get a better approximation of light direction from SH? (note it was only done on the L0 L1 bands)
    //https://github.com/netri/Neitri-Unity-Shaders/blob/master/Avatar%20Shaders/Core.cginc
    //real3 sphericalHarmonics_dominantDirection = unity_SHAr.xyz * 0.3 + unity_SHAg.xyz * 0.59 + unity_SHAb.xyz * 0.11;

    //#if defined (SPHERICAL_HARMONICS_BETTER_QUALITY)
        //sphericalHarmonics_dominantDirection += unity_SHBr.xyz * 0.3 + unity_SHBg.xyz * 0.59 + unity_SHBb.xyz * 0.11 + unity_SHC; //add the L2 bands for better precision
    //#endif

    //custom version of what Neitri proposes, instead of using arbitrary luma color values, use what is given to us which is unity_ColorSpaceLuminance
    real3 sphericalHarmonics_dominantDirection = unity_SHAr.xyz * unity_ColorSpaceLuminance.x + unity_SHAg.xyz * unity_ColorSpaceLuminance.y + unity_SHAb.xyz * unity_ColorSpaceLuminance.z;

    #if defined (SPHERICAL_HARMONICS_BETTER_QUALITY)
        sphericalHarmonics_dominantDirection += unity_SHBr.xyz * unity_ColorSpaceLuminance.x + unity_SHBg.xyz * unity_ColorSpaceLuminance.y + unity_SHBb.xyz * unity_ColorSpaceLuminance.z + unity_SHC; //add the L2 bands for better precision
    #endif

    return sphericalHarmonics_dominantDirection;
}

// normal should be normalized, w=1.0
real3 GetDominantSphericalHarmoncsProbeVolumeDirection(real3 worldPos)
{
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------

    const real transformToLocal = unity_ProbeVolumeParams.y;
    const real texelSizeX = unity_ProbeVolumeParams.z;

    //The SH coefficients textures and probe occlusion are packed into 1 atlas.
    //-------------------------
    //| ShR | ShG | ShB | Occ |
    //-------------------------

    real3 position = (transformToLocal == 1.0f) ? mul(unity_ProbeVolumeWorldToObject, real4(worldPos, 1.0)).xyz : worldPos;
    real3 texCoord = (position - unity_ProbeVolumeMin.xyz) * unity_ProbeVolumeSizeInv.xyz;
    texCoord.x = texCoord.x * 0.25f;

    // We need to compute proper X coordinate to sample.
    // Clamp the coordinate otherwize we'll have leaking between RGB coefficients
    real texCoordX = clamp(texCoord.x, 0.5f * texelSizeX, 0.25f - 0.5f * texelSizeX);

    // sampler state comes from SHr (all SH textures share the same sampler)
    texCoord.x = texCoordX;
    real4 SHAr = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    texCoord.x = texCoordX + 0.25f;
    real4 SHAg = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    texCoord.x = texCoordX + 0.5f;
    real4 SHAb = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------
    //-------------------------- UNITY PROBE VOLUME SAMPLING --------------------------

    //add the L1 bands from the spherical harmonics probe to get our direction.
    //real3 sphericalHarmonics_dominantDirection = SHAr.xyz + SHAg.xyz + SHAb.xyz;

    //Neitri proposed to use greyscale to get a better approximation of light direction from SH? (note it was only done on the L0 L1 bands)
    //https://github.com/netri/Neitri-Unity-Shaders/blob/master/Avatar%20Shaders/Core.cginc
    //real3 sphericalHarmonics_dominantDirection = SHAr.xyz * 0.3 + SHAg.xyz * 0.59 + SHAb.xyz * 0.11;

    //custom version of what Neitri proposes, instead of using arbitrary luma color values, use what is given to us which is unity_ColorSpaceLuminance
    real3 sphericalHarmonics_dominantDirection = SHAr.xyz * unity_ColorSpaceLuminance.x + SHAg.xyz * unity_ColorSpaceLuminance.y + SHAb.xyz * unity_ColorSpaceLuminance.z;

    return sphericalHarmonics_dominantDirection;
}

real3 GetMultipleSphericalHarmoncsDirection(real3 normal, real roughness)
{
    // SH lighting environment
    real4 SHAr = unity_SHAr;
    real4 SHAg = unity_SHAg;
    real4 SHAb = unity_SHAb;
    real4 SHBr = unity_SHBr;
    real4 SHBg = unity_SHBg;
    real4 SHBb = unity_SHBb;
    real4 SHC = unity_SHC;

    //------------------------------------------------------------------
    // Prompted ChatGPT 3.5 for this solution to smooth out the spherical harmonics that would cause a sharp line to appear in the inital solution
    // Low-pass filter the SH coefficients to smooth out the color
    SHAr = 0.25 * unity_SHAr + 0.5 * (unity_SHBr + unity_SHC.yzxw) + 0.25 * unity_SHC.zxyw;
    SHAg = 0.25 * unity_SHAg + 0.5 * (unity_SHBg + unity_SHC.yzwx) + 0.25 * unity_SHC.yzwx;
    SHAb = 0.25 * unity_SHAb + 0.5 * (unity_SHBb + unity_SHC.zxyw) + 0.25 * unity_SHC.xwyz;

    ///*
    //------------------------------------------------------------------
    // Prompted ChatGPT 3.5 for this solution to extract multi directional lights from an SH enviorment.
    // Calculate linear and quadratic SH terms
    real3 linSH = real3(
        dot(normal, SHAr.xyz),
        dot(normal, SHAg.xyz),
        dot(normal, SHAb.xyz));

    #if defined (SPHERICAL_HARMONICS_BETTER_QUALITY)
        real3 quadSH = real3(
            -dot(normal, SHBr.xyz),
            -dot(normal, SHBg.xyz),
            dot(normal, SHBb.xyz));

        // Calculate final SH color
        real3 shColor = max(0.03, 1 - roughness) * (SHC.xyz +
            linSH.x * SHAr.w * SHAr.xyz +
            linSH.y * SHAg.w * SHAg.xyz +
            linSH.z * SHAb.w * SHAb.xyz +
            quadSH.x * SHBr.w * SHBr.xyz +
            quadSH.y * SHBg.w * SHBg.xyz +
            quadSH.z * SHBb.w * SHBb.xyz);
    #else
        real3 shColor = max(0.03, 1 - roughness) * (SHC.xyz +
            linSH.x * SHAr.w * SHAr.xyz +
            linSH.y * SHAg.w * SHAg.xyz +
            linSH.z * SHAb.w * SHAb.xyz);
    #endif
    //*/

    //custom version of what Neitri proposes, instead of using arbitrary luma color values, use what is given to us which is unity_ColorSpaceLuminance
    //real3 shColor = SHAr.xyz * unity_ColorSpaceLuminance.x + SHAg.xyz * unity_ColorSpaceLuminance.y + SHAb.xyz * unity_ColorSpaceLuminance.z;

    //#if defined (SPHERICAL_HARMONICS_BETTER_QUALITY)
        //shColor += SHBr.xyz * unity_ColorSpaceLuminance.x + SHBg.xyz * unity_ColorSpaceLuminance.y + SHBb.xyz * unity_ColorSpaceLuminance.z + SHC; //add the L2 bands for better precision
    //#endif

    //shColor = normalize(shColor + normal);

    // Return the final SH color
    return shColor;
}
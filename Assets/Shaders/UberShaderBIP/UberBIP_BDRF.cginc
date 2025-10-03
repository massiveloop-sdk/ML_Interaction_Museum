struct BDRFOutput
{
    real3 diffuseResult;
    real3 specularResult;
};

//||||||||||||||||||||||||||||||||||| SPECULAR BDRF LUT |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| SPECULAR BDRF LUT |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| SPECULAR BDRF LUT |||||||||||||||||||||||||||||||||||
#if defined (USE_BDRF_LUT)
uniform samplerTexture _BDRF_LUT;

real3 F_Schlick_LUT(real u, real3 f0)
{
    real schlickLUT_F = tex2Dlod(_BDRF_LUT, real4(u, f0.r, 0.0, 0.0)).g;
    return schlickLUT_F + f0 * (1.0 - schlickLUT_F);
}

real D_GGX_LUT(real roughness, real NoH)
{
    return tex2Dlod(_BDRF_LUT, real4(roughness, NoH, 0.0, 0.0)).r;
}
#endif

//||||||||||||||||||||||||||||||||||| SPECULAR BDRF |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| SPECULAR BDRF |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| SPECULAR BDRF |||||||||||||||||||||||||||||||||||

//https://google.github.io/filament/Filament.html#materialsystem
//roughness = roughness value
//NoH = (Normal Direction) dot (Half Direction)
real D_GGX(real roughness, real NoH, const real3 n, const real3 h)
{
    #if defined (USE_BDRF_LUT)
        return D_GGX_LUT(roughness, NoH);
    #else
        real3 NxH = cross(n, h);
        real a = NoH * roughness;
        real k = roughness / (dot(NxH, NxH) + a * a);
        real d = k * k * (1.0 / MATH_PI);
        return saturateMediump(d);
    #endif
}

//https://google.github.io/filament/Filament.html#materialsystem
//NoV = (Normal Direction) dot (View Direction)
//NoL = (Normal Direction) dot (Light Direction)
//roughness = roughness value
real V_SmithGGXCorrelatedFast(real NoV, real NoL, real roughness)
{
    // Hammon 2017, "PBR Diffuse Lighting for GGX+Smith Microsurfaces"
    float v = 0.5 / lerp(2.0 * NoL * NoV, NoL + NoV, roughness);
    return saturateMediump(v);
}

//https://google.github.io/filament/Filament.html#materialsystem
//u = (View Direction) dot (Half Direction)
//f0 = Reflectance at normal incidence
real3 F_Schlick(real u, real3 f0)
{
    #if defined (USE_BDRF_LUT)
        real f = F_Schlick_LUT(u, f0);
    #else
        real f = pow(1.0 - u, 5.0);
    #endif

    real3 f90 = saturate(50.0 * f0); // cheap luminance approximation
    return f0 + (f90 - f0) * f;
}

real D_GGX_Anisotropic(real at, real ab, real ToH, real BoH, real NoH)
{
    // Burley 2012, "Physically-Based Shading at Disney"

    // The values at and ab are perceptualRoughness^2, a2 is therefore perceptualRoughness^4
    // The dot product below computes perceptualRoughness^8. We cannot fit in fp16 without clamping
    // the roughness to too high values so we perform the dot product and the division in fp32
    real a2 = at * ab;
    real3 d = real3(ab * ToH, at * BoH, a2 * NoH);
    real d2 = dot(d, d);
    real b2 = a2 / d2;
    return a2 * b2 * b2 * (1.0 / MATH_PI);
}

real V_SmithGGXCorrelated_Anisotropic(real at, real ab, real ToV, real BoV, real ToL, real BoL, real NoV, real NoL) 
{
    real lambdaV = NoL * length(real3(at * ToV, ab * BoV, NoV));
    real lambdaL = NoV * length(real3(at * ToL, ab * BoL, NoL));
    real v = 0.5 / (lambdaV + lambdaL);
    return saturateMediump(v);
}

//||||||||||||||||||||||||||||||||||| FINAL SPECULAR BDRF |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| FINAL SPECULAR BDRF |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| FINAL SPECULAR BDRF |||||||||||||||||||||||||||||||||||

real3 ComputeBDRF_SpecularResponse(real3 vector_normalDirection, real3 vector_viewDirection, real3 vector_lightDirection, real NdotL, real NdotV, real roughness, real3 f0)
{
    real3 vector_halfDirection = normalize(vector_viewDirection + vector_lightDirection.xyz);

    real NdotH = saturate(dot(vector_normalDirection, vector_halfDirection));
    real LdotH = saturate(dot(vector_lightDirection.xyz, vector_halfDirection));

    real specularVisibility = V_SmithGGXCorrelatedFast(NdotV, NdotL, roughness);
    real specularDistribution = D_GGX(roughness, NdotH, vector_normalDirection, vector_halfDirection);
    real3 specularFresnel = F_Schlick(LdotH, f0);
    real3 specularTerm = NdotL * (specularVisibility * specularDistribution) * specularFresnel;

    return max(0.0, specularTerm);
}

real3 ComputeBDRF_SpecularAnisotropicResponse(real3 vector_normalDirection, real3 vector_viewDirection, real3 vector_lightDirection, real NdotL, real NdotV, real TdotV, real BdotV, real roughness, real3 f0, real3 anisotropicT, real3 anisotropicB, real at, real ab)
{
    real3 vector_halfDirection = normalize(vector_viewDirection + vector_lightDirection.xyz);

    real NdotH = saturate(dot(vector_normalDirection, vector_halfDirection));
    real LdotH = saturate(dot(vector_lightDirection.xyz, vector_halfDirection));
    real TdotL = dot(anisotropicT, vector_lightDirection.xyz);
    real BdotL = dot(anisotropicB, vector_lightDirection.xyz);
    real TdotH = dot(anisotropicT, vector_halfDirection);
    real BdotH = dot(anisotropicB, vector_halfDirection);

    real specularVisibility = D_GGX_Anisotropic(at, ab, TdotH, BdotH, NdotH);
    real specularDistribution = V_SmithGGXCorrelated_Anisotropic(at, ab, TdotV, BdotV, TdotL, BdotL, NdotV, NdotL);

    real3 specularFresnel = F_Schlick(LdotH, f0);
    real3 specularTerm = NdotL * (specularVisibility * specularDistribution) * specularFresnel;

    return max(0.0, specularTerm);
}

//||||||||||||||||||||||||||||||||||| DIFFUSE BDRF |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| DIFFUSE BDRF |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| DIFFUSE BDRF |||||||||||||||||||||||||||||||||||

//https://google.github.io/filament/Filament.html#materialsystem
//tride and true classic lambert for diffuse
real Fd_Lambert()
{
    return 1.0 / MATH_PI;
}
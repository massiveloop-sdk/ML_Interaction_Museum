//||||||||||||||||||||||||||||||||||| TONEMAPS |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| TONEMAPS |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| TONEMAPS |||||||||||||||||||||||||||||||||||
//https://github.com/dmnsgn/glsl-tone-map

float3 tonemap_aces(float3 x)
{
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

float3 tonemap_reinhard(float3 x)
{
    return x / (1.0 + x);
}

float3 tonemap_reinhard2(float3 x)
{
    const float L_white = 4.0;

    return (x * (1.0 + x / (L_white * L_white))) / (1.0 + x);
}

float3 tonemap_unreal(float3 x)
{
    return x / (x + 0.155) * 1.019;
}

//has pow operations, might be expensive
float3 tonemap_filmic(float3 x)
{
    float3 X = max(float3(0.0, 0.0, 0.0), x - 0.004);
    float3 result = (X * (6.2 * X + 0.5)) / (X * (6.2 * X + 1.7) + 0.06);
    return pow(result, float3(2.2, 2.2, 2.2));
}

//has tons of pow operations, might be the most expensive one
float3 tonemap_lottes(float3 x)
{
    const float3 a = float3(1.6, 1.6, 1.6);
    const float3 d = float3(0.977, 0.977, 0.977);
    const float3 hdrMax = float3(8.0, 8.0, 8.0);
    const float3 midIn = float3(0.18, 0.18, 0.18);
    const float3 midOut = float3(0.267, 0.267, 0.267);

    float3 b = (-pow(midIn, a) + pow(hdrMax, a) * midOut) / ((pow(hdrMax, a * d) - pow(midIn, a * d)) * midOut);
    float3 c = (pow(hdrMax, a * d) * pow(midIn, a) - pow(hdrMax, a) * pow(midIn, a * d) * midOut) / ((pow(hdrMax, a * d) - pow(midIn, a * d)) * midOut);

    return pow(x, a) / (pow(x, a * d) * b + c);
}

float3 tonemap(float3 input)
{
#if defined (TONEMAP_ACES)
    return tonemap_aces(input * TONEMAP_EXPOSURE);
#endif

#if defined (TONEMAP_REINHARD)
    return tonemap_reinhard(input * TONEMAP_EXPOSURE);
#endif

#if defined (TONEMAP_REINHARD2)
    return tonemap_reinhard2(input * TONEMAP_EXPOSURE);
#endif

#if defined (TONEMAP_UNREAL)
    return tonemap_unreal(input * TONEMAP_EXPOSURE);
#endif

#if defined (TONEMAP_FILMIC)
    return tonemap_filmic(input * TONEMAP_EXPOSURE);
#endif

#if defined (TONEMAP_LOTTES)
    return tonemap_lottes(input * TONEMAP_EXPOSURE);
#endif
}
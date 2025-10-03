//||||||||||||||||||||||||||||||||||| SPECULAR ANTI ALIASING |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| SPECULAR ANTI ALIASING |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| SPECULAR ANTI ALIASING |||||||||||||||||||||||||||||||||||
//This function is to help prevent aliasing caused by specular highlights.

#if defined (USE_SPECULAR_AA)
real normalFiltering(real perceptualRoughness, const real3 worldNormal)
{
    // Kaplanyan 2016, "Stable specular highlights"
    // Tokuyoshi 2017, "Error Reduction and Simplification for Shading Anti-Aliasing"
    // Tokuyoshi and Kaplanyan 2019, "Improved Geometric Specular Antialiasing"

    // This implementation is meant for deferred rendering in the original paper but
    // we use it in forward rendering as well (as discussed in Tokuyoshi and Kaplanyan
    // 2019). The main reason is that the forward version requires an expensive transform
    // of the half vector by the tangent frame for every light. This is therefore an
    // approximation but it works well enough for our needs and provides an improvement
    // over our original implementation based on Vlachos 2015, "Advanced VR Rendering".

    real3 du = ddx(worldNormal);
    real3 dv = ddy(worldNormal);

    real variance = _SpecularAntiAliasingVariance * (dot(du, du) + dot(dv, dv));

    real roughness = perceptualRoughness * perceptualRoughness;
    real kernelRoughness = min(2.0 * variance, _SpecularAntiAliasingThreshold);
    real squareRoughness = saturate(roughness * roughness + kernelRoughness);

    return sqrt(sqrt(squareRoughness));
}
#endif

//||||||||||||||||||||||||||||||||||| MICRO SHADOWING |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| MICRO SHADOWING |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| MICRO SHADOWING |||||||||||||||||||||||||||||||||||
//Helps add extra contrast to direct lighting when shading with normal maps (REQUIRES AN AMBIENT OCCLUSION MAP)
//Reference - Chan 2018, "Material Advances in Call of Duty: WWII"

#if defined (_MICRO_SHADOWING)
real computeMicroShadowing(real NoL, real visibility) 
{
    real aperture = rsqrt(1.0 - visibility);
    real microShadow = saturate(NoL * aperture);
    return microShadow * microShadow;
}
#endif

//||||||||||||||||||||||||||||||||||| NORMAL MAP SHADOWS |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| NORMAL MAP SHADOWS |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| NORMAL MAP SHADOWS |||||||||||||||||||||||||||||||||||
//Computes shadows for direct lighting just from a normal map, no height map
//Reference - Normal Mapping Shadows by Boris Vorontsov - http://enbdev.com/doc_normalmappingshadows.htm

#if defined(_NORMALMAP) && defined(_NORMALMAP_SHADOWS)

// n must be normalized in [0..1] (e.g. texture coordinates)
real triangleNoise(real2 n)
{
	// triangle noise, in [-1.0..1.0[ range
	n = frac(n * real2(5.3987, 5.4421));
	n += dot(n.yx, n.xy + real2(21.5351, 14.3137));

	real xy = n.x * n.y;
	// compute in [0..2[ and remap to [-1.0..1.0[
	return frac(xy * 95.4307) + frac(xy * 75.04961) - 1.0;
}

// n must not be normalize (e.g. window coordinates)
real interleavedGradientNoise(real2 n)
{
	return frac(52.982919 * frac(dot(real2(0.06711, 0.00584), n)));
}

#if !defined (TERRAIN_MODE)
real NormalMapShadows(real3 lightDirectionTangentSpace, real2 uv, real noise)
{
	const real shadowHardness = _BumpShadowHeightScale * _BumpShadowHardness;
	const real shadowSampleStepSize = 1.0 / NORMAL_MAP_SHADOW_SAMPLES;

	real2 rayDirection = lightDirectionTangentSpace.xy * _BumpShadowHeightScale;
	real3 normal = normalize(SampleNormalMap(uv));

	lightDirectionTangentSpace = normalize(lightDirectionTangentSpace);
	real tangentNdotL = saturate(dot(lightDirectionTangentSpace, normal));
	real rayCurrentSample = shadowSampleStepSize - shadowSampleStepSize * noise;

	//skip backfaces
	rayCurrentSample += (tangentNdotL <= 0.0);

	//From the PDF:
	//Trace from hit point to light direction and compute sum of dot products
	//between normal map and light direction.
	//If slope is bigger than 0, pixel is shadowed. If slope is also bigger
	//than previous maximal value, increase hardness of shadow.

	real result = 0;
	real slope = -tangentNdotL;
	real maxslope = 0.0;

	while (rayCurrentSample <= 1.0)
	{
		normal = SampleNormalMap(uv + rayDirection * rayCurrentSample);
		tangentNdotL = dot(lightDirectionTangentSpace, normal);
		slope = slope - tangentNdotL;

		if (slope > maxslope)
		{
			result += shadowHardness * (1.0 - rayCurrentSample);
		}

		maxslope = max(maxslope, slope);
		rayCurrentSample += shadowSampleStepSize;
	}

	return result * shadowSampleStepSize;
}

real NormalTangentShadow(real2 uv, real3 lightDirectionTangentSpace, real noise)
{
	#if defined (NORMAL_MAP_SHADOW_USE_NOISE)
		real newNoise = triangleNoise(uv * 1.0) * 1.0;
	#else
		real newNoise = 1.0f;
	#endif

	return NormalMapShadows(lightDirectionTangentSpace, uv, newNoise);
}
#endif

#if defined (TERRAIN_MODE)
real TerrainNormalMapShadows(real3 lightDirectionTangentSpace, real2 uv, real noise, real4 splatControl)
{
	const real shadowHardness = _BumpShadowHeightScale * _BumpShadowHardness;
	const real shadowSampleStepSize = 1.0 / NORMAL_MAP_SHADOW_SAMPLES;

	real2 rayDirection = lightDirectionTangentSpace.xy * _BumpShadowHeightScale;
	real3 normal = normalize(SampleTerrainNormalMap(uv, splatControl));

	lightDirectionTangentSpace = normalize(lightDirectionTangentSpace);
	real tangentNdotL = saturate(dot(lightDirectionTangentSpace, normal));
	real rayCurrentSample = shadowSampleStepSize - shadowSampleStepSize * noise;

	//skip backfaces
	rayCurrentSample += (tangentNdotL <= 0.0);

	//From the PDF:
	//Trace from hit point to light direction and compute sum of dot products
	//between normal map and light direction.
	//If slope is bigger than 0, pixel is shadowed. If slope is also bigger
	//than previous maximal value, increase hardness of shadow.

	real result = 0;
	real slope = -tangentNdotL;
	real maxslope = 0.0;

	while (rayCurrentSample <= 1.0)
	{
		normal = SampleTerrainNormalMap(uv + rayDirection * rayCurrentSample, splatControl);
		tangentNdotL = dot(lightDirectionTangentSpace, normal);
		slope = slope - tangentNdotL;

		if (slope > maxslope)
		{
			result += shadowHardness * (1.0 - rayCurrentSample);
		}

		maxslope = max(maxslope, slope);
		rayCurrentSample += shadowSampleStepSize;
	}

	return result * shadowSampleStepSize;
}

real TerrainNormalTangentShadow(real2 uv, real3 lightDirectionTangentSpace, real noise, real4 splatControl)
{
#if defined (NORMAL_MAP_SHADOW_USE_NOISE)
	real newNoise = triangleNoise(uv * 1.0) * 1.0;
#else
	real newNoise = 1.0f;
#endif

	return TerrainNormalMapShadows(lightDirectionTangentSpace, uv, newNoise, splatControl);
}
#endif
#endif

//||||||||||||||||||||||||||||||||||| PARALLAX MAPPING |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| PARALLAX MAPPING |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| PARALLAX MAPPING |||||||||||||||||||||||||||||||||||

#if defined (_PARALLAX_MAPPING)
struct PerPixelHeightDisplacementParam
{
	real2 uv;
	real2 dX;
	real2 dY;
};

PerPixelHeightDisplacementParam InitPerPixelHeightDisplacementParam(real2 uv)
{
	PerPixelHeightDisplacementParam ppd;

	ppd.uv = uv;
	ppd.dX = ddx(uv);
	ppd.dY = ddy(uv);

	return ppd;
}

real ComputePerPixelHeightDisplacement(real2 offset, real lod, PerPixelHeightDisplacementParam ppdParam)
{
	real height = 1;
	real strength = _Parallax;

	// Probably can use LOD to skip reading if too far
	height = tex2Dgrad(_ParallaxMap, ppdParam.uv + offset, ppdParam.dX, ppdParam.dY).g;

	height = clamp(height, 0, 0.9999);

	return height;
}

#if !defined (CHEAP_PARALLAX)
real2 ParallaxRaymarching(real2 viewDir, PerPixelHeightDisplacementParam ppdParam, real strength)
{
    real2 uvOffset = 0;
    const real stepSize = 1.0 / PARALLAX_RAYMARCH_SAMPLES;
    real2 uvDelta = viewDir * (stepSize * strength);

    real stepHeight = 1;
    real surfaceHeight = ComputePerPixelHeightDisplacement(0, 0, ppdParam);

    real2 prevUVOffset = uvOffset;
    real prevStepHeight = stepHeight;
    real prevSurfaceHeight = surfaceHeight;

    for (int i = 1; i < PARALLAX_RAYMARCH_SAMPLES && stepHeight > surfaceHeight; i++)
    {
        prevUVOffset = uvOffset;
        prevStepHeight = stepHeight;
        prevSurfaceHeight = surfaceHeight;

        uvOffset -= uvDelta;
        stepHeight -= stepSize;
        surfaceHeight = ComputePerPixelHeightDisplacement(uvOffset, 0, ppdParam);
    }

    real prevDifference = prevStepHeight - prevSurfaceHeight;
    real difference = surfaceHeight - stepHeight;
    real t = prevDifference / (prevDifference + difference);
    uvOffset = prevUVOffset - uvDelta * t;

    //outHeight = surfaceHeight; //output height
    return uvOffset;
}
#endif

real4 Parallax(real4 texcoords, real3 viewDir)
{
	float parallaxHeight = _Parallax;

	#if defined (CHEAP_PARALLAX)
		parallaxHeight *= 0.5; //arbitrary, but halving the height for the cheap version seems better consistly when comparing with the raymarched version

		real h = tex2D(_ParallaxMap, texcoords.xy).g;
		real2 offset = ParallaxOffset1Step(h, parallaxHeight, viewDir);
		return real4(texcoords.xy + offset, texcoords.zw + offset);
	#else
		PerPixelHeightDisplacementParam ppd = InitPerPixelHeightDisplacementParam(texcoords.xy);
		viewDir.xy /= (viewDir.z + 0.42);
		real2 offset = ParallaxRaymarching(viewDir, ppd, parallaxHeight);
		return real4(texcoords.xy + offset, texcoords.zw + offset);
	#endif
}
#endif

//||||||||||||||||||||||||||||||||||| TRANSLUCENCY |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| TRANSLUCENCY |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| TRANSLUCENCY |||||||||||||||||||||||||||||||||||
//frostbite translucency - https://colinbarrebrisebois.com/2011/03/07/gdc-2011-approximating-translucency-for-a-fast-cheap-and-convincing-subsurface-scattering-look/

#if defined (_TRANSLUCENCY)
real3 ComputeTranslucency(real3 vector_viewDirection, real3 vector_normalDirection, real3 vector_lightDirection, MaterialData materialData)
{
	real3 translucencyLightVector = vector_lightDirection + vector_normalDirection * _TranslucencyDistortion;
	real translucencyDot = saturate(pow(max(0.0, dot(vector_viewDirection, -translucencyLightVector)), _TranslucencyPower)) * _TranslucencyScale;
	real3 translucencyTerm = _TranslucencyColor.rgb * (translucencyDot + _TranslucencyAmbient) * materialData.thickness;

	return translucencyTerm;
}
#endif

//||||||||||||||||||||||||||||||||||| LIGHTING |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| LIGHTING |||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||| LIGHTING |||||||||||||||||||||||||||||||||||

void ComputeLightDirectionAndAttenuation(real3 vector_worldPosition, bool directional, out real3 vector_lightDirection, out real lightAttenuation)
{
	if (directional)
	{
		//get primary realtime light direction vector.
		vector_lightDirection = normalize(_WorldSpaceLightPos0.xyz); //world space light position direction

		lightAttenuation = 1.0f;
	}
	else
	{
		//realtime light attenuation and shadows.
		//get primary realtime light direction vector.
		real3 vector_positionToLight = _WorldSpaceLightPos0;
		real distanceToLight = dot(vector_worldPosition, vector_worldPosition);

		// don't produce NaNs if some vertex position overlaps with the light
		distanceToLight = max(distanceToLight, 0.000001);
		distanceToLight *= rsqrt(distanceToLight);

		//realtime light attenuation.
		//real lightAttenuation = 1.0 / (1.0 + distanceToLight) * LIGHT_ATTENUATION(i);
		//lightAttenuation = 1.0 / (1.0 + distanceToLight);
		//lightAttenuation = 1.0 / (distanceToLight);
		//lightAttenuation = distanceToLight;
		//lightAttenuation = 1.0f / (distanceToLight + 1.0);
		lightAttenuation = 1.0f / distanceToLight;
		vector_lightDirection = normalize(vector_positionToLight);
	}
}

real3 ComputeVertexDiffuseLighting(real3 vector_normal, real3 vector_worldPosition, bool directional)
{
	real lightAttenuation = 1.0;
	real3 vector_lightDirection = real3(0, 0, 0);

	if (directional)
	{
		//get primary realtime light direction vector.
		vector_lightDirection = normalize(_WorldSpaceLightPos0.xyz); //world space light position direction
	}
	else
	{
		//realtime light attenuation and shadows.
		//get primary realtime light direction vector.
		real3 vector_positionToLight = _WorldSpaceLightPos0.xyz - vector_worldPosition;
		real distanceToLight = dot(vector_positionToLight, vector_positionToLight);

		// don't produce NaNs if some vertex position overlaps with the light
		distanceToLight = max(distanceToLight, 0.000001);
		distanceToLight *= rsqrt(distanceToLight);

		//realtime light attenuation.
		//real lightAttenuation = 1.0 / (1.0 + distanceToLight) * LIGHT_ATTENUATION(i);
		lightAttenuation = 1.0 / (1.0 + distanceToLight);
		vector_lightDirection = normalize(vector_positionToLight);
	}

	//calculate primary dot product for realtime light.
	real NdotL = saturate(dot(vector_normal, vector_lightDirection));

	//compute diffuse lighting
	return NdotL * Fd_Lambert() * _LightColor0.rgb * lightAttenuation;
}








//||||||||||||||||||||||||||||| UNITY BOX PROJECTION |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| UNITY BOX PROJECTION |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| UNITY BOX PROJECTION |||||||||||||||||||||||||||||
// Slightly modified version of unity's original box projected function to output the hit distance

inline float3 UnityBoxProjectedCubemapDirection(float3 worldRefl, float3 worldPos, float4 cubemapCenter, float4 boxMin, float4 boxMax, out float distanceToHitPoint)
{
	// Do we have a valid reflection probe?
	UNITY_BRANCH
	if (cubemapCenter.w > 0.0)
	{
		float3 nrdir = normalize(worldRefl);

		#if 1
			float3 rbmax = (boxMax.xyz - worldPos) / nrdir;
			float3 rbmin = (boxMin.xyz - worldPos) / nrdir;

			float3 rbminmax = (nrdir > 0.0f) ? rbmax : rbmin;

		#else // Optimized version
			float3 rbmax = (boxMax.xyz - worldPos);
			float3 rbmin = (boxMin.xyz - worldPos);

			float3 select = step(float3(0, 0, 0), nrdir);
				float3 rbminmax = lerp(rbmax, rbmin, select);
				rbminmax /= nrdir;
		#endif

		distanceToHitPoint = min(min(rbminmax.x, rbminmax.y), rbminmax.z);

		worldPos -= cubemapCenter.xyz;
		worldRefl = worldPos + nrdir * distanceToHitPoint;
	}

	return worldRefl;
}
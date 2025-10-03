/*
* NOTES: This is the main config file for the ubershader.
* Normally for some of these settings, they should be set in the unity graphics settings... but I wanted to grant more control so here we are.
*/

//IMPORTANT
//This define here, when enabled it will quickly set the "preset" settings to the mobile target.
//To set it for the desktop target then comment the define out
//#define TARGET_MOBILE

//||||||||||||||||||||||||||||| SHADER SETTINGS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SHADER SETTINGS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SHADER SETTINGS |||||||||||||||||||||||||||||
//CUSTOM DEFINES, THESE ARE MEANT TO BE SET GLOBALLY AND NOT THROUGH THE MATERIAL INTERFACE
//THESE ALSO ARE NOT COMPILED AS KEYWORDS

//calculating classic unity fog
//#define CALCULATE_FOG

//generally mobile shaders don't have a color multiplier as its adding extra uneeded instructions
#define USE_ALBEDO_COLOR_MULTIPLIER

//for baked lightmaps/enlighten, use an ndotl wrap term for less contrast 
//note: enabling this also disables normal map shadows on baked/dynamic lightmaps.
//mostly because it doesn't really do anything since its way less contrast, so not worth the extra cost (which also makes this cheaper)
//#define LIGHTMAPPING_USE_NDOTL_WRAP

//enabling this means that when we sample textures, we sample using tex2Dbias instead of tex2D.
//this samples the texture with a bias factor, which can be used to sharpen or blur textures at a distance.
//(positive values = blurier at a distance | negative values = sharper at a distance)
#define TEXTURE_SAMPLING_BIAS
#define TEXTURE_SAMPLING_BIAS_FACTOR -1

//uses super sampling for reduced aliasing/improved sharpness for texture sampling at a distance
//NOTE: This will mean that textures get sampled 4x instead of 1x, which can impact performance
//stolen reference - https://bgolus.medium.com/sharper-mipmapping-using-shader-based-supersampling-ed7aadb47bec
//#define TEXTURE_SAMPLING_BIAS_USE_SS

//uses 2x2 rotated grid super sampling for reduced aliasing/improved sharpness for texture sampling at a distance
//NOTE: This will mean that textures get sampled 4x instead of 1x, which can impact performance
//stolen reference - https://bgolus.medium.com/sharper-mipmapping-using-shader-based-supersampling-ed7aadb47bec
#define TEXTURE_SAMPLING_BIAS_USE_RGSS

//custom implementation
//attempts to fix the problem with box projected reflections that have consistent roughness
//so reflections that are closer to the surface will appear sharper than those farther away
#define REFLECTION_PROBE_CONTACT_HARDENING

//experimental feature
//the idea is that if specular cubemaps are too expensive (or they are not avaliable)
//we can utilize light probe data given to us (which are SH coefficents), and in theory they are already a representation of the current enviorment.
//the caveat to this being that since its a light probe the represenation of the enviorment is at a really low fedelity. (its 3rd order SH so no chance of getting sharp specular highlights)
//so we use that instead as our proxy for the enviorment reflections
//#define USE_SH_GLOSSY_REFLECTIONS

// - DIFFUSE DEBUGGING
//#define DEBUG_DIFFUSE_WHITE_ABLEDO
//#define DEBUG_DIFFUSE_ONLY
// - SPECULAR DEBUGGING
//#define DEBUG_SPECULAR_SMOOTHNESS
//#define DEBUG_SPECULAR_METALLIC
//#define DEBUG_SPECULAR_ONLY
#define DEBUG_SPECULAR_SMOOTHNESS_VALUE 0.9
#define DEBUG_SPECULAR_METALLIC_VALUE 1.0

//||||||||||||||||||||||||||||| MOBILE SHADER CONFIGURATION |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| MOBILE SHADER CONFIGURATION |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| MOBILE SHADER CONFIGURATION |||||||||||||||||||||||||||||

//these can be used to forcibly disable features on the uber shader, this will be helpful for mobile optimization
#if defined (TARGET_MOBILE)
	//||||||||||||||||||||||||||||| ALLOW FEATURES |||||||||||||||||||||||||||||
	//||||||||||||||||||||||||||||| ALLOW FEATURES |||||||||||||||||||||||||||||
	//||||||||||||||||||||||||||||| ALLOW FEATURES |||||||||||||||||||||||||||||
	//these are compiled as keywords, which contributes to multiple shader variants

	//#define ALLOW_LOD_CROSSFADING //uses a clip to discard pixels, not really cool with this for performance reasons on mobile
	//#define ALLOW_BOX_PROJECTED_REFLECTIONS	
	//#define ALLOW_LIGHT_PROBE_PROXY_VOLUMES
	//#define ALLOW_DYNAMICLIGHTMAP_ON
	#define ALLOW_DIRLIGHTMAP_COMBINED
	#define ALLOW_GLOSSY_REFLECTIONS
	#define ALLOW_SPECULAR_HIGHLIGHTS
	#define ALLOW_NORMALMAP //is rather expensive on mobile
	//#define ALLOW_TRANSLUCENCY
	//#define ALLOW_ANISOTROPIC
	#define ALLOW_SPECULAR_OCCLUSION
	#define ALLOW_MICRO_SHADOWING
	//#define ALLOW_NORMALMAP_SCALE
	//#define ALLOW_NORMALMAP_SHADOWS //DISABLE FOR MOBILE, REALLY EXPENSIVE
	//#define ALLOW_PARALLAX_MAPPING //DISABLE FOR MOBILE, REALLY EXPENSIVE

	//||||||||||||||||||||||||||||| OPTIONS |||||||||||||||||||||||||||||
	//||||||||||||||||||||||||||||| OPTIONS |||||||||||||||||||||||||||||
	//||||||||||||||||||||||||||||| OPTIONS |||||||||||||||||||||||||||||
	//these are not compiled as keywords, so they don't contribute to multiple shader variants

	#define CHEAP_PARALLAX //does a single step parallax, much cheaper than raymarch but more prone to artifacts (perhaps we can implement a distance fade?)
	#define PARALLAX_RAYMARCH_SAMPLES 1
	#define NORMAL_MAP_SHADOW_SAMPLES 16
	//#define NORMAL_MAP_SHADOW_USE_NOISE

	//use a LUT for GGX and Schlick to save on computation.
	#define USE_BDRF_LUT

	//use specular anti-aliasing
	//#define USE_SPECULAR_AA

	//enable SH shading up to 3 orders (instead of 2)
	//when doing spherical harmonics use all the terms (constant, linear, and polynomials terms)
	//if not then it will be simplified and only use the constant linear terms
	//#define SPHERICAL_HARMONICS_BETTER_QUALITY

	//when doing spherical harmonics, use a multi-directional term rather than a single dominant direction.
	//it looks great but is not as performant as a single dominant direction.
	//#define SPHERICAL_HARMONICS_MULTI_DIRECTIONAL

	//enables a slightly higher quality approxmimation for specular highlights for spherical harmonics and baked lightmaps with directionality.
	//uses a sqrt() operation for modifying roughness value and a division operator for dividing directionality by the length
	//implementation source - https://media.contentapi.ea.com/content/dam/eacom/frostbite/files/gdc2018-precomputedgiobalilluminationinfrostbite.pdf
	//#define HIGHER_QUALITY_BAKED_SPECULAR

	#define REALTIME_LIGHTING_PERVERTEX_DIFFUSE //NOTE: ATTENUATION ISSUE WITH SPOT LIGHTS
	//#define REALTIME_LIGHTING_PERPIXEL_DIFFUSE
	//#define REALTIME_LIGHTING_PERPIXEL_SPECULAR
#else
//||||||||||||||||||||||||||||| DESKTOP SHADER CONFIGURATION |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| DESKTOP SHADER CONFIGURATION |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| DESKTOP SHADER CONFIGURATION |||||||||||||||||||||||||||||

	//||||||||||||||||||||||||||||| ALLOW FEATURES |||||||||||||||||||||||||||||
	//||||||||||||||||||||||||||||| ALLOW FEATURES |||||||||||||||||||||||||||||
	//||||||||||||||||||||||||||||| ALLOW FEATURES |||||||||||||||||||||||||||||
	//these are compiled as keywords, which contributes to multiple shader variants

	#define ALLOW_LOD_CROSSFADING //uses a clip to discard pixels, not really cool with this for performance reasons on mobile
	#define ALLOW_BOX_PROJECTED_REFLECTIONS	
	#define ALLOW_LIGHT_PROBE_PROXY_VOLUMES
	#define ALLOW_DYNAMICLIGHTMAP_ON
	#define ALLOW_DIRLIGHTMAP_COMBINED
	#define ALLOW_GLOSSY_REFLECTIONS
	#define ALLOW_SPECULAR_HIGHLIGHTS
	#define ALLOW_NORMALMAP
	#define ALLOW_TRANSLUCENCY
	#define ALLOW_ANISOTROPIC
	#define ALLOW_SPECULAR_OCCLUSION
	#define ALLOW_MICRO_SHADOWING
	#define ALLOW_NORMALMAP_SCALE
	#define ALLOW_NORMALMAP_SHADOWS //DISABLE FOR MOBILE, REALLY EXPENSIVE
	#define ALLOW_PARALLAX_MAPPING //DISABLE FOR MOBILE, REALLY EXPENSIVE

	//||||||||||||||||||||||||||||| OPTIONS |||||||||||||||||||||||||||||
	//||||||||||||||||||||||||||||| OPTIONS |||||||||||||||||||||||||||||
	//||||||||||||||||||||||||||||| OPTIONS |||||||||||||||||||||||||||||
	//these are not compiled as keywords, so they don't contribute to multiple shader variants

	//#define CHEAP_PARALLAX //does a single step parallax, much cheaper than raymarch but more prone to artifacts (perhaps we can implement a distance fade?)
	#define PARALLAX_RAYMARCH_SAMPLES 64
	#define NORMAL_MAP_SHADOW_SAMPLES 64
	#define NORMAL_MAP_SHADOW_USE_NOISE

	//use a LUT for GGX and Schlick to save on computation.
	//#define USE_BDRF_LUT

	//use specular anti-aliasing
	//#define USE_SPECULAR_AA

	//enable SH shading up to 3 orders (instead of 2)
	//when doing spherical harmonics use all the terms (constant, linear, and polynomials terms)
	//if not then it will be simplified and only use the constant linear terms
	#define SPHERICAL_HARMONICS_BETTER_QUALITY

	//when doing spherical harmonics, use a multi-directional term rather than a single dominant direction.
	//it looks great but is not as performant as a single dominant direction.
	#define SPHERICAL_HARMONICS_MULTI_DIRECTIONAL

	//enables a slightly higher quality approxmimation for specular highlights for spherical harmonics and baked lightmaps with directionality.
	//uses a sqrt() operation for modifying roughness value and a division operator for dividing directionality by the length
	//implementation source - https://media.contentapi.ea.com/content/dam/eacom/frostbite/files/gdc2018-precomputedgiobalilluminationinfrostbite.pdf
	#define HIGHER_QUALITY_BAKED_SPECULAR

	//#define REALTIME_LIGHTING_PERVERTEX_DIFFUSE //NOTE: ATTENUATION ISSUE WITH SPOT LIGHTS
	#define REALTIME_LIGHTING_PERPIXEL_DIFFUSE
	#define REALTIME_LIGHTING_PERPIXEL_SPECULAR
#endif

//||||||||||||||||||||||||||||| TONEMAP SETTINGS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| TONEMAP SETTINGS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| TONEMAP SETTINGS |||||||||||||||||||||||||||||
//Use a tonemap on the shader.
//This is here since post processing on mobile can be costly, so here we implement it on the material level.
//Granted it's not 100% as ideal as post processing which can tonemap EVERYTHING in the scene, but better than nothing.

//ONLY 1 tonemap type can be active at a time
//#define TONEMAP
#define TONEMAP_EXPOSURE 1.0f
#define TONEMAP_ACES			//realtivly simple, might be most performant?
//#define TONEMAP_REINHARD		//realtivly simple, might be most performant?
//#define TONEMAP_REINHARD2		//realtivly simple, might be most performant?
//#define TONEMAP_UNREAL		//realtivly simple, might be most performant?
//#define TONEMAP_FILMIC		//has pow operations, might be expensive
//#define TONEMAP_LOTTES		//has tons of pow operations, might be the most expensive one

//||||||||||||||||||||||||||||| PBR MASK SETTINGS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| PBR MASK SETTINGS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| PBR MASK SETTINGS |||||||||||||||||||||||||||||
//this macro chain is meant to support the many different "mask" types for different PBR systems
//ONLY 1 of these defines should be active at a time
#define PBR_MASK_UNITY_METALLIC //(RGB = Metallic, A = Smoothness)
//#define PBR_MASK_UNITY_HDRP   //(R = Metallic, G = Occlusion, B = Detail Mask, A = Smoothness)
//#define PBR_MASK_UNITY_URP    //(R = Metallic, G = Occlusion, B = None, A = Smoothness)
//#define PBR_MASK_CUSTOM       //(R = Metallic, G = Smoothness, B = Height, A = Occlusion)
//#define PBR_MASK_UNREAL       //(R = Occlusion, G = Smoothness, B = Metallic, A = None)

//||||||||||||||||||||||||||||| PRECSION SETTINGS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| PRECSION SETTINGS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| PRECSION SETTINGS |||||||||||||||||||||||||||||
//normally I would never do this, but added this because I wanted to make the data type consistent when it comes to setting precision for a platform.
//as a note, normally desktop gpus by DEFAULT operate at float/32 bit precision always
//https://docs.unity3d.com/Manual/SL-ShaderPerformance.html
//https://docs.unity3d.com/Manual/SL-DataTypesAndPrecision.html
//float - 32bit high precision
//half - 16bit meduim precision
//fixed - 11bit low precision
//sampler2D_half - 16bit meduim precision
//sampler2D_float - 32bit high precision
#if defined (TARGET_MOBILE)
	#define real fixed
	#define real2 fixed2
	#define real3 fixed3
	#define real4 fixed4
	#define real2x2 fixed2x2
	#define real3x3 fixed3x3
	#define real4x4 fixed4x4
	#define samplerTexture sampler2D_half
	#define samplerCubemap samplerCUBE_half 
#else
	#define real float
	#define real2 float2
	#define real3 float3
	#define real4 float4
	#define real2x2 float2x2
	#define real3x3 float3x3
	#define real4x4 float4x4
	#define samplerTexture sampler2D
	#define samplerCubemap samplerCUBE
#endif

//google filamented suggests clamping roughness value at 0.089 for fp16 (half real) precison.
//frostbite engine clamps the value to 0.045 for fp32 (single precison)
#if defined (TARGET_MOBILE)
	#define MIN_PERCEPTUAL_ROUGHNESS 0.089
#else
	#define MIN_PERCEPTUAL_ROUGHNESS 0.045
	#define MIN_ROUGHNESS            0.002025
#endif

//because the LUT basically makes us work at a lower precision, adjust the minimum roughness value accordingly (these values were chosen arbitrarily)
#if defined (USE_BDRF_LUT)
	#define MIN_ROUGHNESS 0.087921
#else
	//#define MIN_ROUGHNESS 0.007921
	#define MIN_ROUGHNESS 0.002025
#endif

//||||||||||||||||||||||||||||| TEXTURE SAMPLING BIAS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| TEXTURE SAMPLING BIAS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| TEXTURE SAMPLING BIAS |||||||||||||||||||||||||||||
//If enabled it allows us to sample textures with a bias factor (using tex2Dbias instead of tex2Dlod).
//depending on the bias factor we can make images sharper at a distance, or blurier depending on the factor

#if defined (TEXTURE_SAMPLING_BIAS)

	#if defined (TEXTURE_SAMPLING_BIAS_USE_RGSS)
		//stolen reference - https://bgolus.medium.com/sharper-mipmapping-using-shader-based-supersampling-ed7aadb47bec
		real4 SampleTexture2D_RGSS(samplerTexture textureMap, real2 uv)
		{
			// per pixel partial derivatives
			real2 dx = ddx(uv.xy); // horizontal offset
			real2 dy = ddy(uv.xy); // vertical offset

			// rotated grid uv offsets
			real2 uvOffsets = real2(0.125, 0.375);
			real4 offsetUV = real4(0.0, 0.0, 0.0, TEXTURE_SAMPLING_BIAS_FACTOR);

			// supersampled using 2x2 rotated grid
			real4 col = 0;

			offsetUV.xy = uv.xy + uvOffsets.x * dx + uvOffsets.y * dy;
			col += tex2Dbias(textureMap, offsetUV);

			offsetUV.xy = uv.xy - uvOffsets.x * dx - uvOffsets.y * dy;
			col += tex2Dbias(textureMap, offsetUV);

			offsetUV.xy = uv.xy + uvOffsets.y * dx - uvOffsets.x * dy;
			col += tex2Dbias(textureMap, offsetUV);

			offsetUV.xy = uv.xy - uvOffsets.y * dx + uvOffsets.x * dy;
			col += tex2Dbias(textureMap, offsetUV);

			col *= 0.25;

			return col;
		}

		#define UBER_TEXTURE2D(sampler, uv) SampleTexture2D_RGSS(sampler, uv.xy)

	#elif defined (TEXTURE_SAMPLING_BIAS_USE_SS)
		//stolen reference - https://bgolus.medium.com/sharper-mipmapping-using-shader-based-supersampling-ed7aadb47bec
		real4 SampleTexture2D_SS(samplerTexture textureMap, real2 uv)
		{
			// per pixel screen space partial derivatives
			real2 dx = ddx(uv.xy) * 0.25; // horizontal offset
			real2 dy = ddy(uv.xy) * 0.25; // vertical offset

			// supersampled 2x2 ordered grid
			real4 col = 0;

			col += tex2Dbias(textureMap, real4(uv.xy + dx + dy, 0.0, TEXTURE_SAMPLING_BIAS_FACTOR));
			col += tex2Dbias(textureMap, real4(uv.xy - dx + dy, 0.0, TEXTURE_SAMPLING_BIAS_FACTOR));
			col += tex2Dbias(textureMap, real4(uv.xy + dx - dy, 0.0, TEXTURE_SAMPLING_BIAS_FACTOR));
			col += tex2Dbias(textureMap, real4(uv.xy - dx - dy, 0.0, TEXTURE_SAMPLING_BIAS_FACTOR));

			col *= 0.25;

			return col;
		}

		#define UBER_TEXTURE2D(sampler, uv) SampleTexture2D_SS(sampler, uv.xy)

	#else
		#define UBER_TEXTURE2D(sampler, uv) tex2Dbias(sampler, real4(uv.xy, 0, TEXTURE_SAMPLING_BIAS_FACTOR))
	#endif
#else
	#define UBER_TEXTURE2D(sampler, uv) tex2D(sampler, uv)
#endif
struct appdata
{
    //the most important trio for shading
    real4 vertex : POSITION;
    real3 normal : NORMAL;
    real4 texcoord : TEXCOORD0;

    //the rest here aren't really needed depending on what the material shading requires

    #if defined(_NORMALMAP) || defined(_PARALLAX_MAPPING) || defined (_ANISOTROPIC)
        real4 tangent : TANGENT;
    #endif

    #if defined(LIGHTMAP_ON)
        real4 texcoord1 : TEXCOORD1;
    #endif

    #if defined(DYNAMICLIGHTMAP_ON)
        real4 texcoord2 : TEXCOORD2;
    #endif

    //fixed4 color : COLOR;

    //instancing
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct vertexToFragment
{
    real4 pos : SV_POSITION; //xyzw = vertex position
    real2 uvTexture : TEXCOORD0;
    real4 uvStaticAndDynamicLightmap : TEXCOORD1; //xy = static lightmap, zw = dynamic lightmap
    real4 posWorld : TEXCOORD2; //world space position 
    real3 tangentSpace0_worldNormal : TEXCOORD3; //tangent space 0 OR world normal if normal maps are disabled
    real3 tangentSpace1 : TEXCOORD4; //tangent space 1
    real3 tangentSpace2 : TEXCOORD5; //tangent space 2
    real3 vertexLighting : TEXCOORD6;

    #ifdef LOD_FADE_CROSSFADE
        real3 screenPosition : TEXCOORD7;
    #endif

    //shadows
    DECLARE_LIGHT_COORDS(8)
    unityShadowCoord4 _ShadowCoord : TEXCOORD9;

    #if defined(CALCULATE_FOG)
        UNITY_FOG_COORDS(10)
    #endif

    UNITY_VERTEX_OUTPUT_STEREO //instancing
};

//||||||||||||||||||||||||||||||| VERTEX FUNCTION |||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||| VERTEX FUNCTION |||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||| VERTEX FUNCTION |||||||||||||||||||||||||||||||
vertexToFragment vertex_base(appdata v)
{
    vertexToFragment o;

    //instancing
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(vertexToFragment, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.pos = UnityObjectToClipPos(v.vertex);
    o.uvTexture = TRANSFORM_TEX(v.texcoord, _MainTex);

    //get regular static lightmap texcoord ONLY if lightmaps are in use
    #if defined(LIGHTMAP_ON)
        o.uvStaticAndDynamicLightmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    #endif

    //get dynamic lightmap texcoord ONLY if dynamic lightmaps are in use
    #if defined(DYNAMICLIGHTMAP_ON)
        o.uvStaticAndDynamicLightmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
    #endif

    //define our world position vector
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);

    //if we are using a normal map then compute tangent vectors, otherwise just compute the regular mesh normal
    #if defined(_NORMALMAP) || defined(_PARALLAX_MAPPING) || defined (_ANISOTROPIC)
        //compute the world normal
        real3 worldNormal = UnityObjectToWorldNormal(normalize(v.normal));

        //the tangents of the mesh
        real3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);

        //compute the tangent sign
        real tangentSign = v.tangent.w * unity_WorldTransformParams.w;

        //compute bitangent from cross product of normal and tangent
        real3 worldBiTangent = cross(worldNormal, worldTangent) * tangentSign;

        //output the tangent space matrix
        o.tangentSpace0_worldNormal = real3(worldTangent.x, worldBiTangent.x, worldNormal.x);
        o.tangentSpace1 = real3(worldTangent.y, worldBiTangent.y, worldNormal.y);
        o.tangentSpace2 = real3(worldTangent.z, worldBiTangent.z, worldNormal.z);

        //if enabled, do diffuse lighting per vertex
        #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
            o.vertexLighting += ComputeVertexDiffuseLighting(worldNormal, real3(0, 0, 0), true);
        #endif
    #else
        //the world normal of the mesh
        o.tangentSpace0_worldNormal = UnityObjectToWorldNormal(normalize(v.normal));

        //if enabled, do diffuse lighting per vertex
        #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
            o.vertexLighting += ComputeVertexDiffuseLighting(o.tangentSpace0_worldNormal, real3(0, 0, 0), true);
        #endif
    #endif

    #ifdef LOD_FADE_CROSSFADE
        o.screenPosition = UnityObjectToViewPos(v.vertex);
    #endif

    TRANSFER_VERTEX_TO_FRAGMENT(o);

    #if defined(CALCULATE_FOG)
        UNITY_TRANSFER_FOG(o, o.pos);
    #endif

    return o;
}

//||||||||||||||||||||||||||||||| FRAGMENT/PIXEL FUNCTION |||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||| FRAGMENT/PIXEL FUNCTION |||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||| FRAGMENT/PIXEL FUNCTION |||||||||||||||||||||||||||||||
//MAIN FRAGMENT (PER PIXEL) FORWARD BASE PASS
//Computes the following...
// - Baked Lightmaps (Main, Micro Shadow, Normal Map Shadows)
// - Dynamic Lightmaps
// - Ambient Lighting (Main, Translucency)
// - Glossy Reflections
// - Emission
// - 1 Realtime Directional Light (Main, Translucency, Micro Shadow, Normal Map Shadows)
// - Parallax Occlusion Mapping
real4 fragment_forward_base(vertexToFragment i) : SV_Target
{
    #ifdef LOD_FADE_CROSSFADE
        real2 vpos = i.screenPosition.xy / 1.0f * _ScreenParams.xy;
        UnityApplyDitherCrossFade(vpos);
    #endif

    //declare these values, and we will add terms to it later in the shader.
    real4 finalColor = real4(0.0, 0.0, 0.0, 1.0);
    real3 computedSpecular = real3(0.0, 0.0, 0.0);
    real3 computedDiffuse = real3(0.0, 0.0, 0.0);

    //||||||||||||||||||||||||||||||| VECTORS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| VECTORS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| VECTORS |||||||||||||||||||||||||||||||
    //main shader vectors used for textures or lighting calculations.

    real2 vector_uv = i.uvTexture; //uvs for sampling regular textures (texcoord0)
    real3 vector_worldPosition = i.posWorld.xyz; //world position vector
    real3 vector_viewPosition = _WorldSpaceCameraPos.xyz - vector_worldPosition; //camera world position
    real3 vector_viewDirection = normalize(vector_viewPosition); //camera world position direction

    //if any of these features are enabled, calculate these vectors for it since they use it.
    #if defined (_ANISOTROPIC) || defined (_NORMALMAP_SHADOWS) || defined (_PARALLAX_MAPPING)
        real3 vector_tangent = real3(i.tangentSpace0_worldNormal.x, i.tangentSpace1.x, i.tangentSpace2.x);
        real3 vector_biTangent = real3(i.tangentSpace0_worldNormal.y, i.tangentSpace1.y, i.tangentSpace2.y);
        real3 vector_worldNormal = real3(i.tangentSpace0_worldNormal.z, i.tangentSpace1.z, i.tangentSpace2.z);

        real3x3 shading_tangentToWorld = real3x3(vector_tangent, vector_biTangent, vector_worldNormal);
    #endif

    //if parallax mapping is enabled, modify the 
    #if defined(_PARALLAX_MAPPING)
        real3 vector_viewDirectionTangentSpace = mul(shading_tangentToWorld, vector_viewDirection);
        vector_uv = Parallax(real4(vector_uv.xy, 0, 0), vector_viewDirectionTangentSpace).xy;
    #endif

    //sample our normals (either with a normal map if its in use, or use the geometric normal)
    #if defined(_NORMALMAP)
        //sample our normal map texture
        real3 texture_normalMap = SampleNormalMap(vector_uv);

        //calculate our normals with the normal map into consideration
        real3 vector_normalDirection = real3(dot(i.tangentSpace0_worldNormal, texture_normalMap.xyz), dot(i.tangentSpace1, texture_normalMap.xyz), dot(i.tangentSpace2, texture_normalMap.xyz));

        //normalize the vector so it stays in a -1..1 range
        vector_normalDirection = normalize(vector_normalDirection);
    #else
        //FIX: because we can have parallaxing/anistrophic without normals, we need to use the world normal that is split across different vectors.
        #if defined (_PARALLAX_MAPPING) || defined (_ANISOTROPIC)
            real3 vector_normalDirection = vector_worldNormal;
        #else
            //use the main mesh normals calculated in the vertex shader
            real3 vector_normalDirection = i.tangentSpace0_worldNormal;
        #endif
    #endif

    //||||||||||||||||||||||||||||||| MATERIAL DATA |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| MATERIAL DATA |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| MATERIAL DATA |||||||||||||||||||||||||||||||
    //sample our main material data
    MaterialData materialData;
    SampleMaterialData(vector_uv, materialData);

    #if defined (_ALPHA_CUTOFF)
        clip(materialData.albedo.a - _Cutoff);
    #endif

    finalColor.a = materialData.albedo.a - _Cutoff;

    //||||||||||||||||||||||||||||||| SHARED DOT PRODUCTS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| SHARED DOT PRODUCTS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| SHARED DOT PRODUCTS |||||||||||||||||||||||||||||||
    //main dot products used for calculating shading (these are shared and don't use the realtime light)

    //real NdotV = clamp(dot(vector_normalDirection, vector_viewDirection), 0.0f, 1.0f); //note: in UnityStandardBRDF.cginc they use abs instead to prevent some issues later on?
    //half shiftAmount = dot(vector_normalDirection, vector_viewDirection);
    //vector_normalDirection = shiftAmount < 0.0f ? vector_normalDirection + vector_viewDirection * (-shiftAmount + 1e-5f) : vector_normalDirection;

    real NdotV = abs(dot(vector_normalDirection, vector_viewDirection)); //note: in UnityStandardBRDF.cginc they use abs instead to prevent some issues later on?

    //||||||||||||||||||||||||||||||| PHYSICALLY BASED SHADING SETUP |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| PHYSICALLY BASED SHADING SETUP |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| PHYSICALLY BASED SHADING SETUP |||||||||||||||||||||||||||||||
    //calculating some terms to use in PBR calculations

    //normally I would just reuse the main occlusion term for occluding specularity.
    //however, the regular enviorment reflections from the provided specular cubemaps tend to be more problematic.
    //for example the enviorment reflections often contribute to the final shading result appearing like its "glowing" in low lighting conditions.
    //so we compute a seperate procedual occlusion term to mitigate the enviorment reflections in those circumstances.
    //purposefully seperate occlusion term not used by the generated specular highlights (from terms like baked lightmaps/dynamic lightmaps/spherical harmonics) (they do recieve occlusion, just not as much of it)
    real3 acumulatedEnviormentLighting = real3(0, 0, 0);
    real occlusionEnviormentSpecular = 1.0;
    real occlusion = (materialData.occlusion * _OcclusionStrength) + (1.0 - _OcclusionStrength); //<--- regular material occlusion term
    real metallic = materialData.metallic;
    real smoothness = materialData.smoothness;
    real reflectance = materialData.reflectance;
    real perceptualRoughness = 1.0 - smoothness;

    //clamp perceptual roughness
    perceptualRoughness = max(perceptualRoughness, MIN_PERCEPTUAL_ROUGHNESS);

    //apply specular anti-aliasing (doesn't outright solve it, but helps mitgate it)
    #if defined (USE_SPECULAR_AA)
        perceptualRoughness = normalFiltering(perceptualRoughness, vector_normalDirection);
    #endif

    real roughness = perceptualRoughness * perceptualRoughness; //offical roughness term for pbr shading
    roughness = max(roughness, MIN_ROUGHNESS); //clamp roughness value

    //if anistrophic specular is enabled, calculate these vectors and products as they will be used later.
    #if defined (_ANISOTROPIC)
        real at = max(roughness * (1.0 + materialData.anisotropy), 0.001);
        real ab = max(roughness * (1.0 - materialData.anisotropy), 0.001);

        real3 anisotropicDirectionInput = real3(0.0, 1.0, 0.0);
        real3 anisotropicT = normalize(mul(shading_tangentToWorld, anisotropicDirectionInput));
        real3 anisotropicB = normalize(cross(vector_normalDirection, anisotropicT));

        real3 vector_anisotropyDirection = materialData.anisotropy >= 0.0 ? anisotropicB : anisotropicT;
        real3 vector_anisotropicTangent = cross(vector_anisotropyDirection, vector_viewDirection);
        real3 vector_anisotropicNormal = cross(vector_anisotropicTangent, vector_anisotropyDirection);

        real TdotV = dot(anisotropicT, vector_viewDirection);
        real BdotV = dot(anisotropicB, vector_viewDirection);
    #endif

    //specular reflectance at normal incidence angle
    //in english this basically means how reflective a material is when looking at it directly
    //this term also uses the albedo color for metallics as part of their specularity color
    real3 f0 = 0.16 * reflectance * reflectance * (1.0 - metallic) + materialData.albedo.rgb * metallic;

    //according to filament, we also need to remap the albedo since metallic surfaces actually use the albedo color as part of their specular color.
    materialData.albedo *= (1.0 - metallic);

    //||||||||||||||||||||||||||||||| REALTIME LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| REALTIME LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| REALTIME LIGHTING |||||||||||||||||||||||||||||||
    //this is for calculating shading for realtime per pixel lights in the scene.

    real realtimeLightSpecularOcclusion = 1.0;

    //shared realtime per pixel vectors/dot products
    #if defined (REALTIME_LIGHTING_PERPIXEL_DIFFUSE) || defined (REALTIME_LIGHTING_PERPIXEL_SPECULAR) || defined (_TRANSLUCENCY)
        //realtime light attenuation and shadows.
        real realtime_lightAttenuation = LIGHT_ATTENUATION(i);

        //get primary realtime light direction vector.
        real3 vector_lightDirection = normalize(_WorldSpaceLightPos0.xyz); //world space light position direction

        //calculate primary dot product for realtime light.
        real NdotL = saturate(dot(vector_normalDirection, vector_lightDirection));
    #endif

    //perform per pixel realtime diffuse lighting
    #if defined (REALTIME_LIGHTING_PERPIXEL_DIFFUSE)
        real3 realtime_diffuse = NdotL * Fd_Lambert() * _LightColor0.rgb * realtime_lightAttenuation;

        //compute micro normal map shadowing for extra detail (if enabled)
        #if defined (_MICRO_SHADOWING)
            real realtime_microShadowing = computeMicroShadowing(NdotL, occlusion);
            realtime_diffuse *= realtime_microShadowing;
            realtimeLightSpecularOcclusion *= realtime_microShadowing;
        #endif

        //compute normal map shadows for extra detail (if enabled)
        #if defined (_NORMALMAP_SHADOWS) && defined(_NORMALMAP)
            real3 vector_lightDirectionTangent = mul(shading_tangentToWorld, vector_lightDirection.xyz);
            real realtime_normalMapShadow = saturate(1 - NormalTangentShadow(vector_uv, vector_lightDirectionTangent, 1.0f));
            realtime_diffuse *= realtime_normalMapShadow;
            realtimeLightSpecularOcclusion *= realtime_normalMapShadow;
        #endif

        computedDiffuse += realtime_diffuse;
    #endif

    //perform per vertex realtime diffuse lighting
    #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
        computedDiffuse += i.vertexLighting;
    #endif

    //perform per pixel specularity if enabled
    #if defined (_SPECULAR_HIGHLIGHTS) && defined(REALTIME_LIGHTING_PERPIXEL_SPECULAR)
        #if defined (_ANISOTROPIC)
            real3 realtime_specular = _LightColor0.rgb * realtime_lightAttenuation * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, vector_lightDirection, NdotL, NdotV, TdotV, BdotV, roughness, f0, anisotropicT, anisotropicB, at, ab);
        #else
            real3 realtime_specular = _LightColor0.rgb * realtime_lightAttenuation * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, vector_lightDirection, NdotL, NdotV, roughness, f0);
        #endif

        realtime_specular *= realtimeLightSpecularOcclusion;
        computedSpecular += realtime_specular;
    #endif

    //compute translucency for realtime lights
    #if defined (_TRANSLUCENCY)
        real translucencyShadows = lerp(1.0, realtime_lightAttenuation, _TranslucencyShadowStrength);
        real3 translucencyTerm = _LightColor0.rgb * translucencyShadows * ComputeTranslucency(vector_viewDirection, vector_normalDirection, vector_lightDirection, materialData);
        computedDiffuse += translucencyTerm;
    #endif

    //||||||||||||||||||||||||||||||| ENLIGHTEN LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| ENLIGHTEN LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| ENLIGHTEN LIGHTING |||||||||||||||||||||||||||||||
    //calcuate enlighten lighting if it is in use (can do some dope ass realtime indirect lighting, so lets support it if its in use because why the hell not)

    #if defined(DYNAMICLIGHTMAP_ON)
        //get lightmap uvs for realtime lightmap
        real2 vector_lightmapDynamicUVs = i.uvStaticAndDynamicLightmap.zw; //uvs for dynamic lightmaps (enlighten) (texcoord2)

        //sample the enlighten map
        real4 dynamicLightmap = UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, vector_lightmapDynamicUVs.xy);

        //decode it
        dynamicLightmap.rgb = DecodeRealtimeLightmap(dynamicLightmap);

        //accumulate the enviorment lighting color for occluding enviorment reflections later
        acumulatedEnviormentLighting += dynamicLightmap;

        //if directional lightmaps are enabled, lets do some cool shit with it
        #if defined(DIRLIGHTMAP_COMBINED)
            //sample the realtime directional lightmap
            real4 dynamicLightmapDirection = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, vector_lightmapDynamicUVs.xy) * 2.0f - 1.0f;

            #if defined(HIGHER_QUALITY_BAKED_SPECULAR)
                real dynamicLightmapDirectionLength = length(dynamicLightmapDirection.w);
                dynamicLightmapDirection /= dynamicLightmapDirectionLength;
            #endif

            //calculate an NdotL term from the dominant lightmap direction (this will be used later)
            real dynamicLightmap_NdotL = saturate(dot(vector_normalDirection, dynamicLightmapDirection.xyz));

            //declare occlusion term for the lightmap specular (not overall specular term)
            real dynamicLightmap_computedSpecularOcclusion = 1.0;

            //compute micro normal map shadowing for extra detail (if enabled)
            #if defined (_MICRO_SHADOWING)
                real dynamicLightmap_microShadowing = saturate(computeMicroShadowing(dynamicLightmap_NdotL, occlusion));
                dynamicLightmap_NdotL *= dynamicLightmap_microShadowing;
                dynamicLightmap_computedSpecularOcclusion *= dynamicLightmap_microShadowing;
            #endif

            //compute normal map shadows (don't compute if we are using ndotl wrap because it doesn't affect the final result at all)
            #if defined (_NORMALMAP_SHADOWS) && !defined (LIGHTMAPPING_USE_NDOTL_WRAP) && defined(_NORMALMAP)
                real3 dynamicLightmap_lightDirectionTangent = mul(shading_tangentToWorld, dynamicLightmapDirection.xyz);
                real dynamicLightmap_shadowTerm = saturate(1 - NormalTangentShadow(vector_uv, dynamicLightmap_lightDirectionTangent, 1.0f));
                dynamicLightmap_NdotL *= dynamicLightmap_shadowTerm;
                dynamicLightmap_computedSpecularOcclusion *= dynamicLightmap_shadowTerm;
            #endif

            //sample an ndotl term so we can shade the original diffuse term of the lightmap again but using additional detail from the normal maps
            #if defined (LIGHTMAPPING_USE_NDOTL_WRAP)
                //dynamicLightmap *= saturate(dot(vector_normalDirection, dynamicLightmapDirection.xyz) * 0.5 + 0.5) / max(1e-4h, dynamicLightmapDirection.w); //from unitycg
                dynamicLightmap *= saturate(dot(vector_normalDirection, dynamicLightmapDirection.xyz) * 0.5 + 0.5);
            #else
                //dynamicLightmap *= dynamicLightmap_NdotL / max(1e-4h, dynamicLightmapDirection.w); //from unitycg
                dynamicLightmap *= dynamicLightmap_NdotL;
            #endif

            //calculate a specular highlight for the dynamic lightmap using the directionality term
            #if defined(_SPECULAR_HIGHLIGHTS)
                #if defined(HIGHER_QUALITY_BAKED_SPECULAR)
                    #if defined (_ANISOTROPIC)
                        //real3 dynamicLightmap_specularTerm = dynamicLightmap * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, dynamicLightmapDirection, dynamicLightmap_NdotL, NdotV, TdotV, BdotV, roughness * sqrt(lightmapDirectionLength), f0, anisotropicT, anisotropicB, at, ab);
                        real3 dynamicLightmap_specularTerm = dynamicLightmap * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, dynamicLightmapDirection, dynamicLightmap_NdotL, NdotV, TdotV, BdotV, roughness / sqrt(lightmapDirectionLength), f0, anisotropicT, anisotropicB, at, ab);
                    #else
                        //real3 dynamicLightmap_specularTerm = dynamicLightmap * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, dynamicLightmapDirection, dynamicLightmap_NdotL, NdotV, roughness * sqrt(lightmapDirectionLength), f0);
                        real3 dynamicLightmap_specularTerm = dynamicLightmap * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, dynamicLightmapDirection, dynamicLightmap_NdotL, NdotV, roughness / sqrt(lightmapDirectionLength), f0);
                    #endif
                #else
                    #if defined (_ANISOTROPIC)
                        real3 dynamicLightmap_specularTerm = dynamicLightmap * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, dynamicLightmapDirection, dynamicLightmap_NdotL, NdotV, TdotV, BdotV, roughness, f0, anisotropicT, anisotropicB, at, ab);
                    #else
                        real3 dynamicLightmap_specularTerm = dynamicLightmap * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, dynamicLightmapDirection, dynamicLightmap_NdotL, NdotV, roughness, f0);
                    #endif
                #endif

                dynamicLightmap_specularTerm *= dynamicLightmap_computedSpecularOcclusion;

                //max is required because at some really grazing angles we get some black pixels?
                computedSpecular += max(0.0, dynamicLightmap_specularTerm);
            #endif
        #endif

        //add the results to the diffuse term since enlighten takes care 
        computedDiffuse += dynamicLightmap;
    #endif

    //||||||||||||||||||||||||||||||| BAKED LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| BAKED LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| BAKED LIGHTING |||||||||||||||||||||||||||||||
    //calculate the baked lighting if it is in use.
    //lots of fancy stuff in here to approximate how to shade the object correctly and make it look comparable to the realtime shading.

    #if defined(LIGHTMAP_ON)
        //get lightmap uvs for static lightmap
        real2 vector_lightmapUVs = i.uvStaticAndDynamicLightmap.xy; //uvs for baked lightmaps (texcoord1)

        //sample the lightmap (lightmaps only have diffuse lighting)
        real4 indirectLightmap = UNITY_SAMPLE_TEX2D(unity_Lightmap, vector_lightmapUVs.xy);

        //before adding it, we need to treat the lightmap (if its HDR or not)
        //#if defined(UNITY_LIGHTMAP_FULL_HDR)
            indirectLightmap.rgb = DecodeLightmap(indirectLightmap);
        //#else
            //according to UnityCG.cginc when non-hdr lightmaps are used...
            //in gamma space the multiplier is 2.0.
            //in linear space the multiplier is 4.59 or pow(2.0, 2.2).
            //indirectLightmap.rgb *= 4.59;
        //#endif

        //accumulate the enviorment lighting color for occluding enviorment reflections later
        acumulatedEnviormentLighting += indirectLightmap.rgb;

        //if directional lightmaps are enabled, lets do some cool shit with it
        #if defined(DIRLIGHTMAP_COMBINED)
            //sample the directional lightmap, and scale it to normal space (from 0..1 to -1..1) - this contains the dominant light direction from the lightmaps
            real4 lightmapDirection = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, vector_lightmapUVs) * 2.0 - 1.0;

            #if defined(HIGHER_QUALITY_BAKED_SPECULAR)
                real lightmapDirectionLength = length(lightmapDirection.w);
                lightmapDirection /= lightmapDirectionLength;
            #endif

            //calculate an NdotL term from the dominant lightmap direction (this will be used later)
            real lightmap_NdotL = saturate(dot(vector_normalDirection, lightmapDirection.xyz));

            //declare occlusion term for the lightmap specular (not overall specular term)
            real lightmap_computedSpecularOcclusion = 1.0;

            //compute micro normal map shadowing for extra detail (if enabled)
            #if defined (_MICRO_SHADOWING)
                real lightmap_microShadowing = saturate(computeMicroShadowing(lightmap_NdotL, occlusion));
                lightmap_NdotL *= lightmap_microShadowing;
                lightmap_computedSpecularOcclusion *= lightmap_microShadowing;
            #endif

            //compute normal map shadows (don't compute if we are using ndotl wrap because it doesn't affect the final result at all)
            #if defined (_NORMALMAP_SHADOWS) && !defined (LIGHTMAPPING_USE_NDOTL_WRAP) && defined(_NORMALMAP)
                real3 lightmap_lightDirectionTangent = mul(shading_tangentToWorld, lightmapDirection.xyz);
                real lightmap_shadowTerm = saturate(1 - NormalTangentShadow(vector_uv, lightmap_lightDirectionTangent, 1.0f));
                lightmap_NdotL *= lightmap_shadowTerm;
                lightmap_computedSpecularOcclusion *= lightmap_shadowTerm;
            #endif

            //acumulatedEnviormentLighting *= lightmap_NdotL;
            //occlusionEnviormentSpecular *= lightmap_NdotL;

            //sample an ndotl term so we can shade the original diffuse term of the lightmap again but using additional detail from the normal maps
            #if defined (LIGHTMAPPING_USE_NDOTL_WRAP)
                //indirectLightmap *= saturate(dot(vector_normalDirection, lightmapDirection.xyz) * 0.5 + 0.5) / max(1e-4h, lightmapDirection.w); //from unitycg
                indirectLightmap *= saturate(dot(vector_normalDirection, lightmapDirection.xyz) * 0.5 + 0.5); //from unitycg
            #else
                //indirectLightmap *= lightmap_NdotL / max(1e-4h, lightmapDirection.w); //from unitycg
                indirectLightmap *= lightmap_NdotL;
            #endif

            //return float4(lightmapDirection.r + (indirectLightmap.x * 0.0001), lightmapDirection.g, lightmapDirection.b, 1);

            //calculate a specular highlight for the baked lightmap using the baked directionality term
            #if defined(_SPECULAR_HIGHLIGHTS)
                #if defined(HIGHER_QUALITY_BAKED_SPECULAR)
                    #if defined (_ANISOTROPIC)
                        //real3 lightmap_specularTerm = indirectLightmap * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, lightmapDirection, lightmap_NdotL, NdotV, TdotV, BdotV, roughness * sqrt(lightmapDirectionLength), f0, anisotropicT, anisotropicB, at, ab);
                        real3 lightmap_specularTerm = indirectLightmap * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, lightmapDirection, lightmap_NdotL, NdotV, TdotV, BdotV, roughness / sqrt(lightmapDirectionLength), f0, anisotropicT, anisotropicB, at, ab);
                    #else
                        //real3 lightmap_specularTerm = indirectLightmap * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, lightmapDirection, lightmap_NdotL, NdotV, roughness * sqrt(lightmapDirectionLength), f0);
                        real3 lightmap_specularTerm = indirectLightmap * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, lightmapDirection, lightmap_NdotL, NdotV, roughness / sqrt(lightmapDirectionLength), f0);
                    #endif
                #else
                    #if defined (_ANISOTROPIC)
                        real3 lightmap_specularTerm = indirectLightmap * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, lightmapDirection, lightmap_NdotL, NdotV, TdotV, BdotV, roughness, f0, anisotropicT, anisotropicB, at, ab);
                    #else
                        real3 lightmap_specularTerm = indirectLightmap * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, lightmapDirection, lightmap_NdotL, NdotV, roughness, f0);
                    #endif
                #endif

                lightmap_specularTerm *= lightmap_computedSpecularOcclusion;

                //max is required because at some really grazing angles we get some black pixels?
                computedSpecular += max(0.0, lightmap_specularTerm);
            #endif
        #endif

        //add it to the overall diffuse lighting (because lightmaps are diffuse)
        computedDiffuse += indirectLightmap.rgb;
    #endif

    //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC LIGHTING |||||||||||||||||||||||||||||||
    #if !defined (LIGHTMAP_ON)
        //sample the given ambient probe for the material.
        //this ambient probe depending on what it is, is either a lightprobe, or a regular ambient skybox probe.

        #if defined (UNITY_LIGHT_PROBE_PROXY_VOLUME)
            real3 sphericalHarmonicsColor = real3(0, 0, 0);

            UNITY_BRANCH
            if (unity_ProbeVolumeParams.x == 1.0)
            {
                sphericalHarmonicsColor = SphericalHarmonics_ProbeVolume_GetDiffuseLighting(vector_normalDirection, vector_worldPosition);
            }
            else
            {
                sphericalHarmonicsColor = SphericalHarmonics_GetDiffuseLighting(vector_normalDirection);
                //sphericalHarmonicsColor = SphericalHarmonics_GetDiffuseLighting(-vector_viewDirection * smoothness);
                //sphericalHarmonicsColor = pow(sphericalHarmonicsColor, 2);
                //return real4(sphericalHarmonicsColor, 1);
            }
        #else
            real3 sphericalHarmonicsColor = SphericalHarmonics_GetDiffuseLighting(vector_normalDirection);
        #endif

        //extra shared variables used by the following features
        #if defined (_SPECULAR_HIGHLIGHTS) || defined (_MICRO_SHADOWING) || defined (_NORMALMAP_SHADOWS)
            #if defined (UNITY_LIGHT_PROBE_PROXY_VOLUME)
                real3 sphericalHarmonics_direction = real3(0, 0, 0);

                UNITY_BRANCH
                if (unity_ProbeVolumeParams.x == 1.0)
                {
                    sphericalHarmonics_direction = GetDominantSphericalHarmoncsProbeVolumeDirection(vector_worldPosition);
                }
                else
                {
                    sphericalHarmonics_direction = GetDominantSphericalHarmoncsDirection();
                    //sphericalHarmonics_direction = GetMultipleSphericalHarmoncsDirection(vector_normalDirection, roughness);
                }
            #else
                real3 sphericalHarmonics_direction = GetDominantSphericalHarmoncsDirection();
            #endif

                //real3 testttt = reflect(-vector_viewDirection, vector_normalDirection);


                //sphericalHarmonics_direction = SH_test(vector_normalDirection);
                //sphericalHarmonics_direction = SphericalHarmonics_GetDiffuseLighting(real4(vector_normalDirection, 1));

                //real3 testttt = GetGlossyReflectionFromSH(vector_normalDirection);
                //real3 testttt = GetGlossyReflectionFromSHA(vector_normalDirection);
                //real3 testttt = GetGlossyReflectionFromSHB(vector_normalDirection);
                //sphericalHarmonics_direction = testttt;

            //real sphericalHarmonicsL1_length = length(sphericalHarmonics_direction);
            //sphericalHarmonics_direction /= sphericalHarmonicsL1_length;
            sphericalHarmonics_direction = normalize(sphericalHarmonics_direction);

            //all commented out, but kept in here from the micro shadow/normal map shadow attempts
            //real sphericalHarmonics_NdotL = (dot(vector_normalDirection, sphericalHarmonics_direction));
            real sphericalHarmonics_NdotL = saturate(dot(vector_normalDirection, sphericalHarmonics_direction));
            //real sphericalHarmonics_NdotL = abs(dot(vector_normalDirection, sphericalHarmonics_direction));

            //if (sphericalHarmonics_NdotL < 0.1)
                //sphericalHarmonics_direction = -sphericalHarmonics_direction;

            //test += sphericalHarmonics_direction / sphericalHarmonicsL1_length;
            //test += sphericalHarmonics_direction * sphericalHarmonicsL1_length;
            //sphericalHarmonics_direction /= sphericalHarmonicsL1_length;
            //sphericalHarmonics_direction *= sphericalHarmonicsL1_length;

            //return float4(test, 1);
            //return float4(sphericalHarmonics_direction, 1);

            //float3 test = float3(0, 0, 0);

            //test += SphericalHarmonics_GetDiffuseLighting(real4(vector_normalDirection, 1.0));
            //test += SphericalHarmonics_GetDiffuseLighting(real4(reflect(-vector_viewDirection, vector_normalDirection), 1.0));

            //return float4(test, 1);
        #endif

        /*
            NOTE TO SELF: This does work correctly, however we an issue when it comes to blending the final shaded results with the original term.
            If we just simply multiply as is, the lit side will look correct however when in shadow it will be completely black.
            Normally this would be fine however the spherical harmonics provides the total lighting of the direct + indirect term.
    
            A simple way to blend the result (that I've tried) is simply adding both the shadowing and the ambient color at half intensity,
            however when doing that the effects are so minimal its almost not worth the extra computation to do at all.

            A second attempt I tried was to instead break down the ShadeSH9 function from UnityCG.cginc which combines all of the L0 L1 L2 bands.
            I split it off instead to where the main indirect color was from the L0 L1 bands (they are combined) and the "direct" was just L2.
            Once again results were very minimal to justify the extra computational costs.

        */
        //compute micro normal map shadowing for extra detail (if enabled)
        #if defined (_MICRO_SHADOWING)
            //real sphericalHarmonics_microShadowing = saturate(computeMicroShadowing(sphericalHarmonics_NdotL, occlusion));
            //sphericalHarmonics_NdotL *= sphericalHarmonics_microShadowing;
            //sphericalHarmonicsColor *= sphericalHarmonics_microShadowing;
            //lightmap_computedSpecularOcclusion *= lightmap_microShadowing;
        //#else
            //sphericalHarmonicsColor *= occlusion;
        #endif

        sphericalHarmonicsColor *= occlusion;

        #if defined (_NORMALMAP_SHADOWS)
            //real3 sphericalHarmonics_lightDirectionTangent = mul(shading_tangentToWorld, sphericalHarmonics_direction.xyz);
            //real sphericalHarmonics_shadowTerm = saturate(1 - NormalTangentShadow(vector_uv, sphericalHarmonics_lightDirectionTangent, 1.0f));
            //sphericalHarmonics_NdotL *= sphericalHarmonics_shadowTerm;
            //sphericalHarmonicsColor *= sphericalHarmonics_shadowTerm;
            //lightmap_computedSpecularOcclusion *= lightmap_shadowTerm;
        #endif

        //accumulate the enviorment lighting color for occluding enviorment reflections later
        acumulatedEnviormentLighting += sphericalHarmonicsColor;
        //acumulatedEnviormentLighting += sphericalHarmonicsColor * sphericalHarmonics_NdotL;
        //occlusionEnviormentSpecular

        computedDiffuse += sphericalHarmonicsColor;
        //computedDiffuse += sphericalHarmonicsColor;

        //NOTE OCCLUSION ISSUE WITH THIS WHERE AT 1 INTENSITY IT ACTUALLY OCCLUDES EVEN LIGHTMAPPED OBJECTS
        //occlude the enviorment specular based on the probe color (not phyiscally based)
        #if defined(_SPECULAR_OCCLUSION)
            real probeOcclusion = saturate(length(sphericalHarmonicsColor * _ProcedualExposureOcclusion) + (1.0 - _ProcedualExposureOcclusion));
            occlusionEnviormentSpecular *= probeOcclusion;
        #endif

        //ambient probe specular lighting
        #if defined (_SPECULAR_HIGHLIGHTS)
            #if defined (_ANISOTROPIC)
                real3 sphericalHarmonicsL1_specular = sphericalHarmonicsColor * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, sphericalHarmonics_direction, sphericalHarmonics_NdotL, NdotV, TdotV, BdotV, roughness, f0, anisotropicT, anisotropicB, at, ab);
            #else
                real3 sphericalHarmonicsL1_specular = sphericalHarmonicsColor * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, sphericalHarmonics_direction, sphericalHarmonics_NdotL, NdotV, roughness, f0);
            #endif

            //max is required because at some really grazing angles we get some black pixels?
            computedSpecular += max(0.0f, sphericalHarmonicsL1_specular);
        #endif

        //compute translucency for spherical harmonic lighting
        #if defined (_TRANSLUCENCY)
            real3 sphericalHarmonics_translucencyTerm = sphericalHarmonicsColor.rgb * ComputeTranslucency(vector_viewDirection, vector_normalDirection, sphericalHarmonics_direction, materialData);
            computedDiffuse += sphericalHarmonics_translucencyTerm;
        #endif
    #endif

    //||||||||||||||||||||||||||||||| ENVIORMENT REFLECTIONS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| ENVIORMENT REFLECTIONS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| ENVIORMENT REFLECTIONS |||||||||||||||||||||||||||||||
    //calculating enviorment reflections

    #if defined(_GLOSSY_REFLECTIONS)
        //experimental feature
        //use light probe data (spherical harmonics) to do our reflections.
        #if defined (USE_SH_GLOSSY_REFLECTIONS)
            real3 vector_reflectionDirection = reflect(-vector_viewDirection, vector_normalDirection);
            real4 enviormentReflection = real4(SphericalHarmonics_GetEnviormentReflection(vector_reflectionDirection, smoothness), 1);
        #else 
            //---- regular enviorment reflections

            #if !defined (_ANISOTROPIC)
                //compute our reflection vector for glossy reflections
                real3 vector_reflectionDirection = reflect(-vector_viewDirection, vector_normalDirection);
            #else
                //compute our reflection vector for glossy reflections
                real bendFactor = abs(materialData.anisotropy) * saturate(5.0 * perceptualRoughness);
                real3 bentNormal = normalize(lerp(vector_normalDirection, vector_anisotropicNormal, bendFactor));
                real3 vector_reflectionDirection = reflect(-vector_viewDirection, bentNormal);
            #endif

            real mipOffset = 0;

            //if box projection is enabled, modify our vector to project reflections onto a world space box (defined by the reflection probe)
            #if defined(UNITY_SPECCUBE_BOX_PROJECTION)
                vector_reflectionDirection = UnityBoxProjectedCubemapDirection(vector_reflectionDirection, vector_worldPosition, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax, mipOffset);
            #endif

            //used for sampling blurry/sharp glossy reflections.
            real mip = perceptualRoughnessToMipmapLevel(perceptualRoughness);

            #if defined (REFLECTION_PROBE_CONTACT_HARDENING)
                mip *= (mipOffset / UNITY_SPECCUBE_LOD_STEPS);
                //mip *= (mipOffset / UNITY_SPECCUBE_LOD_STEPS) + perceptualRoughness;
                //mip *= (mipOffset / UNITY_SPECCUBE_LOD_STEPS) + roughness;
            #endif

            //sample the provided reflection probe at the given mip level
            real4 enviormentReflection = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, vector_reflectionDirection.xyz, mip);
            //enviormentReflection *= saturate(pow(saturate(mipOffset * 0.25), 2.0));
        #endif

        //decode the reflection if it's HDR
        enviormentReflection.rgb = DecodeHDR(enviormentReflection, unity_SpecCube0_HDR);

        //apply a new fresnel for the enviorment reflection and use NdotV instead because enviorment reflections come from everywhere instead of a specific light source.
        real3 enviormentReflection_fresnel = F_Schlick(NdotV, f0);
        enviormentReflection.rgb *= enviormentReflection_fresnel;

        //occlude the enviorment reflections from the overall accumulated light (primarily coming from dynamic/baked lightmaps, and also this is not phyiscally based)
        #if defined(_SPECULAR_OCCLUSION)
            //#if defined(UNITY_LIGHTMAP_FULL_HDR)
                real dynamicLightmapOcclusion = saturate(length(acumulatedEnviormentLighting * (1.0 - _ProcedualExposureOcclusion)));
            //#else
                //real dynamicLightmapOcclusion = saturate(length(max(acumulatedEnviormentLighting - _ProcedualExposureOcclusion, 0.0)) - 1.0);
            //#endif
            occlusionEnviormentSpecular *= dynamicLightmapOcclusion;
        #endif

        //occlude the enviorment specular
        enviormentReflection.rgb *= occlusionEnviormentSpecular;

        //we need a max here because otherwise we get some pure black spots?
        computedSpecular = max(0.0, computedSpecular);

        //add the final glossy reflection
        computedSpecular += enviormentReflection;
    #endif

    //||||||||||||||||||||||||||||||| REFRACTION |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| REFRACTION |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| REFRACTION |||||||||||||||||||||||||||||||
    //artistically implemented refraction, not physically based

    #if defined (_REFRACTION)
        //get the view direction that matches the camera
        real3 vector_refractionViewDirection = -vector_viewDirection;

        //if there is box projection, use it for better accuracy
        #if defined(UNITY_SPECCUBE_BOX_PROJECTION)
            vector_refractionViewDirection = BoxProjectedCubemapDirection(vector_refractionViewDirection, vector_worldPosition, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
        #endif

        //modify the view direction to warp the view direction with the material normals
        vector_refractionViewDirection = vector_refractionViewDirection + vector_normalDirection * _RefractionDistortion;

        //sample the specular cubemap, which we will use again in this instance as our proxy enviorment refraction
        real4 refractionCubemap = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, vector_refractionViewDirection.xyz, _RefractionMip);

        //decode it before we can use it
        refractionCubemap.rgb = DecodeHDR(refractionCubemap, unity_SpecCube0_HDR);
    #endif

    //||||||||||||||||||||||||||||||| FINAL |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| FINAL |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| FINAL |||||||||||||||||||||||||||||||

    //after all of our shenangins adding light to the final result, now we finally multiply it by the base material color.
    #if defined (_REFRACTION)
        computedDiffuse *= lerp(materialData.albedo, refractionCubemap.rgb * materialData.albedo, _RefractionOpacity);
        //computedDiffuse *= lerp(materialData.albedo, refractionCubemap.rgb, _RefractionOpacity);
    #else
        computedDiffuse *= materialData.albedo;
    #endif

    //apply final material occlusion to specular
    computedSpecular *= occlusion;

    //emissive property, only adding after we multiply with the base albedo color because light is emitting from the material, not reflecting.
    #if defined(_EMISSION)
        computedDiffuse += materialData.emission;
    #endif

    #if defined (DEBUG_DIFFUSE_ONLY)
        #if defined (TONEMAP)
            computedDiffuse.rgb = tonemap(computedDiffuse.rgb);
        #endif

        return real4(computedDiffuse, finalColor.a);
    #endif

    #if defined (DEBUG_SPECULAR_ONLY)
        #if defined (TONEMAP)
            computedSpecular.rgb = tonemap(computedSpecular.rgb);
        #endif

        return real4(computedSpecular, finalColor.a);
    #endif

    //combine the diffuse and specular lighting
    finalColor.rgb += computedDiffuse;
    finalColor.rgb += computedSpecular;

    //apply a tonemap is its enabled
    #if defined (TONEMAP)
        finalColor.rgb = tonemap(finalColor.rgb);
    #endif

    //calculate classic unity fog if enabled
    #if defined(CALCULATE_FOG)
        UNITY_APPLY_FOG(i.fogCoord, finalColor);
    #endif

    return finalColor;
}
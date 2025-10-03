//terrain help resources to understand this mess of a system
//https://github.com/TwoTailsGames/Unity-Built-in-Shaders/blob/master/CGIncludes/TerrainSplatmapCommon.cginc
//https://github.com/UnityTechnologies/ScriptableRenderPipeline/blob/master/com.unity.render-pipelines.high-definition/HDRP/Material/TerrainLit/TerrainLitSplatCommon.hlsl
//https://alastaira.wordpress.com/2013/12/07/custom-unity-terrain-material-shaders/

struct appdata
{
    //the most important trio for shading
    real4 vertex : POSITION;
    real3 normal : NORMAL;
    real4 texcoord : TEXCOORD0;

    //the rest here aren't really needed depending on what the material shading requires

    #if defined(_NORMALMAP) || defined(_PARALLAX_MAPPING)
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
    real4 pos : SV_POSITION;
    real2 uvTexture : TEXCOORD0;
    real4 uvStaticAndDynamicLightmap : TEXCOORD1; //xy = static lightmap, zw = dynamic lightmap
    real4 posWorld : TEXCOORD2; //world space position 
    real3 tangentSpace0_worldNormal : TEXCOORD3; //tangent space 0 OR world normal if normal maps are disabled
    real3 tangentSpace1 : TEXCOORD4; //tangent space 1
    real3 tangentSpace2 : TEXCOORD5; //tangent space 2
    real3 vertexLighting : TEXCOORD6;

    //shadows
    DECLARE_LIGHT_COORDS(8)
    unityShadowCoord4 _ShadowCoord : TEXCOORD9;

    #if defined(CALCULATE_FOG)
        UNITY_FOG_COORDS(10)
    #endif

    UNITY_VERTEX_OUTPUT_STEREO //instancing
};

real3 ComputeLightDirectionAndAttenuation(real3 vector_position, bool directional, out real3 vector_lightDirection, out real lightAttenuation)
{
    if (directional)
    {
        //get primary realtime light direction vector.
        vector_lightDirection = normalize(_WorldSpaceLightPos0.xyz); //world space light position direction

        lightAttenuation = 1.0;
    }
    else
    {
        //realtime light attenuation and shadows.
        //get primary realtime light direction vector.
        real3 vector_positionToLight = _WorldSpaceLightPos0.xyz - vector_position;
        real distanceToLight = dot(vector_positionToLight, vector_positionToLight);

        // don't produce NaNs if some vertex position overlaps with the light
        distanceToLight = max(distanceToLight, 0.000001);
        distanceToLight *= rsqrt(distanceToLight);

        //realtime light attenuation.
        //real lightAttenuation = 1.0 / (1.0 + distanceToLight) * LIGHT_ATTENUATION(i);
        lightAttenuation = 1.0 / (1.0 + distanceToLight);
        vector_lightDirection = normalize(vector_positionToLight);
    }
}

real3 ComputeVertexDiffuseLighting(real3 vector_normal, real3 vector_position, bool directional)
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
        real3 vector_positionToLight = _WorldSpaceLightPos0.xyz - vector_position;
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

//per vertex
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
    #if defined(_NORMALMAP) || defined(_PARALLAX_MAPPING)
        real3 worldNormal = UnityObjectToWorldNormal(normalize(v.normal));
        real3 geomTangent = normalize(cross(worldNormal, real3(0, 0, 1)));
        real3 geomBitangent = normalize(cross(geomTangent, worldNormal));

        //output the tangent space matrix
        o.tangentSpace0_worldNormal = real3(geomTangent.x, geomBitangent.x, worldNormal.x);
        o.tangentSpace1 = real3(geomTangent.y, geomBitangent.y, worldNormal.y);
        o.tangentSpace2 = real3(geomTangent.z, geomBitangent.z, worldNormal.z);

        //if enabled, do diffuse lighting per vertex
        #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
            o.vertexLighting += ComputeVertexDiffuseLighting(worldNormal, real3(0, 0, 0), true);
        #endif
    #else
        real3 worldNormal = UnityObjectToWorldNormal(normalize(v.normal));

        //the world normal of the mesh
        o.tangentSpace0_worldNormal = worldNormal;

        //if enabled, do diffuse lighting per vertex
        #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
            o.vertexLighting += ComputeVertexDiffuseLighting(o.tangentSpace0_worldNormal, real3(0, 0, 0), true);
        #endif
    #endif

    TRANSFER_VERTEX_TO_FRAGMENT(o);

    #if defined(CALCULATE_FOG)
        UNITY_TRANSFER_FOG(o, o.pos);
    #endif

    return o;
}

//per vertex
vertexToFragment vertex_add(appdata v)
{
    vertexToFragment o;

    //instancing
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(vertexToFragment, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.pos = UnityObjectToClipPos(v.vertex);
    o.uvTexture = TRANSFORM_TEX(v.texcoord, _MainTex);

    //define our world position vector
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);

    //if we are using a normal map then compute tangent vectors, otherwise just compute the regular mesh normal
    #if defined(_NORMALMAP) || defined(_PARALLAX_MAPPING)
        real3 worldNormal = UnityObjectToWorldNormal(normalize(v.normal));
        real3 geomTangent = normalize(cross(worldNormal, real3(0, 0, 1)));
        real3 geomBitangent = normalize(cross(geomTangent, worldNormal));

        //output the tangent space matrix
        o.tangentSpace0_worldNormal = real3(geomTangent.x, geomBitangent.x, worldNormal.x);
        o.tangentSpace1 = real3(geomTangent.y, geomBitangent.y, worldNormal.y);
        o.tangentSpace2 = real3(geomTangent.z, geomBitangent.z, worldNormal.z);

        //if enabled, do diffuse lighting per vertex
        #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
            o.vertexLighting += ComputeVertexDiffuseLighting(worldNormal, o.posWorld.xyz, false);
        #endif
    #else
        real3 worldNormal = UnityObjectToWorldNormal(normalize(v.normal));

        //the world normal of the mesh
        o.tangentSpace0_worldNormal = worldNormal;

        //if enabled, do diffuse lighting per vertex
        #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
            o.vertexLighting += ComputeVertexDiffuseLighting(o.tangentSpace0_worldNormal, o.posWorld.xyz, false);
        #endif
    #endif

    TRANSFER_VERTEX_TO_FRAGMENT(o);

    #if defined(CALCULATE_FOG)
        UNITY_TRANSFER_FOG(o, o.pos);
    #endif

    return o;
}

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
    #if defined (_NORMALMAP_SHADOWS) || defined (_PARALLAX_MAPPING)
        real3 vector_tangent = real3(i.tangentSpace0_worldNormal.x, i.tangentSpace1.x, i.tangentSpace2.x);
        real3 vector_biTangent = real3(i.tangentSpace0_worldNormal.y, i.tangentSpace1.y, i.tangentSpace2.y);
        real3 vector_worldNormal = real3(i.tangentSpace0_worldNormal.z, i.tangentSpace1.z, i.tangentSpace2.z);

        real3x3 shading_tangentToWorld = real3x3(vector_tangent, vector_biTangent, vector_worldNormal);
    #endif

    real4 splatControl = tex2D(_Control, vector_uv);

    //if parallax mapping is enabled, modify the 
    #if defined(_PARALLAX_MAPPING)
        real3 vector_viewDirectionTangentSpace = mul(shading_tangentToWorld, vector_viewDirection);
        vector_uv = Parallax(real4(vector_uv.xy, 0, 0), vector_viewDirectionTangentSpace).xy;
    #endif

    //sample our normals (either with a normal map if its in use, or use the geometric normal)
    #if defined(_NORMALMAP)
        //sample our normal map texture
        real3 texture_normalMap = SampleTerrainNormalMap(vector_uv, splatControl);

        //calculate our normals with the normal map into consideration
        real3 vector_normalDirection = real3(dot(i.tangentSpace0_worldNormal, texture_normalMap.xyz), dot(i.tangentSpace1, texture_normalMap.xyz), dot(i.tangentSpace2, texture_normalMap.xyz));

        //normalize the vector so it stays in a -1..1 range
        vector_normalDirection = normalize(vector_normalDirection);
    #else
        //FIX: because we can have parallaxing/anistrophic without normals, we need to use the world normal that is split across different vectors.
        #if defined (_PARALLAX_MAPPING)
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
    TerrainMaterialData materialData;
    SampleTerrainMaterialData(vector_uv, splatControl, materialData);

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
    real occlusion = (materialData.occlusion * _OcclusionStrength) + (1.0 - _OcclusionStrength); //<--- regular occlusion term
    real metallic = materialData.metallic;
    real smoothness = materialData.smoothness;
    real reflectance = materialData.reflectance;
    real perceptualRoughness = 1.0 - smoothness;

    //clamp perceptual roughness
    perceptualRoughness = max(perceptualRoughness, MIN_PERCEPTUAL_ROUGHNESS);

    //apply specular anti-aliasing (doesn't outright solve it, but helps mitgate it)
    #if defined (_SPECULAR_AA)
        perceptualRoughness = normalFiltering(perceptualRoughness, vector_normalDirection);
    #endif

    real roughness = perceptualRoughness * perceptualRoughness; //offical roughness term for pbr shading
    roughness = max(roughness, MIN_ROUGHNESS); //clamp roughness value

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
    #if defined (REALTIME_LIGHTING_PERPIXEL_DIFFUSE) || defined (REALTIME_LIGHTING_PERPIXEL_SPECULAR)
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
            real realtime_normalMapShadow = saturate(1 - TerrainNormalTangentShadow(vector_uv, vector_lightDirectionTangent, 1.0f, splatControl));
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
        real3 vector_halfDirection = normalize(vector_viewDirection + vector_lightDirection); //halfway direction between the view and the light

        //calculate some dot products using the realtime light direction
        real HdotV = saturate(dot(vector_halfDirection, vector_viewDirection));
        real NdotH = saturate(dot(vector_normalDirection, vector_halfDirection));
        real VdotH = saturate(dot(vector_viewDirection, vector_halfDirection));
        real LdotH = saturate(dot(vector_lightDirection, vector_halfDirection));

        //realtime specular
        real realtime_specularVisibility = V_SmithGGXCorrelatedFast(NdotV, NdotL, roughness);
        real realtime_specularDistribution = D_GGX(roughness, NdotH, vector_normalDirection, vector_halfDirection);
        real3 realtime_specularFresnel = F_Schlick(LdotH, f0);
        real3 realtime_specular = realtime_specularFresnel * (realtime_specularVisibility * realtime_specularDistribution) * _LightColor0.rgb * realtime_lightAttenuation * NdotL;

        realtime_specular *= realtimeLightSpecularOcclusion;
        computedSpecular += realtime_specular;
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

        //if directional lightmaps are enabled
        #if defined(DIRLIGHTMAP_COMBINED)
            //sample the realtime directional lightmap
            real4 dynamicLightmapDirection = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, vector_lightmapDynamicUVs.xy) * 2.0f - 1.0f;

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

            //compute normal map shadows
            #if defined (_NORMALMAP_SHADOWS) && !defined (LIGHTMAPPING_USE_NDOTL_WRAP) && defined(_NORMALMAP)
                real3 dynamicLightmap_lightDirectionTangent = mul(shading_tangentToWorld, dynamicLightmapDirection.xyz);
                real dynamicLightmap_shadowTerm = saturate(1 - TerrainNormalTangentShadow(vector_uv, dynamicLightmap_lightDirectionTangent, 1.0f, splatControl));
                dynamicLightmap_NdotL *= dynamicLightmap_shadowTerm;
                dynamicLightmap_computedSpecularOcclusion *= dynamicLightmap_shadowTerm;
            #endif

            //sample an ndotl term so we can shade the original diffuse term of the lightmap again but using additional detail from the normal maps
            #if defined (LIGHTMAPPING_USE_NDOTL_WRAP)
                dynamicLightmap *= saturate(dot(vector_normalDirection, dynamicLightmapDirection.xyz) * 0.5 + 0.5) / max(1e-4h, dynamicLightmapDirection.w); //from unitycg
            #else
                dynamicLightmap *= dynamicLightmap_NdotL / max(1e-4h, dynamicLightmapDirection.w); //from unitycg
            #endif

            //calculate a specular highlight for the dynamic lightmap using the directionality term
            #if defined(_SPECULAR_HIGHLIGHTS)
                //note: normally it would be nice to reuse the vectors and dot products we calculated earlier.
                //however all of those are calculated for realtime lights and not dominant lightmap direction so we need to recalculate new ones.
                // 
                //recalculate our own vector and dot products using the dominant direction from the lightmap as the "light direction"
                real3 dynamicLightmap_halfDirection = normalize(vector_viewDirection + dynamicLightmapDirection.xyz);
                real dynamicLightmap_NdotH = saturate(dot(vector_normalDirection, dynamicLightmap_halfDirection));
                real dynamicLightmap_LdotH = saturate(dot(dynamicLightmapDirection.xyz, dynamicLightmap_halfDirection));

                //use our new vector and dot products calculate new specular visibility, distribution, and fresnel terms for the dominant lightmap direction.
                real dynamicLightmap_specularVisibility = V_SmithGGXCorrelatedFast(NdotV, dynamicLightmap_NdotL, roughness);
                real dynamicLightmap_specularDistribution = D_GGX(roughness, dynamicLightmap_NdotH, vector_normalDirection, dynamicLightmap_halfDirection);
                real3 dynamicLightmap_specularFresnel = F_Schlick(dynamicLightmap_LdotH, f0);
                real3 dynamicLightmap_specularTerm = (dynamicLightmap_specularVisibility * dynamicLightmap_specularDistribution) * dynamicLightmap_specularFresnel * dynamicLightmap;

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

        //if there is also a directional lightmap baked, lets use it to our advantage do to some extra stuff with it.
        #if defined(DIRLIGHTMAP_COMBINED)
            //sample the directional lightmap, and scale it to normal space (from 0..1 to -1..1) - this contains the dominant light direction from the lightmaps
            real4 lightmapDirection = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, vector_lightmapUVs) * 2.0 - 1.0;

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

            //compute normal map shadows
            #if defined (_NORMALMAP_SHADOWS) && !defined (LIGHTMAPPING_USE_NDOTL_WRAP) && defined(_NORMALMAP)
                real3 lightmap_lightDirectionTangent = mul(shading_tangentToWorld, lightmapDirection.xyz);
                real lightmap_shadowTerm = saturate(1 - TerrainNormalTangentShadow(vector_uv, lightmap_lightDirectionTangent, 1.0f, splatControl));
                lightmap_NdotL *= lightmap_shadowTerm;
                lightmap_computedSpecularOcclusion *= lightmap_shadowTerm;
            #endif

            //sample an ndotl term so we can shade the original diffuse term of the lightmap again but using additional detail from the normal maps
            #if defined (LIGHTMAPPING_USE_NDOTL_WRAP)
                indirectLightmap *= saturate(dot(vector_normalDirection, lightmapDirection.xyz) * 0.5 + 0.5) / max(1e-4h, lightmapDirection.w); //from unitycg
            #else
                indirectLightmap *= lightmap_NdotL / max(1e-4h, lightmapDirection.w); //from unitycg
            #endif

            //calculate a specular highlight for the baked lightmap using the baked directionality term
            #if defined(_SPECULAR_HIGHLIGHTS)
                //note: normally it would be nice to reuse the vectors and dot products we calculated earlier.
                //however all of those are calculated for realtime lights and not dominant lightmap direction so we need to recalculate new ones.
                // 
                //recalculate our own vector and dot products using the dominant direction from the lightmap as the "light direction"
                real3 lightmap_halfDirection = normalize(vector_viewDirection + lightmapDirection.xyz);
                real lightmap_NdotH = saturate(dot(vector_normalDirection, lightmap_halfDirection));
                real lightmap_LdotH = saturate(dot(lightmapDirection.xyz, lightmap_halfDirection));

                //use our new vector and dot products calculate new specular visibility, distribution, and fresnel terms for the dominant lightmap direction.
                real lightmap_specularVisibility = V_SmithGGXCorrelatedFast(NdotV, lightmap_NdotL, roughness);
                real lightmap_specularDistribution = D_GGX(roughness, lightmap_NdotH, vector_normalDirection, lightmap_halfDirection);
                real3 lightmap_specularFresnel = F_Schlick(lightmap_LdotH, f0);
                real3 lightmap_specularTerm = (lightmap_specularVisibility * lightmap_specularDistribution) * lightmap_specularFresnel * indirectLightmap;

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
        real3 sphericalHarmonicsColor = ShadeSH9(real4(vector_normalDirection, 1.0));

        //probe contrast hack (not physically based at all)
        #if defined (HACK_PROBE_CONTRAST)
            real sphericalHarmonicsLuma = dot(sphericalHarmonicsColor, unity_ColorSpaceLuminance);
            sphericalHarmonicsColor = (sphericalHarmonicsLuma * sphericalHarmonicsLuma) * sphericalHarmonicsColor * UNITY_PI;
        #endif

        //extra shared variables used by the following features
        #if defined (_SPECULAR_HIGHLIGHTS)// || defined (_MICRO_SHADOWING) || defined (_NORMALMAP_SHADOWS)
            //add the L1 bands from the spherical harmonics probe to get our direction.
            real3 sphericalHarmonicsL1_direction = unity_SHAr.xyz + unity_SHAg.xyz + unity_SHAb.xyz;

            //compute the classic n dot l term using the dominant direction
            //real sphericalHarmonics_NdotL = saturate(dot(vector_normalDirection, sphericalHarmonicsL1_direction));

            //all commented out, but kept in here from the micro shadow/normal map shadow attempts
            //real3 sphericalHarmonicsL2_direction = unity_SHBr.xyz + unity_SHBg.xyz + unity_SHBb.xyz;
            //real3 sphericalHarmonicsL2_direction = unity_SHBr.xyz + unity_SHBg.xyz + unity_SHBb.xyz + unity_SHC.xyz;
            real sphericalHarmonics_NdotL = saturate(dot(vector_normalDirection, sphericalHarmonicsL1_direction));
            //real sphericalHarmonics_NdotL_L1 = saturate(dot(vector_normalDirection, sphericalHarmonicsL1_direction));
            //real sphericalHarmonics_NdotL_L2 = saturate(dot(vector_normalDirection, sphericalHarmonicsL2_direction));
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

            #if defined (PROBE_MICRO_NORMALMAP_SHADOWS)
                //real sphericalHarmonicsShadow = sphericalHarmonics_NdotL;
                half3 l0l1Color = SHEvalLinearL0L1(real4(vector_normalDirection, 1));
                half3 l2Color = SHEvalLinearL2(real4(vector_normalDirection, 1));

                //compute micro normal map shadowing for extra detail (if enabled)
                #if defined (_MICRO_SHADOWING)
                    sphericalHarmonics_NdotL *= saturate(computeMicroShadowing(sphericalHarmonics_NdotL_L1, occlusion));
                    sphericalHarmonics_NdotL *= saturate(computeMicroShadowing(sphericalHarmonics_NdotL_L2, occlusion));
                #endif

                #if defined (_NORMALMAP_SHADOWS)
                    half3 sphericalHarmonicsL1_directionTangent = mul(shading_tangentToWorld, sphericalHarmonicsL1_direction.xyz);
                    half3 sphericalHarmonicsL2_directionTangent = mul(shading_tangentToWorld, sphericalHarmonicsL2_direction.xyz);
                    sphericalHarmonics_NdotL_L1 *= saturate(1 - NormalTangentShadow(vector_uv, sphericalHarmonicsL1_directionTangent, 1.0f));
                    sphericalHarmonics_NdotL_L2 *= saturate(1 - NormalTangentShadow(vector_uv, sphericalHarmonicsL2_directionTangent, 1.0f));
                #endif

                //add the result to the computed diffuse
                //computedDiffuse += (sphericalHarmonicsColor * 0.5) + (spheridcalHarmonicsShadow * 0.5);
                //computedDiffuse += (l2Color * sphericalHarmonicsShadow);
                computedDiffuse += max(0.0, l2Color * sphericalHarmonics_NdotL_L2) + max(0.0, l0l1Color * sphericalHarmonics_NdotL_L1);
            #else
                computedDiffuse += sphericalHarmonicsColor;
            #endif
        */

        //accumulate the enviorment lighting color for occluding enviorment reflections later
        acumulatedEnviormentLighting += sphericalHarmonicsColor;

        computedDiffuse += sphericalHarmonicsColor;

        //NOTE OCCLUSION ISSUE WITH THIS WHERE AT 1 INTENSITY IT ACTUALLY OCCLUDES EVEN LIGHTMAPPED OBJECTS
        //occlude the enviorment specular based on the probe color (not phyiscally based)
        #if defined(_SPECULAR_OCCLUSION)
            real probeOcclusion = saturate(length(sphericalHarmonicsColor * _ProcedualExposureOcclusion) + (1.0 - _ProcedualExposureOcclusion));
            occlusionEnviormentSpecular *= probeOcclusion;
        #endif

        //ambient probe specular lighting
        #if defined (_SPECULAR_HIGHLIGHTS)
            //note: normally it would be nice to reuse the vectors and dot products we calculated earlier.
            //however all of those are calculated for realtime lights and not dominant spherical harmonic directions so we need to recalculate new ones.
            // 
            //recalculate our own vector and dot products using the dominant direction from the spherical harmonics as the "light direction"
            real3 sphericalHarmonics_halfDirection = normalize(vector_viewDirection + sphericalHarmonicsL1_direction);
            real sphericalHarmonics_NdotH = saturate(dot(vector_normalDirection, sphericalHarmonics_halfDirection));
            real sphericalHarmonics_LdotH = saturate(dot(sphericalHarmonicsL1_direction, sphericalHarmonics_halfDirection));

            //use our new vector and dot products calculate new specular visibility, distribution, and fresnel terms for the dominant spherical harmonic direction.
            real sphericalHarmonics_specularVisibility = V_SmithGGXCorrelatedFast(NdotV, sphericalHarmonics_NdotL, roughness);
            real sphericalHarmonics_specularDistribution = D_GGX(roughness, sphericalHarmonics_NdotH, vector_normalDirection, sphericalHarmonics_halfDirection);
            real3 sphericalHarmonics_specularFresnel = F_Schlick(sphericalHarmonics_LdotH, f0);
            real3 sphericalHarmonicsL1_specular = sphericalHarmonics_NdotL * (sphericalHarmonics_specularVisibility * sphericalHarmonics_specularDistribution) * sphericalHarmonics_specularFresnel * sphericalHarmonicsColor;

            //max is required because at some really grazing angles we get some black pixels?
            computedSpecular += max(0.0f, sphericalHarmonicsL1_specular);
        #endif
    #endif

    //||||||||||||||||||||||||||||||| ENVIORMENT REFLECTIONS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| ENVIORMENT REFLECTIONS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| ENVIORMENT REFLECTIONS |||||||||||||||||||||||||||||||
    //calculating enviorment reflections by sampling the current given specular cubemap

    #if defined(_GLOSSY_REFLECTIONS)
        //used for sampling blurry/sharp glossy reflections.
        real mip = perceptualRoughnessToMipmapLevel(perceptualRoughness);

        #if !defined (_ANISOTROPIC)
            //compute our reflection vector for glossy reflections
            real3 vector_reflectionDirection = reflect(-vector_viewDirection, vector_normalDirection);
        #else
            //compute our reflection vector for glossy reflections
            real bendFactor = abs(materialData.anisotropy) * saturate(5.0 * perceptualRoughness);
            real3 bentNormal = normalize(lerp(vector_normalDirection, vector_anisotropicNormal, bendFactor));
            real3 vector_reflectionDirection = reflect(-vector_viewDirection, bentNormal);
        #endif

            //if box projection is enabled, modify our vector to project reflections onto a world space box (defined by the reflection probe)
        #if defined(UNITY_SPECCUBE_BOX_PROJECTION)
            vector_reflectionDirection = BoxProjectedCubemapDirection(vector_reflectionDirection, vector_worldPosition, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
        #endif

        //sample the provided reflection probe at the given mip level
        real4 enviormentReflection = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, vector_reflectionDirection.xyz, mip);

        //decode the reflection if it's HDR
        enviormentReflection.rgb = DecodeHDR(enviormentReflection, unity_SpecCube0_HDR);

        //apply a new fresnel for the enviorment reflection and use NdotV instead because enviorment reflections come from everywhere instead of a specific light source.
        real3 enviormentReflection_fresnel = F_Schlick(NdotV, f0);
        enviormentReflection.rgb *= enviormentReflection_fresnel;

        //occlude the dynamic lightmap specular (not phyiscally based)
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

    //||||||||||||||||||||||||||||||| FINAL |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| FINAL |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| FINAL |||||||||||||||||||||||||||||||

    //after all of our shenangins adding light to the final result, now we finally multiply it by the base material color.
    computedDiffuse *= materialData.albedo;

    //apply final material occlusion to specular
    computedSpecular *= occlusion;

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

//MAIN FRAGMENT (PER PIXEL) FORWARD ADD PASS
//Computes the following...
// - 1 Realtime Point/Spot Light (Main, Translucency, Micro Shadow, Normal Map Shadows)
// - Parallax Occlusion Mapping
real4 fragment_forward_add(vertexToFragment i) : SV_Target
{
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
    #if defined (_NORMALMAP_SHADOWS) || defined (_PARALLAX_MAPPING)
        real3 vector_tangent = real3(i.tangentSpace0_worldNormal.x, i.tangentSpace1.x, i.tangentSpace2.x);
        real3 vector_biTangent = real3(i.tangentSpace0_worldNormal.y, i.tangentSpace1.y, i.tangentSpace2.y);
        real3 vector_worldNormal = real3(i.tangentSpace0_worldNormal.z, i.tangentSpace1.z, i.tangentSpace2.z);

        real3x3 shading_tangentToWorld = real3x3(vector_tangent, vector_biTangent, vector_worldNormal);
    #endif

    real4 splatControl = tex2D(_Control, vector_uv);

    //if parallax mapping is enabled, modify the 
    #if defined(_PARALLAX_MAPPING)
        real3 vector_viewDirectionTangentSpace = mul(shading_tangentToWorld, vector_viewDirection);
        vector_uv = Parallax(real4(vector_uv.xy, 0, 0), vector_viewDirectionTangentSpace).xy;
    #endif

    //sample our normals (either with a normal map if its in use, or use the geometric normal)
    #if defined(_NORMALMAP)
        //sample our normal map texture
        real3 texture_normalMap = SampleTerrainNormalMap(vector_uv, splatControl);

        //calculate our normals with the normal map into consideration
        real3 vector_normalDirection = real3(
            dot(i.tangentSpace0_worldNormal, texture_normalMap.xyz),
            dot(i.tangentSpace1, texture_normalMap.xyz),
            dot(i.tangentSpace2, texture_normalMap.xyz));

        //normalize the vector so it stays in a -1..1 range
        vector_normalDirection = normalize(vector_normalDirection);
    #else
        //FIX: because we can have parallaxing/anistrophic without normals, we need to use the world normal that is split across different vectors.
        #if defined (_PARALLAX_MAPPING)
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
    TerrainMaterialData materialData;
    SampleTerrainMaterialData(vector_uv, splatControl, materialData);

    #if defined (_ALPHA_CUTOFF)
        clip(materialData.albedo.a - _Cutoff);
    #endif

    finalColor.a = materialData.albedo.a - _Cutoff;

    //||||||||||||||||||||||||||||||| SHARED DOT PRODUCTS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| SHARED DOT PRODUCTS |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| SHARED DOT PRODUCTS |||||||||||||||||||||||||||||||
    //main dot products used for calculating shading (these are shared and don't use the realtime light)

    real NdotV = saturate(dot(vector_normalDirection, vector_viewDirection)); //note: in UnityStandardBRDF.cginc they use abs instead to prevent some issues later on?

    //||||||||||||||||||||||||||||||| PHYSICALLY BASED SHADING SETUP |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| PHYSICALLY BASED SHADING SETUP |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| PHYSICALLY BASED SHADING SETUP |||||||||||||||||||||||||||||||
    //calculating some terms to use in PBR calculations

    real occlusion = (materialData.occlusion * _OcclusionStrength) + (1.0 - _OcclusionStrength);
    real metallic = materialData.metallic;
    real smoothness = materialData.smoothness;
    real reflectance = materialData.reflectance;
    real perceptualRoughness = 1.0 - smoothness;

    //clamp perceptual roughness
    perceptualRoughness = max(perceptualRoughness, MIN_PERCEPTUAL_ROUGHNESS);

    //apply specular anti-aliasing (doesn't outright solve it, but helps mitgate it)
    #if defined (_SPECULAR_AA)
        perceptualRoughness = normalFiltering(perceptualRoughness, vector_normalDirection);
    #endif

    real roughness = perceptualRoughness * perceptualRoughness; //offical roughness term for pbr shading
    roughness = max(roughness, MIN_ROUGHNESS); //clamp roughness value

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

    //shared realtime per pixel vectors/dot products
    #if defined (REALTIME_LIGHTING_PERPIXEL_DIFFUSE) || defined (REALTIME_LIGHTING_PERPIXEL_SPECULAR)
        //get primary realtime light direction vector.
        real3 vector_positionToLight = _WorldSpaceLightPos0.xyz - vector_worldPosition.xyz;
        real distanceToLight = dot(vector_positionToLight, vector_positionToLight);

        // don't produce NaNs if some vertex position overlaps with the light
        distanceToLight = max(distanceToLight, 0.000001);
        distanceToLight *= rsqrt(distanceToLight);

        //realtime light attenuation and shadows.
        real realtime_lightAttenuation = 1.0 / (1.0 + distanceToLight) * LIGHT_ATTENUATION(i);
        real3 vector_lightDirection = normalize(vector_positionToLight);

        //calculate primary dot product for realtime light.
        real NdotL = saturate(dot(vector_normalDirection, vector_lightDirection));
    #endif

    //perform per pixel realtime diffuse lighting
    #if defined (REALTIME_LIGHTING_PERPIXEL_DIFFUSE)
        real3 realtime_diffuse = NdotL * Fd_Lambert() * _LightColor0.rgb * realtime_lightAttenuation;

        //compute micro normal map shadowing for extra detail (if enabled)
        #if defined (_MICRO_SHADOWING)
            real microShadowingTerm = computeMicroShadowing(NdotL, occlusion);
            computedDiffuse += realtime_diffuse * microShadowingTerm;
            occlusion *= microShadowingTerm;
        #else
            computedDiffuse += realtime_diffuse;
        #endif

        //compute normal map shadows for extra detail (if enabled)
        #if defined (_NORMALMAP_SHADOWS) && defined(_NORMALMAP)
            real3 vector_lightDirectionTangent = mul(shading_tangentToWorld, vector_lightDirection.xyz);
            real normalMapShadowTerm = saturate(1 - TerrainNormalTangentShadow(vector_uv, vector_lightDirectionTangent, 1.0f, splatControl));
            computedDiffuse *= normalMapShadowTerm;
            occlusion *= normalMapShadowTerm;
        #endif
    #endif

    //perform per vertex realtime diffuse lighting
    #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
        computedDiffuse += i.vertexLighting;
    #endif

    //perform per pixel specularity if enabled
    #if defined (_SPECULAR_HIGHLIGHTS) && defined(REALTIME_LIGHTING_PERPIXEL_SPECULAR)
        real3 vector_halfDirection = normalize(vector_viewDirection + vector_lightDirection); //halfway direction between the view and the light

        //calculate some dot products using the realtime light direction
        real HdotV = saturate(dot(vector_halfDirection, vector_viewDirection));
        real NdotH = saturate(dot(vector_normalDirection, vector_halfDirection));
        real VdotH = saturate(dot(vector_viewDirection, vector_halfDirection));
        real LdotH = saturate(dot(vector_lightDirection, vector_halfDirection));

        //realtime specular
        real realtime_specularVisibility = V_SmithGGXCorrelatedFast(NdotV, NdotL, roughness);
        real realtime_specularDistribution = D_GGX(roughness, NdotH, vector_normalDirection, vector_halfDirection);
        real3 realtime_specularFresnel = F_Schlick(LdotH, f0);
        real3 realtime_specular = realtime_specularFresnel * (realtime_specularVisibility * realtime_specularDistribution) * _LightColor0.rgb * realtime_lightAttenuation * NdotL;
        computedSpecular += realtime_specular;
    #endif

    //||||||||||||||||||||||||||||||| COMBINE LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| COMBINE LIGHTING |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| COMBINE LIGHTING |||||||||||||||||||||||||||||||

    //after all of our shenangins adding light to the final result, now we finally multiply it by the base material color.
    computedDiffuse *= materialData.albedo;

    computedSpecular *= occlusion;

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
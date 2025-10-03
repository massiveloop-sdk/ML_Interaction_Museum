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

    //fixed4 color : COLOR;

    //instancing
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct vertexToFragment
{
    real4 pos : SV_POSITION; //xyzw = vertex position
    real2 uvTexture : TEXCOORD0;
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
    //o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    //o.posWorld = v.vertex;
    o.posWorld = mul(unity_WorldToObject, v.vertex);

    //if we are using a normal map then compute tangent vectors, otherwise just compute the regular mesh normal
    #if defined(_NORMALMAP) || defined(_PARALLAX_MAPPING) || defined (_ANISOTROPIC)
        //compute the world normal
        real3 worldNormal = UnityObjectToWorldNormal(normalize(v.normal));

        //the tangents of the mesh
        real3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);

        real tangentSign = v.tangent.w * unity_WorldTransformParams.w;

        //compute bitangent from cross product of normal and tangent
        real3 worldBiTangent = cross(worldNormal, worldTangent) * tangentSign;

        //output the tangent space matrix
        o.tangentSpace0_worldNormal = real3(worldTangent.x, worldBiTangent.x, worldNormal.x);
        o.tangentSpace1 = real3(worldTangent.y, worldBiTangent.y, worldNormal.y);
        o.tangentSpace2 = real3(worldTangent.z, worldBiTangent.z, worldNormal.z);

        //if enabled, do diffuse lighting per vertex
        #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
            o.vertexLighting += ComputeVertexDiffuseLighting(worldNormal, o.posWorld.xyz, false);
        #endif
    #else
        //the world normal of the mesh
        o.tangentSpace0_worldNormal = UnityObjectToWorldNormal(normalize(v.normal));

        //if enabled, do diffuse lighting per vertex
        #if defined (REALTIME_LIGHTING_PERVERTEX_DIFFUSE)
            o.vertexLighting += ComputeVertexDiffuseLighting(o.tangentSpace0_worldNormal, o.posWorld.xyz, false);
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
//MAIN FRAGMENT (PER PIXEL) FORWARD ADD PASS
//Computes the following...
// - 1 Realtime Point/Spot Light (Main, Translucency, Micro Shadow, Normal Map Shadows)
// - Parallax Occlusion Mapping
real4 fragment_forward_add(vertexToFragment i) : SV_Target
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
        real3 vector_normalDirection = real3(
            dot(i.tangentSpace0_worldNormal, texture_normalMap.xyz),
            dot(i.tangentSpace1, texture_normalMap.xyz),
            dot(i.tangentSpace2, texture_normalMap.xyz));

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

    //shared realtime per pixel vectors/dot products
    #if defined (REALTIME_LIGHTING_PERPIXEL_DIFFUSE) || defined (REALTIME_LIGHTING_PERPIXEL_SPECULAR)
        //get primary realtime light direction vector.
        //real3 vector_positionToLight = _WorldSpaceLightPos0.xyz - vector_worldPosition.xyz;
        //real distanceToLight = dot(vector_positionToLight, vector_positionToLight);

        // don't produce NaNs if some vertex position overlaps with the light
        //distanceToLight = max(distanceToLight, 0.000001);
        //distanceToLight *= rsqrt(distanceToLight);

        real realtime_lightAttenuation;
        real3 vector_lightDirection;

        //vector_worldPosition
        //vector_viewPosition


        ComputeLightDirectionAndAttenuation(vector_worldPosition, false, vector_lightDirection, realtime_lightAttenuation);


        realtime_lightAttenuation *= LIGHT_ATTENUATION(i);

        //realtime light attenuation and shadows.
        //real realtime_lightAttenuation = 1.0 / (1.0 + distanceToLight) * LIGHT_ATTENUATION(i);
        //real3 vector_lightDirection = normalize(vector_positionToLight);

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
            real normalMapShadowTerm = saturate(1 - NormalTangentShadow(vector_uv, vector_lightDirectionTangent, 1.0f));
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
        #if defined (_ANISOTROPIC)
            real3 realtime_specular = _LightColor0.rgb * realtime_lightAttenuation * ComputeBDRF_SpecularAnisotropicResponse(vector_normalDirection, vector_viewDirection, vector_lightDirection, NdotL, NdotV, TdotV, BdotV, roughness, f0, anisotropicT, anisotropicB, at, ab);
        #else
            real3 realtime_specular = _LightColor0.rgb * realtime_lightAttenuation * ComputeBDRF_SpecularResponse(vector_normalDirection, vector_viewDirection, vector_lightDirection, NdotL, NdotV, roughness, f0);
        #endif

        computedSpecular += realtime_specular;
    #endif

    //compute translucency for realtime lights
    #if defined (_TRANSLUCENCY) && (defined (REALTIME_LIGHTING_PERPIXEL_DIFFUSE) || defined (REALTIME_LIGHTING_PERPIXEL_SPECULAR))
        real translucencyShadows = lerp(1.0, realtime_lightAttenuation, _TranslucencyShadowStrength);
        real3 translucencyTerm = _LightColor0.rgb * translucencyShadows * ComputeTranslucency(vector_viewDirection, vector_normalDirection, vector_lightDirection, materialData);
        computedDiffuse += translucencyTerm;
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
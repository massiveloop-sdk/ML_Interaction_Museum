struct vertexToFragmentShadow
{
    V2F_SHADOW_CASTER;

    real2 uvTexture : TEXCOORD1;

    UNITY_VERTEX_OUTPUT_STEREO
};

//per vertex
vertexToFragmentShadow vertex_shadow_cast(appdata_tan v)
{
    vertexToFragmentShadow o;

    //instancing
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(vertexToFragmentShadow, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    //o.pos = UnityObjectToClipPos(v.vertex);
    o.uvTexture = TRANSFORM_TEX(v.texcoord, _MainTex);

    TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)

    return o;
}

//FRAGMENT (PER PIXEL) SHADOW CASTER
//Computes the following...
//Shadow Casting
fixed4 fragment_shadow_caster(vertexToFragmentShadow i) : SV_Target
{
    //||||||||||||||||||||||||||||||| MATERIAL DATA |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| MATERIAL DATA |||||||||||||||||||||||||||||||
    //||||||||||||||||||||||||||||||| MATERIAL DATA |||||||||||||||||||||||||||||||
    //sample our main material data
    MaterialData materialData;
    SampleMaterialData(i.uvTexture, materialData);

    #if defined (_ALPHA_CUTOFF)
        clip(materialData.albedo.a - _Cutoff);
    #endif

    SHADOW_CASTER_FRAGMENT(i)
}
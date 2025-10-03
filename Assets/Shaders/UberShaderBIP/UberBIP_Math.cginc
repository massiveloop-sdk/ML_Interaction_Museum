//https://github.com/google/filament/blob/main/shaders/src/common_math.glsl

#define MEDIUMP_FLT_MIN    0.00006103515625
#define MEDIUMP_FLT_MAX    65504.0
#define saturateMediump(x) min(x, MEDIUMP_FLT_MAX)

//BUILT IN PIPELINE
//#define MATH_PI UNITY_PI
#define MATH_PI 3.14159265359f
#if UNITY_EDITOR
using UnityEngine;

namespace TextureTools
{
    public class TextureAdjustmentsOptions
    {
        public float brightness = 1.0f;
        public float contrast = 0.0f;
        public float saturation = 0.0f;
        public float vibrance = 0.0f;
        public float hueShift = 0.0f;
        public float gamma = 1.0f;

        public float colorFilterAmount;
        public Color colorFilter = Color.white;

        public Color colorMultiply = Color.white;
    }
}
#endif
#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TextureTools
{
    public class FilterAdditiveBloomOptions
    {
        public int blurSamples = 8;
        public float threshold = 0.05f;
        public float intensity = 1.0f;
        public float hdrPower = 1.0f;
    }
}
#endif
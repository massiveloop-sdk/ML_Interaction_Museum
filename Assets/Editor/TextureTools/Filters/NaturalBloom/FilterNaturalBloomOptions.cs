#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TextureTools
{
    public class FilterNaturalBloomOptions
    {
        public int blurSamples = 8;
        public float intensity = 1.0f;
        public float hdrPower = 1.0f;
    }
}
#endif
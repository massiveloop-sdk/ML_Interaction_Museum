#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TextureTools
{
    public class FilterUnsharpMaskOptions
    {
        public int gaussianSamples;
        public float amount;
    }
}
#endif
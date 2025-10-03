#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TextureTools
{
    public enum RoughnessMapping
    {
        RoughnessToSmoothness,
        RoughnessToPerceptualRoughness,
        SmoothnessToRoughness,
        SmoothnessToPerceptualRoughness,
        PerceptualRoughnessToRoughness
    }

    public class RoughnessConversionOptions
    {
        public RoughnessMapping mapping;
    }
}
#endif
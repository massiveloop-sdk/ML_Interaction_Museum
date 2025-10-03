#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TextureTools
{
    public class FilterDirectionalBlurOptions
    {
        public int blurSamples;
        public Vector2 direction;
    }
}
#endif
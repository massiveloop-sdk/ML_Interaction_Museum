#if UNITY_EDITOR

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CustomEditorTools
{
    [PreferBinarySerialization]
    [CreateAssetMenu(fileName = "LightProbePlacementAsset", menuName = "Lighting/LightProbePlacement", order = 1)]
    public class LightProbePlacementAsset : ScriptableObject
    {
        public List<LightProbePlacementVolume> volumes;
    }
}

#endif
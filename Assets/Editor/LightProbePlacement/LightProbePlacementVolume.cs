#if UNITY_EDITOR

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CustomEditorTools
{
    [System.Serializable]
    public class LightProbePlacementVolume
    {
        public string name;

        [Header("Probe Volume Options")]
        public Vector3 size;
        public Vector3 position;

        public LightProbePlacementVolumeResolutionType resolutionType;
        public float probeDensity = 1.0f;
        public Vector3Int customResolution = new Vector3Int(8, 8, 8);

        [Header("Output")]
        public List<Vector3> generatedProbePositions = new List<Vector3>();

        public Vector3Int GetCalculatedResolution()
        {
            if (resolutionType == LightProbePlacementVolumeResolutionType.Automatic)
                return new Vector3Int((int)(size.x / probeDensity), (int)(size.y / probeDensity), (int)(size.z / probeDensity));
            else
                return customResolution;
        }
    }
}

#endif
#if UNITY_EDITOR
using UnityEngine;

namespace TextureTools
{
    public struct TextureChannel
    {
        public Texture2D sourceTexture;
        public int channel; //0 = r, 1 = g, 2 = b, 3 = a
        public bool invert;
    }
}
#endif
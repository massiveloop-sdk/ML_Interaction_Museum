#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;

namespace TextureTools
{
    public static class Utils
    {
        public static GUIStyle GetNewStyleWithTextColor(GUIStyle style, Color color)
        {
            GUIStyle newStyle = new GUIStyle(style);
            newStyle.normal.textColor = color;

            return newStyle;
        }
    }
}
#endif
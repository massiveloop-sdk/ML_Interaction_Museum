#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace UberShader
{
    public class UberBIP_BDRFGenerator : EditorWindow
    {
        //GUI related
        private static int guiSectionSpacePixels = 10;
        private Vector2Int windowSize = new Vector2Int(350, 420);

        private int textureSize = 32;
        private static readonly string assetFolder = "Assets/Shader/UberShader";

        private static readonly TextureFormat texutreFormat = TextureFormat.RGHalf;

        //add a menu item at the top of the unity editor toolbar
        [MenuItem("UberShader/BDRF Generator")]
        public static void ShowWindow()
        {
            //get the window and open it
            GetWindow(typeof(UberBIP_BDRFGenerator));
        }

        /// <summary>
        /// GUI display function for the window
        /// </summary>
        void OnGUI()
        {
            maxSize = windowSize;
            minSize = windowSize;

            GUILayout.Label("BDRF Generator", EditorStyles.whiteLargeLabel);
            //GUILayout.BeginHorizontal();
            //GUILayout.BeginVertical();

            textureSize = EditorGUILayout.IntField("LUT Size", textureSize);

            if (GUILayout.Button("Bake BDRF"))
            {
                GenerateGGX();
            }
        }

        private void GenerateGGX()
        {
            Texture2D lut = new Texture2D(textureSize, textureSize, texutreFormat, false, true);
            lut.filterMode = FilterMode.Bilinear;
            lut.wrapMode = TextureWrapMode.Clamp;
            
            //for (int x = 1; x <= lut.width; x++)
            for (int x = 0; x < lut.width; x++)
            {
                //for(int y = 1; y <= lut.height; y++)
                for (int y = 0; y < lut.height; y++)
                {
                    float normalizedX = x + 1;
                    float normalizedY = y + 1;
                    normalizedX *= 1.0f / lut.width;
                    normalizedY *= 1.0f / lut.height;

                    //normalizedX = Mathf.Clamp(normalizedX, 0.01f, 1.0f);
                    //normalizedY = Mathf.Clamp(normalizedY, 0.01f, 1.0f);

                    float roughness = normalizedX;
                    float NdotH = normalizedY;

                    float u = normalizedX;

                    double schlickFValue = F_Schlick_TermF(u);
                    double ggxValue = GGXTerm(NdotH, roughness);
                    Color result = new Color((float)ggxValue, (float)schlickFValue, 0);

                    //lut.SetPixel(x - 1, y - 1, result);
                    lut.SetPixel(x, y, result);
                }
            }

            lut.Apply();

            SaveTexture("GGX_Schlick", lut);
        }

        private void SaveTexture(string filename, Texture2D texture)
        {
            string texturePath = assetFolder + "/" + filename + ".asset";

            //if(AssetDatabase.AssetPathExists(texturePath))
                AssetDatabase.DeleteAsset(texturePath);

            AssetDatabase.CreateAsset(texture, texturePath);
        }

        public static double GGXTerm(double NoH, double roughness)
        {
            double a = NoH * roughness;
            double k = roughness / (1.0 - NoH * NoH + a * a);
            return k * k * (1.0 / System.Math.PI);
        }

        //https://google.github.io/filament/Filament.html#materialsystem
        //u = (View Direction) dot (Half Direction)
        //float3 F_Schlick(float u, float3 f0)
        public static double F_Schlick_TermF(double u)
        {
            return System.Math.Pow(1.0 - u, 5.0);
        }
    }
}
#endif
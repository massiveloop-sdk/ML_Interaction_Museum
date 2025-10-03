#if UNITY_EDITOR
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEditor;

namespace TextureTools
{
    public class TextureAdjustments
    {
        private static int guiSectionSpacePixels = 10;

        private ComputeShader computeShader;
        private TextureAdjustmentsOptions adjustmentsOptons;

        private Texture2D temp;

        public TextureAdjustments()
        {
            computeShader = (ComputeShader)AssetDatabase.LoadAssetAtPath("Assets/Editor/TextureTools/Adjustments/Adjustments.compute", typeof(ComputeShader));
        }

        public void ShowUI()
        {
            if (adjustmentsOptons == null)
                adjustmentsOptons = new TextureAdjustmentsOptions();

            EditorGUILayout.BeginVertical();

            EditorGUILayout.BeginHorizontal();

            if (temp != null)
            {
                EditorGUI.DrawPreviewTexture(new Rect(5, 110, 375, 375), temp);
                EditorGUILayout.Space(375);
            }
            else
            {
                EditorGUILayout.Space(375);
            }

            EditorGUILayout.BeginVertical();
            adjustmentsOptons.brightness = EditorGUILayout.FloatField("Brightness", adjustmentsOptons.brightness);
            adjustmentsOptons.contrast = EditorGUILayout.FloatField("Contrast", adjustmentsOptons.contrast);
            adjustmentsOptons.saturation = EditorGUILayout.FloatField("Saturation", adjustmentsOptons.saturation);
            adjustmentsOptons.vibrance = EditorGUILayout.FloatField("Vibrance", adjustmentsOptons.vibrance);
            adjustmentsOptons.hueShift = EditorGUILayout.FloatField("Hue Shift", adjustmentsOptons.hueShift);
            adjustmentsOptons.gamma = EditorGUILayout.FloatField("Gamma", adjustmentsOptons.gamma);

            GUILayout.Space(guiSectionSpacePixels);
            adjustmentsOptons.colorFilter = EditorGUILayout.ColorField("Color Filter", adjustmentsOptons.colorFilter);
            adjustmentsOptons.colorFilterAmount = EditorGUILayout.Slider("Color Filter Strength", adjustmentsOptons.colorFilterAmount, 0.0f, 1.0f);

            GUILayout.Space(guiSectionSpacePixels);
            adjustmentsOptons.colorMultiply = EditorGUILayout.ColorField("Color Multiply", adjustmentsOptons.colorMultiply);

            EditorGUILayout.EndVertical();

            EditorGUILayout.EndHorizontal();

            EditorGUILayout.EndVertical();
        }

        public void Render(TextureFileEntry textureFileEntry)
        {
            //create a temp RT so the compute shader can write to it
            RenderTexture adjustRT = new RenderTexture(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, RenderTextureFormat.ARGBFloat);
            adjustRT.enableRandomWrite = true;
            adjustRT.Create();

            //find the main compute shader function
            int compute_main = computeShader.FindKernel("Adjustments");

            //feed additional values to the compute shader for remixing
            computeShader.SetFloat("Brightness", adjustmentsOptons.brightness);
            computeShader.SetFloat("Contrast", adjustmentsOptons.contrast);
            computeShader.SetFloat("Saturation", adjustmentsOptons.saturation);
            computeShader.SetFloat("Vibrance", adjustmentsOptons.vibrance);
            computeShader.SetFloat("HueShift", adjustmentsOptons.hueShift);
            computeShader.SetFloat("Gamma", adjustmentsOptons.gamma);

            computeShader.SetVector("ColorFilter", adjustmentsOptons.colorFilter);
            computeShader.SetFloat("ColorFilterStrength", adjustmentsOptons.colorFilterAmount);

            computeShader.SetVector("ColorMultiply", adjustmentsOptons.colorMultiply);

            computeShader.SetTexture(compute_main, "SourceTexture", textureFileEntry.sourceTexture);

            computeShader.SetVector("SourceTextureResolution", new Vector4(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, 0));

            computeShader.SetTexture(compute_main, "Result", adjustRT);

            //execute the compute shader function
            computeShader.Dispatch(compute_main, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            //temporairly create a new texture 2D that will contain the final rendered result
            temp = new Texture2D(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, DefaultFormat.HDR, TextureCreationFlags.None);

            //set the temp render texture from the compute shader as the current active one
            RenderTexture.active = adjustRT;

            //read the pixels and data from the render texture and apply it to the temp texture2d
            temp.ReadPixels(new Rect(0, 0, adjustRT.width, adjustRT.height), 0, 0);
            temp.Apply();

            //set the current active render texture null since we don't need it anymore
            RenderTexture.active = null;

            //free the memory and get rid of the RT since we don't need it anymore
            adjustRT.Release();
        }

        public void RenderAndSaveTexture(TextureFileEntry textureFileEntry, bool overwriteOriginalFile)
        {
            Render(textureFileEntry);

            string finalFilePath = "";

            if (overwriteOriginalFile)
            {
                AssetDatabase.DeleteAsset(textureFileEntry.sourceTexturePath);

                finalFilePath = string.Format("{0}/{1}{2}", textureFileEntry.sourceTextureDirectory, textureFileEntry.sourceTextureName, ".png");
            }
            else
            {
                finalFilePath = string.Format("{0}/{1}{2}{3}", textureFileEntry.sourceTextureDirectory, textureFileEntry.sourceTextureName, "_new", ".png");
            }

            byte[] data = null;

            /*
            switch (textureFileEntry.sourceTextureExtension)
            {
                case ".png":
                    data = newTexture.EncodeToPNG();
                    break;
                case ".tga":
                    data = newTexture.EncodeToTGA();
                    break;
                case ".jpg":
                    data = newTexture.EncodeToJPG();
                    break;
                case ".jpeg":
                    data = newTexture.EncodeToJPG();
                    break;
                case ".exr":
                    data = newTexture.EncodeToEXR();
                    break;
            }
            */

            data = temp.EncodeToPNG();

            //if the byte data is null, that means the original texture couldn't be encoded so don't continue
            if (data == null)
                return;

            //write and save the file to the disk and then reimport it in unity so it generates a .meta file and appears in the project view right away.
            File.WriteAllBytes(finalFilePath, data);
            AssetDatabase.ImportAsset(finalFilePath);
        }
    }
}
#endif
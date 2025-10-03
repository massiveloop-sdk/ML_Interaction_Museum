#if UNITY_EDITOR
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEditor;

namespace TextureTools
{
    public class FilterUnsharpMask
    {
        private static int guiSectionSpacePixels = 10;

        private ComputeShader computeShader;
        private FilterUnsharpMaskOptions options;

        private Texture2D temp;

        public FilterUnsharpMask()
        {
            computeShader = (ComputeShader)AssetDatabase.LoadAssetAtPath("Assets/Editor/TextureTools/Filters/UnsharpMask/UnsharpMask.compute", typeof(ComputeShader));
        }

        public void ShowUI()
        {
            if (options == null)
                options = new FilterUnsharpMaskOptions();

            EditorGUILayout.BeginVertical();

            EditorGUILayout.BeginHorizontal();

            if (temp != null)
            {
                EditorGUI.DrawPreviewTexture(new Rect(5, 155, 375, 375), temp);
                EditorGUILayout.Space(375);
            }
            else
            {
                EditorGUILayout.Space(375);
            }

            EditorGUILayout.BeginVertical();
            options.gaussianSamples = EditorGUILayout.IntSlider("Gaussian Samples", options.gaussianSamples, 1, 1024);
            options.amount = EditorGUILayout.FloatField("Amount", options.amount);
            EditorGUILayout.EndVertical();

            EditorGUILayout.EndHorizontal();

            EditorGUILayout.EndVertical();
        }

        public void Render(TextureFileEntry textureFileEntry)
        {
            //create a temp RT so the compute shader can write to it
            RenderTexture tempRT_1 = new RenderTexture(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, RenderTextureFormat.ARGBFloat);
            tempRT_1.enableRandomWrite = true;
            tempRT_1.Create();

            RenderTexture tempRT_2 = new RenderTexture(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, RenderTextureFormat.ARGBFloat);
            tempRT_2.enableRandomWrite = true;
            tempRT_2.Create();

            RenderTexture tempRT_3 = new RenderTexture(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, RenderTextureFormat.ARGBFloat);
            tempRT_3.enableRandomWrite = true;
            tempRT_3.Create();

            //find the main compute shader function
            int compute_pass1 = computeShader.FindKernel("UnsharpMask_Pass1");
            int compute_pass2 = computeShader.FindKernel("UnsharpMask_Pass2");
            int compute_pass3 = computeShader.FindKernel("UnsharpMask_Pass3");

            //feed additional values to the compute shader for remixing
            computeShader.SetInt("BlurSamples", options.gaussianSamples);
            computeShader.SetFloat("Amount", options.amount);
            computeShader.SetVector("SourceTextureResolution", new Vector4(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, 0));

            computeShader.SetTexture(compute_pass1, "Read_SourceTexture_Pass1", textureFileEntry.sourceTexture);
            computeShader.SetTexture(compute_pass1, "Write_SourceTexturePass1", tempRT_1);
            computeShader.Dispatch(compute_pass1, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            computeShader.SetTexture(compute_pass2, "Read_SourceTexture_Pass2", tempRT_1);
            computeShader.SetTexture(compute_pass2, "Write_SourceTexturePass2", tempRT_2);
            computeShader.Dispatch(compute_pass2, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            computeShader.SetTexture(compute_pass3, "Read_SourceTexture_Pass1", textureFileEntry.sourceTexture);
            computeShader.SetTexture(compute_pass3, "Read_SourceTexture_Pass3", tempRT_2);
            computeShader.SetTexture(compute_pass3, "Write_SourceTexturePass3", tempRT_3);
            computeShader.Dispatch(compute_pass3, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            //temporairly create a new texture 2D that will contain the final rendered result
            temp = new Texture2D(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, DefaultFormat.HDR, TextureCreationFlags.None);

            //set the temp render texture from the compute shader as the current active one
            RenderTexture.active = tempRT_3;

            //read the pixels and data from the render texture and apply it to the temp texture2d
            temp.ReadPixels(new Rect(0, 0, tempRT_3.width, tempRT_3.height), 0, 0);
            temp.Apply();

            //set the current active render texture null since we don't need it anymore
            RenderTexture.active = null;

            //free the memory and get rid of the RT since we don't need it anymore
            tempRT_1.Release();
            tempRT_2.Release();
            tempRT_3.Release();
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
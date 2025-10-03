#if UNITY_EDITOR
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEditor;

namespace TextureTools
{
    public class FilterNaturalBloom
    {
        private static int guiSectionSpacePixels = 10;

        private ComputeShader computeShader;
        private FilterNaturalBloomOptions options;

        private Texture2D temp;

        public FilterNaturalBloom()
        {
            computeShader = (ComputeShader)AssetDatabase.LoadAssetAtPath("Assets/Editor/TextureTools/Filters/NaturalBloom/NaturalBloom.compute", typeof(ComputeShader));
        }

        public void ShowUI()
        {
            if (options == null)
                options = new FilterNaturalBloomOptions();

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
            options.blurSamples = EditorGUILayout.IntSlider("Blur Gaussian Samples", options.blurSamples, 1, 1024);
            options.intensity = EditorGUILayout.FloatField("Bloom Intensity", options.intensity);
            options.hdrPower = EditorGUILayout.FloatField("HDR Power", options.hdrPower);
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

            RenderTexture tempRT_4 = new RenderTexture(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, RenderTextureFormat.ARGBFloat);
            tempRT_4.enableRandomWrite = true;
            tempRT_4.Create();

            //find the main compute shader function
            int compute_pass1 = computeShader.FindKernel("NaturalBloom_Pass1");
            int compute_pass2 = computeShader.FindKernel("NaturalBloom_Pass2");
            int compute_pass3 = computeShader.FindKernel("NaturalBloom_Pass3");
            int compute_pass4 = computeShader.FindKernel("NaturalBloom_Pass4");

            //feed additional values to the compute shader for remixing
            computeShader.SetInt("BlurSamples", options.blurSamples);
            computeShader.SetFloat("BloomIntensity", options.intensity);
            computeShader.SetFloat("HDRPower", options.hdrPower);
            computeShader.SetVector("SourceTextureResolution", new Vector4(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, 0));

            //pass1 - threshold
            computeShader.SetTexture(compute_pass1, "Read_SourceTexture_Pass1", textureFileEntry.sourceTexture);
            computeShader.SetTexture(compute_pass1, "Write_SourceTexture_Pass1", tempRT_1);
            computeShader.Dispatch(compute_pass1, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            //pass2 - blur h
            computeShader.SetTexture(compute_pass2, "Read_SourceTexture_Pass2", tempRT_1);
            computeShader.SetTexture(compute_pass2, "Write_SourceTexture_Pass2", tempRT_2);
            computeShader.Dispatch(compute_pass2, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            //pass3 - blur v
            computeShader.SetTexture(compute_pass3, "Read_SourceTexture_Pass3", tempRT_2);
            computeShader.SetTexture(compute_pass3, "Write_SourceTexture_Pass3", tempRT_3);
            computeShader.Dispatch(compute_pass3, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            //pass4 - composite
            computeShader.SetTexture(compute_pass4, "Read_SourceTexture_Pass1", textureFileEntry.sourceTexture);
            computeShader.SetTexture(compute_pass4, "Read_SourceTexture_Pass3", tempRT_3);
            computeShader.SetTexture(compute_pass4, "Write_SourceTexture_Pass4", tempRT_4);
            computeShader.Dispatch(compute_pass4, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            //temporairly create a new texture 2D that will contain the final rendered result
            temp = new Texture2D(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, DefaultFormat.HDR, TextureCreationFlags.None);

            //set the temp render texture from the compute shader as the current active one
            RenderTexture.active = tempRT_4;

            //read the pixels and data from the render texture and apply it to the temp texture2d
            temp.ReadPixels(new Rect(0, 0, tempRT_4.width, tempRT_4.height), 0, 0);
            temp.Apply();

            //set the current active render texture null since we don't need it anymore
            RenderTexture.active = null;

            //free the memory and get rid of the RT since we don't need it anymore
            tempRT_1.Release();
            tempRT_2.Release();
            tempRT_3.Release();
            tempRT_4.Release();
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

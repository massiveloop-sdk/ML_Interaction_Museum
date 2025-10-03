#if UNITY_EDITOR
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEditor;

namespace TextureTools
{
    public class ChannelRemixer
    {
        private static int guiSectionSpacePixels = 10;

        private static string[] channels = new string[] { "R", "G", "B", "A", "0", "1" };

        private ComputeShader computeShader;
        private TextureChannelSettings channelSettings;

        public ChannelRemixer()
        {
            computeShader = (ComputeShader)AssetDatabase.LoadAssetAtPath("Assets/Editor/TextureTools/ChannelRemixer/ChannelRemixer.compute", typeof(ComputeShader));
        }

        public void SetChannelSourceTextures(Texture2D sourceTexture)
        {
            channelSettings = new TextureChannelSettings();
            channelSettings.red.sourceTexture = sourceTexture;
            channelSettings.green.sourceTexture = sourceTexture;
            channelSettings.blue.sourceTexture = sourceTexture;
            channelSettings.alpha.sourceTexture = sourceTexture;
        }

        public void ShowUI()
        {
            if(channelSettings == null)
                channelSettings = new TextureChannelSettings();

            EditorGUILayout.BeginHorizontal();

            EditorGUILayout.BeginVertical();
            GUILayout.Label("[RED]", Utils.GetNewStyleWithTextColor(EditorStyles.boldLabel, Color.red));
            channelSettings.red.sourceTexture = (Texture2D)EditorGUILayout.ObjectField("Source Texture", channelSettings.red.sourceTexture, typeof(Texture2D), false);
            channelSettings.red.invert = EditorGUILayout.Toggle("Invert", channelSettings.red.invert);
            channelSettings.red.channel = EditorGUILayout.Popup("Use Channel", channelSettings.red.channel, channels);
            EditorGUILayout.EndVertical();

            EditorGUILayout.BeginVertical();
            GUILayout.Label("[GREEN]", Utils.GetNewStyleWithTextColor(EditorStyles.boldLabel, Color.green));
            channelSettings.green.sourceTexture = (Texture2D)EditorGUILayout.ObjectField("Source Texture", channelSettings.green.sourceTexture, typeof(Texture2D), false);
            channelSettings.green.invert = EditorGUILayout.Toggle("Invert", channelSettings.green.invert);
            channelSettings.green.channel = EditorGUILayout.Popup("Use Channel", channelSettings.green.channel, channels);
            EditorGUILayout.EndVertical();

            EditorGUILayout.BeginVertical();
            GUILayout.Label("[BLUE]", Utils.GetNewStyleWithTextColor(EditorStyles.boldLabel, Color.blue));
            channelSettings.blue.sourceTexture = (Texture2D)EditorGUILayout.ObjectField("Source Texture", channelSettings.blue.sourceTexture, typeof(Texture2D), false);
            channelSettings.blue.invert = EditorGUILayout.Toggle("Invert", channelSettings.blue.invert);
            channelSettings.blue.channel = EditorGUILayout.Popup("Use Channel", channelSettings.blue.channel, channels);
            EditorGUILayout.EndVertical();

            EditorGUILayout.BeginVertical();
            GUILayout.Label("[ALPHA]", EditorStyles.boldLabel);
            channelSettings.alpha.sourceTexture = (Texture2D)EditorGUILayout.ObjectField("Source Texture", channelSettings.alpha.sourceTexture, typeof(Texture2D), false);
            channelSettings.alpha.invert = EditorGUILayout.Toggle("Invert", channelSettings.alpha.invert);
            channelSettings.alpha.channel = EditorGUILayout.Popup("Use Channel", channelSettings.alpha.channel, channels);
            EditorGUILayout.EndVertical();

            EditorGUILayout.EndHorizontal();
        }

        public void RenderAndSaveTexture(TextureFileEntry textureFileEntry, bool overwriteOriginalFile)
        {
            //create a temp RT so the compute shader can write to it
            RenderTexture mixerRT = new RenderTexture(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 0, RenderTextureFormat.ARGBFloat);
            mixerRT.enableRandomWrite = true;
            mixerRT.Create();

            //find the main compute shader function
            int compute_main = computeShader.FindKernel("ChannelRemixer");

            //feed additional values to the compute shader for remixing
            computeShader.SetInt("RedChannelSetting", channelSettings.red.channel);
            computeShader.SetInt("GreenChannelSetting", channelSettings.green.channel);
            computeShader.SetInt("BlueChannelSetting", channelSettings.blue.channel);
            computeShader.SetInt("AlphaChannelSetting", channelSettings.alpha.channel);

            computeShader.SetBool("RedChannelInvert", channelSettings.red.invert);
            computeShader.SetBool("GreenChannelInvert", channelSettings.green.invert);
            computeShader.SetBool("BlueChannelInvert", channelSettings.blue.invert);
            computeShader.SetBool("AlphaChannelInvert", channelSettings.alpha.invert);

            computeShader.SetTexture(compute_main, "RedChannelTexture", channelSettings.red.sourceTexture);
            computeShader.SetTexture(compute_main, "GreenChannelTexture", channelSettings.green.sourceTexture);
            computeShader.SetTexture(compute_main, "BlueChannelTexture", channelSettings.blue.sourceTexture);
            computeShader.SetTexture(compute_main, "AlphaChannelTexture", channelSettings.alpha.sourceTexture);

            computeShader.SetVector("RedChannelTextureResolution", new Vector4(channelSettings.red.sourceTexture.width, channelSettings.red.sourceTexture.height, 0, 0));
            computeShader.SetVector("GreenChannelTextureResolution", new Vector4(channelSettings.green.sourceTexture.width, channelSettings.green.sourceTexture.height, 0, 0));
            computeShader.SetVector("BlueChannelTextureResolution", new Vector4(channelSettings.blue.sourceTexture.width, channelSettings.blue.sourceTexture.height, 0, 0));
            computeShader.SetVector("AlphaChannelTextureResolution", new Vector4(channelSettings.alpha.sourceTexture.width, channelSettings.alpha.sourceTexture.height, 0, 0));

            computeShader.SetTexture(compute_main, "Result", mixerRT);

            //execute the compute shader function
            computeShader.Dispatch(compute_main, textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, 1);

            //temporairly create a new texture 2D that will contain the final rendered result
            Texture2D newTexture = new Texture2D(textureFileEntry.sourceTexture.width, textureFileEntry.sourceTexture.height, DefaultFormat.HDR, TextureCreationFlags.None);

            //set the temp render texture from the compute shader as the current active one
            RenderTexture.active = mixerRT;

            //read the pixels and data from the render texture and apply it to the temp texture2d
            newTexture.ReadPixels(new Rect(0, 0, mixerRT.width, mixerRT.height), 0, 0);
            newTexture.Apply();

            //set the current active render texture null since we don't need it anymore
            RenderTexture.active = null;

            //free the memory and get rid of the RT since we don't need it anymore
            mixerRT.Release();


            string finalFilePath = "";

            if(overwriteOriginalFile)
            {
                AssetDatabase.DeleteAsset(textureFileEntry.sourceTexturePath);

                finalFilePath = string.Format("{0}/{1}{2}", textureFileEntry.sourceTextureDirectory, textureFileEntry.sourceTextureName, ".png");
            }
            else
            {
                finalFilePath = string.Format("{0}/{1}{2}{3}", textureFileEntry.sourceTextureDirectory, textureFileEntry.sourceTextureName, "_new", ".png");
            }

            //byte data of the texture file
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

            data = newTexture.EncodeToPNG();

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
#if UNITY_EDITOR
using System.IO;
using UnityEngine;
using UnityEditor;

namespace TextureTools
{
    public class TextureFileEntry
    {
        public Texture2D sourceTexture;
        public string sourceTextureSystemPath;
        public string sourceTexturePath;
        public string sourceTextureName;
        public string sourceTextureExtension;
        public string sourceTextureDirectory;

        public TextureFileEntry(Texture2D texture2D)
        {
            string selectedTexturePath = AssetDatabase.GetAssetPath(texture2D); //starts at Assets/
            string systemStartPath = Application.dataPath.Remove(Application.dataPath.Length - "Assets".Length, "Assets".Length);
            string systemAssetPath = systemStartPath + selectedTexturePath;

            //get additional data regarding the file path and format
            sourceTexture = texture2D;
            sourceTextureSystemPath = systemAssetPath;
            sourceTexturePath = selectedTexturePath;
            sourceTextureName = Path.GetFileNameWithoutExtension(sourceTexturePath);
            sourceTextureExtension = Path.GetExtension(sourceTexturePath);
            sourceTextureDirectory = Path.GetDirectoryName(sourceTexturePath);
        }
    }
}
#endif
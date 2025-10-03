#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;
using System.IO;

namespace TextureTools
{
    /// <summary>
    /// David: This is my custom utillity editor script meant for remixing textures and channels.
    /// Very useful for combining multiple textures into one to save on space...
    /// Or converting and combining seperate gloss/specular/metallic/roughness maps into one in a specific configuration so a given shader can shade properly using the correct map.
    /// </summary>
    public class TextureTools : EditorWindow
    {
        //GUI related
        private bool overwriteOriginalFile = false;
        private static bool isSingleMode = true;
        private static int guiSectionSpacePixels = 10;
        private static Vector2 minWindowSize = new Vector2(836, 300);
        private static string[] tabsSingle = new string[] { "Channel Remixer", "Adjustments", "Filters", "Utilities", "File Convert"};
        private static string[] tabsMultiple = new string[] { "Adjustments", "Filters", "Convert" };
        private static int tabsSingleIndex = 0;
        private static int tabsMultipleIndex = 0;

        //main
        private TextureFileEntry firstEntry;
        private TextureFileEntry[] textureFileEntries;
        private static string nameModifiedPrefix = "_modified";
        private static Texture2D newTexture;

        public FilterEffectTypes filterEffectTypes;
        public UtilityTypes utilityTypes;
        public TextureFormat format;

        private bool compressTexture;
        private bool highQualityCompression;

        private ChannelRemixer channelRemixer;
        private TextureAdjustments textureAdjustments;
        private FilterGaussianBlur gaussianBlur;
        private FilterBoxBlur boxBlur;
        private FilterCircleBlur circleBlur;
        private FilterDirectionalBlur directionalBlur;
        private FilterUnsharpMask unsharpMask;
        private FilterAdditiveBloom additiveBloom;
        private FilterNaturalBloom naturalBloom;

        private HeightToNormal heightToNormal;
        private RoughnessConversion roughnessConversion;

        //add a menu item at the top of the unity editor toolbar
        [MenuItem("Custom Editor Tools/Texture Tools")]
        public static void ShowWindow() => GetWindow(typeof(TextureTools));

        public Texture2D[] GetSelectedTextureAssets()
        {
            Object[] selections = Selection.objects;
            List<Texture2D> selectedTextures = new List<Texture2D>();

            if (selections != null || selections.Length > 0)
            {
                for (int i = 0; i < selections.Length; i++)
                {
                    Object currentObject = selections[i];
                    Texture2D currentTexture2D = currentObject as Texture2D;

                    if (currentTexture2D != null)
                        selectedTextures.Add(currentTexture2D);
                }

                if (selectedTextures.Count > 0)
                {
                    textureFileEntries = new TextureFileEntry[selectedTextures.Count];

                    for (int i = 0; i < selectedTextures.Count; i++)
                    {
                        textureFileEntries[i] = new TextureFileEntry(selectedTextures[i]);
                    }

                    return selectedTextures.ToArray();
                }
                else
                    return null;
            }
            else
                return null;
        }

        private void InitalizeTool()
        {
            minSize = minWindowSize;
        }

        /// <summary>
        /// GUI display function for the window
        /// </summary>
        void OnGUI()
        {
            InitalizeTool();

            Texture2D[] selectedTextures = GetSelectedTextureAssets();

            if (selectedTextures == null)
            {
                GUILayout.Label("Select one or multiple Texture2D assets...", EditorStyles.label);
                return;
            }

            isSingleMode = selectedTextures.Length < 2;

            if (isSingleMode)
            {
                if (channelRemixer == null) channelRemixer = new ChannelRemixer();
                if (textureAdjustments == null) textureAdjustments = new TextureAdjustments();

                if (firstEntry == null)
                {
                    firstEntry = textureFileEntries[0];
                    channelRemixer.SetChannelSourceTextures(firstEntry.sourceTexture);
                }

                if (firstEntry.sourceTexture != textureFileEntries[0].sourceTexture)
                {
                    firstEntry = textureFileEntries[0];
                    channelRemixer.SetChannelSourceTextures(firstEntry.sourceTexture);
                }

                //title
                GUILayout.Space(guiSectionSpacePixels);
                GUILayout.Label(string.Format("{0}{1}", firstEntry.sourceTextureName, firstEntry.sourceTextureExtension), EditorStyles.whiteLargeLabel);
                GUILayout.Space(guiSectionSpacePixels);

                overwriteOriginalFile = EditorGUILayout.Toggle("Overwrite File", overwriteOriginalFile);

                GUILayout.Space(guiSectionSpacePixels);

                //create a toolbar to organize our mess
                tabsSingleIndex = GUILayout.Toolbar(tabsSingleIndex, tabsSingle);
                GUILayout.Space(guiSectionSpacePixels);

                if (tabsSingleIndex == 0) //CHANNEL REMIXER
                {
                    channelRemixer.ShowUI();

                    GUILayout.Space(guiSectionSpacePixels);

                    if (GUILayout.Button("Render and Save Remixed Texture"))
                    {
                        channelRemixer.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                    }
                }
                else if (tabsSingleIndex == 1) //ADJUSTMENTS
                {
                    textureAdjustments.ShowUI();

                    GUILayout.Space(guiSectionSpacePixels);

                    if (GUILayout.Button("Render Preview"))
                    {
                        textureAdjustments.Render(firstEntry);
                    }

                    if (GUILayout.Button("Render and Save Adjusted Texture"))
                    {
                        textureAdjustments.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                    }

                }
                else if (tabsSingleIndex == 2) //FILTERS
                {
                    filterEffectTypes = (FilterEffectTypes)EditorGUILayout.EnumPopup("Filter", filterEffectTypes);
                    GUILayout.Label(System.Enum.GetName(typeof(FilterEffectTypes), filterEffectTypes), EditorStyles.whiteLargeLabel);
                    GUILayout.Space(guiSectionSpacePixels);

                    if(filterEffectTypes == FilterEffectTypes.GaussianBlur)
                    {
                        if (gaussianBlur == null) 
                            gaussianBlur = new FilterGaussianBlur();

                        gaussianBlur.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            gaussianBlur.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            gaussianBlur.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                    else if (filterEffectTypes == FilterEffectTypes.BoxBlur)
                    {
                        if (boxBlur == null)
                            boxBlur = new FilterBoxBlur();

                        boxBlur.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            boxBlur.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            boxBlur.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                    else if (filterEffectTypes == FilterEffectTypes.CircleBlur)
                    {
                        if (circleBlur == null)
                            circleBlur = new FilterCircleBlur();

                        circleBlur.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            circleBlur.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            circleBlur.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                    else if (filterEffectTypes == FilterEffectTypes.DirectionalBlur)
                    {
                        if (directionalBlur == null)
                            directionalBlur = new FilterDirectionalBlur();

                        directionalBlur.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            directionalBlur.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            directionalBlur.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                    else if (filterEffectTypes == FilterEffectTypes.UnsharpMask)
                    {
                        if (unsharpMask == null)
                            unsharpMask = new FilterUnsharpMask();

                        unsharpMask.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            unsharpMask.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            unsharpMask.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                    else if (filterEffectTypes == FilterEffectTypes.AdditiveBloom)
                    {
                        if (additiveBloom == null)
                            additiveBloom = new FilterAdditiveBloom();

                        additiveBloom.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            additiveBloom.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            additiveBloom.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                    else if (filterEffectTypes == FilterEffectTypes.NaturalBloom)
                    {
                        if (naturalBloom == null)
                            naturalBloom = new FilterNaturalBloom();

                        naturalBloom.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            naturalBloom.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            naturalBloom.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                }
                else if (tabsSingleIndex == 3) //UTILITIES
                {
                    utilityTypes = (UtilityTypes)EditorGUILayout.EnumPopup("Utility", utilityTypes);
                    GUILayout.Label(System.Enum.GetName(typeof(UtilityTypes), utilityTypes), EditorStyles.whiteLargeLabel);
                    GUILayout.Space(guiSectionSpacePixels);

                    if (utilityTypes == UtilityTypes.HeightToNormal)
                    {
                        if (heightToNormal == null)
                            heightToNormal = new HeightToNormal();

                        heightToNormal.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            heightToNormal.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            heightToNormal.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                    else if (utilityTypes == UtilityTypes.RoughnessConversion)
                    {
                        if (roughnessConversion == null)
                            roughnessConversion = new RoughnessConversion();

                        roughnessConversion.ShowUI();

                        GUILayout.Space(guiSectionSpacePixels);

                        if (GUILayout.Button("Render Preview"))
                        {
                            roughnessConversion.Render(firstEntry);
                        }

                        if (GUILayout.Button("Render and Save Texture"))
                        {
                            roughnessConversion.RenderAndSaveTexture(firstEntry, overwriteOriginalFile);
                        }
                    }
                }
                else if (tabsSingleIndex == 4) //FILE CONVERT
                {
                    //firstEntry
                    format = (TextureFormat)EditorGUILayout.EnumPopup("Texture Format", format);
                    GUILayout.Label(System.Enum.GetName(typeof(TextureFormat), format), EditorStyles.whiteLargeLabel);
                    GUILayout.Space(guiSectionSpacePixels);

                    compressTexture = EditorGUILayout.ToggleLeft("Compress Texture", compressTexture);

                    if(compressTexture)
                        highQualityCompression = EditorGUILayout.ToggleLeft("High Quality Compress", highQualityCompression);

                    if (GUILayout.Button("Save Texture"))
                    {
                        Texture2D convertedTexture = new Texture2D(firstEntry.sourceTexture.width, firstEntry.sourceTexture.height, format, true);
                        //Graphics.CopyTexture(convertedTexture, firstEntry.sourceTexture);
                        string path = AssetDatabase.GetAssetPath(firstEntry.sourceTexture);

                        if(compressTexture)
                        {
                            convertedTexture.Compress(highQualityCompression);
                        }

                        /*
                        if (firstEntry.sourceTexture.isReadable == false)
                        {
                            TextureImporter sourceTextureImporter = (TextureImporter)AssetImporter.GetAtPath(path);
                            sourceTextureImporter.isReadable = true;
                            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
                            firstEntry.sourceTexture = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                        }

                        for (int x = 0; x < convertedTexture.width; x++)
                        {
                            for(int y = 0; y < convertedTexture.height; y++)
                            {
                                convertedTexture.SetPixel(x, y, firstEntry.sourceTexture.GetPixel(x, y));
                            }
                        }
                        */

                        if (firstEntry.sourceTexture.isReadable == false)
                        {
                            TextureImporter sourceTextureImporter = (TextureImporter)AssetImporter.GetAtPath(path);
                            sourceTextureImporter.isReadable = true;
                            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
                            firstEntry.sourceTexture = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                        }

                        convertedTexture.SetPixels32(firstEntry.sourceTexture.GetPixels32());
                        convertedTexture.Apply();

                        //if (firstEntry.sourceTexture.isReadable == true)
                        //{
                        //TextureImporter sourceTextureImporter = (TextureImporter)AssetImporter.GetAtPath(path);
                        //sourceTextureImporter.isReadable = false;
                        //AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
                        //}

                        string finalFilePath = "";

                        if (overwriteOriginalFile)
                        {
                            AssetDatabase.DeleteAsset(firstEntry.sourceTexturePath);

                            finalFilePath = string.Format("{0}/{1}{2}", firstEntry.sourceTextureDirectory, firstEntry.sourceTextureName, ".png");
                        }
                        else
                        {
                            //finalFilePath = string.Format("{0}/{1}{2}{3}", firstEntry.sourceTextureDirectory, firstEntry.sourceTextureName, "_new", ".png");
                            //finalFilePath = string.Format("{0}/{1}{2}{3}", firstEntry.sourceTextureDirectory, firstEntry.sourceTextureName, "_new", ".asset");
                            finalFilePath = string.Format("{0}/{1}{2}{3}", firstEntry.sourceTextureDirectory, firstEntry.sourceTextureName, "_new", firstEntry.sourceTextureExtension);
                        }

                        byte[] data = null;

                        switch (firstEntry.sourceTextureExtension)
                        {
                            case ".png":
                                data = convertedTexture.EncodeToPNG();
                                break;
                            case ".tga":
                                data = convertedTexture.EncodeToTGA();
                                break;
                            case ".jpg":
                                data = convertedTexture.EncodeToJPG();
                                break;
                            case ".jpeg":
                                data = convertedTexture.EncodeToJPG();
                                break;
                            case ".exr":
                                data = convertedTexture.EncodeToEXR(Texture2D.EXRFlags.CompressZIP);
                                break;
                        }


                        //if the byte data is null, that means the original texture couldn't be encoded so don't continue
                        if (data == null)
                            return;

                        //write and save the file to the disk and then reimport it in unity so it generates a .meta file and appears in the project view right away.
                        File.WriteAllBytes(finalFilePath, data);
                        AssetDatabase.ImportAsset(finalFilePath);

                        //AssetDatabase.CreateAsset(convertedTexture, finalFilePath);
                    }
                }
            }
            else
            {
                //title
                GUILayout.Space(guiSectionSpacePixels);
                GUILayout.Label(string.Format("{0} textures selected.", textureFileEntries.Length), EditorStyles.whiteLargeLabel);
                GUILayout.Space(guiSectionSpacePixels);

                //create a toolbar to organize our mess
                tabsMultipleIndex = GUILayout.Toolbar(tabsMultipleIndex, tabsMultiple);
            }
        }
    }
}


#endif
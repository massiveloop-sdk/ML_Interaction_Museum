#if UNITY_EDITOR

using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

/// <summary>
/// David: This is my custom wip utillity editor script meant for placing light probes in a scene.
/// </summary>
namespace CustomEditorTools
{
    public class LightProbePlacement : EditorWindow
    {
        //GUI related
        private int tabIndex = 0;
        private static int guiSectionSpacePixels = 10;
        private static string[] tabNames = new string[] { "Main", "Utilities", "Gizmos" };
        private Vector2Int windowSize = new Vector2Int(450, 660);
        private GUIStyle errorStyle;

        //options
        private LightProbeGroup sceneLightProbeGroup;
        private LightProbePlacementAsset lightProbePlacementAsset;
        private string lightProbePlacementAssetPath;

        private List<string> lightProbeVolumeNames = new List<string>();
        private int probeVolumeObjectIndex = 0;

        private float intersectionRadius = 0.1f;
        private bool removeProbesIntersectingWithGeo = true;
        private bool removeProbesFloatingOverVoid = true;
        private bool includeDynamicMeshes = false;
        private bool includeDynamicMeshes_useBoundsCenter = false;
        private float maxHeight = 3;
        private float fromTopHitOffset = 0.25f;

        //unity gizmo
        private float gizmo_probeSize = 0.01f;
        private bool gizmo_showCalculatedPositions = false;
        private bool gizmo_showIntersectionSphere = false;
        private bool gizmo_showOtherProbeVolumeOutlines = true;

        //add a menu item at the top of the unity editor toolbar
        [MenuItem("Custom Editor Tools/Light Probe Placer")]
        [MenuItem("GameObject/Light Probe Placer", false, 30)]
        public static void ShowWindow()
        {
            //get the window and open it
            GetWindow(typeof(LightProbePlacement));
        }

        private void GetLightProbeGroupsInScene()
        {
            sceneLightProbeGroup = FindObjectOfType<LightProbeGroup>();

            if(sceneLightProbeGroup == null)
            {
                GameObject newLightProbeGroupGameObject = new GameObject("Light Probe Group");
                sceneLightProbeGroup = newLightProbeGroupGameObject.AddComponent<LightProbeGroup>();
                sceneLightProbeGroup.probePositions = new Vector3[0];
            }    
        }

        private void GetLightProbePlacementAsset()
        {
            UnityEngine.SceneManagement.Scene activeScene = EditorSceneManager.GetActiveScene();
            string sceneFilePath = activeScene.path;
            string sceneFolderPath = sceneFilePath.Remove(sceneFilePath.Length - ".unity".Length);

            if (activeScene.IsValid() == false || string.IsNullOrEmpty(activeScene.path))
            {
                string message = "Scene is not valid! Be sure to save the scene before baking!";
                EditorUtility.DisplayDialog("Error", message, "OK");
                return;
            }

            lightProbePlacementAssetPath = string.Format("{0}/{1}_LightProbePlacement.asset", sceneFolderPath, activeScene.name);

            lightProbePlacementAsset = AssetDatabase.LoadAssetAtPath<LightProbePlacementAsset>(lightProbePlacementAssetPath);

            if(lightProbePlacementAsset == null)
            {
                lightProbePlacementAsset = new LightProbePlacementAsset();
                lightProbePlacementAsset.volumes = new List<LightProbePlacementVolume>();

                LightProbePlacementVolume lightProbePlacementVolume = new LightProbePlacementVolume();
                lightProbePlacementVolume.name = activeScene.name + "Volume";
                lightProbePlacementAsset.volumes.Add(lightProbePlacementVolume);

                AssetDatabase.CreateAsset(lightProbePlacementAsset, lightProbePlacementAssetPath);
            }    
        }

        private void GetLightProbePlacementVolumeAssetNames()
        {
            lightProbeVolumeNames.Clear();
            
            foreach(LightProbePlacementVolume volume in lightProbePlacementAsset.volumes)
            {
                lightProbeVolumeNames.Add(volume.name);
            }
        }

        private void SaveAsset()
        {
            EditorUtility.SetDirty(lightProbePlacementAsset);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }

        private void NewVolume()
        {
            LightProbePlacementVolume lightProbePlacementVolume = new LightProbePlacementVolume();
            lightProbePlacementVolume.name = EditorSceneManager.GetActiveScene().name + "Volume" + lightProbePlacementAsset.volumes.Count;
            lightProbePlacementAsset.volumes.Add(lightProbePlacementVolume);
            probeVolumeObjectIndex = lightProbePlacementAsset.volumes.Count - 1;

            SaveAsset();
        }

        private void RemoveVolume()
        {
            lightProbePlacementAsset.volumes.RemoveAt(probeVolumeObjectIndex);

            probeVolumeObjectIndex = Mathf.Clamp(probeVolumeObjectIndex, 0, lightProbePlacementAsset.volumes.Count - 1);

            SaveAsset();
        }

        private static string sceneCollidersParentName = "TEMP_Colliders";

        public static void SpawnSceneColliders()
        {
            GameObject sceneCollidersParent = new GameObject(sceneCollidersParentName);

            MeshFilter[] meshes = FindObjectsOfType<MeshFilter>();

            for (int i = 0; i < meshes.Length; i++)
            {
                GameObject meshGameObject = meshes[i].gameObject;

                StaticEditorFlags staticEditorFlags = GameObjectUtility.GetStaticEditorFlags(meshGameObject);

                if (staticEditorFlags.HasFlag(StaticEditorFlags.ContributeGI))
                {
                    GameObject sceneColliderChild = new GameObject("collider");
                    sceneColliderChild.transform.SetParent(sceneCollidersParent.transform);

                    sceneColliderChild.transform.position = meshGameObject.transform.position;
                    sceneColliderChild.transform.rotation = meshGameObject.transform.rotation;
                    sceneColliderChild.transform.localScale = meshGameObject.transform.localScale;

                    MeshCollider meshCollider = sceneColliderChild.AddComponent<MeshCollider>();
                    meshCollider.sharedMesh = meshes[i].sharedMesh;
                }
            }
        }

        public void DestroySceneColliders()
        {
            GameObject sceneCollidersParent = GameObject.Find(sceneCollidersParentName);

            if (sceneCollidersParent != null)
                DestroyImmediate(sceneCollidersParent);
            else
            {
                sceneCollidersParent = GameObject.Find(sceneCollidersParentName);

                if (sceneCollidersParent != null)
                    DestroyImmediate(sceneCollidersParent);
            }
        }

        /// <summary>
        /// GUI display function for the window
        /// </summary>
        void OnGUI()
        {
            maxSize = windowSize;
            minSize = windowSize;

            errorStyle = new GUIStyle(EditorStyles.helpBox);
            errorStyle.normal.textColor = Color.red;

            GetLightProbeGroupsInScene();
            GetLightProbePlacementAsset();
            GetLightProbePlacementVolumeAssetNames();

            //window title
            GUILayout.Label("Light Probe Placement", EditorStyles.whiteLargeLabel);
            tabIndex = GUILayout.Toolbar(tabIndex, tabNames);
            GUILayout.Space(guiSectionSpacePixels);

            //tab - main
            if (tabIndex == 0)
            {
                GUILayout.Label("Volumes", EditorStyles.whiteLargeLabel);
                probeVolumeObjectIndex = EditorGUILayout.Popup(probeVolumeObjectIndex, lightProbeVolumeNames.ToArray());

                GUILayout.BeginHorizontal();
                if (GUILayout.Button("New Volume")) NewVolume();
                if (GUILayout.Button("Remove Volume")) RemoveVolume();
                GUILayout.EndHorizontal();
                GUILayout.Space(guiSectionSpacePixels);

                LightProbePlacementVolume currentVolume = lightProbePlacementAsset.volumes[probeVolumeObjectIndex];

                GUILayout.Label(string.Format("[{0}]", currentVolume.name), EditorStyles.whiteLargeLabel);
                GUILayout.Space(guiSectionSpacePixels);

                GUILayout.Label("Properties", EditorStyles.boldLabel);
                currentVolume.name = EditorGUILayout.TextField("Name", currentVolume.name);
                currentVolume.position = EditorGUILayout.Vector3Field("Position", currentVolume.position);
                currentVolume.size = EditorGUILayout.Vector3Field("Size", currentVolume.size);
                GUILayout.Space(guiSectionSpacePixels);

                GUILayout.Label("Resolution", EditorStyles.boldLabel);
                currentVolume.resolutionType = (LightProbePlacementVolumeResolutionType)EditorGUILayout.EnumPopup("Resolution Calculation", currentVolume.resolutionType);
                if(currentVolume.resolutionType == LightProbePlacementVolumeResolutionType.Automatic)
                    currentVolume.probeDensity = EditorGUILayout.FloatField("Probe Density", currentVolume.probeDensity);
                else
                    currentVolume.customResolution = EditorGUILayout.Vector3IntField("Custom Resolution", currentVolume.customResolution);
                GUILayout.Space(guiSectionSpacePixels);

                GUILayout.Label("Global", EditorStyles.whiteLargeLabel);
                GUILayout.Label("Probe Addition", EditorStyles.boldLabel);
                includeDynamicMeshes = EditorGUILayout.ToggleLeft("Include Positions from Dynamic Meshes", includeDynamicMeshes, GUILayout.Width(position.width));
                if (includeDynamicMeshes)
                    includeDynamicMeshes_useBoundsCenter = EditorGUILayout.ToggleLeft("Use Mesh Bounds Center Instead of GameObject position", includeDynamicMeshes_useBoundsCenter, GUILayout.Width(position.width));

                maxHeight = EditorGUILayout.FloatField("Max Height From Ground", maxHeight);
                fromTopHitOffset = EditorGUILayout.FloatField("Offset From Ground", fromTopHitOffset);

                GUILayout.Space(guiSectionSpacePixels);

                GUILayout.Label("Probe Reduction", EditorStyles.boldLabel);
                removeProbesFloatingOverVoid = EditorGUILayout.ToggleLeft("Remove probes floating over the void", removeProbesFloatingOverVoid, GUILayout.Width(position.width));
                removeProbesIntersectingWithGeo = EditorGUILayout.ToggleLeft("Remove Probes intersecting with geometry", removeProbesIntersectingWithGeo, GUILayout.Width(position.width));
                if (removeProbesIntersectingWithGeo)
                    intersectionRadius = EditorGUILayout.FloatField("Intersection Radius", intersectionRadius);
                if (GUILayout.Button("Remove Probes")) CleanLightProbePositions();
                GUILayout.Space(guiSectionSpacePixels);

                GUILayout.Label("Adding Probes", EditorStyles.boldLabel);
                GUILayout.BeginHorizontal();
                if (GUILayout.Button("From Current Volume")) AddProbesFromVolume();
                if (GUILayout.Button("From All Volumes")) AddProbesFromAllVolumes();
                if (GUILayout.Button("From Dynamic Meshes")) AddProbesFromDynamicMeshes();
                if (GUILayout.Button("From Top Of Volume")) AddProbesFromAbove();
                GUILayout.EndHorizontal();

                GUILayout.Space(guiSectionSpacePixels);
                if (GUILayout.Button("Clear Probes From LightProbeGroup")) ClearProbesFromSceneLightProbeGroup();
                if (GUILayout.Button("Save")) SaveAsset();
            }
            //tab - utilities
            else if (tabIndex == 1)
            {
                //tab title
                GUILayout.Label("Utilities", EditorStyles.whiteLargeLabel);
                GUILayout.Space(guiSectionSpacePixels);

                GUILayout.BeginHorizontal();
                if (GUILayout.Button("Spawn Scene Colliders")) SpawnSceneColliders();
                if (GUILayout.Button("Destroy Sceen Colliders")) DestroySceneColliders();
                GUILayout.EndHorizontal();
            }
            //tab - gizmos
            else if (tabIndex == 2)
            {
                GUILayout.Label("Gizmos", EditorStyles.whiteLargeLabel);
                GUILayout.Space(guiSectionSpacePixels);

                gizmo_probeSize = EditorGUILayout.FloatField("Probe Gizmo Size", gizmo_probeSize);
                gizmo_showCalculatedPositions = EditorGUILayout.ToggleLeft("Show Calculated Positions", gizmo_showCalculatedPositions, GUILayout.Width(position.width));
                gizmo_showIntersectionSphere = EditorGUILayout.ToggleLeft("Show Intersection Radius", gizmo_showIntersectionSphere, GUILayout.Width(position.width));
                gizmo_showOtherProbeVolumeOutlines = EditorGUILayout.ToggleLeft("Show Other Probe Volume Outlines", gizmo_showOtherProbeVolumeOutlines, GUILayout.Width(position.width));
            }
        }

        public void ClearProbesFromSceneLightProbeGroup()
        {
            sceneLightProbeGroup.probePositions = new Vector3[0];

            SaveAsset();
        }

        public void CleanLightProbePositions()
        {
            List<Vector3> existingSceneLightProbeGroupPositions = new List<Vector3>(sceneLightProbeGroup.probePositions);

            sceneLightProbeGroup.probePositions = CleanProbePositions(existingSceneLightProbeGroupPositions).ToArray();

            SaveAsset();
        }

        private List<Vector3> CleanProbePositions(List<Vector3> oldPositions)
        {
            List<Vector3> newPositions = new List<Vector3>();

            foreach(Vector3 oldPosition in oldPositions)
            {
                bool case1 = true;
                bool case2 = true;

                if (removeProbesIntersectingWithGeo)
                    case1 = !Position_IntersectsWithGeometry(oldPosition, intersectionRadius);

                if (removeProbesFloatingOverVoid)
                    case2 = Position_FloatingOverVoid(oldPosition);

                if (case1 && case2)
                    newPositions.Add(oldPosition);
            }

            newPositions = CleanUpVectorList(newPositions);

            return newPositions;
        }

        private List<Vector3> GetProbesFromVolume(LightProbePlacementVolume volume)
        {
            List<Vector3> positions = new List<Vector3>();

            Vector3Int calculatedResolution = volume.GetCalculatedResolution();

            //3d loop for our volume
            for (int x = -calculatedResolution.x / 2; x <= calculatedResolution.x / 2; x++)
            {
                //get the x offset
                float x_offset = volume.size.x / calculatedResolution.x;

                for (int y = -calculatedResolution.y / 2; y <= calculatedResolution.y / 2; y++)
                {
                    //get the y offset
                    float y_offset = volume.size.y / calculatedResolution.y;

                    for (int z = -calculatedResolution.z / 2; z <= calculatedResolution.z / 2; z++)
                    {
                        //get the z offset
                        float z_offset = volume.size.z / calculatedResolution.z;

                        //get our new probe position
                        Vector3 probePosition = new Vector3(volume.position.x + (x * x_offset), volume.position.y + (y * y_offset), volume.position.z + (z * z_offset));

                        positions.Add(probePosition);
                    }
                }
            }

            return positions;
        }

        private List<Vector3> GetProbesFromDynamicMeshes()
        {
            List<Vector3> positions = new List<Vector3>();

            //go through all of the game objects in the scene
            foreach (GameObject sceneGameObject in GetAllObjectsInScene())
            {
                Debug.Log("test");

                //get the static editor flags of the gameobject
                StaticEditorFlags staticEditorFlags = GameObjectUtility.GetStaticEditorFlags(sceneGameObject);

                //if it DOESN'T contribute to the global illumination
                if (!staticEditorFlags.HasFlag(StaticEditorFlags.ContributeGI))
                {
                    //get the renderer component
                    Renderer renderer = sceneGameObject.GetComponent<Renderer>();

                    //if it exists and the renderer is using probes
                    //if (renderer && renderer.lightProbeUsage != UnityEngine.Rendering.LightProbeUsage.Off && renderer.isVisible)
                    if (renderer && renderer.isVisible)
                    {
                        Vector3 center = includeDynamicMeshes_useBoundsCenter ? renderer.bounds.center : renderer.transform.position;

                        positions.Add(center);
                    }
                }
            }

            return positions;
        }

        public void AddProbesFromVolume()
        {
            LightProbePlacementVolume currentVolume = lightProbePlacementAsset.volumes[probeVolumeObjectIndex];
            currentVolume.generatedProbePositions = GetProbesFromVolume(currentVolume);

            List<Vector3> existingSceneLightProbeGroupPositions = new List<Vector3>(sceneLightProbeGroup.probePositions);

            for(int i = 0; i < currentVolume.generatedProbePositions.Count; i++)
                existingSceneLightProbeGroupPositions.Add(currentVolume.generatedProbePositions[i]);

            sceneLightProbeGroup.probePositions = CleanProbePositions(existingSceneLightProbeGroupPositions).ToArray();

            SaveAsset();
        }

        public void AddProbesFromAllVolumes()
        {
            List<Vector3> existingSceneLightProbeGroupPositions = new List<Vector3>(sceneLightProbeGroup.probePositions);

            foreach (LightProbePlacementVolume volume in lightProbePlacementAsset.volumes)
            {
                volume.generatedProbePositions = GetProbesFromVolume(volume);

                for (int i = 0; i < volume.generatedProbePositions.Count; i++)
                    existingSceneLightProbeGroupPositions.Add(volume.generatedProbePositions[i]);
            }

            sceneLightProbeGroup.probePositions = CleanProbePositions(existingSceneLightProbeGroupPositions).ToArray();

            SaveAsset();
        }

        public void AddProbesFromAbove()
        {
            Debug.Log("AddProbesFromAbove");

            List<Vector3> existingSceneLightProbeGroupPositions = new List<Vector3>(sceneLightProbeGroup.probePositions);

            LightProbePlacementVolume currentVolume = lightProbePlacementAsset.volumes[probeVolumeObjectIndex];

            Vector3Int calculatedResolution = currentVolume.GetCalculatedResolution();

            //3d loop for our volume
            for (int x = -calculatedResolution.x / 2; x <= calculatedResolution.x / 2; x++)
            {
                //get the x offset
                float x_offset = currentVolume.size.x / calculatedResolution.x;

                for (int z = -calculatedResolution.z / 2; z <= calculatedResolution.z / 2; z++)
                {
                    //get the z offset
                    float z_offset = currentVolume.size.z / calculatedResolution.z;

                    //get our new probe position
                    Vector3 probePosition = new Vector3(currentVolume.position.x + (x * x_offset), currentVolume.position.y + (currentVolume.size.y * 0.5f), currentVolume.position.z + (z * z_offset));

                    RaycastHit hit;

                    if(Physics.Raycast(probePosition, Vector3.down, out hit, Mathf.Infinity))
                    {
                        Vector3 hitPosition = hit.point;

                        float y_offset = currentVolume.size.y / calculatedResolution.y;

                        for(float currentOffset = fromTopHitOffset; currentOffset < maxHeight; currentOffset += y_offset) 
                        {
                            existingSceneLightProbeGroupPositions.Add(hitPosition + new Vector3(0, currentOffset, 0));
                        }
                    }
                }
            }

            sceneLightProbeGroup.probePositions = CleanProbePositions(existingSceneLightProbeGroupPositions).ToArray();

            SaveAsset();
        }

        public void AddProbesFromDynamicMeshes()
        {
            List<Vector3> existingSceneLightProbeGroupPositions = new List<Vector3>(sceneLightProbeGroup.probePositions);

            List<Vector3> dynamicMeshPositions = GetProbesFromDynamicMeshes();

            foreach (Vector3 position in dynamicMeshPositions)
            {
                //Debug.Log("test");
                existingSceneLightProbeGroupPositions.Add(position);
            }

            sceneLightProbeGroup.probePositions = CleanProbePositions(existingSceneLightProbeGroupPositions).ToArray();

            SaveAsset();
        }

        // Window has been selected
        void OnFocus()
        {
            // Remove delegate listener if it has previously
            // been assigned.
            SceneView.duringSceneGui -= OnSceneGUI;
            // Add (or re-add) the delegate.
            SceneView.duringSceneGui += OnSceneGUI;
        }

        void OnDestroy()
        {
            // When the window is destroyed, remove the delegate
            // so that it will no longer do any drawing.
            SceneView.duringSceneGui -= OnSceneGUI;
        }

        void OnSceneGUI(SceneView sceneView)
        {
            if (lightProbePlacementAsset == null)
                return;

            if(gizmo_showOtherProbeVolumeOutlines)
            {
                for(int i = 0; i < lightProbePlacementAsset.volumes.Count; i++)
                {
                    if(i == probeVolumeObjectIndex)
                        Handles.color = Color.green;
                    else
                        Handles.color = Color.yellow;

                    Handles.DrawWireCube(lightProbePlacementAsset.volumes[i].position, lightProbePlacementAsset.volumes[i].size);
                }
            }

            LightProbePlacementVolume currentVolume = lightProbePlacementAsset.volumes[probeVolumeObjectIndex];

            //if the user wants to see the calculated positions
            if (gizmo_showCalculatedPositions)
            {
                //make it white to diffrentiate it 
                Handles.color = Color.white;

                Vector3 sceneCameraPosition = SceneView.GetAllSceneCameras()[0].transform.position;

                Vector3Int calculatedResolution = currentVolume.GetCalculatedResolution();

                //3d loop for our volume
                for (int x = -calculatedResolution.x / 2; x <= calculatedResolution.x / 2; x++)
                {
                    //get the x offset
                    float x_offset = currentVolume.size.x / calculatedResolution.x;

                    for (int y = -calculatedResolution.y / 2; y <= calculatedResolution.y / 2; y++)
                    {
                        //get the y offset
                        float y_offset = currentVolume.size.y / calculatedResolution.y;

                        for (int z = -calculatedResolution.z / 2; z <= calculatedResolution.z / 2; z++)
                        {
                            //get the z offset
                            float z_offset = currentVolume.size.z / calculatedResolution.z;

                            //get our new probe position
                            Vector3 probePosition = new Vector3(currentVolume.position.x + (x * x_offset), currentVolume.position.y + (y * y_offset), currentVolume.position.z + (z * z_offset));

                            //probe normal direction
                            Vector3 probeNormal = probePosition - sceneCameraPosition;

                            //draw a sphere at the calculated position
                            Handles.DrawSolidDisc(probePosition, probeNormal, gizmo_probeSize);

                            //if the user wants to see the intersection radius then draw a wireframe sphere to represent it
                            if (gizmo_showIntersectionSphere)
                                Handles.DrawWireDisc(probePosition, probeNormal, intersectionRadius);
                        }
                    }
                }
            }

            HandleUtility.Repaint();
        }

        public static bool Position_IntersectsWithGeometry(Vector3 position, float intersectionRadius)
        {
            //get a list of any colliders that are within the intersection radius
            List<Collider> colliders = new List<Collider>(Physics.OverlapSphere(position, intersectionRadius));

            //if there are any colliders we found
            if (colliders.Count > 0)
            {
                //we intersected with something!
                return true;
            }

            //we didn't intersect with any geometry
            return false;
        }

        public static bool Position_FloatingOverVoid(Vector3 position)
        {
            //create a downward pointing ray
            Ray ray = new Ray(position, Vector3.down);

            //do an infinte raycast downward
            if (Physics.Raycast(ray, int.MaxValue) == false)
            {
                //if we hit something then we aren't floating over the void
                return false;
            }

            //we didn't hit anything so we are floating over the void
            return true;
        }

        public static List<Vector3> CleanUpVectorList(List<Vector3> list)
        {
            return list.Distinct().ToList();
        }

        public static bool IsNotOverlapped(List<Vector3> positionArray, Vector3 targetPosition)
        {
            foreach (Vector3 position in positionArray)
            {
                if (Vector3.Distance(position, targetPosition) < 0.001f)
                {
                    return false;
                }
            }

            return true;
        }

        private static List<GameObject> GetAllObjectsInScene()
        {
            List<GameObject> objectsInScene = new List<GameObject>();
            //ReflectionProbe[] probes = FindObjectsOfType<ReflectionProbe>();
            //foreach (GameObject go in Resources.FindObjectsOfTypeAll(typeof(GameObject)) as GameObject[])
            foreach (GameObject go in FindObjectsOfType<GameObject>())
            {
                if (go.hideFlags != HideFlags.None)
                    continue;

                if (PrefabUtility.GetPrefabType(go) == PrefabType.Prefab || PrefabUtility.GetPrefabType(go) == PrefabType.ModelPrefab)
                    continue;

                objectsInScene.Add(go);
            }
            return objectsInScene;
        }
    }
}

#endif
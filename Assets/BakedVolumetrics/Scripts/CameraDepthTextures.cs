using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[ExecuteInEditMode]
public class CameraDepthTextures : MonoBehaviour
{
    public DepthTextureMode depthTextureMode = DepthTextureMode.None;

    private Camera camera;

    [ContextMenu("Set Depth Texture")]
    public void SetDepthTexture()
    {
        camera = GetComponent<Camera>();
        camera.depthTextureMode = depthTextureMode;
    }

    private void Awake()
    {
        SetDepthTexture();
    }

    private void OnEnable()
    {
        SetDepthTexture();
    }
}

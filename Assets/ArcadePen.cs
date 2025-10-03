using ML.SDK;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ArcadePen : MonoBehaviour
{
    [SerializeField] public GameObject drawnPrefab;
    [SerializeField] private Transform drawPoint;
    [SerializeField] private float segmentLength = 0.1f;

    public MLClickable Redo_Button;
    public MLClickable Undo_Button;
    public MLClickable button_IncreaseWidth;
    public MLClickable button_DecreaseWidth;
    public MLClickable button_ChangeColor;
    public MLClickable button_ClearAll;
    public string currentColor;
    public GameObject ColorPreview;
    public GameObject sizePreview;
    public MLClickable button_IncreaseEmissive;
    public MLClickable button_DecreaseEmissive;
    public MLClickable button_toggle_SurfaceGrab;
    public MLClickable button_ResetPen;
    public MLClickable[] ColorButtons;
    public GameObject ColorCanvas;
    public Slider RSlider;
    public Slider BSlider;
    public Slider GSlider;
    public Slider EmissionSlider;
    public Slider MetalicSlider;
    public Slider SmoothnessSlider;

    private GameObject curDrawn;
    private int drawing = 0;
    private Vector3 lastDrawnPosition;
    private MLGrab grab;

    private Vector3 lastSegmentEndPosition;

    [SerializeField] public GameObject[] drawnColors;
    [SerializeField] public Material[] corresponding_materials;
    [SerializeField] public MLGrab grabComponent;
    private Vector3 initialSizePreviewScale;

    private Vector3 originalScale; // Store the initial scale

    private LineRenderer currentLine;
    private List<Vector3> linePoints = new List<Vector3>();
    private Stack<GameObject> undoStack = new Stack<GameObject>();
    private Stack<GameObject> redoStack = new Stack<GameObject>();

    private Material penMaterialInstance;           // unique material for this pen (per-player)
    private float currentWidthMultiplier = 1f;      // keep track of width for new segments

    private Material[] materialInstances;

    public TextMeshProUGUI PlayerNameLabel;
    // inside ArcadePen class, near the top-of-class fields:
    [HideInInspector] public Vector3 OriginPosition;
    [HideInInspector] public Quaternion OriginRotation;
    private bool isUpdatingFromNetwork = false;
    private Vector3 canvasOriginalScale;

    private void SetOriginalScale(GameObject button)
    {
        originalScale = button.transform.localScale;
    }


    // ===== Helper: pick a base material to clone =====
    private Material GetBaseMaterialForColor(int colorIndex)
    {
        // prefer corresponding_materials if provided
        if (corresponding_materials != null && corresponding_materials.Length > colorIndex && corresponding_materials[colorIndex] != null)
            return corresponding_materials[colorIndex];

        // fallback: use the drawnPrefab's renderer shared material
        if (drawnPrefab != null)
        {
            var lr = drawnPrefab.GetComponent<LineRenderer>();
            if (lr != null && lr.sharedMaterial != null) return lr.sharedMaterial;
            var tr = drawnPrefab.GetComponent<TrailRenderer>();
            if (tr != null && tr.material != null) return tr.material;
            var rend = drawnPrefab.GetComponent<Renderer>();
            if (rend != null && rend.sharedMaterial != null) return rend.sharedMaterial;
        }

        // last-resort: a new standard material
        return new Material(Shader.Find("Standard"));
    }

    // ===== Create or refresh the per-pen material instance =====
    private void CreateOrUpdatePenMaterialInstance(int colorIndex)
    {
        // Just grab the cached instance instead of destroying/creating
        if (materialInstances != null && colorIndex < materialInstances.Length)
            penMaterialInstance = materialInstances[colorIndex];
        else
            penMaterialInstance = new Material(Shader.Find("Standard"));

        UpdatePreviewMaterial();
    }


    private void UpdatePreviewMaterial()
    {
        if (penMaterialInstance == null)
            return;

        // Update color preview
        if (ColorPreview != null)
        {
            var previewRenderer = ColorPreview.GetComponent<Renderer>();
            if (previewRenderer != null)
                previewRenderer.material = penMaterialInstance;
        }

        // Update size preview (match color)
        if (sizePreview != null)
        {
            var sizeRenderer = sizePreview.GetComponent<Renderer>();
            if (sizeRenderer != null)
                sizeRenderer.material = penMaterialInstance;
        }
    }

    private IEnumerator PulseButton(GameObject button)
    {
        if (originalScale == Vector3.zero)
            SetOriginalScale(button); // Initialize original scale if not already done

        Vector3 smallerScale = originalScale * 0.8f; // Shrinks to 80% of its size
        float duration = 0.15f; // Pulse speed
        float elapsedTime = 0f;

        // Shrink
        while (elapsedTime < duration)
        {
            button.transform.localScale = Vector3.Lerp(originalScale, smallerScale, elapsedTime / duration);
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        // Reset elapsed time
        elapsedTime = 0f;

        // Expand back
        while (elapsedTime < duration)
        {
            button.transform.localScale = Vector3.Lerp(smallerScale, originalScale, elapsedTime / duration);
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        button.transform.localScale = originalScale; // Ensure it resets perfectly
    }

    // Trigger Down Handler
    private void TriggerDownHandler()
    {
        drawing = 1;
        lastDrawnPosition = drawPoint.position;
        lastSegmentEndPosition = drawPoint.position;  // Start tracking the end of the last segment
        CreateNewLineSegment();
    }

    // Trigger Up Handler
    private void TriggerUpHandler()
    {
        drawing = 0;

        if (curDrawn != null)
        {
            undoStack.Push(curDrawn);
            redoStack.Clear(); // new action wipes redo history
        }

        curDrawn = null;
    }

    private void Undo(MLPlayer player)
    {
        if (undoStack.Count == 0) return;

        GameObject lastLine = undoStack.Pop();
        if (lastLine != null)
        {
            lastLine.SetActive(false); // keep reference but hide
            redoStack.Push(lastLine);
        }

        StartCoroutine(PulseButton(Undo_Button.gameObject));
        this.InvokeNetwork("PenUndo", EventTarget.Others, null, this.gameObject.name);
    }

    private void Redo(MLPlayer player)
    {
        if (redoStack.Count == 0) return;

        GameObject line = redoStack.Pop();
        if (line != null)
        {
            line.SetActive(true);
            undoStack.Push(line);
        }

        StartCoroutine(PulseButton(Redo_Button.gameObject));
        this.InvokeNetwork("PenRedo", EventTarget.Others, null, this.gameObject.name);
    }

    private void OnNetworkUndo(object[] args)
    {
        string objName = (string)args[0];
        if (this.gameObject.name != objName) return;

        if (undoStack.Count > 0)
        {
            GameObject lastLine = undoStack.Pop();
            if (lastLine != null)
            {
                lastLine.SetActive(false);
                redoStack.Push(lastLine);
            }
        }
    }

    private void OnNetworkRedo(object[] args)
    {
        string objName = (string)args[0];
        if (this.gameObject.name != objName) return;

        if (redoStack.Count > 0)
        {
            GameObject line = redoStack.Pop();
            if (line != null)
            {
                line.SetActive(true);
                undoStack.Push(line);
            }
        }
    }

    private void ClearAll(MLPlayer player)
    {
        // Destroy everything this pen has drawn
        foreach (var line in undoStack)
        {
            if (line != null) Destroy(line);
        }
        foreach (var line in redoStack)
        {
            if (line != null) Destroy(line);
        }

        undoStack.Clear();
        redoStack.Clear();

        StartCoroutine(PulseButton(button_ClearAll.gameObject));
        this.InvokeNetwork("PenClearAll", EventTarget.Others, null, this.gameObject.name);
    }

    private void OnNetworkClearAll(object[] args)
    {
        string objName = (string)args[0];
        if (this.gameObject.name != objName) return;

        foreach (var line in undoStack)
        {
            if (line != null) Destroy(line);
        }
        foreach (var line in redoStack)
        {
            if (line != null) Destroy(line);
        }

        undoStack.Clear();
        redoStack.Clear();
    }

    private void CreateNewLineSegment()
    {
        curDrawn = Instantiate(drawnPrefab, drawPoint.position, drawPoint.rotation);
        currentLine = curDrawn.GetComponent<LineRenderer>();
        linePoints.Clear();
        linePoints.Add(drawPoint.position);
        linePoints.Add(drawPoint.position);
        currentLine.positionCount = 2;
        currentLine.SetPositions(linePoints.ToArray());

        // make sure we have a per-pen material
        if (penMaterialInstance == null)
            CreateOrUpdatePenMaterialInstance(currentColorIndex);

        // assign the same material instance to all renderers on this spawned object
        var renderers = curDrawn.GetComponentsInChildren<Renderer>(true);
        foreach (var r in renderers)
        {
            // assign the instance (so all segments spawned by this pen share the same instance)
            r.material = penMaterialInstance;
        }

        // apply the pen's width to the newly-created line/trail
        if (currentLine != null)
            currentLine.widthMultiplier = currentWidthMultiplier;

        var trail = curDrawn.GetComponent<TrailRenderer>();
        if (trail != null)
            trail.widthMultiplier = currentWidthMultiplier;
    }

    private void Increase_Width(MLPlayer player)
    {
        Debug.Log("increase size pressed");

        currentWidthMultiplier += 0.5f; // grow pen width
        sizePreview.transform.localScale = initialSizePreviewScale * currentWidthMultiplier;

        StartCoroutine(PulseButton(button_IncreaseWidth.gameObject));
        this.InvokeNetwork(EVENTID_SizeUp, EventTarget.Others, null, this.gameObject.name);
    }

    private void Decrease_Width(MLPlayer player)
    {
        Debug.Log("decrease size pressed");

        currentWidthMultiplier = Mathf.Max(0.5f, currentWidthMultiplier - 0.5f); // shrink but don’t go too small
        sizePreview.transform.localScale = initialSizePreviewScale * currentWidthMultiplier;

        StartCoroutine(PulseButton(button_DecreaseWidth.gameObject));
        this.InvokeNetwork(EVENTID_SizeDown, EventTarget.Others, null, this.gameObject.name);
    }

    private float emissionIntensity = 1f; // Default intensity
    private const float maxEmission = 3.0f; // Max allowed emission intensity
    private const float minEmission = 0.1f; // Min allowed emission intensity
    private const float step = 0.1f; // Change amount per press

    private void Increase_Emission(MLPlayer player)
    {
        // update local value
        emissionIntensity = Mathf.Min(emissionIntensity + step, maxEmission);

        if (penMaterialInstance == null)
            CreateOrUpdatePenMaterialInstance(currentColorIndex);

        if (penMaterialInstance.HasProperty("_EmissionColor"))
        {
            Color baseEmission = penMaterialInstance.GetColor("_EmissionColor").linear;
            float luminance = baseEmission.maxColorComponent;
            if (luminance > 0) baseEmission /= luminance;
            penMaterialInstance.SetColor("_EmissionColor", baseEmission * emissionIntensity);
            penMaterialInstance.EnableKeyword("_EMISSION");
        }

        StartCoroutine(PulseButton(button_IncreaseEmissive.gameObject));
        this.InvokeNetwork(EVENT_ID_Em_Up, EventTarget.Others, null, this.gameObject.name);
    }

    private void Decrease_Emission(MLPlayer player)
    {
        emissionIntensity = Mathf.Max(emissionIntensity - step, minEmission);

        if (penMaterialInstance == null)
            CreateOrUpdatePenMaterialInstance(currentColorIndex);

        if (penMaterialInstance.HasProperty("_EmissionColor"))
        {
            Color baseEmission = penMaterialInstance.GetColor("_EmissionColor").linear;
            float luminance = baseEmission.maxColorComponent;
            if (luminance > 0) baseEmission /= luminance;
            penMaterialInstance.SetColor("_EmissionColor", baseEmission * emissionIntensity);
            penMaterialInstance.EnableKeyword("_EMISSION");
        }

        StartCoroutine(PulseButton(button_DecreaseEmissive.gameObject));
        this.InvokeNetwork(EVENT_ID_Em_Down, EventTarget.Others, null, this.gameObject.name);
    }

    private int currentColorIndex = 0;  // Keep track of the current color index
    void OnNetworkClickPen(object[] args)
    {
        Debug.Log("Clicked registered on other client");

        currentColorIndex = (currentColorIndex + 1) % drawnColors.Length;
        drawnPrefab = drawnColors[currentColorIndex];

        // create/refresh the per-pen material instance (uses corresponding_materials if present)
        CreateOrUpdatePenMaterialInstance(currentColorIndex);

        if (corresponding_materials.Length > currentColorIndex)
        {
            var previewRenderer = ColorPreview.GetComponent<Renderer>();
            if (previewRenderer != null)
                previewRenderer.material = penMaterialInstance; // same instance
        }

        currentColor = drawnColors[currentColorIndex].name;
    }


    private void ApplyEmissionDeltaLocal(float delta)
    {
        emissionIntensity = Mathf.Clamp(emissionIntensity + delta, minEmission, maxEmission);

        if (penMaterialInstance == null)
            CreateOrUpdatePenMaterialInstance(currentColorIndex);

        if (penMaterialInstance.HasProperty("_EmissionColor"))
        {
            Color baseEmission = penMaterialInstance.GetColor("_EmissionColor").linear;
            float luminance = baseEmission.maxColorComponent;
            if (luminance > 0) baseEmission /= luminance;
            penMaterialInstance.SetColor("_EmissionColor", baseEmission * emissionIntensity);
            penMaterialInstance.EnableKeyword("_EMISSION");
        }
    }




    public void OnChangeColor_ToggleMenu(MLPlayer player)
    {

        Debug.Log("Local Button Pressed");
        StartCoroutine(PulseButton(button_ChangeColor.gameObject));

        if (ColorCanvas.activeSelf == false)
        {
            StartCoroutine(AnimateCanvas(ColorCanvas, true));  // animate open
        }
        else
        {
            StartCoroutine(AnimateCanvas(ColorCanvas, false)); // animate close
        }

        //    this.InvokeNetwork(EVENT_ID, EventTarget.All, null, true);

    }


    const string EVENT_ID = "ClickEvent";
    EventToken token;

    const string EVENTID_SizeUp = "SizeUp";
    EventToken token_SizeUp;

    const string EVENTID_SizeDown = "SizeDown";
    EventToken token_SizeDown;

    const string EVENT_ID_Em_Up = "EmUp";
    EventToken token_Em_Up;

    const string EVENT_ID_Em_Down = "EmDown";
    EventToken token_Em_Down;

    const string EVENT_HANDLE_LATE_JOINER = "OnLateJoiner";
    private EventToken tokenLateJoiner;

    const string EVENT_ID_SetColor = "SetColor";
    EventToken token_SetColor;

    void OnNetworkSizeUp(object[] args)
    {
        Debug.Log("increase size pressed by other player");
        if (this.gameObject.name == (string)args[0])
        {
            currentWidthMultiplier += 0.5f;
            sizePreview.transform.localScale = initialSizePreviewScale * currentWidthMultiplier;
        }
    }

    void OnNetworkSizeDown(object[] args)
    {
        Debug.Log("decrease size pressed by other player");
        if (this.gameObject.name == (string)args[0])
        {
            currentWidthMultiplier = Mathf.Max(0.5f, currentWidthMultiplier - 0.5f);
            sizePreview.transform.localScale = initialSizePreviewScale * currentWidthMultiplier;
        }
    }

    void OnNetworkEmissionUp(object[] args)
    {
        if (this.gameObject.name == (string)args[0])
        {
            Debug.Log("increase emission pressed by another player (local apply)");
            ApplyEmissionDeltaLocal(step);
        }
    }

    void OnNetworkEmissionDown(object[] args)
    {
        if (this.gameObject.name == (string)args[0])
        {
            Debug.Log("decrease emission pressed by another player (local apply)");
            ApplyEmissionDeltaLocal(-step);
        }
    }

    void OnSendInfoTolateJoiner(object[] args)
    {
        if (this.gameObject.name == (string)args[2])
        {
            // Extract the passed-in color index and color name from the args array
            int passedinColorIndex = (int)args[1];
            string passedinColorName = (string)args[0];

            // Set the current color index and color name
            currentColorIndex = passedinColorIndex;
            currentColor = passedinColorName;

            // Set the drawnPrefab to the corresponding color prefab
            if (drawnColors.Length > currentColorIndex)
            {
                drawnPrefab = drawnColors[currentColorIndex];
            }

            // Set the material of the ColorPreview to the corresponding material
            if (corresponding_materials.Length > currentColorIndex)
            {
                Renderer previewRenderer = ColorPreview.GetComponent<Renderer>();
                Renderer previewSphere = previewRenderer.GetComponent<Renderer>();
                if (previewRenderer != null)
                {
                    previewRenderer.material = corresponding_materials[currentColorIndex];
                    previewSphere.material = corresponding_materials[currentColorIndex];
                }
            }

            Debug.Log($"Late joiner updated: Color Index = {currentColorIndex}, Color Name = {currentColor}");
        }
    }

    //Look into left and right hand detection
    void OnPrimaryGrabBegin()
    {
        PlayerNameLabel.text = $"OMNI-PEN User : {grabComponent.CurrentUser.NickName}";
    }
    public void ResetPen(MLPlayer player)
    {
        this.transform.position = OriginPosition;
        this.transform.rotation = OriginRotation;
    }

    public void OnPlayerToggleSurfaceGrab(MLPlayer player)
    {
        if (grabComponent.SurfaceGrab == true)
        {
            grabComponent.SurfaceGrab = false;
        }
        else
        {
            grabComponent.SurfaceGrab = true;
        }
    }

    // Start method
    void Start()
    {
        Debug.Log("Test start pen");
        //grab = GetComponent<MLGrab>();
        grabComponent.OnPrimaryTriggerDown.AddListener(TriggerDownHandler);
        grabComponent.OnPrimaryTriggerUp.AddListener(TriggerUpHandler);
        grabComponent.OnPrimaryGrabBegin.AddListener(OnPrimaryGrabBegin);

        button_IncreaseWidth.OnPlayerClick.AddListener(Increase_Width);
        button_DecreaseWidth.OnPlayerClick.AddListener(Decrease_Width);
        button_IncreaseEmissive.OnPlayerClick.AddListener(Increase_Emission);
        button_DecreaseEmissive.OnPlayerClick.AddListener(Decrease_Emission);

        button_ChangeColor.OnPlayerClick.AddListener(OnChangeColor_ToggleMenu);
        button_toggle_SurfaceGrab.OnPlayerClick.AddListener(OnPlayerToggleSurfaceGrab);
        button_ResetPen.OnPlayerClick.AddListener(ResetPen);

        token = this.AddEventHandler(EVENT_ID, OnNetworkClickPen);
        token_SizeDown = this.AddEventHandler(EVENTID_SizeUp, OnNetworkSizeUp);
        token_SizeDown = this.AddEventHandler(EVENTID_SizeDown, OnNetworkSizeDown);
        token_Em_Up = this.AddEventHandler(EVENT_ID_Em_Up, OnNetworkEmissionUp);
        token_Em_Down = this.AddEventHandler(EVENT_ID_Em_Down, OnNetworkEmissionDown);
        tokenLateJoiner = this.AddEventHandler(EVENT_HANDLE_LATE_JOINER, OnSendInfoTolateJoiner);
        token_SetColor = this.AddEventHandler(EVENT_ID_SetColor, OnNetworkSetColor);
        this.AddEventHandler("SetRGB", OnNetworkSetRGB);
        this.AddEventHandler("SetEmission", OnNetworkSetEmission);
        this.AddEventHandler("SetMetallic", OnNetworkSetMetallic);
        this.AddEventHandler("SetSmoothness", OnNetworkSetSmoothness);
        Redo_Button.OnPlayerClick.AddListener(Redo);
        Undo_Button.OnPlayerClick.AddListener(Undo);

        this.AddEventHandler("PenUndo", OnNetworkUndo);
        this.AddEventHandler("PenRedo", OnNetworkRedo);

        button_ClearAll.OnPlayerClick.AddListener(ClearAll);
        this.AddEventHandler("PenClearAll", OnNetworkClearAll);

        RSlider.onValueChanged.AddListener(OnRGBChanged);
        GSlider.onValueChanged.AddListener(OnRGBChanged);
        BSlider.onValueChanged.AddListener(OnRGBChanged);
        EmissionSlider.onValueChanged.AddListener(OnEmissionChanged);
        MetalicSlider.onValueChanged.AddListener(OnMetallicChanged);
        SmoothnessSlider.onValueChanged.AddListener(OnSmoothnessChanged);

        initialSizePreviewScale = sizePreview.transform.localScale; // Store the initial scale

        MassiveLoopRoom.OnPlayerJoined += PlayerJoined;
        canvasOriginalScale = ColorCanvas.transform.localScale;

        var prefabLR = drawnPrefab != null ? drawnPrefab.GetComponent<LineRenderer>() : null;
        if (prefabLR != null)
            currentWidthMultiplier = prefabLR.widthMultiplier;

        // ensure we have the per-pen material instance for the starting color
        CreateOrUpdatePenMaterialInstance(currentColorIndex);

        materialInstances = new Material[corresponding_materials.Length];
        for (int i = 0; i < corresponding_materials.Length; i++)
        {
            if (corresponding_materials[i] != null)
                materialInstances[i] = new Material(corresponding_materials[i]);
            else
                materialInstances[i] = new Material(Shader.Find("Standard"));
        }

        // pick starting instance
        penMaterialInstance = materialInstances[currentColorIndex];
        UpdatePreviewMaterial();

        for (int i = 0; i < ColorButtons.Length; i++)
        {
            int colorIndex = i; // local copy to avoid closure issue
            if (ColorButtons[colorIndex] != null)
            {
                var img = ColorButtons[colorIndex].GetComponent<Image>();
                if (img != null && colorIndex < corresponding_materials.Length && corresponding_materials[colorIndex] != null)
                {
                    if (corresponding_materials[colorIndex].HasProperty("_Color"))
                    {
                        img.color = corresponding_materials[colorIndex].GetColor("_Color");
                    }
                }

                // 🔹 Add listener for click
                ColorButtons[colorIndex].OnPlayerClick.AddListener((player) =>
                {
                    SetColorByIndex(colorIndex);
                });
            }
        }

        ColorCanvas.SetActive(false);

        OriginPosition = transform.position;
        OriginRotation = transform.rotation;

    }

    private void SetColorByIndexLocal(int index)
    {
        if (index < 0 || index >= drawnColors.Length)
            return;

        currentColorIndex = index;
        drawnPrefab = drawnColors[index];
        CreateOrUpdatePenMaterialInstance(index);

        if (ColorPreview != null)
        {
            var previewRenderer = ColorPreview.GetComponent<Renderer>();
            if (previewRenderer != null)
                previewRenderer.material = penMaterialInstance;
        }

        currentColor = drawnColors[index].name;

        // 🔹 Update sliders from the material
        UpdateSlidersFromMaterial();
    }

    void OnNetworkSetColor(object[] args)
    {
        int index = (int)args[0];
        string objName = (string)args[1];

        if (this.gameObject.name == objName)
        {
            SetColorByIndexLocal(index);
            UpdateSlidersFromMaterial(); // 🔹 sync UI with material values
        }
    }

    private void UpdateSlidersFromMaterial()
    {
        if (penMaterialInstance == null) return;

        if (penMaterialInstance.HasProperty("_Color"))
        {
            Color c = penMaterialInstance.GetColor("_Color");
            RSlider.SetValueWithoutNotify(c.r);
            GSlider.SetValueWithoutNotify(c.g);
            BSlider.SetValueWithoutNotify(c.b);
        }

        if (penMaterialInstance.HasProperty("_EmissionColor"))
        {
            Color em = penMaterialInstance.GetColor("_EmissionColor");
            emissionIntensity = em.maxColorComponent;
            EmissionSlider.SetValueWithoutNotify(emissionIntensity);
        }

        if (penMaterialInstance.HasProperty("_Metallic"))
            MetalicSlider.SetValueWithoutNotify(penMaterialInstance.GetFloat("_Metallic"));

        if (penMaterialInstance.HasProperty("_Glossiness"))
            SmoothnessSlider.SetValueWithoutNotify(penMaterialInstance.GetFloat("_Glossiness"));
    }


    void OnNetworkSetRGB(object[] args)
    {
        float r = (float)args[0];
        float g = (float)args[1];
        float b = (float)args[2];
        string objName = (string)args[3];

        if (this.gameObject.name == objName)
        {
            isUpdatingFromNetwork = true;

            RSlider.SetValueWithoutNotify(r);
            GSlider.SetValueWithoutNotify(g);
            BSlider.SetValueWithoutNotify(b);
            OnRGBChanged(0); // apply to material, but don’t re-broadcast

            isUpdatingFromNetwork = false;
        }
    }

    void OnNetworkSetEmission(object[] args)
    {
        float value = (float)args[0];
        string objName = (string)args[1];

        if (this.gameObject.name == objName)
        {
            isUpdatingFromNetwork = true;

            EmissionSlider.SetValueWithoutNotify(value);
            OnEmissionChanged(value);

            isUpdatingFromNetwork = false;
        }
    }

    void OnNetworkSetMetallic(object[] args)
    {
        float value = (float)args[0];
        string objName = (string)args[1];

        if (this.gameObject.name == objName)
        {
            isUpdatingFromNetwork = true;

            MetalicSlider.SetValueWithoutNotify(value);
            OnMetallicChanged(value);

            isUpdatingFromNetwork = false;
        }
    }

    void OnNetworkSetSmoothness(object[] args)
    {
        float value = (float)args[0];
        string objName = (string)args[1];

        if (this.gameObject.name == objName)
        {
            isUpdatingFromNetwork = true;

            SmoothnessSlider.SetValueWithoutNotify(value);
            OnSmoothnessChanged(value);

            isUpdatingFromNetwork = false;
        }
    }



    private void OnRGBChanged(float _)
    {
        if (penMaterialInstance == null) return;

        Color newColor = new Color(RSlider.value, GSlider.value, BSlider.value, 1f);

        if (penMaterialInstance.HasProperty("_Color"))
            penMaterialInstance.SetColor("_Color", newColor);

        if (penMaterialInstance.HasProperty("_EmissionColor"))
        {
            penMaterialInstance.SetColor("_EmissionColor", newColor * emissionIntensity);
            penMaterialInstance.EnableKeyword("_EMISSION");
        }

        UpdatePreviewMaterial();

        if (!isUpdatingFromNetwork)
        {
            this.InvokeNetwork("SetRGB", EventTarget.Others, null,
                RSlider.value, GSlider.value, BSlider.value, this.gameObject.name);
        }

        UpdateActiveColorButtonImage();
    }


    private void OnEmissionChanged(float value)
    {
        emissionIntensity = value;

        if (penMaterialInstance == null) return;

        if (penMaterialInstance.HasProperty("_EmissionColor"))
        {
            Color baseColor = penMaterialInstance.HasProperty("_Color")
                ? penMaterialInstance.GetColor("_Color")
                : Color.white;

            penMaterialInstance.SetColor("_EmissionColor", baseColor * emissionIntensity);
            penMaterialInstance.EnableKeyword("_EMISSION");
        }

        UpdatePreviewMaterial();

        if (!isUpdatingFromNetwork)
        {
            this.InvokeNetwork("SetEmission", EventTarget.Others, null, emissionIntensity, this.gameObject.name);
        }

        UpdateActiveColorButtonImage();
    }

    private void OnMetallicChanged(float value)
    {
        if (penMaterialInstance != null && penMaterialInstance.HasProperty("_Metallic"))
            penMaterialInstance.SetFloat("_Metallic", value);

        UpdatePreviewMaterial();

        if (!isUpdatingFromNetwork)
        {
            this.InvokeNetwork("SetMetallic", EventTarget.Others, null, value, this.gameObject.name);
        }

        UpdateActiveColorButtonImage();
    }

    private void OnSmoothnessChanged(float value)
    {
        if (penMaterialInstance != null && penMaterialInstance.HasProperty("_Glossiness"))
            penMaterialInstance.SetFloat("_Glossiness", value);

        UpdatePreviewMaterial();

        if (!isUpdatingFromNetwork)
        {
            this.InvokeNetwork("SetSmoothness", EventTarget.Others, null, value, this.gameObject.name);
        }

        UpdateActiveColorButtonImage();
    }

    private void SetColorByIndex(int index)
    {
        if (index < 0 || index >= drawnColors.Length)
            return;

        currentColorIndex = index;
        drawnPrefab = drawnColors[index];
        CreateOrUpdatePenMaterialInstance(index);

        if (ColorPreview != null)
        {
            var previewRenderer = ColorPreview.GetComponent<Renderer>();
            if (previewRenderer != null)
                previewRenderer.material = penMaterialInstance;
        }

        currentColor = drawnColors[index].name;

        this.InvokeNetwork(EVENT_ID_SetColor, EventTarget.All, null, index, this.gameObject.name);
    }

    private void PlayerJoined(ML.SDK.MLPlayer player)
    {
        if (MassiveLoopClient.IsMasterClient)
        {
            this.InvokeNetwork(EVENT_HANDLE_LATE_JOINER, EventTarget.All, null, currentColor, currentColorIndex, this.gameObject.name);
        }
        else
        {
            UnityEngine.Debug.Log($"The master client will handle synchronization for {player.NickName}.");
        }

    }

    private void UpdateActiveColorButtonImage()
    {
        if (currentColorIndex < 0 || currentColorIndex >= ColorButtons.Length)
            return;

        var img = ColorButtons[currentColorIndex].GetComponent<Image>();
        if (img != null && penMaterialInstance != null && penMaterialInstance.HasProperty("_Color"))
        {
            // Base color from material
            Color baseColor = penMaterialInstance.GetColor("_Color");

            // Apply emission brightness if you want emission visible in preview
            Color finalColor = baseColor * Mathf.Max(1f, emissionIntensity);

            // Clamp to 0–1 so UI Image doesn’t blow out
            finalColor.r = Mathf.Clamp01(finalColor.r);
            finalColor.g = Mathf.Clamp01(finalColor.g);
            finalColor.b = Mathf.Clamp01(finalColor.b);
            finalColor.a = 1f;

            img.color = finalColor;
        }
    }

    private IEnumerator AnimateCanvas(GameObject canvas, bool opening)
    {
        Vector3 hiddenScale = Vector3.zero;
        Vector3 visibleScale = canvasOriginalScale;
        float duration = 0.2f;
        float elapsed = 0f;

        if (opening)
        {
            canvas.SetActive(true);
            canvas.transform.localScale = hiddenScale;
            while (elapsed < duration)
            {
                canvas.transform.localScale = Vector3.Lerp(hiddenScale, visibleScale, elapsed / duration);
                elapsed += Time.deltaTime;
                yield return null;
            }
            canvas.transform.localScale = visibleScale;
        }
        else
        {
            Vector3 startScale = canvasOriginalScale;
            while (elapsed < duration)
            {
                canvas.transform.localScale = Vector3.Lerp(startScale, hiddenScale, elapsed / duration);
                elapsed += Time.deltaTime;
                yield return null;
            }
            canvas.transform.localScale = hiddenScale;
            canvas.SetActive(false);
        }
    }

    // Update method
    void FixedUpdate()
    {
        if (drawing == 1 && currentLine != null)
        {
            linePoints.Add(drawPoint.position);
            currentLine.positionCount = linePoints.Count;
            currentLine.SetPositions(linePoints.ToArray());
            lastDrawnPosition = drawPoint.position;
        }
    }
}

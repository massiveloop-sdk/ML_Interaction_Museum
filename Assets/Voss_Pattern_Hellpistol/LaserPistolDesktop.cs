using ML.SDK;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(LineRenderer))]

public class LaserPistolDesktop : MonoBehaviour
{
    [Header("Basics")]
    public Transform muzzlePoint;
    public float maxLaserDistance = 100f;
    public float laserDuration = 0.1f;
    public int baseDamage = 10;
    public LayerMask hitLayers = ~0;


    [Header("Click Cooldown Settings")]
    public float clickCooldown = 0.2f; // Minimum time between clicks
    private float nextClickTime = 0f;

    [Header("Ammo and Reload Settings")]
    public int maxAmmo = 10;
    public float reloadTime = 2f;
    private int currentAmmo;
    private bool isReloading = false;

    [Header("Firing Mode")]
    public bool isAutomatic = false;
    public bool isBurstFire = false; // New: Toggle for burst fire mode
    public bool isShotgun = false; // Toggle for shotgun mode
    public bool isChargedShot = false; // Toggle for charged shot mode
    public float automaticFireRate = 10f; // Shots per second
    private float automaticFireTimer = 0f;
    private bool isTriggerHeld = false;

    [Header("Burst Fire Settings")] // New: Burst fire settings
    public int burstRounds = 3; // Number of rounds per burst
    public float burstFireRate = 5f; // Bursts per second
    private float burstFireTimer = 0f;
    private int currentBurstCount = 0;
    private bool isBursting = false;

    [Header("Charged Shot Settings")]
    public int pelletCount = 8; // Number of pellets in shotgun spread
    public float spreadAngle = 15f; // Spread angle in degrees
    public float chargeTime = 1.5f; // Time to fully charge weapon
    public float minChargePercent = 0.3f; // Minimum charge required to fire
    public float maxDamageMultiplier = 3f; // Maximum damage multiplier at full charge
    public float maxLaserWidth = 0.2f; // Maximum laser width at full charge
    private float currentCharge = 0f;
    private bool isCharging = false;

    [Header("Charge Preview Settings")]
    public bool showChargePreview = true; // Toggle to show preview while charging
    public Material previewMaterial; // Material for the preview laser
    private Material originalLaserMaterial;
    private bool isShowingPreview = false;

    [Header("Bounce Shot Settings")]
    public bool enableBounceShot = false; // Toggle to enable bouncing shots
    public int maxBounces = 3; // Maximum number of bounces
    public float bounceDistanceMultiplier = 0.8f; // Distance reduction per bounce

    [Header("Charge VFX")]
    public GameObject chargeEffect;
    public float maxChargeEffectSize = 2f;
    private GameObject currentChargeEffect;

    [Header("Recoil Settings")]
    public Vector2[] recoilPattern; // Predefined recoil pattern (x, y offsets)
    public float recoilIntensity = 1f;
    public float recoilApplySpeed = 8f; // How quickly recoil is applied
    public float recoilRecoverySpeed = 3f; // How quickly recoil recovers
    private int currentRecoilIndex = 0;
    private Vector3 currentRecoilOffset = Vector3.zero;
    private Vector3 targetRecoilOffset = Vector3.zero;
    private bool isApplyingRecoil = false;

    [Header("UI Elements")]
    public Slider ammoSlider;
    public Slider reloadSlider;

    [Header("Visual Feedback")]
    public Transform gunTransform;
    public float reloadTiltAngle = 45f;
    public float twirlSpeed = 360f; // Degrees per second
    public int numberOfTwirls = 2; // How many complete rotations
    private Quaternion originalRotation;
    private Vector3 originalGunPosition;
    private bool isTwirling = false;

    private ML.SDK.MLGrab grabComponent;
    private LineRenderer lineRenderer;
    private float laserTimer = 0f;

    [Header("Sound Settings")]
    public GameObject impactEffect;
    public AudioClip laserSound;
    public AudioClip shotgunSound;
    public AudioClip chargedShotSound;
    public AudioClip chargingSound;
    public AudioClip reloadSound;
    public AudioClip emptySound;
    public AudioSource audioSource;
    public GameObject MuzzleEffect;
    public AudioClip[] LaserGunShootSoundEffects;
    public float pitchVariation = 0.2f; // ±20% pitch variation
    private float lastSoundTime = 0f;
    public float minSoundInterval = 0.05f; // 20 sounds per second max

    //   [Header("GameManager")]
    //   public GameObject GameManagerObject;
    //    public DeathMatchCoordinatorManager DeathMatchCoordinatorManagerReference;

    const string EVENT_ID_SYNC_AMMO = "SyncAmmo";
    EventToken token_SyncAmmo;


    void Start()
    {
        grabComponent = (MLGrab)GetComponent(typeof(MLGrab));
        if (grabComponent != null)
        {
            grabComponent.OnPrimaryTriggerDown.AddListener(OnPrimaryTriggerDown);
            grabComponent.OnPrimaryTriggerUp.AddListener(OnPrimaryTriggerUp);
            grabComponent.OnPrimaryGrabBegin.AddListener(OnPrimaryGrabBegin);
            grabComponent.OnPrimaryGrabEnd.AddListener(OnPrimaryGrabEnd);
        }

        token_SyncAmmo = this.AddEventHandler(EVENT_ID_SYNC_AMMO, OnNetworkSyncAmmo);


        lineRenderer = GetComponent<LineRenderer>();
        lineRenderer.positionCount = 2;
        lineRenderer.enabled = false;

        // Store original laser material
        originalLaserMaterial = lineRenderer.material;

        // Initialize ammo
        currentAmmo = maxAmmo;
        originalRotation = gunTransform.localRotation;
        originalGunPosition = gunTransform.localPosition;

        // Initialize UI
        UpdateAmmoUI();
        reloadSlider.gameObject.SetActive(false);

        // Initialize default recoil pattern if none is set (simple upward pattern)
        if (recoilPattern == null || recoilPattern.Length == 0)
        {
            recoilPattern = new Vector2[]
            {
                new Vector2(0f, 0.05f),
                new Vector2(0.03f, 0.08f),
                new Vector2(-0.02f, 0.1f),
                new Vector2(0.04f, 0.12f),
                new Vector2(-0.03f, 0.14f),
                new Vector2(0.05f, 0.16f),
                new Vector2(-0.04f, 0.18f),
                new Vector2(0.06f, 0.2f),
                new Vector2(-0.05f, 0.22f),
                new Vector2(0.07f, 0.24f)
            };
        }

   //     DeathMatchCoordinatorManagerReference = GameManagerObject.GetComponent(typeof(DeathMatchCoordinatorManager)) as DeathMatchCoordinatorManager;

    }

    void Update()
    {
        // Handle laser duration timer
        if (laserTimer > 0)
        {
            laserTimer -= Time.deltaTime;
            if (laserTimer <= 0)
            {
                lineRenderer.enabled = false;
                // Restore original material if we were showing preview
                if (isShowingPreview)
                {
                    lineRenderer.material = originalLaserMaterial;
                    isShowingPreview = false;
                }
            }
        }

        // Handle automatic reload when empty
        if (currentAmmo <= 0 && !isReloading)
        {
            StartReload();
        }

        // Handle automatic firing
        if (isAutomatic && !isBurstFire && !isShotgun && !isChargedShot && isTriggerHeld && !isReloading && currentAmmo > 0)
        {
            automaticFireTimer -= Time.deltaTime;
            if (automaticFireTimer <= 0f)
            {
                FireLaser();
                automaticFireTimer = 1f / automaticFireRate;
            }
        }

        // Handle burst firing
        if (isBurstFire && !isShotgun && !isChargedShot && isBursting && !isReloading && currentAmmo > 0)
        {
            burstFireTimer -= Time.deltaTime;
            if (burstFireTimer <= 0f && currentBurstCount < burstRounds)
            {
                FireLaser();
                currentBurstCount++;
                burstFireTimer = 1f / (burstFireRate * burstRounds);
            }
            else if (currentBurstCount >= burstRounds)
            {
                isBursting = false;
                currentBurstCount = 0;
            }
        }

        // Handle charging for shotgun and charged shot modes
        if ((isShotgun || isChargedShot) && isCharging && !isReloading && currentAmmo > 0)
        {
            currentCharge += Time.deltaTime;
            currentCharge = Mathf.Clamp(currentCharge, 0f, chargeTime);

            // Update reload slider to show charge progress
            reloadSlider.value = currentCharge / chargeTime;

            // Update charge VFX for charged shot mode
            UpdateChargeVFX();

            // Show preview if enabled
            if (showChargePreview && !isShowingPreview)
            {
                ShowChargePreview();
            }
            else if (showChargePreview && isShowingPreview)
            {
                UpdateChargePreview();
            }
        }

        // Handle twirling animation
        if (isTwirling)
        {
            HandleTwirlAnimation();
        }

        // Handle recoil application and recovery
        HandleRecoil();
    }

    void ShowChargePreview()
    {
        if (previewMaterial != null)
        {
            lineRenderer.material = previewMaterial;
            isShowingPreview = true;
        }
        UpdateChargePreview();
        lineRenderer.enabled = true;
        laserTimer = 0.1f; // Keep it visible for a short time, will be refreshed in UpdateChargePreview
    }

    void UpdateChargePreview()
    {
        if (!isShowingPreview) return;

        float chargeFactor = currentCharge / chargeTime;
        float laserWidth = Mathf.Lerp(0.05f, maxLaserWidth, chargeFactor);

        lineRenderer.startWidth = laserWidth;
        lineRenderer.endWidth = laserWidth;

        if (enableBounceShot && isChargedShot)
        {
            // Calculate bounce trajectory
            CalculateBounceTrajectory(chargeFactor);
        }
        else
        {
            // Standard trajectory
            RaycastHit hit;
            Vector3 endPoint;

            if (Physics.Raycast(muzzlePoint.position, muzzlePoint.forward, out hit, maxLaserDistance, hitLayers))
            {
                endPoint = hit.point;
            }
            else
            {
                endPoint = muzzlePoint.position + muzzlePoint.forward * maxLaserDistance;
            }

            lineRenderer.positionCount = 2;
            lineRenderer.SetPosition(0, muzzlePoint.position);
            lineRenderer.SetPosition(1, endPoint);
        }

        laserTimer = 0.1f; // Keep the preview visible
    }

    void CalculateBounceTrajectory(float chargeFactor)
    {
        Vector3 direction = muzzlePoint.forward;
        Vector3 currentPosition = muzzlePoint.position;
        float remainingDistance = maxLaserDistance * Mathf.Lerp(1f, 1.5f, chargeFactor); // Charge increases range
        int bounceCount = 0;

        List<Vector3> trajectoryPoints = new List<Vector3>();
        trajectoryPoints.Add(currentPosition);

        while (bounceCount < maxBounces && remainingDistance > 0.1f)
        {
            RaycastHit hit;
            if (Physics.Raycast(currentPosition, direction, out hit, remainingDistance, hitLayers))
            {
                trajectoryPoints.Add(hit.point);

                // Calculate bounce direction
                direction = Vector3.Reflect(direction, hit.normal);
                currentPosition = hit.point;
                remainingDistance -= hit.distance;
                remainingDistance *= bounceDistanceMultiplier; // Reduce distance after bounce

                bounceCount++;
            }
            else
            {
                // No more hits, add final point
                trajectoryPoints.Add(currentPosition + direction * remainingDistance);
                break;
            }
        }

        // Update line renderer with trajectory
        lineRenderer.positionCount = trajectoryPoints.Count;
        for (int i = 0; i < trajectoryPoints.Count; i++)
        {
            lineRenderer.SetPosition(i, trajectoryPoints[i]);
        }
    }

    void UpdateChargeVFX()
    {
        if (isChargedShot && chargeEffect != null)
        {
            if (currentChargeEffect == null)
            {
                currentChargeEffect = Instantiate(chargeEffect, muzzlePoint.position, muzzlePoint.rotation);
                currentChargeEffect.transform.parent = muzzlePoint;
            }

            // Scale VFX based on charge level
            float chargeFactor = currentCharge / chargeTime;
            float scale = Mathf.Lerp(0.1f, maxChargeEffectSize, chargeFactor);
            currentChargeEffect.transform.localScale = Vector3.one * scale;
        }
    }

    void HandleTwirlAnimation()
    {
        // Rotate the gun around its forward axis for the twirl effect
        gunTransform.Rotate(Vector3.forward, twirlSpeed * Time.deltaTime, Space.Self);
    }

    void HandleRecoil()
    {
        if (isApplyingRecoil)
        {
            // Smoothly apply recoil towards target
            currentRecoilOffset = Vector3.Lerp(currentRecoilOffset, targetRecoilOffset, recoilApplySpeed * Time.deltaTime);
            ApplyRecoilToGun();

            // Check if we've reached the target recoil
            if (Vector3.Distance(currentRecoilOffset, targetRecoilOffset) < 0.001f)
            {
                isApplyingRecoil = false;
            }
        }
        else if (currentRecoilOffset != Vector3.zero)
        {
            // Smoothly recover from recoil when not applying new recoil
            currentRecoilOffset = Vector3.Lerp(currentRecoilOffset, Vector3.zero, recoilRecoverySpeed * Time.deltaTime);
            ApplyRecoilToGun();
        }
    }

    void ApplyRecoilToGun()
    {
        // Apply the current recoil offset to the gun's position
        gunTransform.localPosition = originalGunPosition + currentRecoilOffset;
    }

    void ApplyRecoil()
    {
        if (recoilPattern.Length == 0) return;

        // Get the next recoil pattern point
        Vector2 recoil = recoilPattern[currentRecoilIndex] * recoilIntensity;

        // Set target recoil offset
        targetRecoilOffset = new Vector3(recoil.x, recoil.y, 0f);
        isApplyingRecoil = true;

        // Move to next point in pattern, loop if needed
        currentRecoilIndex = (currentRecoilIndex + 1) % recoilPattern.Length;
    }

    void ResetRecoilPattern()
    {
        currentRecoilIndex = 0;
        currentRecoilOffset = Vector3.zero;
        targetRecoilOffset = Vector3.zero;
        isApplyingRecoil = false;
        ApplyRecoilToGun();
    }

    void OnPrimaryGrabBegin()
    {
        // Make all colliders triggers while grabbed
        Collider[] colliders = GetComponentsInChildren<Collider>();
        foreach (Collider col in colliders)
        {
            col.isTrigger = true;
        }

        /* Logic for handling UI
        if (grabComponent.CurrentUser.IsLocal)
        {
            DeathMatchLocalPlayer.Instance.Ammo.maxValue = maxAmmo;
            DeathMatchLocalPlayer.Instance.Ammo.value = currentAmmo;
            string GunNameWithoutNumbers = Regex.Replace(this.name, @"\d", ""); // Removes all digits
            DeathMatchLocalPlayer.Instance.Ammo_Text.text = $"{GunNameWithoutNumbers} {currentAmmo} / {maxAmmo}";


            DeathMatchLocalPlayer.Instance.Ammo_VR_Bar.maxValue = maxAmmo;
            DeathMatchLocalPlayer.Instance.Ammo_VR_Bar.value = currentAmmo;
            DeathMatchLocalPlayer.Instance.Ammo_Text_VR.text = $"{GunNameWithoutNumbers} {currentAmmo} / {maxAmmo}";
        }
        */
    }

    void OnPrimaryGrabEnd()
    {
        // Make all colliders triggers while grabbed
        Collider[] colliders = GetComponentsInChildren<Collider>();
        foreach (Collider col in colliders)
        {
            col.isTrigger = false;
        }

        /* Logic for Handling UI. Not needed here.
        if (grabComponent.CurrentUser.IsLocal)
        {
            DeathMatchLocalPlayer.Instance.Ammo.maxValue = maxAmmo;
            DeathMatchLocalPlayer.Instance.Ammo.value = currentAmmo;
            string GunNameWithoutNumbers = Regex.Replace(this.name, @"\d", ""); // Removes all digits
            DeathMatchLocalPlayer.Instance.Ammo_Text.text = $"UNARMED";


            DeathMatchLocalPlayer.Instance.Ammo_VR_Bar.maxValue = maxAmmo;
            DeathMatchLocalPlayer.Instance.Ammo_VR_Bar.value = currentAmmo;
            DeathMatchLocalPlayer.Instance.Ammo_Text_VR.text = $"UNARMED";
        }
        */

        isTriggerHeld = false;

    }
    void OnPrimaryTriggerDown()
    {
        isTriggerHeld = true;

        if (isReloading)
        {
            if (emptySound != null && audioSource != null)
            {
                audioSource.PlayOneShot(emptySound);
            }
            return;
        }

        if (currentAmmo > 0)
        {
            if (isShotgun || isChargedShot)
            {
                // Start charging
                isCharging = true;
                currentCharge = 0f;
                reloadSlider.gameObject.SetActive(true);
                reloadSlider.value = 0f;

                // Play charging sound if available
                if (chargingSound != null && audioSource != null)
                {
                    audioSource.PlayOneShot(chargingSound);
                }
            }
            else if (isBurstFire)
            {
                // Start burst fire
                if (!isBursting)
                {
                    isBursting = true;
                    currentBurstCount = 0;
                    burstFireTimer = 0f;
                }
            }
            else if (!isAutomatic)
            {
                FireLaser();
            }
            else
            {
                automaticFireTimer = 0f;
            }
        }
        else
        {
            if (emptySound != null && audioSource != null)
            {
                audioSource.PlayOneShot(emptySound);
            }
        }
    }

    void OnPrimaryTriggerUp()
    {
        isTriggerHeld = false;

        if ((isShotgun || isChargedShot) && isCharging)
        {
            // Fire if charged enough
            if (currentCharge >= chargeTime * minChargePercent)
            {
                if (isShotgun)
                {
                    FireShotgun();
                }
                else if (isChargedShot)
                {
                    FireChargedShot();
                }
            }
            else
            {
                // Cancel charge if not enough
                CancelCharge();
            }
        }
        else
        {
            ResetRecoilPattern();
        }
    }

    void CancelCharge()
    {
        isCharging = false;
        reloadSlider.gameObject.SetActive(false);

        // Clean up charge VFX
        if (currentChargeEffect != null)
        {
            Destroy(currentChargeEffect);
            currentChargeEffect = null;
        }

        // Hide preview
        if (isShowingPreview)
        {
            lineRenderer.enabled = false;
            lineRenderer.material = originalLaserMaterial;
            isShowingPreview = false;
        }
    }

    void FireLaser()
    {
        if (isReloading || currentAmmo <= 0)
            return;

        currentAmmo--;
        UpdateAmmoUI();

        // Apply recoil before performing raycast
        ApplyRecoil();

        if (enableBounceShot)
        {
            FireBounceShot(baseDamage);
        }
        else
        {
            RaycastHit hit;
            Vector3 endPoint;

            if (Physics.Raycast(muzzlePoint.position, muzzlePoint.forward, out hit, maxLaserDistance, hitLayers))
            {
                endPoint = hit.point;
                HandleHitObject(hit, baseDamage);
            }
            else
            {
                endPoint = muzzlePoint.position + muzzlePoint.forward * maxLaserDistance;
            }

            lineRenderer.SetPosition(0, muzzlePoint.position);
            lineRenderer.SetPosition(1, endPoint);
            lineRenderer.enabled = true;
            laserTimer = laserDuration;
        }

        PlayRandomLaserSound();

        if (currentAmmo <= 0)
        {
            StartReload();
        }
    }

    void FireBounceShot(int damage)
    {
        Vector3 direction = muzzlePoint.forward;
        Vector3 currentPosition = muzzlePoint.position;
        float remainingDistance = maxLaserDistance;
        int bounceCount = 0;

        List<Vector3> trajectoryPoints = new List<Vector3>();
        trajectoryPoints.Add(currentPosition);

        while (bounceCount < maxBounces && remainingDistance > 0.1f)
        {
            RaycastHit hit;
            if (Physics.Raycast(currentPosition, direction, out hit, remainingDistance, hitLayers))
            {
                trajectoryPoints.Add(hit.point);
                HandleHitObject(hit, damage);

                // Calculate bounce direction
                direction = Vector3.Reflect(direction, hit.normal);
                currentPosition = hit.point;
                remainingDistance -= hit.distance;
                remainingDistance *= bounceDistanceMultiplier; // Reduce distance after bounce

                bounceCount++;
            }
            else
            {
                // No more hits, add final point
                trajectoryPoints.Add(currentPosition + direction * remainingDistance);
                break;
            }
        }

        // Show the bounce trajectory
        lineRenderer.positionCount = trajectoryPoints.Count;
        for (int i = 0; i < trajectoryPoints.Count; i++)
        {
            lineRenderer.SetPosition(i, trajectoryPoints[i]);
        }

        lineRenderer.enabled = true;
        laserTimer = laserDuration;
    }

    void FireChargedShot()
    {
        if (isReloading || currentAmmo <= 0 || !isCharging)
            return;

        currentAmmo--;
        UpdateAmmoUI();

        float chargeFactor = currentCharge / chargeTime;

        // Calculate scaled damage and laser width based on charge
        int calculatedDamage = Mathf.RoundToInt(baseDamage * Mathf.Lerp(1f, maxDamageMultiplier, chargeFactor));
        float laserWidth = Mathf.Lerp(0.05f, maxLaserWidth, chargeFactor);

        // Apply recoil scaled by charge
        ApplyRecoil();
        targetRecoilOffset *= (1f + chargeFactor); // More charge = more recoil

        if (enableBounceShot)
        {
            FireBounceShot(calculatedDamage);
            // Adjust laser width for bounce shot
            lineRenderer.startWidth = laserWidth;
            lineRenderer.endWidth = laserWidth;
        }
        else
        {
            RaycastHit hit;
            Vector3 endPoint;

            if (Physics.Raycast(muzzlePoint.position, muzzlePoint.forward, out hit, maxLaserDistance, hitLayers))
            {
                endPoint = hit.point;
                HandleHitObject(hit, calculatedDamage);
            }
            else
            {
                endPoint = muzzlePoint.position + muzzlePoint.forward * maxLaserDistance;
            }

            // Set laser width based on charge
            lineRenderer.startWidth = laserWidth;
            lineRenderer.endWidth = laserWidth;
            lineRenderer.SetPosition(0, muzzlePoint.position);
            lineRenderer.SetPosition(1, endPoint);
            lineRenderer.enabled = true;
            laserTimer = laserDuration;
        }

        // Play charged shot sound
        if (chargedShotSound != null && audioSource != null)
        {
            float originalPitch = audioSource.pitch;
            float randomPitch = Random.Range(0.8f - pitchVariation, 1.2f + pitchVariation * chargeFactor);
            audioSource.pitch = randomPitch;
            audioSource.PlayOneShot(chargedShotSound);
            audioSource.pitch = originalPitch;
            PlayRandomLaserSound();
        }

        // Reset charging
        CancelCharge();

        if (currentAmmo <= 0)
        {
            StartReload();
        }
    }

    void FireShotgun()
    {
        if (isReloading || currentAmmo <= 0 || !isCharging)
            return;

        currentAmmo--;
        UpdateAmmoUI();

        // Apply stronger recoil for shotgun
        ApplyRecoil();
        targetRecoilOffset *= 2f; // Double recoil for shotgun

        float chargeFactor = currentCharge / chargeTime;
        float currentSpread = spreadAngle * (1.1f - chargeFactor); // More charge = tighter spread

        // Fire multiple pellets in spread pattern
        for (int i = 0; i < pelletCount; i++)
        {
            Vector3 pelletDirection = GetPelletDirection(currentSpread);
            RaycastHit hit;
            Vector3 endPoint;

            if (Physics.Raycast(muzzlePoint.position, pelletDirection, out hit, maxLaserDistance, hitLayers))
            {
                HandleHitObject(hit, baseDamage);
                endPoint = hit.point;
            }
            else
            {
                endPoint = muzzlePoint.position + pelletDirection * maxLaserDistance;
            }

            // Create a temporary line renderer for this pellet
            StartCoroutine(DrawPelletLine(muzzlePoint.position, endPoint, laserDuration));
        }

        // Play shotgun sound
        if (shotgunSound != null && audioSource != null)
        {
            float originalPitch = audioSource.pitch;
            float randomPitch = Random.Range(0.9f - pitchVariation, 1.1f + pitchVariation);
            audioSource.pitch = randomPitch;
            audioSource.PlayOneShot(shotgunSound);
            audioSource.pitch = originalPitch;
        }

        // Reset charging
        CancelCharge();

        if (currentAmmo <= 0)
        {
            StartReload();
        }
    }

    IEnumerator DrawPelletLine(Vector3 start, Vector3 end, float duration)
    {
        GameObject pelletLineObj = new GameObject("PelletLine");
        LineRenderer pelletLine = pelletLineObj.AddComponent<LineRenderer>();

        pelletLine.material = originalLaserMaterial;
        pelletLine.startWidth = 0.02f;
        pelletLine.endWidth = 0.02f;
        pelletLine.positionCount = 2;
        pelletLine.SetPosition(0, start);
        pelletLine.SetPosition(1, end);

        yield return new WaitForSeconds(duration);
        Destroy(pelletLineObj);
    }

    Vector3 GetPelletDirection(float spread)
    {
        // Calculate random spread within cone
        float angle = Random.Range(0f, 360f);
        float distance = Random.Range(0f, spread);

        Quaternion spreadRotation = Quaternion.Euler(
            Mathf.Cos(angle) * distance,
            Mathf.Sin(angle) * distance,
            0f
        );

        return spreadRotation * muzzlePoint.forward;
    }

    void PlayLaserSoundWithThrottle()
    {
        if (Time.time - lastSoundTime < minSoundInterval) return;
        lastSoundTime = Time.time;

        PlayRandomLaserSound();
    }

    void PlayRandomLaserSound()
    {
        if (audioSource != null)
        {
            if (LaserGunShootSoundEffects != null && LaserGunShootSoundEffects.Length > 0)
            {
                int randomIndex = Random.Range(0, LaserGunShootSoundEffects.Length);
                AudioClip selectedSound = LaserGunShootSoundEffects[randomIndex];

                float originalPitch = audioSource.pitch;
                float randomPitch = Random.Range(1f - pitchVariation, 1f + pitchVariation);
                audioSource.pitch = randomPitch;

                audioSource.clip = LaserGunShootSoundEffects[randomIndex];
                audioSource.Play();
                audioSource.pitch = originalPitch;
            }
            else if (laserSound != null)
            {
                float originalPitch = audioSource.pitch;
                float randomPitch = Random.Range(1f - pitchVariation, 1f + pitchVariation);
                audioSource.pitch = randomPitch;
                audioSource.clip = laserSound;

                audioSource.Play();
                audioSource.pitch = originalPitch;
            }
        }
    }

    void StartReload()
    {
        if (isReloading || currentAmmo == maxAmmo)
            return;

        isReloading = true;
        isTriggerHeld = false;
        CancelCharge(); // Stop charging if reloading
        isBursting = false; // Stop burst firing if reloading
        isTwirling = true;

        ResetRecoilPattern();

        gunTransform.localRotation = originalRotation * Quaternion.Euler(reloadTiltAngle, 0, 0);

        reloadSlider.gameObject.SetActive(true);
        reloadSlider.value = 0f;

        if (reloadSound != null && audioSource != null)
        {
            audioSource.PlayOneShot(reloadSound);
        }

        StartCoroutine(ReloadCoroutine());
    }

    System.Collections.IEnumerator ReloadCoroutine()
    {
        float reloadTimer = 0f;
        float twirlDuration = reloadTime * 0.5f;
        float stopTwirlTime = reloadTime - twirlDuration;

        while (reloadTimer < reloadTime)
        {
            reloadTimer += Time.deltaTime;
            float progress = reloadTimer / reloadTime;

            reloadSlider.value = progress;

            if (reloadTimer >= stopTwirlTime && isTwirling)
            {
                isTwirling = false;
                gunTransform.localRotation = originalRotation * Quaternion.Euler(reloadTiltAngle, 0, 0);
            }

            yield return null;
        }

        currentAmmo = maxAmmo;
        isReloading = false;
        isTwirling = false;

        gunTransform.localRotation = originalRotation;
        ResetRecoilPattern();

        reloadSlider.gameObject.SetActive(false);
        UpdateAmmoUI();

        if (grabComponent.CurrentUser.IsLocal)
        {
            this.InvokeNetwork(EVENT_ID_SYNC_AMMO, EventTarget.Others, null, currentAmmo, this.gameObject.name);
        }
    }

    void OnNetworkSyncAmmo(object[] args)
    {
        int syncedAmmo = (int)args[0];
        string objName = (string)args[1];

        if (this.gameObject.name == objName)
        {
            currentAmmo = syncedAmmo;
            UpdateAmmoUI();
        }
    }

    void UpdateAmmoUI()
    {
        if (ammoSlider != null && grabComponent.CurrentUser != null)
        {
            ammoSlider.value = (float)currentAmmo / maxAmmo;

            /* Logic for handling UI. Not needed here.
            if (grabComponent.CurrentUser.IsLocal)
            {
                DeathMatchLocalPlayer.Instance.Ammo.maxValue = maxAmmo;
                DeathMatchLocalPlayer.Instance.Ammo.value = currentAmmo;
                string GunNameWithoutNumbers = Regex.Replace(this.name, @"\d", ""); // Removes all digits
                DeathMatchLocalPlayer.Instance.Ammo_Text.text = $"{GunNameWithoutNumbers} {currentAmmo} / {maxAmmo}";


                DeathMatchLocalPlayer.Instance.Ammo_VR_Bar.maxValue = maxAmmo;
                DeathMatchLocalPlayer.Instance.Ammo_VR_Bar.value = currentAmmo;
                DeathMatchLocalPlayer.Instance.Ammo_Text_VR.text = $"{GunNameWithoutNumbers} {currentAmmo} / {maxAmmo}";
            }
            */
        }
    }

    void HandleHitObject(RaycastHit hit, int damageAmount)
    {
        if (impactEffect != null)
        {
            GameObject TempHitVFX = Instantiate(impactEffect, hit.point, Quaternion.LookRotation(hit.normal));
            Object.Destroy(TempHitVFX, 2);
        }

        if (MuzzleEffect != null)
        {
            GameObject MuzzleEffect_temp = Instantiate(MuzzleEffect, muzzlePoint.position, muzzlePoint.rotation);
            MuzzleEffect_temp.transform.parent = this.gameObject.transform;
            Object.Destroy(MuzzleEffect_temp, 2);
        }

        //  Debug.Log("Hit: " + hit.collider.name + " with " + damageAmount + " damage at distance: " + hit.distance);


        // Example: Apply damage to health component  && DeathMatchCoordinatorManagerReference.GetMatchState() == "InProgress"

        //Clause here, : hitPlayer.NickName != grabComponent.CurrentUser.NickName is new, delete if does not work.
        //put that there to stop players from being able to hurt themselves.
        MLPlayer hitPlayer = hit.collider.gameObject.GetPlayer();
        if (hitPlayer != null && MassiveLoopClient.IsMasterClient && hitPlayer.NickName != grabComponent.CurrentUser.NickName && (int)hitPlayer.GetProperty("PLAYER_HEALTH") > 0)
        {
            // hitPlayer.TakeDamage(damageAmount);
            Debug.Log($"Shooting player : {grabComponent.CurrentUser.NickName} Hit player : {hitPlayer.NickName} attempting to deal damage : {damageAmount} ");
          //  DeathMatchLocalPlayer.Instance.MasterClientDamage(damageAmount, grabComponent.CurrentUser.NickName, hitPlayer);

            if ((int)hitPlayer.GetProperty("PLAYER_HEALTH") <= 0)
            {
                //DeathMatchLocalPlayer.Instance.RpcPlayKillFeedback(grabComponent.CurrentUser.NickName);

            }

        }



        if (hitPlayer != null && grabComponent.CurrentUser.IsLocal)
        {
          //  DeathMatchLocalPlayer.Instance.TriggerHitMarker();
        }
    }



    void OnDestroy()
    {
        if (grabComponent != null)
        {
            grabComponent.OnPrimaryTriggerDown.RemoveListener(OnPrimaryTriggerDown);
            grabComponent.OnPrimaryTriggerUp.RemoveListener(OnPrimaryTriggerUp);
        }

        StopAllCoroutines();

        // Clean up charge VFX
        if (currentChargeEffect != null)
        {
            Destroy(currentChargeEffect);
        }
    }

    public void ManualReload()
    {
        if (!isReloading && currentAmmo < maxAmmo)
        {
            StartReload();
        }
    }

    public void ToggleFiringMode()
    {
        isAutomatic = !isAutomatic;
    }

    public void SetFiringMode(bool automatic)
    {
        isAutomatic = automatic;
    }

    public void ToggleBurstFireMode()
    {
        isBurstFire = !isBurstFire;
        if (isBurstFire)
        {
            isAutomatic = false;
            isShotgun = false;
            isChargedShot = false;
        }
    }

    public void SetBurstFireMode(bool burstFire)
    {
        isBurstFire = burstFire;
        if (isBurstFire)
        {
            isAutomatic = false;
            isShotgun = false;
            isChargedShot = false;
        }
    }

    public void ToggleShotgunMode()
    {
        isShotgun = !isShotgun;
        if (isShotgun)
        {
            isAutomatic = false;
            isBurstFire = false;
            isChargedShot = false;
        }
    }

    public void SetShotgunMode(bool shotgun)
    {
        isShotgun = shotgun;
        if (isShotgun)
        {
            isAutomatic = false;
            isBurstFire = false;
            isChargedShot = false;
        }
    }

    public void ToggleChargedShotMode()
    {
        isChargedShot = !isChargedShot;
        if (isChargedShot)
        {
            isAutomatic = false;
            isBurstFire = false;
            isShotgun = false;
        }
    }

    public void SetChargedShotMode(bool chargedShot)
    {
        isChargedShot = chargedShot;
        if (isChargedShot)
        {
            isAutomatic = false;
            isBurstFire = false;
            isShotgun = false;
        }
    }

    public void ToggleChargePreview()
    {
        showChargePreview = !showChargePreview;
    }

    public void SetChargePreview(bool enablePreview)
    {
        showChargePreview = enablePreview;
    }

    public void ToggleBounceShot()
    {
        enableBounceShot = !enableBounceShot;
    }

    public void SetBounceShot(bool enableBounce)
    {
        enableBounceShot = enableBounce;
    }
}
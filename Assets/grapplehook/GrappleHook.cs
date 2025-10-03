using UnityEngine;
using ML.SDK;
using System.Collections;

[RequireComponent(typeof(LineRenderer))]
public class GrappleHook : MonoBehaviour
{
    public float grappleSpeed = 20f;
    public float minDistanceThreshold;
    public float smoothTime = 0.3f;
    public float maxGrappleRange = 50f;
    public float ropeCurveHeight = 2f;
    public float hookDetectionRadius; // Radius for SphereCast
    public float pullStrength = 10f; // Strength of the pull towards the grapple point
    private bool isGrappling = false;
    private bool isHookShot = false;
    public MLGrab mlgrabItem;
    public Transform shootPoint;
    public GameObject hookPrefab;
    public GameObject visualHook;
    private Vector3 grappleTarget;
    private GameObject currentHook;
    private Transform playerTransform;
    private MLPlayer player;
    private float playerGrav;
    private Vector3 velocity = Vector3.zero;
    private LineRenderer lineRenderer;
    private Vector3 hookStartPosition;
    public GameObject hiteffect;
    private Vector3[] linePositions = new Vector3[20]; // Array to store smoothed line positions
    private Vector3 swingVelocity; // Add this with other private variables
    private float currentRopeLength; // Add this to track rope length
    private Rigidbody playerRigidbody; // Add this for physics

    [Header("Swing Settings")]
    public float initialSwingSpeed = 3f;
    public float gravityScale = 0.5f;
    public float airResistance = 0.995f;
    public float minPullForce = 2f;
    public float autoSwingForce = 0.5f;

    [Header("Rope Physics")]
    public float ropeSmoothSpeed = 15f;
    public float ropeMaxStretch = 1.2f;
    private Vector3[] ropeVelocities; // For smoothing each rope segment
    private void Start()
    {
        mlgrabItem.OnPrimaryTriggerDown.AddListener(HandlePrimaryTriggerDown);
        mlgrabItem.OnPrimaryGrabEnd.AddListener(HandlePrimaryGrabEnd);
        mlgrabItem.OnPrimaryGrabBegin.AddListener(HandlePrimaryGrab);
        player = ML.SDK.MassiveLoopRoom.GetLocalPlayer();
        lineRenderer = GetComponent<LineRenderer>();
        lineRenderer.positionCount = 20; // Default curve points
        lineRenderer.enabled = false;

        ropeVelocities = new Vector3[lineRenderer.positionCount];
        for (int i = 0; i < ropeVelocities.Length; i++)
        {
            ropeVelocities[i] = Vector3.zero;
        }
    }

    void HandlePrimaryGrab()
    {
        player = mlgrabItem.CurrentUser;
        playerTransform = player.PlayerRoot.transform;
        playerGrav = player.GetGravity();
        playerRigidbody = playerTransform.GetComponent<Rigidbody>(); // Add this line
    }

    void HandlePrimaryGrabEnd()
    {
        if (isGrappling || isHookShot)
        {
            StopGrappling(); // Stop any ongoing grapples regardless
        }

        player = null;
        playerTransform = null;


    }

    public LayerMask grapplableLayer; // Assign this layer in the Inspector

    void HandlePrimaryTriggerDown()
    {
        if (isGrappling || isHookShot)
        {
            StopGrappling(); // Stop ongoing grapples
        }

        RaycastHit hit;
        Vector3 targetPoint = shootPoint.position + shootPoint.forward * maxGrappleRange;

        // Cast a ray to detect any surface within range
        if (Physics.Raycast(shootPoint.position, shootPoint.forward, out hit, maxGrappleRange))
        {
            Debug.Log("Grapple target detected: " + hit.collider.name);
            targetPoint = hit.point; // Set the valid grapple target
            StartCoroutine(ShootHook(targetPoint)); // Proceed to shoot the hook
            return;
        }

        Debug.Log("No valid grapple target detected");
    }

    private IEnumerator ShootHook(Vector3 targetPoint)
    {
        isHookShot = true; // Prevent multiple grapples
        hookStartPosition = shootPoint.position;
        grappleTarget = targetPoint;
        visualHook.SetActive(false);


        if (currentHook != null)
        {
            Destroy(currentHook);
        }

        currentHook = Instantiate(hookPrefab, shootPoint.position, Quaternion.identity);
        lineRenderer.enabled = true;

        float elapsedTime = 0f;
        float distance = Vector3.Distance(hookStartPosition, grappleTarget);

        while (elapsedTime < distance / grappleSpeed)
        {
            elapsedTime += Time.deltaTime;
            float t = elapsedTime / (distance / grappleSpeed);
            currentHook.transform.position = Vector3.Lerp(hookStartPosition, grappleTarget, t);

            UpdateRopeCurve(currentHook.transform.position); // Render rope curve
            yield return null;
        }

        isHookShot = false;

        // Confirm the hook is attached to the target
        Debug.Log("Hook successfully attached to: " + grappleTarget);
        GameObject tempEffect = Object.Instantiate(hiteffect, currentHook.transform.position, Quaternion.identity);
        Object.Destroy(tempEffect, 2);
        isGrappling = true;
        player.SetGravity(0); // Disable player gravity
    }

    private void FixedUpdate()
    {
        if (isGrappling && playerRigidbody != null)
        {
            Vector3 toGrapplePoint = grappleTarget - playerTransform.position;
            currentRopeLength = toGrapplePoint.magnitude;

            // Calculate pendulum forces using gravityScale
            Vector3 gravityForce = Physics.gravity * gravityScale;
            Vector3 tensionDirection = toGrapplePoint.normalized;

            // Calculate centripetal force based on velocity perpendicular to rope
            Vector3 perpendicularVelocity = Vector3.ProjectOnPlane(playerRigidbody.velocity, tensionDirection);
            float speed = perpendicularVelocity.magnitude;
            Vector3 centripetalForce = tensionDirection * (speed * speed / currentRopeLength);

            // Apply pendulum forces
            playerRigidbody.AddForce(gravityForce + centripetalForce, ForceMode.Acceleration);

            // Add initial swing impulse if needed using initialSwingSpeed
            if (swingVelocity == Vector3.zero)
            {
                Vector3 swingDirection = Vector3.Cross(toGrapplePoint, Vector3.up).normalized;
                swingVelocity = swingDirection * initialSwingSpeed;
            }

            // Apply air resistance using airResistance variable
            playerRigidbody.velocity *= airResistance;

            // Add automatic swinging using autoSwingForce when moving slowly
            if (speed < 2f)
            {
                Vector3 autoSwingDirection = Vector3.Cross(toGrapplePoint, Vector3.up).normalized;
                playerRigidbody.AddForce(autoSwingDirection * autoSwingForce, ForceMode.Acceleration);
            }
        }
    }

    private void Update()
    {
        if (isGrappling && playerTransform != null)
        {
            float distanceToTarget = Vector3.Distance(playerTransform.position, grappleTarget);

            if (distanceToTarget > minDistanceThreshold)
            {
                // Use minPullForce variable for minimal pull force
                Vector3 pullDirection = (grappleTarget - playerTransform.position).normalized;
                playerRigidbody.AddForce(pullDirection * minPullForce, ForceMode.Acceleration);
            }
            else
            {
                Debug.Log("Grapple complete");
                StopGrappling();
            }

            UpdateRopeTaut();
        }
    }

    private void UpdateRopeCurve(Vector3 hookPosition)
    {
        lineRenderer.positionCount = 20;
        Vector3 startPoint = shootPoint.position;
        Vector3 endPoint = hookPosition;
        float totalLength = Vector3.Distance(startPoint, endPoint);

        for (int i = 0; i < lineRenderer.positionCount; i++)
        {
            float t = i / (float)(lineRenderer.positionCount - 1);
            Vector3 targetPoint = Vector3.Lerp(startPoint, endPoint, t);

            // Only apply curve effects during hook shot (not while grappling)
            if (!isGrappling)
            {
                // Calculate natural catenary curve
                float curveFactor = Mathf.Sin(t * Mathf.PI);
                Vector3 curveOffset = Vector3.up * curveFactor * ropeCurveHeight;

                // Add subtle noise for organic look
                float noise = Mathf.PerlinNoise(i * 0.1f, Time.time * 0.5f) * 0.1f;
                curveOffset += Vector3.right * noise;

                targetPoint += curveOffset;
            }

            // Smooth movement of each rope point
            if (i > 0 && i < lineRenderer.positionCount - 1)
            {
                linePositions[i] = Vector3.SmoothDamp(
                    linePositions[i],
                    targetPoint,
                    ref ropeVelocities[i],
                    ropeSmoothSpeed * Time.deltaTime);
            }
            else
            {
                // Keep endpoints locked
                linePositions[i] = targetPoint;
            }

            // Apply distance constraints to prevent over-stretching
            if (i > 0)
            {
                Vector3 prevToCurrent = linePositions[i] - linePositions[i - 1];
                float segmentLength = prevToCurrent.magnitude;
                float maxSegmentLength = totalLength * ropeMaxStretch / (lineRenderer.positionCount - 1);

                if (segmentLength > maxSegmentLength)
                {
                    linePositions[i] = linePositions[i - 1] + prevToCurrent.normalized * maxSegmentLength;
                }
            }

            lineRenderer.SetPosition(i, linePositions[i]);
        }
    }

    private void UpdateRopeTaut()
    {
        // Use the same smoothing for taut rope
        Vector3 startPoint = shootPoint.position;
        Vector3 endPoint = grappleTarget;

        // Smooth transition to taut rope
        for (int i = 0; i < lineRenderer.positionCount; i++)
        {
            float t = i / (float)(lineRenderer.positionCount - 1);
            Vector3 targetPoint = Vector3.Lerp(startPoint, endPoint, t);

            linePositions[i] = Vector3.SmoothDamp(
                linePositions[i],
                targetPoint,
                ref ropeVelocities[i],
                ropeSmoothSpeed * Time.deltaTime);

            lineRenderer.SetPosition(i, linePositions[i]);
        }
    }

    private void StopGrappling()
    {
        isGrappling = false;
        player.SetGravity(-9.81f, true); // Restore gravity
        visualHook.SetActive(true);

        if (currentHook != null)
        {
            Destroy(currentHook);
        }

        lineRenderer.enabled = false;
        Debug.Log("Stopped grappling");
    }

    private void StopHookVisual()
    {
        isHookShot = false;
        visualHook.SetActive(true);
        if (currentHook != null)
        {
            Destroy(currentHook);
        }
        lineRenderer.enabled = false;
    }

    private void OnDestroy()
    {
        mlgrabItem.OnPrimaryTriggerDown.RemoveListener(HandlePrimaryTriggerDown);
        mlgrabItem.OnPrimaryGrabEnd.RemoveListener(HandlePrimaryGrabEnd);
        mlgrabItem.OnPrimaryGrabBegin.RemoveListener(HandlePrimaryGrab);
    }
}
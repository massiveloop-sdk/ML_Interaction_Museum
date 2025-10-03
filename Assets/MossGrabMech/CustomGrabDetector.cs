using System.Collections.Generic;
using UnityEngine;

public class CustomGrabDetector : MonoBehaviour
{
    public bool isLeftHand; // Set true for left hand, false for right hand in the Inspector

    private Vector3 initialHandPosition; // The position where the climb started
    private Vector3 initialPlayerPosition; // The player's position at the start of the climb
    private Collider currentClimbable; // The climbable object being interacted with
    private bool isClimbing = false;

    // Static lists to support multiple hands
    private static List<CustomGrabDetector> activeGrabDetectors = new List<CustomGrabDetector>();

    // Adjustable thresholds
    [Header("Climbing Settings")]
    public float gripThreshold = 0.2f; // Grip strength threshold
    public float climbSpeedMultiplier = 1.5f; // Multiplier for climb speed

    [Header("Smoothing Settings")]
    public float smoothingSpeed = 10f; // Speed factor for smoothing movement
 
                                            
    [HideInInspector]
    public float swingForceMultiplier = 100f; // Multiplier for swing launch force
    [HideInInspector]
    public float minimumSwingVelocity = 100f; // Minimum hand velocity to trigger swing

    private Vector3 targetPlayerPosition; // The target position to move the player towards
    private Vector3 velocity = Vector3.zero; // Used for SmoothDamp

    // Variables for tracking hand velocity
    private Vector3 lastHandPosition;
    private Vector3 handVelocity;
    
    private void OnTriggerEnter(Collider other)
    {
        // Only set currentClimbable if the object has the "Climbable" tag
        if (other.CompareTag("Finish"))
        {
            currentClimbable = other;
           
        }
    }

    private void OnTriggerExit(Collider other)
    {
        // Clear the reference when exiting the trigger if it's the current climbable
        if (currentClimbable != null && other == currentClimbable)
        {
            
            currentClimbable = null;
            // Do not call EndClimbing() here
        }
    }

    private void Update()
    {
        // Safely get grip strength with null checks
        float gripStrength = isLeftHand
            ? (GrabMechanic_Local.Instance != null && GrabMechanic_Local.Instance.localPlayer != null && GrabMechanic_Local.Instance.localPlayer.UserInput != null ? GrabMechanic_Local.Instance.localPlayer.UserInput.Grip1 : 0f)
            : (GrabMechanic_Local.Instance != null && GrabMechanic_Local.Instance.localPlayer != null && GrabMechanic_Local.Instance.localPlayer.UserInput != null ? GrabMechanic_Local.Instance.localPlayer.UserInput.Grip2 : 0f);

        if (gripStrength > gripThreshold)
        {
            if (!isClimbing)
            {
                if (currentClimbable != null)
                {
                    StartClimbing();
                }
            }
            else
            {
                PerformClimbing();
            }
        }
        else if (isClimbing)
        {
            EndClimbing();
        }
    }

    private void StartClimbing()
    {
        isClimbing = true;
        activeGrabDetectors.Add(this);

        // Store the initial positions
        initialHandPosition = GetHandPosition();
        initialPlayerPosition = GrabMechanic_Local.Instance.localPlayer.PlayerRoot.transform.position;
        targetPlayerPosition = initialPlayerPosition;

        // Initialize hand velocity tracking
        lastHandPosition = initialHandPosition;
        handVelocity = Vector3.zero;

        // Disable locomotion and gravity when starting to climb
        if (activeGrabDetectors.Count == 1)
        {
            GrabMechanic_Local.Instance.localPlayer.Locomotion.ToggleLocomotion(false);
            GrabMechanic_Local.Instance.localPlayer.SetGravity(0, true);

            GrabMechanic_Local.Instance.playerCollider.isTrigger = true;
        }
    }
   
    private void PerformClimbing()
    {
        Vector3 currentHandPosition = GetHandPosition();

        // Update hand velocity
        handVelocity = (currentHandPosition - lastHandPosition) / Time.deltaTime;
        lastHandPosition = currentHandPosition;

        // Apply the climb speed multiplier to the hand delta
        Vector3 handDelta = (initialHandPosition - currentHandPosition) * climbSpeedMultiplier;

        // Calculate the target player position
        targetPlayerPosition = initialPlayerPosition + handDelta;

        // Smoothly move the player towards the target position
        Rigidbody playerRigidbody = GrabMechanic_Local.Instance.localPlayer.PlayerRoot.GetComponent<Rigidbody>();
        if (playerRigidbody != null)
        {
            Vector3 smoothedPosition = Vector3.SmoothDamp(
                playerRigidbody.position,
                targetPlayerPosition,
                ref velocity,
                1f / smoothingSpeed);

            playerRigidbody.MovePosition(smoothedPosition);
        }
        else
        {
            Transform playerTransform = GrabMechanic_Local.Instance.localPlayer.PlayerRoot.transform;
            Vector3 smoothedPosition = Vector3.Lerp(
                playerTransform.position,
                targetPlayerPosition,
                Time.deltaTime * smoothingSpeed);

            playerTransform.position = smoothedPosition;
        }
    }

    private void EndClimbing()
    {
        isClimbing = false;
        activeGrabDetectors.Remove(this);

        // Re-enable locomotion and gravity if no hands are climbing
        if (activeGrabDetectors.Count == 0)
        {
            GrabMechanic_Local.Instance.playerCollider.isTrigger = false;
            GrabMechanic_Local.Instance.localPlayer.Locomotion.ToggleLocomotion(true);
            GrabMechanic_Local.Instance.localPlayer.SetGravity(-9.81f, true);
        }

        // Apply swing force based on hand velocity
        Rigidbody playerRigidbody = GrabMechanic_Local.Instance.localPlayer.PlayerRoot.GetComponent<Rigidbody>();
        if (playerRigidbody != null)
        {
            if (handVelocity.magnitude > minimumSwingVelocity)
            {
                Vector3 launchDirection = handVelocity.normalized;
                float launchForce = handVelocity.magnitude * swingForceMultiplier;
                playerRigidbody.AddForce(launchDirection * launchForce, ForceMode.VelocityChange);
            }
        }
    }

    private Vector3 GetHandPosition()
    {
        // Return the appropriate hand's position with null checks
        return isLeftHand
            ? (GrabMechanic_Local.Instance != null && GrabMechanic_Local.Instance.leftHandAnchorHelper != null ? GrabMechanic_Local.Instance.leftHandAnchorHelper.position : Vector3.zero)
            : (GrabMechanic_Local.Instance != null && GrabMechanic_Local.Instance.rightHandAnchorHelper != null ? GrabMechanic_Local.Instance.rightHandAnchorHelper.position : Vector3.zero);
    }
}

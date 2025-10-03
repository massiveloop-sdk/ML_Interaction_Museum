using System.Collections;
using UnityEngine;
using ML.SDK;

public class DishText : MonoBehaviour
{
    public MLPlayer playerLocal;
    public GameObject text;

    [Header("Distance Settings")]
    public float maxDistance = 10f; // Distance beyond which text is at minimum scale
    public float minDistance = 2f;  // Distance within which text is at normal scale
    public float minScale = 0.5f;   // Minimum scale when player is far away

    [Header("Rotation Settings")]
    public float rotationSpeed = 5f; // Speed of the smooth rotation
    public bool useSlerp = true;    // Whether to use Slerp (true) or Lerp (false)

    private bool foundPlayer = false;
    private Vector3 originalScale;

    void Start()
    {
        originalScale = text.transform.localScale;
        StartCoroutine(CheckForLocalPlayer());
    }

    private IEnumerator CheckForLocalPlayer()
    {
        while (playerLocal == null || !playerLocal.IsInstantiated)
        {
            playerLocal = MassiveLoopRoom.GetLocalPlayer();
            yield return new WaitForSeconds(0.05f); // Wait before trying again
        }
        foundPlayer = true;
    }

    void Update()
    {
        // Skip execution until player is found and instantiated
        if (!foundPlayer || playerLocal == null || !playerLocal.IsInstantiated) return;

        // Calculate the direction to the player, ignoring the Y-axis difference to keep the text upright
        Vector3 directionToPlayer = playerLocal.PlayerRoot.transform.position - text.transform.position;
        directionToPlayer.y = 0; // Ignore vertical tilt

        // Create a target rotation that faces the player horizontally and keeps the text upright
        Quaternion targetRotation = Quaternion.LookRotation(-directionToPlayer, Vector3.up);

        // Smoothly interpolate between current rotation and target rotation
        if (useSlerp)
        {
            text.transform.rotation = Quaternion.Slerp(
                text.transform.rotation,
                targetRotation,
                rotationSpeed * Time.deltaTime
            );
        }
        else
        {
            text.transform.rotation = Quaternion.Lerp(
                text.transform.rotation,
                targetRotation,
                rotationSpeed * Time.deltaTime
            );
        }

        // Calculate distance to player (ignoring Y-axis)
        float distance = directionToPlayer.magnitude;

        // Calculate scale based on distance
        float scaleFactor;
        if (distance <= minDistance)
        {
            // At or within min distance - normal scale
            scaleFactor = 1f;
        }
        else if (distance >= maxDistance)
        {
            // At or beyond max distance - minimum scale
            scaleFactor = minScale;
        }
        else
        {
            // Between min and max distance - interpolate scale
            scaleFactor = Mathf.Lerp(1f, minScale, (distance - minDistance) / (maxDistance - minDistance));
        }

        // Apply the scale
        text.transform.localScale = originalScale * scaleFactor;
    }
}
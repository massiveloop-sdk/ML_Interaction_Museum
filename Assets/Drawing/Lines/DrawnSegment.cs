using UnityEngine;

public class DrawnSegment : MonoBehaviour
{
    // This will be the collider that checks for eraser collisions
    private void OnTriggerEnter(Collider other)
    {
        // Check if the object colliding is the ErasePen
        if (other.gameObject.name.Contains("ErasePen"))
        {
            // Destroy the current drawn segment
            Destroy(gameObject);
        }
    }
}

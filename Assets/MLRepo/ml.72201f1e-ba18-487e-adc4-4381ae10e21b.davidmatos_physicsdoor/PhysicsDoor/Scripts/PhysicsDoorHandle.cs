using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PhysicsDoorHandle : MonoBehaviour
{
    public float forceReleaseDistance;

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, forceReleaseDistance);
    }
}

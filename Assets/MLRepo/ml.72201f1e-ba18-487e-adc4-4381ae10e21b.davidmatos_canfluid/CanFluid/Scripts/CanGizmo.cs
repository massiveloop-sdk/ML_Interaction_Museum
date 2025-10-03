using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.SocialPlatforms;

public class CanGizmo : MonoBehaviour
{
    public float pourAngle;

    private void OnDrawGizmosSelected()
    {
        float number_canAngle = Vector3.Angle(-gameObject.transform.up, -Vector3.up);

        if (number_canAngle > pourAngle)
        {
            Gizmos.color = Color.green;
        }
        else
        {
            Gizmos.color = Color.red;
        }

        Gizmos.DrawLine(gameObject.transform.position, gameObject.transform.position + gameObject.transform.up);
    }
}

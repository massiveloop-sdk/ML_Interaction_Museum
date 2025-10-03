using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TrainTrackPoints : MonoBehaviour
{
    public bool showGizmo;
    public float playArea;
    public float maxLength;

    private GameObject[] trackPoints;

    [ContextMenu("Update Track Points")]
    public void UpdateTrackPoints()
    {
        trackPoints = new GameObject[transform.childCount];

        for (int i = 0; i < trackPoints.Length; i++)
        {
            trackPoints[i] = transform.GetChild(i).gameObject;
        }
    }

    private void OnTransformChildrenChanged()
    {
        UpdateTrackPoints();
    }

    private void OnDrawGizmos()
    {
        if (!showGizmo || trackPoints == null)
            return;

        for(int i = 1; i < trackPoints.Length; i++)
        {
            GameObject lastPoint = trackPoints[i - 1];
            GameObject currentPoint = trackPoints[i];

            float distanceBetweenPoints = Vector3.Distance(lastPoint.transform.position, currentPoint.transform.position);

            if (distanceBetweenPoints < maxLength + playArea && distanceBetweenPoints > maxLength - playArea)
                Gizmos.color = Color.green;
            else
                Gizmos.color = Color.red;

            Gizmos.DrawLine(lastPoint.transform.position, currentPoint.transform.position);
        }

        foreach(GameObject point in trackPoints)
        {
            Gizmos.DrawSphere(point.transform.position, 0.5f);
        }
    }
}

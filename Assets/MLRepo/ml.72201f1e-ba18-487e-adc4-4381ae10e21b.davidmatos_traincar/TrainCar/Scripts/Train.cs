using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Train : MonoBehaviour
{
    //public
    public GameObject trackSystem; //GameObject type
    public GameObject trainCarParent; //GameObject type

    public float trainCarSeperation; //float type
    public float moveSpeed; //float type
    public bool useSmoothing; //bool type
    public float smoothFactor; //float type

    //private
    private List<GameObject> trackPoints; //List<GameObject> type
    private List<GameObject> trainCarParts; //List<GameObject> type
    private float lerpFactor; //float type

    private void Awake()
    {
        trackPoints = new List<GameObject>();
        trainCarParts = new List<GameObject>();

        for (int i = 0; i < trackSystem.transform.childCount; i++)
        {
            trackPoints.Add(trackSystem.transform.GetChild(i).gameObject);
        }

        for (int i = 0; i < trainCarParent.transform.childCount; i++)
        {
            trainCarParts.Add(trainCarParent.transform.GetChild(i).gameObject);
        }
    }

    private void Update()
    {
        if (trackPoints == null)
            return;

        lerpFactor += Time.deltaTime * moveSpeed;

        if (lerpFactor > trackPoints.Count - 1)
            lerpFactor = 0;

        for (int i = 0; i < trainCarParts.Count; i++)
        {
            GameObject trainCar = trainCarParts[i];

            float seperationFactor = trainCarSeperation * i;
            int lerpIndex = (int)Mathf.Clamp(lerpFactor + seperationFactor, 0.0f, trackPoints.Count - 1);

            if (lerpIndex < trackPoints.Count - 1)
            {
                Vector3 currentTrackPoint = trackPoints[lerpIndex].transform.position;
                Vector3 nextTrackPoint = trackPoints[lerpIndex + 1].transform.position;
                Vector3 direction = currentTrackPoint - nextTrackPoint;

                float newLerpFactor = (lerpFactor + seperationFactor) - lerpIndex;

                trainCar.transform.position = Vector3.Lerp(currentTrackPoint, nextTrackPoint, newLerpFactor);

                if(useSmoothing)
                {
                    trainCar.transform.rotation = Quaternion.Slerp(trainCar.transform.rotation, Quaternion.LookRotation(direction, Vector3.up), Time.deltaTime * smoothFactor);
                }
                else
                {
                    trainCar.transform.rotation = Quaternion.LookRotation(direction, Vector3.up);
                }
            }
        }
    }
}

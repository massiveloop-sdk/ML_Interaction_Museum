using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NonPhysicsDoor : MonoBehaviour
{
    public GameObject doorObject;
    public GameObject doorHandleGrabbable;
    public GameObject originalDoorHandle;
    public bool doorAxisPositiveX;
    public bool doorAxisNegativeX;
    public bool doorAxisPositiveZ;
    public bool doorAxisNegativeZ;
    public Vector3 rotationOffset = Vector3.zero;
    public Vector3 rotationAxis = Vector3.up;

    public void Update()
    {
        Vector3 originPosition = doorObject.transform.position;
        Vector3 doorGrabbableHandlePosition = new Vector3(doorHandleGrabbable.transform.position.x, originPosition.y, doorHandleGrabbable.transform.position.z);

        if(doorAxisPositiveX)
        {
            doorGrabbableHandlePosition.x = Mathf.Clamp(doorGrabbableHandlePosition.x, doorObject.transform.position.x, Mathf.Infinity);
        }

        if(doorAxisNegativeX)
        {
            doorGrabbableHandlePosition.x = Mathf.Clamp(doorGrabbableHandlePosition.x, Mathf.NegativeInfinity, doorObject.transform.position.x);
        }

        if (doorAxisPositiveZ)
        {
            doorGrabbableHandlePosition.z = Mathf.Clamp(doorGrabbableHandlePosition.z, doorObject.transform.position.z, Mathf.Infinity);
        }

        if(doorAxisNegativeZ)
        {
            doorGrabbableHandlePosition.z = Mathf.Clamp(doorGrabbableHandlePosition.z, Mathf.NegativeInfinity, doorObject.transform.position.z);
        }

        Vector3 directionToHandle = originPosition - doorGrabbableHandlePosition;

        Quaternion newRotation = Quaternion.LookRotation(directionToHandle, rotationAxis);

        newRotation *= Quaternion.Euler(rotationOffset);

        doorObject.transform.rotation = newRotation;
    }
}

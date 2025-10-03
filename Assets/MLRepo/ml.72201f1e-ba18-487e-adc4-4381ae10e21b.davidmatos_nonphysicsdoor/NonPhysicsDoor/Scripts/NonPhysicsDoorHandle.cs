using ML.SDK;
using UnityEngine;

    public class NonPhysicsDoorHandle : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        [Header("Door Handle Settings")]
        [SerializeField] private GameObject originalDoorHandlePosition;
        [SerializeField] private float forceReleaseDistance = 0.5f;

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        private MLPlayer localPlayer;
        private MLGrab grabComponent;

        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        private void Start()
        {
            localPlayer = MassiveLoopRoom.GetLocalPlayer();
            grabComponent = GetComponent(typeof(MLGrab)) as MLGrab;

            if (originalDoorHandlePosition == null)
            {
                Debug.LogError("Original Door Handle Position reference is missing!", this);
            }
        }

        private void Update()
        {
            if (originalDoorHandlePosition == null || grabComponent == null) return;

            // Check distance from original position
            float distanceFromDoor = Vector3.Distance(
                transform.position,
                originalDoorHandlePosition.transform.position);

            // Force release if moved too far
            if (distanceFromDoor > forceReleaseDistance)
            {
                grabComponent.ForceRelease();
            }

            // Reset position when not grabbed
            if (grabComponent.CurrentUser == null)
            {
                transform.position = originalDoorHandlePosition.transform.position;
                transform.localRotation = Quaternion.identity;
            }
        }
    }
using ML.SDK;
using UnityEngine;
using static UnityEngine.Object; // For FindObjectOfType

namespace davidmatos_physicsdoor
{
    public class DoorHandle : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

        [SerializeField]
        private GameObject originalDoorHandlePosition; // SerializedField("Original Door Handle Position", GameObject)

        [SerializeField]
        private float forceReleaseDistance; // SerializedField("Force Release Distance", Number)

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

        private MLPlayer localPlayer; // mlplayer_localPlayer
        private MLGrab grab; // mlgrab_grab

        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

        // Start is called at the beginning
        private void Start()
        {
            // Assuming there's a Room class with GetLocalPlayer() method
            localPlayer = MassiveLoopRoom.GetLocalPlayer();

            grab = GetComponent(typeof(MLGrab)) as MLGrab;
        }

        // Update is called every frame
        private void Update()
        {
            float distanceFromDoor = Vector3.Distance(transform.position, originalDoorHandlePosition.transform.position);

            if (distanceFromDoor > forceReleaseDistance)
            {
                grab.ForceRelease();
            }

            if (grab.CurrentUser == null)
            {
                transform.position = originalDoorHandlePosition.transform.position;
                transform.localRotation = Quaternion.identity; // Equivalent to Quaternion(0, 0, 0, 0)
            }
        }
    }
}
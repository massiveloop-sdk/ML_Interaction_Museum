using ML.SDK;
using UnityEngine;

namespace DavidMatos.DoorTrigger
{
    public class TriggerVolume : MonoBehaviour
    {
        [Header("Door Reference")]
        [SerializeField] private DoorBase door;  // reference directly as DoorBase instead of GameObject

        private void OnTriggerEnter(Collider other)
        {
            if (door == null) return;

            MLPlayer player = other.gameObject.GetPlayer();
            if (player != null)
            {
                // local player is the only one who triggers this,
                // DoorBase will handle broadcasting if we're master
                door.OpenDoor();
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (door == null) return;

            MLPlayer player = other.gameObject.GetPlayer();
            if (player != null)
            {
                door.CloseDoor();
            }
        }
    }
}

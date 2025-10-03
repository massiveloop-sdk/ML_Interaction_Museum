using ML.SDK;
using UnityEngine;

    public class TeleportVolume : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

        [SerializeField]
        private GameObject teleportPosition; // The position that the local player will be teleported to

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

        private MLPlayer playerInTriggerVolume; // Reference to the MLPlayer currently inside the trigger volume

        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

        private void Start()
        {
            // Not used (kept for consistency with original)
        }

        private void Update()
        {
            // Not used (kept for consistency with original)
        }

        private void OnTriggerEnter(Collider other)
        {
            // NOTE: The local player is the only one that will trip these (since they have a rigidbody component)
            if (other.gameObject.IsPlayer())
            {
                // Get the current player that is in the volume
                playerInTriggerVolume = other.gameObject.GetPlayer();
            }
        }

        private void OnTriggerExit(Collider other)
        {
            // NOTE: The local player is the only one that will trip these
            if (other.gameObject.IsPlayer())
            {
                // Remove the reference to the current player that was in the volume
                playerInTriggerVolume = null;
            }
        }

        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

        /// <summary>
        /// The main public function that is called when button is clicked to teleport the local player
        /// </summary>
        public void TeleportPlayer()
        {
            // If there isn't a player currently in the volume, then don't continue
            if (playerInTriggerVolume == null || teleportPosition == null)
            {
                return;
            }

            // Use the MLPlayer API to teleport the local player to the given position
            playerInTriggerVolume.Teleport(teleportPosition.transform.position);
        }
    }
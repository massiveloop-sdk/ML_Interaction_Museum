using ML.SDK;
using UnityEngine;

    public class TriggerTeleportVolume : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

        [SerializeField]
        private GameObject teleportPosition; // Position to teleport the player to

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

        // NOTE: The local player is the only one that will trip these
        private void OnTriggerEnter(Collider other)
        {
            // Using non-generic GetComponent for MLPlayer script
            MLPlayer player = other.gameObject.GetPlayer();

            if (player != null && teleportPosition != null)
            {
                player.Teleport(teleportPosition.transform.position);
            }
        }
    }

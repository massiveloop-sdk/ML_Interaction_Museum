using ML.SDK;
using UnityEngine;

namespace DavidMatos.ButtonVolumeTeleport
{
    public class ButtonVolumeTeleportClick : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

        [SerializeField]
        private GameObject teleportVolume; // Reference to the trigger volume GameObject

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||

        private MLClickable mlClickable; // Local clickable component reference

        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||

        private void Start()
        {
            mlClickable = GetComponent<MLClickable>();

            // Add our handler function for calling teleport logic
            if (mlClickable != null)
            {
                mlClickable.OnClick.AddListener(TeleportOnClick);
            }
        }

        private void Update()
        {
            // Not used (kept for consistency with original)
        }

        //|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||| MAIN LOGIC ||||||||||||||||||||||||||||||||||||||||||||||

        /// <summary>
        /// Click callback when the local player clicks the button
        /// </summary>
        private void TeleportOnClick()
        {
            if (teleportVolume == null) return;

            // Get the TeleportVolume component
            TeleportVolume teleportScript = teleportVolume.GetComponent(typeof(TeleportVolume)) as TeleportVolume;

            if (teleportScript != null)
            {
                // Call the main method on script that's on our trigger volume to teleport the player
                teleportScript.TeleportPlayer();
            }
        }
    }
}
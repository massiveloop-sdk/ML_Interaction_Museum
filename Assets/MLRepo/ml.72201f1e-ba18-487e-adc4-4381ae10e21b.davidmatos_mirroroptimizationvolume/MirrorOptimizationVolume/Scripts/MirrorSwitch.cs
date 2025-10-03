using ML.SDK;
using UnityEngine;
    public class MirrorSwitch : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        [Header("Mirror References")]
        [SerializeField] private GameObject activeMirror; // High-quality mirror to activate when player is near
        [SerializeField] private GameObject fallbackMirror; // Low-quality mirror to use when player is far

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        private MLMirror mirrorComponent; // Reference to the MLMirror component on the active mirror

        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        private void Start()
        {
            if (activeMirror != null)
            {
                mirrorComponent = activeMirror.GetComponent(typeof(MLMirror)) as MLMirror;
                if (mirrorComponent != null)
                {
                    mirrorComponent.MirrorActive = false;
                }
                activeMirror.SetActive(false);
            }

            if (fallbackMirror != null)
            {
                fallbackMirror.SetActive(true);
            }
        }

        private void Update()
        {
            // Not used (kept for consistency with original)
        }

        // NOTE: The local player is the only one that will trigger these
        private void OnTriggerEnter(Collider other)
        {
            // Using non-generic GetComponent for MLPlayer script
            MLPlayer player = other.gameObject.GetPlayer();
            if (player != null)
            {
                if (activeMirror != null)
                {
                    activeMirror.SetActive(true);
                }

                if (fallbackMirror != null)
                {
                    fallbackMirror.SetActive(false);
                }

                if (mirrorComponent != null)
                {
                    mirrorComponent.MirrorActive = true;
                }
            }
        }

        // NOTE: The local player is the only one that will trigger these
        private void OnTriggerExit(Collider other)
        {
            // Using non-generic GetComponent for MLPlayer script
            MLPlayer player = other.gameObject.GetPlayer();
            if (player != null)
            {
                if (mirrorComponent != null)
                {
                    mirrorComponent.MirrorActive = false;
                }

                if (activeMirror != null)
                {
                    activeMirror.SetActive(false);
                }

                if (fallbackMirror != null)
                {
                    fallbackMirror.SetActive(true);
                }
            }
        }
    }
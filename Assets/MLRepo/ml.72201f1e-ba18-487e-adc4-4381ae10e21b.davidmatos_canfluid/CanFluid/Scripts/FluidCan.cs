using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Audio;
using ML.SDK;

    public class FluidCan : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        [Header("Visual Settings")]
        [SerializeField] private GameObject closedMesh; // Gameobject with the closed can mesh
        [SerializeField] private GameObject openedMesh; // Gameobject with the opened can mesh
        [SerializeField] private TextMesh fluidText; // Text display for fluid amount

        [Header("Fluid Settings")]
        [SerializeField] private bool limitedAmount = true;
        [SerializeField] private float fluidDrainRate = 0.1f; // How quickly the fluid drains from the can
        [SerializeField] private float fluidMaxAmount = 100f; // How much fluid is in the can
        [SerializeField] private float fluidDrainAngle = 45f; // Angle at which the can will start draining

        [Header("Audio Settings")]
        [SerializeField] private AudioSource openAudio; // Audio when the can is opened
        [SerializeField] private AudioSource pourAudio; // Audio when the can is pouring

        [Header("Particle Effects")]
        [SerializeField] private PlayableDirector particleTimeline; // Timeline for particle effects

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        private bool isOpened = false; // Current state of the can
        private float fluidAmount = 0f;
        private MLGrab grabComponent;
        private MLPlayer localPlayer;

        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        private void Start()
        {
            localPlayer = MassiveLoopRoom.GetLocalPlayer();
            grabComponent = GetComponent<MLGrab>();

            if (grabComponent != null)
            {
                grabComponent.OnPrimaryTriggerDown.AddListener(OnClick);
                grabComponent.OnPrimaryGrabBegin.AddListener(OnGrabBegin);
                grabComponent.OnPrimaryGrabEnd.AddListener(OnGrabEnd);
            }

            fluidAmount = fluidMaxAmount;

            closedMesh.SetActive(true);
            openedMesh.SetActive(false);

            if (fluidText != null)
            {
                fluidText.gameObject.SetActive(false);
            }
        }

        private void Update()
        {
            // Update fluid text display
            if (fluidText != null)
            {
                fluidText.text = fluidAmount.ToString("F1");
            }

            // Handle empty can state
            if (fluidAmount <= 0f)
            {
                pourAudio.enabled = false;
                if (particleTimeline != null)
                {
                    particleTimeline.Stop();
                    particleTimeline.RebuildGraph();
                }
                return;
            }

            // Handle pouring logic when can is opened
            if (isOpened)
            {
                float canAngle = Vector3.Angle(-transform.up, Vector3.down);

                if (canAngle > fluidDrainAngle)
                {
                    pourAudio.enabled = true;
                    PlayLoopingAudio(pourAudio);

                    if (particleTimeline != null && particleTimeline.state != PlayState.Playing)
                    {
                        particleTimeline.RebuildGraph();
                        particleTimeline.Play();
                    }

                    if (limitedAmount)
                    {
                        fluidAmount -= fluidDrainRate * Time.deltaTime;
                        fluidAmount = Mathf.Max(fluidAmount, 0f);
                    }
                }
                else
                {
                    if (particleTimeline != null)
                    {
                        particleTimeline.Stop();
                        particleTimeline.RebuildGraph();
                    }
                    pourAudio.enabled = false;
                }
            }
        }

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        private void OpenFluidCan()
        {
            openAudio.Play();
            isOpened = true;
            closedMesh.SetActive(false);
            openedMesh.SetActive(true);
        }

        private void PlayLoopingAudio(AudioSource audioSource)
        {
            if (audioSource.isActiveAndEnabled)
            {
                if (!audioSource.loop)
                {
                    audioSource.loop = true;
                }

                if (!audioSource.isPlaying)
                {
                    audioSource.Play();
                }
            }
        }

        //|||||||||||||||||||||||||||||||||||||||||||||| GRAB CALLBACKS ||||||||||||||||||||||||||||||||||||||||||||||
        private void OnGrabBegin()
        {
            if (fluidText != null)
            {
                fluidText.gameObject.SetActive(true);
            }
        }

        private void OnGrabEnd()
        {
            if (fluidText != null)
            {
                fluidText.gameObject.SetActive(false);
            }
        }

        private void OnClick()
        {
            OpenFluidCan();
        }

        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        public void ForceRelease()
        {
            // Note: In C# you would typically use a networking solution like:
            // - RPC calls in Photon/UNET
            // - Custom network messaging
            // For now, we'll just call locally
            LocalForceRelease();
        }

        private void LocalForceRelease()
        {
            if (grabComponent != null)
            {
                grabComponent.ForceRelease();
            }
        }
    }

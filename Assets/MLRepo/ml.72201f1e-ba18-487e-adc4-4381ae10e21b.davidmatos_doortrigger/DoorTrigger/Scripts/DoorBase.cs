using ML.SDK;
using UnityEngine;

    public class DoorBase : MonoBehaviour
    {
        [Header("Door References")]
        [SerializeField] private GameObject doorObject;
        [SerializeField] private GameObject doorOpenedPosition;
        [SerializeField] private GameObject doorClosedPosition;
        [SerializeField] private float doorSpeed = 1f;

        [Header("Audio Settings")]
        [SerializeField] private AudioClip openSound;
        [SerializeField] private AudioClip closeSound;

        private bool localDoorState = false; // false = closed, true = open
        private AudioSource audioSource;

        // Networking
        private const string EVENT_ID_TOGGLE = "DoorToggle";
        private const string EVENT_ID_LATE_JOINER = "DoorLateJoiner";
        private EventToken tokenToggle;
        private EventToken tokenLateJoiner;

        private void Start()
        {
            audioSource = GetComponent<AudioSource>();
            if (audioSource == null) audioSource = gameObject.AddComponent<AudioSource>();

            // init door position
            if (doorObject != null && doorClosedPosition != null)
                doorObject.transform.position = doorClosedPosition.transform.position;

            // register network events
            tokenToggle = this.AddEventHandler(EVENT_ID_TOGGLE, OnNetworkDoorToggle);
            tokenLateJoiner = this.AddEventHandler(EVENT_ID_LATE_JOINER, OnNetworkLateJoiner);

            MassiveLoopRoom.OnPlayerJoined += PlayerJoined;
        }

        private void OnDestroy()
        {
            MassiveLoopRoom.OnPlayerJoined -= PlayerJoined;
        }

        private void Update()
        {
            UpdateDoorState();
        }

        private void UpdateDoorState()
        {
            if (doorObject == null || doorOpenedPosition == null || doorClosedPosition == null) return;

            Vector3 target = localDoorState ? doorOpenedPosition.transform.position : doorClosedPosition.transform.position;
            doorObject.transform.position = Vector3.Lerp(doorObject.transform.position, target, Time.deltaTime * doorSpeed);
        }

        // Public methods your trigger can call
        public void OpenDoor()
        {
            if (!MassiveLoopClient.IsMasterClient) return;
            SetDoorState(true);
            BroadcastState(true);
        }

        public void CloseDoor()
        {
            if (!MassiveLoopClient.IsMasterClient) return;
            SetDoorState(false);
            BroadcastState(false);
        }

        // Networking
        private void BroadcastState(bool newState)
        {
            int stateInt = newState ? 1 : 0;
            this.InvokeNetwork(EVENT_ID_TOGGLE, EventTarget.Others, null, stateInt, this.gameObject.name);
        }

        private void OnNetworkDoorToggle(object[] args)
        {
            if (args == null || args.Length < 2) return;
            string objName = (string)args[1];
            if (this.gameObject.name != objName) return;

            int stateInt = (int)args[0];
            SetDoorState(stateInt == 1);
        }

        private void PlayerJoined(MLPlayer player)
        {
            if (!MassiveLoopClient.IsMasterClient) return;

            int stateInt = localDoorState ? 1 : 0;
            this.InvokeNetwork(EVENT_ID_LATE_JOINER, EventTarget.All, null, stateInt, this.gameObject.name);
        }

        private void OnNetworkLateJoiner(object[] args)
        {
            if (args == null || args.Length < 2) return;
            string objName = (string)args[1];
            if (this.gameObject.name != objName) return;

            int stateInt = (int)args[0];
            SetDoorState(stateInt == 1);
        }

        private void SetDoorState(bool newState)
        {
            if (localDoorState == newState) return;

            localDoorState = newState;

            if (audioSource != null)
            {
                AudioClip clip = newState ? openSound : closeSound;
                if (clip != null) audioSource.PlayOneShot(clip);
            }
        }
    }

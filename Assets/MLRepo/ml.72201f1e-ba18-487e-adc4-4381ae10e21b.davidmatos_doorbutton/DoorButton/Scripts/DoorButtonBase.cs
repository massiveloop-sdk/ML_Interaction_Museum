using ML.SDK;
using UnityEngine;

    public class DoorButtonBase : MonoBehaviour
    {
        [Header("Door References")]
        [SerializeField] private GameObject doorObject;
        [SerializeField] private GameObject doorOpenedPosition;
        [SerializeField] private GameObject doorClosedPosition;
        [SerializeField] private float doorSpeed = 1f;

        [Header("Audio Settings")]
        [SerializeField] private AudioClip openSound;
        [SerializeField] private AudioClip closeSound;

        // runtime state
        private bool localDoorState = false; // false == closed
        private AudioSource audioSource;

        // network event ids / tokens
        private const string EVENT_ID_TOGGLE = "DoorToggle";
        private const string EVENT_ID_LATE_JOINER = "Door_LateJoiner";
        private EventToken tokenToggle;
        private EventToken tokenLateJoiner;

        void Start()
        {
            audioSource = GetComponent<AudioSource>();
            if (audioSource == null) audioSource = gameObject.AddComponent<AudioSource>();

            // place door in closed position initially
            if (doorObject != null && doorClosedPosition != null)
                doorObject.transform.position = doorClosedPosition.transform.position;

            // register network handlers
            tokenToggle = this.AddEventHandler(EVENT_ID_TOGGLE, OnNetworkDoorToggle);
            tokenLateJoiner = this.AddEventHandler(EVENT_ID_LATE_JOINER, OnNetworkLateJoiner);

            // listen for players joining so master can sync late joiners
            MassiveLoopRoom.OnPlayerJoined += PlayerJoined;
        }

        void OnDestroy()
        {
            // tidy up
            MassiveLoopRoom.OnPlayerJoined -= PlayerJoined;
            // (If your SDK exposes a RemoveEventHandler by token, call it here.
            // sample code left handlers registered in many examples; if you have RemoveEventHandler, use it.)
        }

        void Update()
        {
            UpdateDoorState();
        }

        private void UpdateDoorState()
        {
            if (doorObject == null || doorOpenedPosition == null || doorClosedPosition == null) return;

            Vector3 target = localDoorState ? doorOpenedPosition.transform.position : doorClosedPosition.transform.position;
            doorObject.transform.position = Vector3.Lerp(doorObject.transform.position, target, Time.deltaTime * doorSpeed);
        }

        // Public API: called by local button / clickable. MLClickable passes MLPlayer, many examples accept MLPlayer.
        // Provide both overloads so either wiring style works.
        public void ToggleDoor()
        {
            DoToggle();
        }

        public void ToggleDoor(MLPlayer player)
        {
            DoToggle();
        }

        // internal toggle that enforces master-client authority
        private void DoToggle()
        {
            // Only master client should authoritatively toggle
      //      if (!MassiveLoopClient.IsMasterClient) return;

            bool newState = !localDoorState;
            // apply locally on master immediately (no need to wait for network callback)
            SetDoorState(newState);

            // broadcast to other clients (send int 0/1 + object name so multiple doors won't conflict)
            int stateInt = newState ? 1 : 0;
            this.InvokeNetwork(EVENT_ID_TOGGLE, EventTarget.Others, null, stateInt, this.gameObject.name);
        }

        // Received on other clients (master used EventTarget.Others so master won't re-apply)
        private void OnNetworkDoorToggle(object[] args)
        {
            // args: [int stateInt, string objectName]
            if (args == null || args.Length < 2) return;

            string objName = (string)args[1];
            if (this.gameObject.name != objName) return;

            int stateInt = (int)args[0];
            bool newState = stateInt == 1;
            SetDoorState(newState);
        }

        // Master sends this to sync late joiners
        private void PlayerJoined(MLPlayer player)
        {
            if (!MassiveLoopClient.IsMasterClient) return;

            // send current state to all (or you could target only the new player if API supports)
            int stateInt = localDoorState ? 1 : 0;
            this.InvokeNetwork(EVENT_ID_LATE_JOINER, EventTarget.All, null, stateInt, this.gameObject.name);
        }

        // Handler for late-join sync
        private void OnNetworkLateJoiner(object[] args)
        {
            // args: [int stateInt, string objectName]
            if (args == null || args.Length < 2) return;

            string objName = (string)args[1];
            if (this.gameObject.name != objName) return;

            int stateInt = (int)args[0];
            bool newState = stateInt == 1;
            SetDoorState(newState);
        }

        private void SetDoorState(bool newState)
        {
            if (localDoorState == newState) return;

            localDoorState = newState;

            // play sound (master and non-master will play when they apply)
            if (audioSource != null)
            {
                AudioClip clip = newState ? openSound : closeSound;
                if (clip != null) audioSource.PlayOneShot(clip);
            }
        }
    }

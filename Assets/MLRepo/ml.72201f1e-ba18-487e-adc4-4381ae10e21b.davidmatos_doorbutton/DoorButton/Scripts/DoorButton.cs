using ML.SDK;
using UnityEngine;

namespace DavidMatos.DoorButton
{
    public class DoorButtonClick : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        [Header("Door Reference")]
        [SerializeField] private GameObject doorObject;

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        private MLClickable clickable;
        private DoorButtonBase doorObjectScript;

        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        private void Start()
        {
            if (doorObject != null)
            {
                doorObjectScript = doorObject.GetComponent(typeof(DoorButtonBase)) as DoorButtonBase;
            }

            clickable = GetComponent(typeof(MLClickable)) as MLClickable;
            if (clickable != null)
            {
                clickable.OnPlayerClick.AddListener(OnClick);
            }
        }

        private void Update()
        {
            // Not used (kept for consistency with original)
        }

        //|||||||||||||||||||||||||||||||||||||||||||||| BUTTON HANDLER ||||||||||||||||||||||||||||||||||||||||||||||
        private void OnClick(MLPlayer player)
        {
            if (doorObjectScript != null)
            {
                //Direct method call (for local objects):
                doorObjectScript.ToggleDoor();

            }
        }
    }
}
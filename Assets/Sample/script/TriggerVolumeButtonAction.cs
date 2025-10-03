using ML.SDK;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

namespace Sample
{
    public class TriggerVolumeButtonAction : MonoBehaviour, ISystemTrayItemEventListener
    {
        #region Attributes

        [SerializeField] protected TrayItemSO m_TrayItemSO = null;

        [SerializeField] protected SystemTrayItemEventSO m_TrayItemEventSO = null;

        [FormerlySerializedAs("m_State")]
        [SerializeField] protected Text m_StateLabel = null;

        protected SystemUIHandler m_SystemUIHandler = null;
        private bool m_IsRegistered = false;
        private const ItemControllerState k_DEFAULT_START_State = ItemControllerState.Closed;
        private ItemControllerState m_CurrentState = k_DEFAULT_START_State;

        #endregion

        public void Initialize()
        {
            m_SystemUIHandler = SystemUIHandler.instance;
            UpdateStateAndLabel(k_DEFAULT_START_State);
        }

        public void UpdateStateAndLabel(ItemControllerState updatedState)
        {
            string state = Enum.GetName(typeof(ItemControllerState), updatedState);
            m_CurrentState = updatedState;
            m_StateLabel.text = state;
        }

        #region Mono

        public void Start()
        {
            Initialize();
        }

        public void OnDisable()
        {
            m_IsRegistered = false;
        }

        public void OnTriggerEnter(Collider other)
        {
            GameObject go = other.attachedRigidbody.gameObject;
            MLPlayer mlPlayer = go.gameObject.GetPlayer();
            if (go != null && go.tag.Equals("Player") && mlPlayer.IsLocal && !m_IsRegistered)
            {
                m_IsRegistered = true;
                // Register the item.
                m_SystemUIHandler.UpdateSystemUIItems(null, new List<TrayItemSO>() { m_TrayItemSO });

                // check if the item is registered.
                bool isItemRegistered = m_SystemUIHandler.IsSystemUIItemRegistered(m_TrayItemSO.ItemID);

                if (isItemRegistered)
                {
                    //Enum.TryParse<ItemControllerState>(m_StateLabel.text, );

                    m_TrayItemEventSO.RegisterListener(this); // register this item event listener
                    m_TrayItemEventSO.RequestItemStateUpdate(m_TrayItemSO.ItemID, m_CurrentState); // sync the systemUI item state to what we have. 
                }
            }
        }

        public void OnTriggerExit(Collider other)
        {
            GameObject go = other.attachedRigidbody.gameObject;
            MLPlayer mlPlayer = go.gameObject.GetPlayer();

            if (go != null && go.tag.Equals("Player") && mlPlayer.IsLocal && m_IsRegistered)
            {
                m_IsRegistered = false;

                // Unregister the item, will remove the item from the MassiveLoop SystemUI, you may want to keep track of the state yourself in this case.
                m_SystemUIHandler.UpdateSystemUIItems(new List<TrayItemSO>() { m_TrayItemSO }, null);
                m_TrayItemEventSO.UnRegisterListener(this); // Unregister this item event listener
            }
        }

        #endregion

        #region ISystemTrayItemEventListener Interface Implementation

        // Interface implementation to receive item state update.
        public void OnItemStateUpdated(string itemID, ItemControllerState newState)
        {
            UpdateStateAndLabel(newState);
        }

        #endregion
    }
}


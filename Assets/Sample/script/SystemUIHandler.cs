using ML.SDK;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Sample
{
    public class SystemUIHandler : MonoBehaviour
    {
        public static SystemUIHandler instance;

        // List of trayitemSOs which we want to register.
        [SerializeField] private TrayItemSO m_TrayItemSO;
         
        /// <summary>
        /// Reference to the SystemUI 
        /// </summary>
        private SystemUI m_SystemUI;

        #region Mono

        private void Awake()
        {
            instance = this;
            m_SystemUI = new SystemUI();
            Debug.Log($"SDK [SystemUIHandler] instance set");
        }

        private void OnEnable()
        {
            MassiveLoopRoom.OnPlayerInstantiated += OnPlayerInstantiatedCallback;
        }

        private void OnDisable()
        {
            MassiveLoopRoom.OnPlayerInstantiated -= OnPlayerInstantiatedCallback;
        }

        // Start is called before the first frame update
        void Start()
        {
            
        }

        #endregion

        #region MassiveLoop Callbacks

        private void OnPlayerInstantiatedCallback(MLPlayer player)
        {
            if (player.IsLocal)
            {
                m_SystemUI.UpdateSystemUIItems(null, new List<TrayItemSO> { m_TrayItemSO });

                // check if the item is registered.
                bool isItemRegistered = IsSystemUIItemRegistered(m_TrayItemSO.ItemID);

                if (isItemRegistered)
                {
                    //Debug.LogFormat("SDK [SystemUI handler ] itemID {0}, registered > {1}", m_TrayItemSO.ItemID, isItemRegistered);
                    // Activate window, if it is a window item.
                    bool activateWindowEventRaisedSuccessfully = TryActivateWindow(m_TrayItemSO.ItemID);
                    Debug.Log($"SDK [SystemUI handler ] itemID {m_TrayItemSO}, registered > {isItemRegistered}, isActivated {activateWindowEventRaisedSuccessfully}");
                }
            }
        }

        #endregion


        // Item

        #region Adding / Removing Items to/from SystemUI

        /// <summary>
        /// First removes the items, then add the items.
        /// Registers the items in the itemsToAdd, and Unregister the items in the itemsToRemove.
        /// passing null will have no effect.
        /// Priority is always to item addition: if the same item is passed to both itemsToRemove and itemsToAdd to both then the item will be added.
        /// </summary>
        /// <param name="itemsToRemove"> Items To Remove </param>
        /// <param name="itemsToAdd"> Items To Add </param>
        public void UpdateSystemUIItems(List<TrayItemSO> itemsToRemove, List<TrayItemSO> itemsToAdd)
        {
            m_SystemUI.UpdateSystemUIItems(itemsToRemove, itemsToAdd);
        }

        /// <summary>
        /// Removes the systemUI item, identified by the itemID
        /// </summary>
        /// <param name="itemID">item ID</param>
        public void RemoveSystemUIItem(string itemID)
        {
            m_SystemUI.RemoveSystemUIItem(itemID);
        }

        /// <summary>
        /// Removes SystemUI items, identified by the itemIDs provided in the list.
        /// </summary>
        /// <param name="itemIDs">List of itemIDs</param>
        public void RemoveSystemUIItems(List<string> itemIDs)
        {
            m_SystemUI.RemoveSystemUIItems(itemIDs);
        }

        #endregion

        /// <summary>
        /// checks whether a specific system UI item, identified by itemID, is registered or not.
        /// </summary>
        /// <param name="itemID">item ID</param>
        /// <returns>true if item is registered, false otherwise.</returns>
        public bool IsSystemUIItemRegistered(string itemID)
        {
            return m_SystemUI.IsSystemUIItemRegistered(itemID);
        }

        /// <summary>
        /// used to check whether a specific item identified by an itemID is currently active or not.
        /// </summary>
        /// <param name="itemID">itemID</param>
        /// <returns>bool Returns true if the itemID is registered and is active, false otherwise.</returns>
        public bool IsItemActive(string itemID)
        {
            return m_SystemUI.IsItemActive(itemID);
        }

        /// <summary>
        /// Get the item state of the specified itemID, if the itemID is registered.
        /// </summary>
        /// <param name="itemID">itemID</param>
        /// <param name="state">The output argument that will contain the state or closed default state.</param>
        /// <returns>bool Returns true if the itemID is registered, false otherwise.</returns>
        public bool TryGetItemState(string itemID, out ItemControllerState state)
        {
            return m_SystemUI.TryGetItemState(itemID, out state); ;
        }

        // System Tray

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool TryGetSystemTrayState(out SystemTrayState trayState)
        {
            return m_SystemUI.TryGetSystemTrayState(out trayState);
        }

        public SystemTrayState GetSystemTrayState()
        {
            return m_SystemUI.GetSystemTrayState();
        }

        // Window

        #region Activating / Deactivating Window

        /// <summary>
        /// Activate the window specified by the itemID, if the itemID is registered and is a window item.
        /// </summary>
        /// <param name="itemID">itemID</param>
        /// <returns>bool Returns true if the itemID is registered and the window is already open or event to open the window is successfully raised.</returns>
        public bool TryActivateWindow(string itemID)
        {
            return m_SystemUI.TryActivateWindow(itemID);
        }

        /// <summary>
        /// Deactivate the window specified by the itemID, if the itemID is registered and is a window item.
        /// </summary>
        /// <param name="itemID">item ID</param>
        /// <returns>bool Returns true if the itemID is registered and the window is already closed or event to close the window is successfully raised.</returns>
        public bool TryDeactivateWindow(string itemID)
        {
            return m_SystemUI.TryDeactivateWindow(itemID);
        }

        #endregion

        /// <summary>
        /// Gets the SystemUI Window component of the specified itemID, if it is registered and it a window item.
        /// </summary>
        /// <param name="itemID">ItemID</param>
        /// <param name="systemUIWindow">The output argument that will contain the SystemUI Window Object or null.</param>
        /// <returns>bool Returns true if the provided itemID is registered and is valid window item, otherwise false.</returns>
        public bool TryGetWindow(string itemID, out SystemUIWindow systemUIWindow)
        {
            return m_SystemUI.TryGetWindow(itemID, out systemUIWindow);
        }
    }
}
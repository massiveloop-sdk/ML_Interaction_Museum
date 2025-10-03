using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using ML.SDK;

namespace Sample
{
    [Serializable]
    public abstract class TriggerVolumeBase : MonoBehaviour
    {
        #region Attributes

        [SerializeField] protected TrayItemSO m_TrayItemSO = null;

        [SerializeField] protected SystemTrayItemEventSO m_TrayItemEventSO = null;

        [SerializeField] protected Text m_Label = null;
        [SerializeField] protected Text m_State = null;

        protected SystemUIHandler m_SystemUIHandler = null;

        #endregion

        #region Mono

        public virtual void Start()
        {
            Debug.Log("[SDK] [TriggerVolumeBase]");

            Initialize();
        }

        public abstract void OnTriggerEnter(Collider other);

        public abstract void OnTriggerExit(Collider other);

        #endregion

        public virtual void Initialize()
        {
            m_SystemUIHandler = SystemUIHandler.instance;
            UpdateLabelAndState(m_TrayItemSO.ItemID, ItemControllerState.Closed.ToString());
        }
        public virtual void UpdateLabelAndState(string label, string state)
        {
            Debug.Log($"SDK [Trigget Volume ] itemID {label} {state}" );
            m_Label.text = label;
            m_State.text = state;
        }
    }
}

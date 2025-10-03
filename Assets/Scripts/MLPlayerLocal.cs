using ML.SDK;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
//using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.Rendering.PostProcessing;


public class PlayerLocal : MonoBehaviour
{
    private static PlayerLocal _instance;

    [HideInInspector]
    public MLPlayer localPlayer;
 
    [HideInInspector]
    public GameObject Head;
    [HideInInspector]
    public GameObject leftHandIK;
    [HideInInspector]
    public GameObject rightHandIK;
    [HideInInspector]
    public GameObject leftHandGrip;
    [HideInInspector]
    public GameObject rightHandGrip;
    [HideInInspector]
    public GameObject leftHandAnchor;
    [HideInInspector]
    public GameObject rightHandAnchor;
    [HideInInspector]
    public bool done = false;

    public Transform rightHandAnchorHelper;
    public Transform leftHandAnchorHelper;
  //  public Transform HUDHelper;
    public GameObject FootStepCollider;

    public static PlayerLocal Instance
    {

        get
        {
            if (_instance == null)
            {
               

            }
            return _instance;
        }
    }

    // Ensure the singleton instance remains constant across scene loads
    private void Awake()
    {
        if (_instance == null)
        {
            _instance = this;

        }
        else if (_instance != this)
        {
            Destroy(gameObject); // Destroy duplicate instances


        }

    }


    [HideInInspector]
    public int LastSyncedDamage = 0;
    [HideInInspector]
    public bool DamageReady = false;
    // Modify the OnProjectileHitPlayer method


    public bool isInvulnerable = false;
    private float invulnerabilityDuration = 0.5f; // Adjust as needed
    private Coroutine invulnerabilityCoroutine;


    void Start()
    {

        MassiveLoopRoom.OnPlayerInstantiated += Init;

        MLPlayer localplayer = MassiveLoopRoom.GetLocalPlayer();


    }


    void Init(MLPlayer player)
    {
        if (player.IsLocal)
        {
            if (localPlayer != null)  // Check if already set to prevent double initialization
            {
                return;
            }

            localPlayer = player;

            GetData();
            // ListAllChildObjects(localPlayer.PlayerRoot.transform);
        }
        //This could be used for team indicators

        if (player != null)
        {
            // Instantiate the health bar
            //This could be used for team indicators
            GameObject healthBarInstance = Instantiate(FootStepCollider);

            //Might explore this approach later on
        //    GameObject StorageInterface_Instance = Instantiate(Global_CloudStorageSystem);


            // Parent it to the player's PlayerRoot
            healthBarInstance.transform.SetParent(player.PlayerRoot.transform);
            healthBarInstance.transform.localPosition = new Vector3(-0.465f, 2.15f, 0); // Adjust the Y value as needed

            // Reset rotation and scale
            healthBarInstance.transform.localRotation = Quaternion.identity;
            healthBarInstance.transform.localScale = Vector3.one; // Adjust this if the health bar is too large/small

            // If the health bar is still too large, adjust the scale further
            healthBarInstance.transform.localScale = new Vector3(0.0025f, 0.0025f, 0.0025f); // Example scale adjustment

        }

    }


    void GetData()
    {
       
        Head = GameObject.Find("Main Camera");
        leftHandIK = GameObject.Find("Left Hand_IK Target");
        rightHandIK = GameObject.Find("RightHand_IK Target");
        leftHandAnchor = GameObject.Find("LeftHandAnchor");
        rightHandAnchor = GameObject.Find("RightHandAnchor");
        leftHandAnchorHelper.parent = leftHandAnchor.transform;
        leftHandAnchorHelper.position= leftHandAnchor.transform.position;
        rightHandAnchorHelper.parent = rightHandAnchor.transform;
        rightHandAnchorHelper.position = rightHandAnchor.transform.position;

     //   HUDHelper.parent = Head.transform;
     //   HUDHelper.position = Head.transform.position;

        //Coroutine does not help here
        // StartCoroutine(WaitCoro());


        done = true;
    }




}
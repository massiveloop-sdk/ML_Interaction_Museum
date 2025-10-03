using ML.SDK;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class GrabMechanic_Local : MonoBehaviour
{
    private static GrabMechanic_Local _instance;

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
    [HideInInspector]
    public Collider playerCollider;
    public static GrabMechanic_Local Instance
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

    // Start is called before the first frame update
    void Start()
    {


        MassiveLoopRoom.OnPlayerInstantiated += Init;

    }

    // Update is called once per frame
    void Update()
    {
    }

    public void ListAllChildObjects(Transform parent)
    {
        if (parent == null) return;

        // Print the name of the current GameObject
        Debug.Log(parent.name);

        // Recursively call this function for each child
        foreach (Transform child in parent)
        {
            ListAllChildObjects(child);
        }
    }

    public bool MakeAChildOfTarget(Transform parent, string objName, GameObject obj = null)
    {
        foreach (Transform child in parent)
        {
            if (child.name == objName)
            {
                if (obj != null)
                {
                    obj.transform.parent = child;
                    obj.transform.position = child.position;
                    obj.transform.rotation = child.rotation;
                }

                return true; // Exit early and indicate the target was found
            }

            // Recursive call to search the child's children
            if (MakeAChildOfTarget(child, objName, obj))
            {
                return true; // Exit early if the target was found in the recursive call
            }
        }

        return false; // Return false if the target was not found in this branch
    }
    public GameObject GetTarget(Transform parent, string nameToFind)
    {
        // Check if the current transform's name matches
        if (parent.name.Equals(nameToFind, System.StringComparison.OrdinalIgnoreCase))
        {

            return parent.gameObject;
        }

        // Recursively search each child
        foreach (Transform child in parent)
        {
            GameObject found = GetTarget(child, nameToFind);
            if (found != null)
            {

                return found;
            }
        }

        // If nothing was found, return null
        return null;
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
        localPlayer.Locomotion.ToggleClimb(false);
        CheckColliders(localPlayer.PlayerRoot);
        done = true;
    }

    public void CheckColliders(GameObject rootObject)
    {
        // Get all components of type Collider in the root object and its children
        Collider[] colliders = rootObject.GetComponentsInChildren<Collider>(true);

        // Iterate through all colliders and log their details
        foreach (Collider col in colliders)
        {
           if (col.isTrigger == false)
            {
                playerCollider = col;
            }
        }
    }


}
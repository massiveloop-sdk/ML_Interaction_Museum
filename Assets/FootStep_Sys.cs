using ML.SDK;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class FootStep_Sys : MonoBehaviour
{

    /*Foot Step system
     * This handles local footstep sound effects for the local user.
     * There is an event function setup and is ready to be used and does work, however
     * it can be a source of lag for users.
     * You could use it with the following line and pass in the string of the material name the user is currently standing on as one of the parameters. :
     * this.InvokeNetwork(EVENT_ID_FOOTSTEPS, EventTarget.All,)
     * 
     * Although, it would be wise to not do so at this moment.
     */

    //Getting the material the player is standing on to play the correct sound effects.
    public AudioClip[] footStepSFXConcrete;
    public AudioClip[] footStepSFXDirt;
    public AudioClip[] footStepSFXMud;
    public AudioClip[] footStepSFXGrass;
    public AudioClip[] footStepSFXMetal;
    public AudioClip[] footStepSFXWater;
    public AudioClip[] footStepSFXWood;
    public AudioClip[] footStepSFXSand;
    public AudioClip[] footStepSFXStone;
    public AudioClip[] footStepSFXSnow;
    public string currentStandingMaterial;
    public AudioSource footAutoSource;

    private float footstepTimer = 0f;  // Timer to control the interval between steps
    private float footstepInterval = 0.45f;  // Interval between steps (in seconds)
    public MLPlayer Owner;
    private const float DM_KEY_TRESHOLD = 0.1f;

    public const string EVENT_ID_FOOTSTEPS = "OnNetworkFootStep";
    public EventToken token_footstep;

    private Dictionary<string, AudioClip[]> footstepSounds;

    private Dictionary<string, string> materialMappings = new Dictionary<string, string>
    {
        { "metal", "metal" },
        { "dirt", "dirt" },
        { "concrete", "concrete" },
        { "grass", "grass" },
        { "wood", "wood" },
        { "water", "water" },
        { "mud", "mud" },
        { "sand", "sand" },
        { "stone", "stone" },
        { "snow", "snow" }
    };

    // Start is called before the first frame update
    void Start()
    {
        Debug.Log("footstep start");

        StartCoroutine(AssignOwnerAfterDelay());
        // Initialize the dictionary mapping materials to sound arrays
        footstepSounds = new Dictionary<string, AudioClip[]>
        {
            { "concrete", footStepSFXConcrete },
            { "dirt", footStepSFXDirt },
            { "mud", footStepSFXMud },
            { "grass", footStepSFXGrass },
            { "metal", footStepSFXMetal },
            { "water", footStepSFXWater },
            { "wood", footStepSFXWood },
            { "sand", footStepSFXSand },
            { "stone", footStepSFXStone },
            { "snow", footStepSFXSnow }
        };

        token_footstep = this.AddEventHandler(EVENT_ID_FOOTSTEPS, OnNetworkFootStep);
        
    }

    public void OnNetworkFootStep(object[] args)
    {
        if (args != null && args.Length > 0)
        {
            string clipName = (string)args[0];
        //    Debug.Log($"Received footstep clip name from another player: {clipName}");

            // Search for the clip manually
            AudioClip foundClip = null;

            foreach (var clipArray in footstepSounds.Values)
            {
                foreach (var clip in clipArray)
                {
                    if (clip.name == clipName)
                    {
                        foundClip = clip;
                        break;
                    }
                }
                if (foundClip != null) break;
            }

            if (foundClip != null)
            {
                footAutoSource.PlayOneShot(foundClip);
            }
            else
            {
              //  Debug.LogWarning($"Clip '{clipName}' not found locally!");
            }
        }
    }




    public IEnumerator AssignOwnerAfterDelay()
    {
        yield return new WaitForSeconds(3.5f); // Wait for half a second

        Transform parent = transform;
        while (parent.parent != null)
        {
            parent = parent.parent; // Go up the hierarchy
        }

        Owner = ML.SDK.MassiveLoopRoom.GetLocalPlayer();
        Debug.Log("Owner assigned: " + Owner?.NickName);

    }

    //For this, I would normally use a switch case statement here, but for some reason
    //that was not producing reliable results.
    void PlayFootstepSound()
    {
        string material = currentStandingMaterial.Trim().ToLower();

        // Explicitly check if the material exists in the dictionary
        AudioClip[] clips = null;
        if (footstepSounds.ContainsKey(material))
        {
            clips = footstepSounds[material];
        }

        if (clips != null && clips.Length > 0)
        {
            AudioClip clipToPlay = clips[UnityEngine.Random.Range(0, clips.Length)];
            footAutoSource.pitch = 1.0f + UnityEngine.Random.Range(-0.1f, 0.1f); // ±10% pitch variation
            footAutoSource.PlayOneShot(clipToPlay);
        }
        else
        {
            Debug.LogWarning($"No footstep sound found for material: {material}");
        }
       
    }

    private void OnTriggerEnter(Collider other)
    {
        string lowerName = other.name.ToLower();

        foreach (var pair in materialMappings)
        {
            if (lowerName.Contains(pair.Key))
            {
                currentStandingMaterial = pair.Value;
                return;
            }
        }

      //  Debug.LogWarning($"Unrecognized material: {other.name}");
    }
    private void ToggleFootstepInterval()
    {
        // Check if JoyClick1 is pressed and ensure we haven't toggled yet during this press
        if (Owner.UserInput.JoyClick1 && !isTogglePressed)
        {
            // Toggle between 0.35f and 0.45f
            if (footstepInterval == 0.30f)
            {
                footstepInterval = 0.40f;
            }
            else
            {
                footstepInterval = 0.30f;
            }

            // Log the new interval for debugging
            Debug.Log("Footstep interval set to: " + footstepInterval);

            // Set the flag to prevent further toggling while button is held
            isTogglePressed = true;
        }
        // If JoyClick1 is released, allow the toggle action again
        else if (!Owner.UserInput.JoyClick1)
        {
            isTogglePressed = false;
        }
    }

    private bool isTogglePressed = false;  // Flag to check if toggle action has been performed

    // Update is called once per frame
    void Update()
    {

        footstepTimer -= Time.deltaTime;
        if (Owner != null)
        {
            if (Owner.UserInput != null)
            {
                // omni-movement footsteps
                if (Owner.UserInput.Joy1.y > DM_KEY_TRESHOLD || Owner.UserInput.Joy1.y < -DM_KEY_TRESHOLD || Owner.UserInput.Joy1.x > DM_KEY_TRESHOLD || Owner.UserInput.Joy1.x < -DM_KEY_TRESHOLD)
                {
                    // If it's time to play the next footstep sound
                    if (footstepTimer <= 0f)
                    {
                     //   Debug.Log("Attempting to play sound");
                        PlayFootstepSound();  // Play footstep sound
                        footstepTimer = footstepInterval;  // Reset timer for next footstep sound
                    }
                }
                else
                {
                    // Stop footsteps when not moving
                    footstepTimer = 0f;
                }

                if (Owner.UserInput.JoyClick1 && !isTogglePressed)
                {
                    // Toggle between 0.35f and 0.45f
                    if (footstepInterval == 0.30f)
                    {
                        footstepInterval = 0.4f;
                    }
                    else
                    {
                        footstepInterval = 0.30f;
                    }

                    // Log the new interval for debugging
                //    Debug.Log("Footstep interval set to: " + footstepInterval);

                    // Set the flag to prevent further toggling while button is held
                    isTogglePressed = true;
                }
                // If JoyClick1 is released, allow the toggle action again
                else if (!Owner.UserInput.JoyClick1)
                {
                    isTogglePressed = false;
                }
            }
        }
    }
}

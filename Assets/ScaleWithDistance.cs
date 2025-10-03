using UnityEngine;
using System.Collections;

public class ScaleWithDistance : MonoBehaviour
{
    public float minScale = 0.1f; // Minimum scale of the object
    public float maxScale = 2f;   // Maximum scale of the object
    public float minDistance = 1f; // Distance at which the object is at its max scale
    public float maxDistance = 10f; // Distance at which the object is at its min scale

    private ML.SDK.MLPlayer player;
    private Transform playerTransform;

    void Start()
    {
        Debug.Log("InitializePlayer started");
        StartCoroutine(InitializePlayer());
    }

    IEnumerator InitializePlayer()
    {
        while (player == null)
        {
            Debug.Log("Waiting started");
            yield return new WaitForSeconds(2f);
            player = ML.SDK.MassiveLoopRoom.GetLocalPlayer();
            Debug.Log("Checking player...");

            if (player != null)
            {
                Debug.Log("Player non null");
                UnityEngine.Debug.Log("Local player : " + player.ActorId + " Local player nick name : " + player.NickName + player.PlayerRoot);
                UnityEngine.Debug.Log("Local player transform pos : " + player.PlayerRoot + " Local player nick name : " + player.NickName);
                playerTransform = player.PlayerRoot.gameObject.transform;
                Debug.Log(player.PlayerRoot.gameObject.transform);
            }
            else
            {
                Debug.LogWarning("Waiting for player to be initialized...");
            }
        }
        Debug.Log("Waiting ended");
    }

    void Update()
    {
        if (playerTransform != null)
        {
         //   Debug.Log("Player transform non null");
            // Calculate the distance between the player and the object
            float distance = Vector3.Distance(playerTransform.position, transform.position);

         //   Debug.Log("Distance  : " + distance);

            // Map the distance to a scale factor between minScale and maxScale
            float scale = Mathf.Lerp(maxScale, minScale, Mathf.InverseLerp(minDistance, maxDistance, distance));

            // Apply the scale to the object
            transform.localScale = new Vector3(scale, scale, scale);
        }
    }
}

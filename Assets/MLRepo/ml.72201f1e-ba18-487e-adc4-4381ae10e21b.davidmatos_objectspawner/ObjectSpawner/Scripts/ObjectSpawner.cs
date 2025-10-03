using ML.SDK;
using UnityEngine;
using System.Collections.Generic;

    public class ObjectSpawnerClick : MonoBehaviour
    {
        [Header("Spawn Settings")]
        [SerializeField] private GameObject spawnPosition;
        [SerializeField] private GameObject objectToSpawn;
        [SerializeField] private int maxSpawnedObjects = 5; // New limit setting

        private MLClickable clickable;
        private MLPlayer localPlayer;
        private List<GameObject> spawnedObjects = new List<GameObject>();

        private void Start()
        {
            localPlayer = MassiveLoopRoom.GetLocalPlayer();
            clickable = GetComponent(typeof(MLClickable)) as MLClickable;

            if (clickable != null)
            {
                clickable.OnClick.AddListener(Click);
            }
        }

        private void SpawnObject()
        {
            if (!CanSpawn()) return;

            // Remove oldest object if we've reached limit
            if (spawnedObjects.Count >= maxSpawnedObjects)
            {
                DestroyOldestObject();
            }

            // Spawn new object
            if (spawnPosition != null && objectToSpawn != null)
            {
                GameObject newObj = Instantiate(
                    objectToSpawn,
                    spawnPosition.transform.position,
                    spawnPosition.transform.rotation);

                spawnedObjects.Add(newObj);
            }
        }

        private bool CanSpawn()
        {
            return localPlayer != null &&
                   localPlayer.IsMasterClient &&
                   spawnPosition != null &&
                   objectToSpawn != null;
        }

        private void DestroyOldestObject()
        {
            if (spawnedObjects.Count > 0)
            {
                GameObject oldest = spawnedObjects[0];
                if (oldest != null)
                {
                    Destroy(oldest);
                }
                spawnedObjects.RemoveAt(0);
            }
        }

        private void Click()
        {
            SpawnObject();
        }

        // Optional: Clean up destroyed objects from our list
        private void Update()
        {
            for (int i = spawnedObjects.Count - 1; i >= 0; i--)
            {
                if (spawnedObjects[i] == null)
                {
                    spawnedObjects.RemoveAt(i);
                }
            }
        }
    }

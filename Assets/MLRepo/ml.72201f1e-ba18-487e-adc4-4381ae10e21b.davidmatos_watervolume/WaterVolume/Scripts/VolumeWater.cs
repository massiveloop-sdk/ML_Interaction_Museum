using UnityEngine;
using System.Collections.Generic;
using ML.SDK;

    public class VolumeWater : MonoBehaviour
    {
        //|||||||||||||||||||||||||||||||||||||||||||||| PUBLIC VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||
        [Header("Buoyancy Settings")]
        [SerializeField] private bool doBuoyancy = true;
        [SerializeField] private float buoyancyForce = 8f;
        [SerializeField][Range(0, 1)] private float depthPower = 0f;

        [Header("Splash Settings")]
        [SerializeField] private bool doSplashes = true;
        [SerializeField] private GameObject waterSplashEnterPrefab;
        [SerializeField] private GameObject waterSplashExitPrefab;
        [SerializeField] private GameObject waterSurfaceHeight;

        [Header("Player Buoyancy Settings")]
        [SerializeField] private float playerBuoyancyForce = 4f;   // weaker than normal objects
        [SerializeField][Range(0, 1)] private float playerDepthPower = 0.3f;

        //|||||||||||||||||||||||||||||||||||||||||||||| PRIVATE FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        private void SpawnWaterSplashPrefab(Vector3 prefabSpawnPosition, bool isEntering)
        {
            GameObject prefabToSpawn = isEntering ? waterSplashEnterPrefab : waterSplashExitPrefab;
            if (prefabToSpawn != null)
            {
                Instantiate(prefabToSpawn, prefabSpawnPosition, Quaternion.identity);
            }
        }

        private void ComputeBuoyancyOnRigidbody(Collider collider, Rigidbody rigidbody, float forceOverride = -1f, float depthOverride = -1f)
        {
            if (waterSurfaceHeight == null || rigidbody == null) return;

            float objectYPosition = collider.bounds.center.y;
            float buoyantForceMass = ((forceOverride > 0 ? forceOverride : buoyancyForce) * rigidbody.mass);
            float underWaterBuoyantForce = Mathf.Clamp01(
                (waterSurfaceHeight.transform.position.y - objectYPosition) *
                (depthOverride >= 0 ? depthOverride : depthPower));
            float buoyancy = buoyantForceMass + (buoyantForceMass * underWaterBuoyantForce);

            rigidbody.AddForce(Vector3.up * buoyancy, ForceMode.Force);
        }

        //|||||||||||||||||||||||||||||||||||||||||||||| UNITY FUNCTIONS ||||||||||||||||||||||||||||||||||||||||||||||
        private void Start()
        {
            // Initialization if needed
        }

        private void Update()
        {
            // Not used (kept for consistency)
        }

        private void OnTriggerEnter(Collider other)
        {
            if (!doSplashes || waterSurfaceHeight == null) return;

            Vector3 prefabSpawnPosition = new Vector3(
                other.transform.position.x,
                waterSurfaceHeight.transform.position.y,
                other.transform.position.z);

            // Check if it's a player
            MLPlayer player = other.gameObject.GetPlayer();
            if (player != null)
            {
                SpawnWaterSplashPrefab(prefabSpawnPosition, true);
                return;
            }

            // Check for rigidbodies or grabbable objects
            bool hasRigidbody = other.GetComponent<Rigidbody>() != null ||
                               other.GetComponentInChildren<Rigidbody>() != null;
            bool hasGrabbable = other.GetComponent(typeof(MLGrab)) as MLGrab != null ||
                               other.GetComponentInChildren(typeof(MLGrab)) as MLGrab != null;

            if (hasRigidbody || hasGrabbable)
            {
                SpawnWaterSplashPrefab(prefabSpawnPosition, true);
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (!doSplashes || waterSurfaceHeight == null) return;

            Vector3 prefabSpawnPosition = new Vector3(
                other.transform.position.x,
                waterSurfaceHeight.transform.position.y,
                other.transform.position.z);

            // Check if it's a player
            MLPlayer player = other.gameObject.GetPlayer();
            if (player != null)
            {
                SpawnWaterSplashPrefab(prefabSpawnPosition, false);
                return;
            }

            // Check for rigidbodies or grabbable objects
            bool hasRigidbody = other.GetComponent<Rigidbody>() != null ||
                               other.GetComponentInChildren<Rigidbody>() != null;
            bool hasGrabbable = other.GetComponent(typeof(MLGrab)) as MLGrab != null ||
                               other.GetComponentInChildren(typeof(MLGrab)) as MLGrab != null;

            if (hasRigidbody || hasGrabbable)
            {
                SpawnWaterSplashPrefab(prefabSpawnPosition, false);
            }
        }

        private void OnTriggerStay(Collider other)
        {
            if (!doBuoyancy) return;

            List<Rigidbody> rigidbodies = new List<Rigidbody>();

            /*
            MLPlayer player = other.gameObject.GetPlayer();
            if (player != null && player.PlayerRoot != null)
            {
                Rigidbody playerRb = player.PlayerRoot.GetComponent<Rigidbody>();
                if (playerRb != null)
                {
                    ComputeBuoyancyOnRigidbody(other, playerRb, playerBuoyancyForce, playerDepthPower);
                }
            }
            */
            
            // Normal rigidbody checks
            Rigidbody parentRb = other.GetComponent<Rigidbody>();
            if (parentRb != null && !rigidbodies.Contains(parentRb))
                rigidbodies.Add(parentRb);

            Component[] childComponents = other.GetComponentsInChildren(typeof(Rigidbody));
            foreach (Component comp in childComponents)
            {
                Rigidbody rb = comp as Rigidbody;
                if (rb != null && !rigidbodies.Contains(rb))
                {
                    rigidbodies.Add(rb);
                }
            }

            // Apply buoyancy to all found rigidbodies
            foreach (Rigidbody rb in rigidbodies)
            {
                ComputeBuoyancyOnRigidbody(other, rb);
            }
        }
    }

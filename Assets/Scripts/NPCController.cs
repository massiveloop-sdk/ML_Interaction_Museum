using UnityEngine;
using UnityEngine.AI;
using System.Collections;
using System.Collections.Generic;

public class NPCController : MonoBehaviour
{
    [Header("Navigation Settings")]
    public float walkSpeed = 1.5f;
    public float runSpeed = 3.5f;
    public float rotationSpeed = 120f;
    public float minDestinationDistance = 5f;
    public float maxDestinationDistance = 20f;
    public float edgeBufferDistance = 1f;

    [Header("Behavior Settings")]
    public float minMoveTime = 5f;
    public float maxMoveTime = 15f;
    public float minIdleTime = 2f;
    public float maxIdleTime = 10f;
    public float interactionRange = 2f;
    public float interactionProbability = 0.1f;
    public float minInteractionTime = 5f;
    public float maxInteractionTime = 15f;
    private const float desiredInteractionDistance = 1.5f;

    [Header("Optimization Settings")]
    public float proximityCheckInterval = 0.5f; // Seconds between checks
    private float lastProximityCheckTime;

    [Header("References")]
    public Animator animator;
    public NavMeshAgent navAgent;
    public Transform lookAtTarget;

    // Internal state
    private enum NPCState { Moving, Idle, Interacting }
    private NPCState currentState = NPCState.Moving;
    private float behaviorTimer = 0f;
    private float currentBehaviorDuration = 0f;
    private NPCController interactionPartner;
    private Vector3 lastPosition;
    private float stuckTimer = 0f;
    private const float stuckThreshold = 0.1f;
    private const float stuckTimeLimit = 3f;
    private const int maxApproachAttempts = 3;
    private int currentApproachAttempts = 0;

    private static List<NPCController> allNPCs = new List<NPCController>();
    private static bool registryDirty = false;

    //   private List<NPCController> nearbyNPCs = new List<NPCController>();
    private float lastInteractionCheckTime;

    private void Awake()
    {
        if (navAgent == null) navAgent = GetComponent<NavMeshAgent>();
        if (animator == null) animator = GetComponent<Animator>();

        navAgent.speed = walkSpeed;
        navAgent.angularSpeed = rotationSpeed;
        lastPosition = transform.position;
    }

    private void Start()
    {
        SetRandomDestination();
    }



    private void Update()
    {
        UpdateAnimation();
        CheckIfStuck();
        CheckProximity(); // New optimized proximity check

        behaviorTimer += Time.deltaTime;

        switch (currentState)
        {
            case NPCState.Moving:
                UpdateMovingState();
                break;
            case NPCState.Idle:
                UpdateIdleState();
                break;
            case NPCState.Interacting:
                UpdateInteractingState();
                break;
        }
    }

    private void CheckProximity()
    {
        if (Time.time - lastProximityCheckTime < proximityCheckInterval ||
            currentState == NPCState.Interacting)
            return;

        lastProximityCheckTime = Time.time;

        float closestDistance = float.MaxValue;
        NPCController closestNPC = null;
        float sqrInteractionRange = interactionRange * interactionRange;

        // Use the cached list
        foreach (var npc in allNPCs)
        {
            // Skip invalid or inactive NPCs
            if (npc == null || npc == this || npc.currentState == NPCState.Interacting)
                continue;

            // Use squared distance for better performance
            float sqrDistance = (transform.position - npc.transform.position).sqrMagnitude;
            if (sqrDistance < sqrInteractionRange && sqrDistance < closestDistance)
            {
                closestDistance = sqrDistance;
                closestNPC = npc;
            }
        }

        if (closestNPC != null)
        {
            // Calculate real distance only when needed
            float realDistance = Mathf.Sqrt(closestDistance);
            if (realDistance <= desiredInteractionDistance)
            {
                StartInteraction(closestNPC);
            }
            else if (currentState != NPCState.Interacting)
            {
                StartApproachForInteraction(closestNPC);
            }
        }
    }



    private void UpdateAnimation()
    {
        float speed = currentState == NPCState.Interacting ? 0f : navAgent.velocity.magnitude;
        animator.SetFloat("Speed", speed);
        animator.SetBool("IsInteracting", currentState == NPCState.Interacting);
        animator.SetBool("IsIdle", currentState == NPCState.Idle);
    }

    private void CheckIfStuck()
    {
        float distanceMoved = Vector3.Distance(lastPosition, transform.position);
        lastPosition = transform.position;

        if (distanceMoved < stuckThreshold && navAgent.hasPath)
        {
            stuckTimer += Time.deltaTime;
            if (stuckTimer > stuckTimeLimit)
            {
                FindNewRandomDestination();
                stuckTimer = 0f;
            }
        }
        else
        {
            stuckTimer = 0f;
        }
    }

    private void UpdateMovingState()
    {
        // Check if we've reached our destination
        if (!navAgent.pathPending && navAgent.remainingDistance <= navAgent.stoppingDistance)
        {
            StartIdle();
            return;
        }

        // Random chance to start interaction while moving
        if (behaviorTimer > 1f && Random.value < interactionProbability * Time.deltaTime)
        {
            TryStartInteraction();
        }

        // Time-based destination change (in case we're walking a long path)
        if (behaviorTimer >= currentBehaviorDuration)
        {
            FindNewRandomDestination();
        }
    }

    private void UpdateIdleState()
    {
        if (behaviorTimer >= currentBehaviorDuration)
        {
            SetRandomDestination();
        }
        else if (behaviorTimer > 1f && Random.value < interactionProbability * Time.deltaTime)
        {
            TryStartInteraction();
        }
    }

    private void UpdateInteractingState()
    {
        if (interactionPartner == null)
        {
            EndInteraction();
            return;
        }

        // Face our interaction partner
        if (lookAtTarget != null)
        {
            Vector3 direction = lookAtTarget.position - transform.position;
            direction.y = 0;
            if (direction != Vector3.zero)
            {
                Quaternion targetRotation = Quaternion.LookRotation(direction);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, rotationSpeed * Time.deltaTime);
            }
        }

        // Maintain interaction distance
        float currentDistance = Vector3.Distance(transform.position, interactionPartner.transform.position);
        if (currentDistance > desiredInteractionDistance * 1.2f)
        {
            // If we've drifted too far apart, end the interaction
            EndInteraction();
        }
        else if (currentDistance > desiredInteractionDistance * 1.05f)
        {
            // If we're slightly too far, adjust position
            Vector3 directionToPartner = (interactionPartner.transform.position - transform.position).normalized;
            Vector3 targetPosition = interactionPartner.transform.position - (directionToPartner * desiredInteractionDistance);

            // Small adjustment without pathfinding to maintain natural look
            transform.position = Vector3.MoveTowards(transform.position, targetPosition, 0.5f * Time.deltaTime);
        }

        if (behaviorTimer >= currentBehaviorDuration)
        {
            EndInteraction();
        }
    }

    private void SetRandomDestination()
    {
        currentState = NPCState.Moving;
        behaviorTimer = 0f;
        currentBehaviorDuration = Random.Range(minMoveTime, maxMoveTime);
        navAgent.isStopped = false;
        FindNewRandomDestination();
    }

    private void FindNewRandomDestination()
    {
        Vector3 randomDirection = Random.insideUnitSphere * Random.Range(minDestinationDistance, maxDestinationDistance);
        randomDirection += transform.position;

        // Sample multiple times to get a good position
        NavMeshHit hit;
        int attempts = 0;
        bool foundPosition = false;

        while (!foundPosition && attempts < 10)
        {
            if (NavMesh.SamplePosition(randomDirection, out hit, maxDestinationDistance, NavMesh.AllAreas))
            {
                // Check if this position is too close to navmesh edge
                if (!IsNearNavMeshEdge(hit.position))
                {
                    navAgent.SetDestination(hit.position);
                    foundPosition = true;
                }
            }

            if (!foundPosition)
            {
                randomDirection = Random.insideUnitSphere * Random.Range(minDestinationDistance, maxDestinationDistance);
                randomDirection += transform.position;
                attempts++;
            }
        }

        if (!foundPosition)
        {
            // Fallback - just go somewhere nearby
            randomDirection = transform.position + transform.forward * minDestinationDistance;
            if (NavMesh.SamplePosition(randomDirection, out hit, minDestinationDistance, NavMesh.AllAreas))
            {
                navAgent.SetDestination(hit.position);
            }
            else
            {
                StartIdle();
            }
        }
    }

    private bool IsNearNavMeshEdge(Vector3 position)
    {
        NavMeshHit hit;
        if (NavMesh.FindClosestEdge(position, out hit, NavMesh.AllAreas))
        {
            return hit.distance < edgeBufferDistance;
        }
        return true;
    }

    private void StartIdle()
    {
        currentState = NPCState.Idle;
        behaviorTimer = 0f;
        currentBehaviorDuration = Random.Range(minIdleTime, maxIdleTime);
        navAgent.isStopped = true;
    }

    private void TryStartInteraction()
    {
        if (currentState == NPCState.Interacting) return;

        Collider[] nearbyColliders = Physics.OverlapSphere(transform.position, interactionRange);

        foreach (var collider in nearbyColliders)
        {
            if (collider.CompareTag("NPC") && collider.gameObject != gameObject)
            {
                NPCController otherNPC = collider.GetComponent(typeof(NPCController)) as NPCController;
                if (otherNPC != null && otherNPC.currentState != NPCState.Interacting)
                {
                    float distance = Vector3.Distance(transform.position, otherNPC.transform.position);

                    // If we're close enough, start interaction immediately
                    if (distance <= desiredInteractionDistance)
                    {
                        StartInteraction(otherNPC);
                        return;
                    }
                    // Otherwise, move toward the interaction position
                    else if (currentState == NPCState.Idle || currentState == NPCState.Moving)
                    {
                        StartApproachForInteraction(otherNPC);
                        return;
                    }
                }
            }
        }
    }

    private void StartApproachForInteraction(NPCController partner)
    {
        if (currentApproachAttempts >= maxApproachAttempts)
        {
            // Give up after max attempts
            currentApproachAttempts = 0;
            SetRandomDestination();
            return;
        }

        currentApproachAttempts++;

        // Calculate a position that's the desired interaction distance from the partner
        Vector3 directionToPartner = (partner.transform.position - transform.position).normalized;
        Vector3 targetPosition = partner.transform.position - (directionToPartner * desiredInteractionDistance);

        // Sample the position on the navmesh
        NavMeshHit hit;
        if (NavMesh.SamplePosition(targetPosition, out hit, maxDestinationDistance, NavMesh.AllAreas))
        {
            currentState = NPCState.Moving;
            navAgent.isStopped = false;
            navAgent.SetDestination(hit.position);

            // Store the potential partner for when we reach the position
            interactionPartner = partner;
            currentBehaviorDuration = Mathf.Infinity; // Override the normal timer

            // Set a special flag to know we're approaching for interaction
            StartCoroutine(MonitorApproachForInteraction(partner));
        }
        else
        {
            // If we can't find a valid position, give up
            currentApproachAttempts = 0;
            SetRandomDestination();
        }
    }

    private IEnumerator MonitorApproachForInteraction(NPCController partner)
    {
        while (currentState == NPCState.Moving &&
               interactionPartner == partner &&
               Vector3.Distance(transform.position, partner.transform.position) > desiredInteractionDistance * 1.1f)
        {
            // Check if we've reached close enough to our destination
            if (!navAgent.pathPending && navAgent.remainingDistance <= navAgent.stoppingDistance)
            {
                // If we're close enough to interact, start interaction
                if (Vector3.Distance(transform.position, partner.transform.position) <= desiredInteractionDistance * 1.1f)
                {
                    currentApproachAttempts = 0;
                    StartInteraction(partner);
                    yield break;
                }
                // Otherwise, try to find a better position (but limited by maxAttempts)
                else if (currentApproachAttempts < maxApproachAttempts)
                {
                    StartApproachForInteraction(partner);
                    yield break;
                }
                else
                {
                    // Give up after max attempts
                    currentApproachAttempts = 0;
                    SetRandomDestination();
                    yield break;
                }
            }

            yield return null;
        }

        // If we exited the loop and are still moving toward the partner, start interaction
        if (interactionPartner == partner && currentState == NPCState.Moving)
        {
            currentApproachAttempts = 0;
            StartInteraction(partner);
        }
    }

    private void StartInteraction(NPCController partner)
    {
        currentApproachAttempts = 0; // Reset attempts when successfully starting interaction

        // Make sure we're close enough
        float distance = Vector3.Distance(transform.position, partner.transform.position);
        if (distance > desiredInteractionDistance * 1.1f)
        {
            StartApproachForInteraction(partner);
            return;
        }

        currentState = NPCState.Interacting;
        interactionPartner = partner;
        partner.ReceiveInteraction(this);

        lookAtTarget = partner.transform;
        partner.lookAtTarget = transform;

        navAgent.isStopped = true;
        currentBehaviorDuration = Random.Range(minInteractionTime, maxInteractionTime);
        behaviorTimer = 0f;

        // Small adjustment to perfect the distance
        Vector3 directionToPartner = (partner.transform.position - transform.position).normalized;
        Vector3 idealPosition = partner.transform.position - (directionToPartner * desiredInteractionDistance);
        transform.position = idealPosition;
    }

    private void ReceiveInteraction(NPCController initiator)
    {
        currentState = NPCState.Interacting;
        interactionPartner = initiator;
        navAgent.isStopped = true;
        behaviorTimer = 0f;
    }

    private void EndInteraction()
    {
        currentState = NPCState.Moving;
        lookAtTarget = null;
        navAgent.isStopped = false;

        if (interactionPartner != null)
        {
            interactionPartner.FinishInteraction();
            interactionPartner = null;
        }

        SetRandomDestination();
    }

    private void FinishInteraction()
    {
        currentState = NPCState.Moving;
        lookAtTarget = null;
        navAgent.isStopped = false;
        SetRandomDestination();
    }

    private void OnDrawGizmosSelected()
    {
        // Draw interaction range
        Gizmos.color = Color.cyan;
        Gizmos.DrawWireSphere(transform.position, interactionRange);

        // Draw current destination if moving
        if (currentState == NPCState.Moving && navAgent.hasPath)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawLine(transform.position, navAgent.destination);
        }
    }
}
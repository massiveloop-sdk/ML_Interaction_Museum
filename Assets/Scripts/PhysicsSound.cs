using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class PhysicsSound : MonoBehaviour
{
    [Header("Impact Thresholds")]
    [SerializeField] private float lowImpactMagnitudeThreshold = 1f;
    [SerializeField] private float highImpactMagnitudeThreshold = 5f;

    [Header("Audio Clips")]
    [SerializeField] private AudioClip[] lowImpactSounds;
    [SerializeField] private AudioClip[] highImpactSounds;

    private AudioSource audioSource;

    private void Awake()
    {
        // Try to get the AudioSource, add one if it doesn't exist (safe fallback).
        audioSource = GetComponent<AudioSource>();
        if (audioSource == null)
        {
            audioSource = gameObject.AddComponent<AudioSource>();
            audioSource.playOnAwake = false;
        }
    }

    private void PlayPhysicsSound(bool playHighImpact)
    {
        if (audioSource == null)
        {
            Debug.LogWarning($"{name}: No AudioSource available to play physics sound.");
            return;
        }

        AudioClip clip = playHighImpact ? GetRandomClip(highImpactSounds) : GetRandomClip(lowImpactSounds);

        if (clip != null)
            audioSource.PlayOneShot(clip);
        else
            Debug.LogWarning($"{name}: No audio clip found for {(playHighImpact ? "high" : "low")} impact.");
    }

    private AudioClip GetRandomClip(AudioClip[] clips)
    {
        if (clips == null || clips.Length == 0) return null;
        int i = Random.Range(0, clips.Length);
        return clips[i];
    }

    private void OnCollisionEnter(Collision collision)
    {
        // Make sure the impulse is meaningful (ensure at least one object in the collision has a Rigidbody)
        float mag = collision.impulse.magnitude;
        if (mag > lowImpactMagnitudeThreshold)
        {
            PlayPhysicsSound(mag > highImpactMagnitudeThreshold);
        }
    }
}

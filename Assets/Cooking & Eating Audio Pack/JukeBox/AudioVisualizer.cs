using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioVisualizer : MonoBehaviour
{
    public GameObject[] Visualizer; // Array of visualizer bars
    public float smoothingSpeed = 5f; // Controls how fast the visualizer responds
    private float[] spectrumData = new float[64]; // Raw spectrum data
    private float[] smoothedSpectrumData = new float[64]; // Smoothed spectrum data
    public float visualizerScale = 5f; // Controls how much the bars scale
    public LayerMask audioSourceMask; // Layer mask to filter the closest audio sources

    void Update()
    {
        // Get the closest AudioSource
        AudioSource closestAudioSource = FindClosestAudioSource();

        if (closestAudioSource != null)
        {
            // Get audio spectrum data from the closest AudioSource
            closestAudioSource.GetSpectrumData(spectrumData, 0, FFTWindow.Rectangular);

            // Process and visualize the spectrum data
            for (int i = 0; i < Visualizer.Length; i++)
            {
                // Smooth out the spectrum data
                smoothedSpectrumData[i] = Mathf.Lerp(smoothedSpectrumData[i], spectrumData[i], Time.deltaTime * smoothingSpeed);

                // Scale the visualizer bars based on the smoothed spectrum data
                float newYScale = Mathf.Lerp(0.1f, visualizerScale, smoothedSpectrumData[i] * 100); // Adjust scaling factor as needed
                Vector3 newScale = Visualizer[i].transform.localScale;
                newScale.y = newYScale;
                Visualizer[i].transform.localScale = newScale;
            }
        }
    }

    // Function to find the closest AudioSource
    AudioSource FindClosestAudioSource()
    {
        AudioSource closestAudioSource = null;
        float closestDistance = Mathf.Infinity;

        // Get all AudioSource objects in the scene
        AudioSource[] audioSources = FindObjectsOfType<AudioSource>();

        // Loop through all AudioSources to find the closest one
        foreach (AudioSource audioSource in audioSources)
        {
            // Ignore inactive or muted sources
            if (!audioSource.isPlaying || audioSource.mute) continue;

            float distance = Vector3.Distance(transform.position, audioSource.transform.position);
            if (distance < closestDistance)
            {
                closestAudioSource = audioSource;
                closestDistance = distance;
            }
        }

        return closestAudioSource;
    }
}

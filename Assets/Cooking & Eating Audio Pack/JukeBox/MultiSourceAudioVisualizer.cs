using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MultiSourceAudioVisualizer : MonoBehaviour
{
    public GameObject[] Visualizer; // Array of visualizer bars
    public float smoothingSpeed = 5f; // Controls how fast the visualizer responds
    private float[] spectrumData = new float[64]; // Raw spectrum data
    private float[] smoothedSpectrumData = new float[64]; // Smoothed spectrum data
    public float visualizerScale = 5f; // Controls how much the bars scale
    public LayerMask audioSourceMask; // Layer mask to filter the audio sources

    void Update()
    {
        // Reset spectrumData to zero at the start of each frame
        for (int i = 0; i < spectrumData.Length; i++)
        {
            spectrumData[i] = 0f;
        }

        // Find all AudioSource objects in the scene
        AudioSource[] audioSources = FindObjectsOfType<AudioSource>();

        // Loop through all AudioSources and accumulate their spectrum data
        foreach (AudioSource audioSource in audioSources)
        {
            if (audioSource.isPlaying && !audioSource.mute)
            {
                // Create a temporary array to store the spectrum data of each source
                float[] tempSpectrum = new float[spectrumData.Length];
                audioSource.GetSpectrumData(tempSpectrum, 0, FFTWindow.Rectangular);

                // Add the spectrum data of this source to the overall spectrum data
                for (int i = 0; i < spectrumData.Length; i++)
                {
                    spectrumData[i] += tempSpectrum[i];
                }
            }
        }

        // Process and visualize the accumulated spectrum data
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

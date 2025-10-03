using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MultiSourceAudioVisualizerMaterialsColorDiscrete : MonoBehaviour
{
    public GameObject[] Visualizer; // Array of visualizer bars
    public float smoothingSpeed = 5f; // Controls how fast the visualizer responds
    private float[] spectrumData = new float[64]; // Raw spectrum data
    private float[] smoothedSpectrumData = new float[64]; // Smoothed spectrum data
    public float visualizerScale = 5f; // Controls how much the bars scale

    // Material property settings
    public string materialColorProperty = "_Color"; // Material color property to modify
    public string materialEmissionProperty = "_EmissionColor"; // Emission property to modify
    public float emissionIntensity = 2f; // Emission intensity multiplier

    // Define colors for frequency ranges
    public Color lowFrequencyColor = Color.blue;    // Color for low frequencies
    public Color mediumFrequencyColor = Color.green; // Color for medium frequencies
    public Color highFrequencyColor = Color.red;    // Color for high frequencies

    void Update()
    {
        // Reset spectrumData to zero at the start of each frame
        for (int i = 0; i < spectrumData.Length; i++)
        {
            spectrumData[i] = 0f;
        }

        // Find all AudioSource objects in the scene
        AudioSource[] audioSources = FindObjectsOfType<AudioSource>();

        // Accumulate spectrum data from all audio sources
        foreach (AudioSource audioSource in audioSources)
        {
            if (audioSource.isPlaying && !audioSource.mute)
            {
                float[] tempSpectrum = new float[spectrumData.Length];
                audioSource.GetSpectrumData(tempSpectrum, 0, FFTWindow.Rectangular);

                for (int i = 0; i < spectrumData.Length; i++)
                {
                    spectrumData[i] += tempSpectrum[i];
                }
            }
        }

        for (int i = 0; i < Visualizer.Length; i++)
        {
            if (i >= spectrumData.Length)
            {
                Debug.LogWarning($"Visualizer index {i} exceeds spectrumData length {spectrumData.Length}. Stopping loop early.");
                break;
            }

            if (Visualizer[i] == null)
            {
                Debug.LogWarning($"Visualizer element at index {i} is null. Skipping this element.");
                continue;
            }

            // Smooth out the spectrum data
            smoothedSpectrumData[i] = Mathf.Lerp(smoothedSpectrumData[i], spectrumData[i], Time.deltaTime * smoothingSpeed);

            // Scale the visualizer bars based on the smoothed spectrum data
            float newYScale = Mathf.Lerp(0.1f, visualizerScale, smoothedSpectrumData[i] * 100); // Adjust scaling factor as needed
            Vector3 newScale = Visualizer[i].transform.localScale;
            newScale.y = newYScale;
            Visualizer[i].transform.localScale = newScale;

            // Update material properties with discrete colors
            Renderer renderer = Visualizer[i].GetComponent<Renderer>();
            if (renderer != null)
            {
                Material material = renderer.material;

                // Get the appropriate color for this bar based on its frequency range
                Color selectedColor = GetColorForFrequencyRange(i, Visualizer.Length);

                // Adjust intensity using smoothed spectrum data
                Color finalColor = selectedColor * Mathf.Clamp01(smoothedSpectrumData[i] * 10f);

                // Set material color and emission
                material.SetColor(materialColorProperty, finalColor);
                material.SetColor(materialEmissionProperty, finalColor * emissionIntensity);

                // Enable emission (if not already enabled)
                material.EnableKeyword("_EMISSION");
            }
            else
            {
                Debug.LogWarning($"Renderer component missing on Visualizer element at index {i}. Skipping material updates.");
            }
        }
    }

    /// <summary>
    /// Returns a color based on the frequency range: low, medium, or high.
    /// </summary>
    private Color GetColorForFrequencyRange(int index, int totalBars)
    {
        float normalizedIndex = (float)index / totalBars;

        if (normalizedIndex < 0.33f)      // Low frequencies (first third of bars)
            return lowFrequencyColor;
        else if (normalizedIndex < 0.66f) // Medium frequencies (middle third)
            return mediumFrequencyColor;
        else                             // High frequencies (last third)
            return highFrequencyColor;
    }
}

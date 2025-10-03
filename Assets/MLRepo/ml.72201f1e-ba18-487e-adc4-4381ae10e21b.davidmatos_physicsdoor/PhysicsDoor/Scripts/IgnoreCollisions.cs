using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IgnoreCollisions : MonoBehaviour
{
    public Collider[] baseColliders;
    public Collider[] collidersToIgnore;

    /*
    private void Awake()
    {
        for(int i = 0; i < baseColliders.Length; i++) 
        {
            for(int j = 0; j < collidersToIgnore.Length; j++)
            {
                Physics.IgnoreCollision(baseColliders[i], collidersToIgnore[j]);
            }
        }
    }*/
}

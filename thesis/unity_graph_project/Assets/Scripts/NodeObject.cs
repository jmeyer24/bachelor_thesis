using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NodeObject
{
    public GameObject go;
    public Vector2 position;
    public Node nodeComp;

    public NodeObject(GameObject prefab, int i, GameObject nodeBin, Vector3 scale, float x_pos, float y_pos, List<float> info)
    {
        go = Object.Instantiate(prefab);
        position = new Vector2(x_pos, y_pos);
        nodeComp = go.AddComponent<Node>();

        Object.Destroy(go.GetComponent<MeshCollider>());
        go.name = prefab.name + " " + (i + 1);
        go.transform.parent = nodeBin.transform;
        go.transform.localScale = scale;
        go.transform.position = position;

        nodeComp.id = i + 1;
        nodeComp.edges = new List<Edge>();
        nodeComp.bearing = Mathf.Rad2Deg * info[3];
        nodeComp.internalNorth = Mathf.Rad2Deg * info[4];
        // in degree...
    }
}

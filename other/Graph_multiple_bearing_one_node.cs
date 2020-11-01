using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//mboon : multiple_bearings_on_one_node
public class Graph_mboon : MonoBehaviour
{
    public Camera MainCamera;
    public List<Node> nodes;
    public TextAsset text_arcs;
    public TextAsset text_nodes;

    public bool interconnection;
    public bool spheres;
    public bool internalBearing;
    public bool internalNorth;
    public bool trueNorth;

    private float minx;
    private float maxx;
    private float miny;
    private float maxy;

    private float time;

    void Start()
    {
        time = 0f;

        Build();
        GetChildren();

        // position the camera to see all of graph
        MainCamera.transform.Translate(new Vector2((maxx + minx) / 2, (maxy + miny) / 2));
        MainCamera.orthographicSize = Mathf.Max(maxx - minx, maxy - miny) / 3;

        //Debug.Log(ObjectiveFunction());
    }

    void Update()
    {
        time += Time.deltaTime;
    }

    void OnDrawGizmos()
    {
        if (interconnection)
        {
            Gizmos.color = Color.yellow;
            foreach (Node node in nodes)
            {
                foreach (Edge currentEdge in node.outEdges)
                {
                    Gizmos.DrawLine(node.position, nodes[currentEdge.childId - 1].position);
                }
            }
        }

        if (spheres)
        {
            Gizmos.color = Color.grey;
            foreach(Node node in nodes)
            {
                Gizmos.DrawWireSphere(node.position, 0.125f);
            }
        }

        if (internalBearing)
        {
            Gizmos.color = Color.green;
            foreach (Node node in nodes)
            {
                foreach (float bearing in node.bearings)
                {
                    Gizmos.DrawRay(node.position, Quaternion.AngleAxis(Mathf.Rad2Deg * bearing, transform.forward) * transform.up);
                }
            }
        }

        if (internalNorth)
        {
            Gizmos.color = Color.red;
            foreach (Node node in nodes)
            {
                Gizmos.DrawRay(node.position, Quaternion.AngleAxis(Mathf.Rad2Deg * node.internalNorth, transform.forward) * transform.up);
            }
        }

        if (trueNorth)
        {
            Gizmos.color = Color.white;
            foreach(Node node in nodes)
            {
                Gizmos.DrawRay(node.position, transform.up);
            }
        }

        //Gizmos.DrawRay(nodes[0].position, Quaternion.AngleAxis(Mathf.Rad2Deg * time, transform.forward) * transform.up);
    }
    void Build()
    {
        nodes = new List<Node>();
        Vector2 previousPosition = new Vector2();
        int id = 1;
        string[] lines = text_nodes.text.Split('\n');

        for (int i = 1; i < lines.Length - 1; i++)
        {
            string[] array = lines[i].Split('\t');
            float x_pos = float.Parse(array[1], System.Globalization.CultureInfo.InvariantCulture.NumberFormat);
            float y_pos = float.Parse(array[2], System.Globalization.CultureInfo.InvariantCulture.NumberFormat);

            if (i == 1)
            {
                minx = x_pos;
                maxx = x_pos;
                miny = y_pos;
                maxy = y_pos;
            }

            if (x_pos < minx)
            {
                minx = x_pos;
            }
            else if (x_pos > maxx)
            {
                maxx = x_pos;
            }

            if (y_pos < miny)
            {
                miny = y_pos;
            }
            else if (y_pos > maxy)
            {
                maxy = y_pos;
            }

            //int id = int.Parse(array[0]) + 1; // +1 as the label starts at 0 while the from and to columns start with 1 to 1372...
            Vector2 position = new Vector2(x_pos, y_pos);
            float bearing = float.Parse(array[3], System.Globalization.CultureInfo.InvariantCulture.NumberFormat);

            if(position.Equals(previousPosition))
            {
                nodes[id - 1].bearings.Add(bearing);
            }
            else
            {
                List<Edge> outEdges = new List<Edge>();
                List<float> bearings = new List<float>() { bearing };
                float internalNorth = float.Parse(array[4], System.Globalization.CultureInfo.InvariantCulture.NumberFormat);

                nodes.Add(new Node() { id = id, outEdges = outEdges, position = position, bearings = bearings, internalNorth = internalNorth });

                id += 1;
                previousPosition = position;
            }
        }
    }
    void GetChildren()
    {
        List<int> from = new List<int>();
        List<int> to = new List<int>();
        List<float> angles = new List<float>();
        string[] lines = text_arcs.text.Split('\n');

        for (int i = 1; i < lines.Length - 1; i++)
        {
            string[] array = lines[i].Split('\t');

            from.Add(int.Parse(array[0]));
            to.Add(int.Parse(array[1]));
            angles.Add(float.Parse(array[4], System.Globalization.CultureInfo.InvariantCulture.NumberFormat));
        }

        for (var i = 0; i < from.Count; i++)
        {
            nodes[from[i] - 1].outEdges.Add(new Edge() { childId = to[i], angle = angles[i] });
        }
    }

    float ObjectiveFunction()
    {
        int n = nodes.Count;
        float sum = 0;

        for (int i = 0; i < n; i++)
        {
            foreach(Edge currentEdge in nodes[i].outEdges)
            {
                int angle = 0;
                Vector2 currentUnitVector = new Vector2(Mathf.Cos(angle), Mathf.Sin(angle));

                sum += (nodes[currentEdge.childId - 1].position - nodes[i].position - currentUnitVector).SqrMagnitude();
            }
        }
        return sum;
    }
}

public class Node_mboon
{
    public int id;
    public Vector2 position;
    public List<Edge> outEdges;
    public List<float> bearings;
    public float internalNorth;
}

public class Edge_mboon
{
    public int childId;
    public float angle;
}

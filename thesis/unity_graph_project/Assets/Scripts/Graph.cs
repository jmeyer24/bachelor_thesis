using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Graph : MonoBehaviour
{
    public Camera MainCamera;
    public GameObject nodePrefab;

    public bool interconnection;
    public bool points;
    public bool internalBearing;
    public bool internalNorth;
    public bool trueNorth;
    public bool unitVector;

    private DataReader dataReader;
    private List<NodeObject> nodes;
    private List<Edge> edges;
    private GameObject nodeBin;

    private float minx;
    private float maxx;
    private float miny;
    private float maxy;

    private readonly float visualSize = .25f;
    private Vector3 standardScale = new Vector3(.1f, .1f, .1f);


    void Start()
    {
        // for this to work: Edit > Project Settings > Script Execution Order
        // set the DataReader script above the Graph script!
        dataReader = GetComponent<DataReader>();

        nodes = new List<NodeObject>();
        edges = new List<Edge>();
        nodeBin = new GameObject("Node Bin");
        nodeBin.transform.parent = this.transform;

        BuildGraph();

        this.transform.position = -nodes[0].go.transform.position;
    }

    void Update()
    {
        UpdateCamera();

        //Debug.Log(CalculateObjectiveFunction());
    }

    void OnDrawGizmos()
    {
        if (!Application.isPlaying) return;

        if (interconnection | points | internalBearing | internalNorth | trueNorth | unitVector)
        {
            foreach (NodeObject node in nodes)
            {
                if (interconnection | unitVector)
                {
                    foreach (Edge edge in node.nodeComp.edges)
                    {
                        if (interconnection)
                        {
                            Gizmos.color = Color.yellow;
                            Gizmos.DrawLine(node.go.transform.position, nodes[(int)edge.toId - 1].go.transform.position);
                        }

                        if (unitVector)
                        {
                            Gizmos.color = Color.cyan;
                            Gizmos.DrawRay(node.go.transform.position, new Vector3(Mathf.Cos(edge.angle), Mathf.Sin(edge.angle), 0) * visualSize);
                        }
                    }
                }

                if (points)
                {
                    node.go.GetComponent<MeshRenderer>().enabled = true;
                }

                if (internalBearing)
                {
                    Gizmos.color = Color.green;
                    Gizmos.DrawRay(node.go.transform.position, Quaternion.AngleAxis(node.nodeComp.bearing, Vector3.forward) * node.go.transform.rotation * transform.up * visualSize); //* node.transform.rotation
                }

                if (internalNorth)
                {
                    Gizmos.color = Color.red;
                    Gizmos.DrawRay(node.go.transform.position, Quaternion.AngleAxis(node.nodeComp.internalNorth, Vector3.forward) * node.go.transform.rotation * transform.up * visualSize); //* node.transform.rotation
                }

                if (trueNorth)
                {
                    Gizmos.color = Color.white;
                    Gizmos.DrawRay(node.go.transform.position, node.go.transform.rotation * transform.up * visualSize);
                    // * node.transform.rotation, so we see after rotating the point how much we did, at the start every points north is facing up!
                }
            }
        }
        
        if(!points)
        {
            foreach (NodeObject node in nodes)
            {
                node.go.GetComponent<MeshRenderer>().enabled = false;
            }
        }

        /*
        if (interconnection)
        {
            Gizmos.color = Color.yellow;
            foreach (NodeObject node in nodes)
            {
                foreach (Edge edge in node.nodeComp.edges)
                {
                    Gizmos.DrawLine(node.go.transform.position, nodes[(int)edge.toId - 1].go.transform.position);
                }
            }
        }

        if (points)
        {
            foreach (NodeObject node in nodes)
            {
                node.go.GetComponent<MeshRenderer>().enabled = true;
            }
        }
        else
        {
            foreach (NodeObject node in nodes)
            {
                node.go.GetComponent<MeshRenderer>().enabled = false;
            }
        }

        if (internalBearing)
        {
            Gizmos.color = Color.green;
            foreach (NodeObject node in nodes)
            {
                Gizmos.DrawRay(node.go.transform.position, Quaternion.AngleAxis(node.nodeComp.bearing, Vector3.forward) * node.go.transform.rotation * transform.up * visualSize); //* node.transform.rotation
            }
        }

        if (internalNorth)
        {
            Gizmos.color = Color.red;
            foreach (NodeObject node in nodes)
            {
                Gizmos.DrawRay(node.go.transform.position, Quaternion.AngleAxis(node.nodeComp.internalNorth, Vector3.forward) * node.go.transform.rotation * transform.up * visualSize); //* node.transform.rotation 
            }
        }

        if (trueNorth)
        {
            Gizmos.color = Color.white;
            foreach (NodeObject node in nodes)
            {
                Gizmos.DrawRay(node.go.transform.position, node.go.transform.rotation * transform.up * visualSize);
                // * node.transform.rotation, so we see after rotating the point how much we did, at the start every points north is facing up!
            }
        }

        if (unitVector)
        {
            Gizmos.color = Color.cyan;
            foreach (NodeObject node in nodes)
            {
                foreach (Edge edge in node.nodeComp.edges)
                {
                    //Vector3 currentUnitVector = new Vector3(Mathf.Cos(edge.angle), Mathf.Sin(edge.angle), 0);
                    Gizmos.DrawRay(node.go.transform.position, new Vector3(Mathf.Cos(edge.angle), Mathf.Sin(edge.angle), 0) * visualSize);
                }
            }
        }
        */
    }

    void BuildGraph()
    {
        FillNodes();
        FillEdges();
    }

    void FillNodes()
    {
        for (int i = 0; i < dataReader.nodeInfo.Count; i++)
        {
            List<float> currentInfo = dataReader.nodeInfo[i];

            float x_pos = currentInfo[1];
            float y_pos = currentInfo[2];

            // calculate min/max x/y
            if (i == 0)
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

            nodes.Add(new NodeObject(nodePrefab, i, nodeBin, standardScale, x_pos, y_pos, currentInfo));
        }
    }

    void FillEdges()
    {
        for (int i = 0; i < dataReader.arcInfo.Count; i++)
        {
            List<float> currentInfo = dataReader.arcInfo[i];
            Edge newEdge = new Edge() { fromId = currentInfo[0], toId = currentInfo[1], angle = currentInfo[4] }; 
            edges.Add(newEdge) ;
            nodes[(int)newEdge.fromId - 1].nodeComp.edges.Add(newEdge);
        }
    }

    void UpdateCamera()
    {
        for (int i = 0; i < nodes.Count; i++)
        {
            float x_pos = nodes[i].go.transform.position.x;
            float y_pos = nodes[i].go.transform.position.y;

            if (i == 0)
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
        }

        // position the camera to see all of graph
        float diffX = maxx - minx;
        float diffY = maxy - miny;
        float asp = MainCamera.aspect;

        if (diffX > diffY)
        {
            MainCamera.orthographicSize = (diffX / 2) / asp + 1;
        }
        else
        {
            MainCamera.orthographicSize = (diffY / 2) + 1;
        }

        MainCamera.transform.position = new Vector3((maxx + minx) / 2, (maxy + miny) / 2, -5);
    }

    float CalculateObjectiveFunction()
    {
        int n = nodes.Count;
        float sum = 0;

        foreach(NodeObject node in nodes)
        {
            foreach(Edge edge in node.nodeComp.edges)
            {
                Vector3 currentUnitVector = new Vector3(Mathf.Cos(edge.angle), Mathf.Sin(edge.angle),0);

                sum += Vector3.SqrMagnitude(nodes[(int)edge.toId - 1].go.transform.position - node.go.transform.position - currentUnitVector);
            }
        }

        return sum;
    }
}
